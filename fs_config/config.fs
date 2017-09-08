#
# Copyright (C) 2017 The XPerience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[AID_QCOM_DIAG]
value:2950

[AID_RFS]
value:2951

[AID_RFS_SHARED]
value:2952

[AID_MOT_ACCY]
value:9000

[AID_MOT_PWRIC]
value:9001

[AID_MOT_USB]
value:9002

[AID_MOT_DRM]
value:9003

[AID_MOT_TCMD]
value:9004

[AID_MOT_SEC_RTC]
value:9005

[AID_MOT_TOMBSTONE]
value:9006

[AID_MOT_TPAPI]
value:9007

[AID_MOT_SECCLKD]
value:9008

[AID_MOT_WHISPER]
value:9009

[AID_MOT_CAIF]
value:9010

[AID_MOT_DLNA]
value:9011

[AID_MOT_ATVC]
value:9012

[AID_SPRINT_EXTENSION]
value:9013

[AID_MOT_DBVC]
value:9014

[AID_FINGERP]
value:9015

[AID_MOT_ESDFS]
value:9016

[AID_POWER]
value:9017

[AID_ITSON]
value:9018

[AID_MOT_DTV]
value:9019

[system/bin/qmuxd]
user: AID_RADAIO
group: AID_SHELL
mode: 0700
caps: BLOCK_SUSPEND

[system/bin/ims_rtp_daemon]
user: AID_SYSTEM
group: AID_RADIO
mode: 0755
caps: NET_BIND_SERVICE

[system/bin/imsdatadaemon]
user: AID_SYSTEM
group: AID_SYSTEM
mode: 0755
caps: NET_BIND_SERVICE

[system/bin/pm-service]
user: AID_SYSTEM
group: AID_SYSTEM
mode: 0755
caps: NET_BIND_SERVICE
