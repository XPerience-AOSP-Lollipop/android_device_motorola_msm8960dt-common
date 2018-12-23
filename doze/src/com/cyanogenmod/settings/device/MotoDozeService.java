/*
 * Copyright (c) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.cyanogenmod.settings.device;

import android.app.IntentService;
import android.app.Service;
import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.hardware.SensorEvent;
import android.hardware.camera2.CameraManager;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraAccessException;
import android.os.IBinder;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.os.SystemClock;
import android.os.UserHandle;
import android.os.Vibrator;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;

public class MotoDozeService extends Service {

    private static final boolean DEBUG = false;
    private static final String TAG = "MotoDozeService";

    private static final String DOZE_INTENT = "com.android.systemui.doze.pulse";

    private static final String GESTURE_CAMERA_KEY = "gesture_camera";
    private static final String GESTURE_FLASHLIGHT_KEY = "gesture_flashlight";
    private static final String GESTURE_PICK_UP_KEY = "gesture_pick_up";
    private static final String GESTURE_HAND_WAVE_KEY = "gesture_hand_wave";

    private static final int SENSOR_WAKELOCK_DURATION = 200;
    private static final int MIN_PULSE_INTERVAL_MS = 10000;
    private static final int HANDWAVE_DELTA_NS = 1000 * 1000 * 1000;

    private Context mContext;
    private FlatSensor mFlatSensor;
    private MotoSensor mStowSensor;
    private MotoSensor mCameraActivationSensor;
    private MotoSensor mFlashlightActivationSensor;
    private PowerManager mPowerManager;
    private WakeLock mSensorWakeLock;
    private CameraManager mCameraManager;
    private String mTorchCameraId;
    private long mLastPulseTimestamp = 0;
    private boolean mTorchEnabled = false;
    private boolean mCameraGestureEnabled = false;
    private boolean mFlashlightGestureEnabled = false;
    private boolean mPickUpGestureEnabled = false;
    private boolean mHandwaveGestureEnabled = false;
    private long mLastStowed = 0;

    private MotoSensor.MotoSensorListener mListener = new MotoSensor.MotoSensorListener() {
        @Override
        public void onEvent(int sensorType, SensorEvent event) {
            if (DEBUG) Log.d(TAG, "Got sensor event: " + event.values[0] + " for type " + sensorType);

            switch (sensorType) {
                case MotoSensor.SENSOR_TYPE_MMI_STOW:
                    handleStow(event);
                    break;
                case MotoSensor.SENSOR_TYPE_MMI_CAMERA_ACTIVATION:
                    handleCameraActivation();
                    break;
                case MotoSensor.SENSOR_TYPE_MMI_FLASHLIGHT_ACTIVATION:
                    handleFlashlightActivation();
                    break;
            }
        }
    };

    private FlatSensor.FlatSensorListener mFlatListener = new FlatSensor.FlatSensorListener() {
        @Override
        public void onEvent(boolean isFlat) {
            if (DEBUG) Log.d(TAG, "Got flat state: " + isFlat);

            handleFlat(isFlat);
        }
    };

    @Override
    public void onCreate() {
        if (DEBUG) Log.d(TAG, "Creating service");
        super.onCreate();
        mContext = this;
        mStowSensor = new MotoSensor(mContext, MotoSensor.SENSOR_TYPE_MMI_STOW);
        mStowSensor.registerListener(mListener);
        mFlatSensor = new FlatSensor(mContext);
        mFlatSensor.registerListener(mFlatListener);
        mCameraActivationSensor = new MotoSensor(mContext, MotoSensor.SENSOR_TYPE_MMI_CAMERA_ACTIVATION);
        mCameraActivationSensor.registerListener(mListener);
        mFlashlightActivationSensor = new MotoSensor(mContext, MotoSensor.SENSOR_TYPE_MMI_FLASHLIGHT_ACTIVATION);
        mFlashlightActivationSensor.registerListener(mListener);
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(mContext);
        loadPreferences(sharedPrefs);
        sharedPrefs.registerOnSharedPreferenceChangeListener(mPrefListener);
        mPowerManager = (PowerManager) mContext.getSystemService(Context.POWER_SERVICE);
        mSensorWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MotoSensorWakeLock");
        mCameraManager = (CameraManager) mContext.getSystemService(Context.CAMERA_SERVICE);
        mCameraManager.registerTorchCallback(mTorchCallback, null);
        mTorchCameraId = getTorchCameraId();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (DEBUG) Log.d(TAG, "Starting service");
        IntentFilter screenStateFilter = new IntentFilter(Intent.ACTION_SCREEN_ON);
        screenStateFilter.addAction(Intent.ACTION_SCREEN_OFF);
        mContext.registerReceiver(mScreenStateReceiver, screenStateFilter);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (DEBUG) Log.d(TAG, "Destroying service");
        super.onDestroy();
        mCameraActivationSensor.disable();
        mFlashlightActivationSensor.disable();
        mFlatSensor.disable();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void launchDozePulse() {
        long delta = SystemClock.elapsedRealtime() - mLastPulseTimestamp;
        if (DEBUG) Log.d(TAG, "Time since last pulse: " + delta);
        if (delta > MIN_PULSE_INTERVAL_MS) {
            mLastPulseTimestamp = SystemClock.elapsedRealtime();
            mContext.sendBroadcast(new Intent(DOZE_INTENT));
        }
    }

    private void launchCamera() {
        mSensorWakeLock.acquire(SENSOR_WAKELOCK_DURATION);
        mPowerManager.wakeUp(SystemClock.uptimeMillis());
        Intent intent = new Intent(MediaStore.INTENT_ACTION_STILL_IMAGE_CAMERA_SECURE);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        try {
            mContext.startActivityAsUser(intent, null, new UserHandle(UserHandle.USER_CURRENT));
        } catch (ActivityNotFoundException e) {
            /* Ignore */
        }
    }

    private void launchFlashlight() {
        try {
            mCameraManager.setTorchMode(mTorchCameraId, !mTorchEnabled);
        } catch (CameraAccessException e) {
            // Ignore
        }
    }

    private boolean isPickUpEnabled() {
        return mPickUpGestureEnabled &&
            (Settings.Secure.getInt(mContext.getContentResolver(),
                                    Settings.Secure.DOZE_ENABLED, 1) != 0);
    }

    private boolean isHandwaveEnabled() {
        return mHandwaveGestureEnabled &&
            (Settings.Secure.getInt(mContext.getContentResolver(),
                                    Settings.Secure.DOZE_ENABLED, 1) != 0);
    }

    private boolean isCameraEnabled() {
        return mCameraGestureEnabled;
    }

    private boolean isFlashlightEnabled() {
        return mFlashlightGestureEnabled;
    }

    private void handleFlat(boolean isFlat) {
        if (!isFlat) {
            launchDozePulse();
        }
    }

    private void handleStow(SensorEvent event) {
        boolean isStowed = (event.values[0] == 1);

        if (isStowed) {
            mLastStowed = event.timestamp;
            if (isPickUpEnabled()) {
                mFlatSensor.disable();
            }
            if (isCameraEnabled()) {
                mCameraActivationSensor.disable();
            }
            if (isFlashlightEnabled()) {
                mFlashlightActivationSensor.disable();
            }
        } else {
            if (DEBUG) Log.d(TAG, "Unstowed: " + event.timestamp + " last stowed: " + mLastStowed);
            if (isHandwaveEnabled() && (event.timestamp - mLastStowed) < HANDWAVE_DELTA_NS) {
                // assume this was a handwave and pulse
                launchDozePulse();
            }
            if (isPickUpEnabled()) {
                mFlatSensor.enable();
            }
            if (isCameraEnabled()) {
                mCameraActivationSensor.enable();
            }
            if (isFlashlightEnabled()) {
                mFlashlightActivationSensor.enable();
            }
        }
        if (DEBUG) Log.d(TAG, "Stowed: " + isStowed);
    }

    private void handleCameraActivation() {
        Vibrator v = (Vibrator) mContext.getSystemService(Context.VIBRATOR_SERVICE);
        v.vibrate(500);
        launchCamera();
    }

    private void handleFlashlightActivation() {
        Vibrator v = (Vibrator) mContext.getSystemService(Context.VIBRATOR_SERVICE);
        if (!mTorchEnabled) {
            v.vibrate(new long[]{0, 200, 100, 400}, -1);
        } else {
            v.vibrate(300);
        }
        launchFlashlight();
    }

    private void onDisplayOn() {
        if (DEBUG) Log.d(TAG, "Display on");

        if (isPickUpEnabled() || isHandwaveEnabled() || isCameraEnabled() || isFlashlightEnabled()) {
            mStowSensor.disable();
        }
        if (isCameraEnabled()) {
            mCameraActivationSensor.enable();
        }
        if (isFlashlightEnabled()) {
            mFlashlightActivationSensor.enable();
        }
        if (isPickUpEnabled()) {
            mFlatSensor.disable();
        }
    }

    private void onDisplayOff() {
        if (DEBUG) Log.d(TAG, "Display off");

        if (isPickUpEnabled() || isHandwaveEnabled() || isCameraEnabled() || isFlashlightEnabled()) {
            mStowSensor.enable();
        }
    }

    private String getTorchCameraId() {
        try {
            for (final String id : mCameraManager.getCameraIdList()) {
                CameraCharacteristics cc = mCameraManager.getCameraCharacteristics(id);
                int direction = cc.get(CameraCharacteristics.LENS_FACING);
                if (direction == CameraCharacteristics.LENS_FACING_BACK) {
                    return id;
                }
            }
        } catch (CameraAccessException e) {
            // Ignore
        }

        return null;
    }

    private CameraManager.TorchCallback mTorchCallback = new CameraManager.TorchCallback() {
        @Override
        public void onTorchModeChanged(String cameraId, boolean enabled) {
            if (!cameraId.equals(mTorchCameraId))
                return;
            mTorchEnabled = enabled;
        }

        @Override
        public void onTorchModeUnavailable(String cameraId) {
            if (!cameraId.equals(mTorchCameraId))
                return;
            mTorchEnabled = false;
        }
    };

    private BroadcastReceiver mScreenStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
                onDisplayOff();
            } else if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
                onDisplayOn();
            }
        }
    };

    private void loadPreferences(SharedPreferences sharedPreferences) {
        mCameraGestureEnabled = sharedPreferences.getBoolean(GESTURE_CAMERA_KEY, true);
        mFlashlightGestureEnabled = sharedPreferences.getBoolean(GESTURE_FLASHLIGHT_KEY, true);
        mPickUpGestureEnabled = sharedPreferences.getBoolean(GESTURE_PICK_UP_KEY, true);
        mHandwaveGestureEnabled = sharedPreferences.getBoolean(GESTURE_HAND_WAVE_KEY, true);
    }

    private SharedPreferences.OnSharedPreferenceChangeListener mPrefListener =
            new SharedPreferences.OnSharedPreferenceChangeListener() {
        @Override
        public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
            if (GESTURE_CAMERA_KEY.equals(key)) {
                mCameraGestureEnabled = sharedPreferences.getBoolean(GESTURE_CAMERA_KEY, true);
                if (mCameraGestureEnabled) {
                    mCameraActivationSensor.enable();
                } else {
                    mCameraActivationSensor.disable();
                }
            } else if (GESTURE_FLASHLIGHT_KEY.equals(key)) {
                mFlashlightGestureEnabled = sharedPreferences.getBoolean(GESTURE_FLASHLIGHT_KEY, true);
                if (mFlashlightGestureEnabled) {
                    mFlashlightActivationSensor.enable();
                } else {
                    mFlashlightActivationSensor.disable();
                }
            } else if (GESTURE_PICK_UP_KEY.equals(key)) {
                mPickUpGestureEnabled = sharedPreferences.getBoolean(GESTURE_PICK_UP_KEY, true);
            } else if (GESTURE_HAND_WAVE_KEY.equals(key)) {
                mHandwaveGestureEnabled = sharedPreferences.getBoolean(GESTURE_HAND_WAVE_KEY, true);
            }
        }
    };
}
