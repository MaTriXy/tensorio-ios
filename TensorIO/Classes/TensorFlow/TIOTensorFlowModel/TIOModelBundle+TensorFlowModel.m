//
//  TIOModelBundle+TensorFlowModel.h
//  TensorIO
//
//  Created by Phil Dow on 4/10/19.
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

#import "TIOModelBundle+TensorFlowModel.h"

@implementation TIOModelBundle (TIOTensorFlowModel)

- (NSString *)modelPredictPath {
    if (self.isPlaceholder) {
        return nil;
    } else {
        return [self.path stringByAppendingPathComponent:self.info[@"model"][@"file"]];
    }
}

- (NSString *)modelTrainPath {
    if (self.isPlaceholder) {
        return nil;
    } else {
        return [self.path stringByAppendingPathComponent:self.info[@"model"][@"file"]];
    }
}

- (NSString *)modelEvalPath {
    return nil;
}

@end
