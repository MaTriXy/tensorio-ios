//
//  TIOMRHyperparameter.m
//  TensorIO
//
//  Created by Phil Dow on 5/3/19.
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

#import "TIOMRHyperparameter.h"
#import "TIOMRErrors.h"

@implementation TIOMRHyperparameter

- (nullable instancetype)initWithJSON:(NSDictionary*)JSON error:(NSError**)error {
    if ((self=[super init])) {
        if ( JSON[@"modelId"] == nil || ![JSON[@"modelId"] isKindOfClass:NSString.class] ) {
            *error = TIOMRJSONParsingError(self.class, @"modelId", JSON);
            return nil;
        } else {
            _modelId = JSON[@"modelId"];
        }
        
        if ( JSON[@"hyperparametersId"] == nil || ![JSON[@"hyperparametersId"] isKindOfClass:NSString.class] ) {
            *error = TIOMRJSONParsingError(self.class, @"hyperparametersId", JSON);
            return nil;
        } else {
            _hyperparametersId = JSON[@"hyperparametersId"];
        }
        
        if ( JSON[@"upgradeTo"] == nil || [JSON[@"upgradeTo"] isKindOfClass:NSNull.class] || [JSON[@"upgradeTo"] isEqual:@""] ) {
            _upgradeTo = nil;
        } else if ( ![JSON[@"upgradeTo"] isKindOfClass:NSString.class] ) {
            *error = TIOMRJSONParsingError(self.class, @"_upgradeTo", JSON);
            return nil;
        } else {
            _upgradeTo = JSON[@"upgradeTo"];
        }
        
        if ( JSON[@"hyperparameters"] == nil || ![JSON[@"hyperparameters"] isKindOfClass:NSDictionary.class] ) {
            *error = TIOMRJSONParsingError(self.class, @"hyperparameters", JSON);
            return nil;
        } else {
            _hyperparameters = JSON[@"hyperparameters"];
        }
        
        if ( JSON[@"canonicalCheckpoint"] == nil || [JSON[@"canonicalCheckpoint"] isKindOfClass:NSNull.class] || [JSON[@"canonicalCheckpoint"] isEqual:@""] ) {
            _canonicalCheckpoint = nil;
        } else if ( ![JSON[@"canonicalCheckpoint"] isKindOfClass:NSString.class] ) {
            *error = TIOMRJSONParsingError(self.class, @"canonicalCheckpoint", JSON);
            return nil;
        } else {
            _canonicalCheckpoint = JSON[@"canonicalCheckpoint"];
        }
    }
    return self;
}

- (NSString*)description {
    NSString *ms = [NSString stringWithFormat:@"Model ID: %@", self.modelId];
    NSString *hs = [NSString stringWithFormat:@"Hyperparameters ID: %@", self.hyperparametersId];
    NSString *is = [NSString stringWithFormat:@"Hyperparameters: %@", self.hyperparameters];
    NSString *us = [NSString stringWithFormat:@"Upgrade To: %@", self.upgradeTo];
    NSString *cs = [NSString stringWithFormat:@"Canonical Checkpoints: %@", self.canonicalCheckpoint];
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", ms, hs, is, us, cs];
}

@end