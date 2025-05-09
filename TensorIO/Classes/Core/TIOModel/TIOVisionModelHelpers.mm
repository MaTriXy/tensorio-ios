//
//  TIOVisionModelHelpers.mm
//  TensorIO
//
//  Created by Philip Dow on 7/12/18.
//  Copyright © 2018 doc.ai (http://doc.ai)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "TIOVisionModelHelpers.h"

// MARK: - Image Volume

const TIOImageVolume kTIOImageVolumeInvalid = {
    .height     = 0,
    .width      = 0,
    .channels   = 0
};

BOOL TIOImageVolumesEqual(TIOImageVolume a, TIOImageVolume b) {
    return a.height == b.height
        && a.width == b.width
        && a.channels == b.channels;
}

int TIOImageVolumeLength(TIOImageVolume volume) {
    return volume.width * volume.height * volume.channels;
}
