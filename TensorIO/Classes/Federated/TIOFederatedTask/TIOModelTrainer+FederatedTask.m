//
//  TIOModelTrainer+FederatedTask.m
//  TensorIO
//
//  Created by Phil Dow on 5/22/19.
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

#import "TIOModelTrainer+FederatedTask.h"
#import "TIOTrainableModel.h"
#import "TIOModelIO.h"
#import "TIOFederatedTask.h"

@implementation TIOModelTrainer (FederatedTask)

- (instancetype)initWithModel:(id<TIOTrainableModel>)model task:(TIOFederatedTask *)task dataSource:(id<TIOBatchDataSource>)dataSource {
    
    BOOL modelPlaceholdersEmpty = model.io.placeholders == nil || model.io.placeholders.count == 0;
    BOOL taskPlaceholdersEmpty = task.io.placeholders == nil || task.io.placeholders.count == 0;
    
    if ( !(modelPlaceholdersEmpty && taskPlaceholdersEmpty)
      && ![model.io.placeholders isEqualToModelIOList:task.io.placeholders] ) {
        NSLog(@"Model placeholder descriptions are not equal to task placeholder descriptions");
        return nil;
    }
    
    return [self initWithModel:model dataSource:dataSource placeholders:task.placeholders epochs:task.epochs batchSize:task.batchSize shuffle:task.shuffle];
}

@end