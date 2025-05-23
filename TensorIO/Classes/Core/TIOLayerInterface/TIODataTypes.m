//
//  TIODataTypes.c
//  TensorIO
//
//  Created by Phil Dow on 7/3/19.
//  Copyright © 2019 doc.ai (http://doc.ai)
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

#import "TIODataTypes.h"

NSUInteger TIOByteSizeOfDataType(TIODataType dtype) {
    switch (dtype) {
    case TIODataTypeUnknown:
        return 0;
    case TIODataTypeUInt8:
        return 1;
    case TIODataTypeFloat32:
        return 4;
    case TIODataTypeInt32:
        return 4;
    case TIODataTypeInt64:
        return 8;
    }
}
