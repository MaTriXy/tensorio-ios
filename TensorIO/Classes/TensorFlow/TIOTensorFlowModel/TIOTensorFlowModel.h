//
//  TIOTensorFlowModel.h
//  TensorIO
//
//  Created by Phil Dow on 4/9/19.
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

#import <Foundation/Foundation.h>

#import "TIOLayerInterface.h"
#import "TIOData.h"
#import "TIOModel.h"
#import "TIOTrainableModel.h"
#import "TIOBatch.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An Objective-C wrapper around TensorFlow models that provides a unified interface to the
 * input and output layers of the underlying model. These models are capable of
 * performing inference, training, and evaluation.
 *
 * See `TIOModel` for more information about TensorIO models and for a description of the
 * conforming properties and methods here.
 */

@interface TIOTensorFlowModel : NSObject <TIOModel>

+ (nullable instancetype)modelWithBundleAtPath:(NSString*)path;

// Model Protocol Properties

@property (readonly) TIOModelBundle *bundle;
@property (readonly) TIOModelOptions *options;
@property (readonly) NSString* identifier;
@property (readonly) NSString* name;
@property (readonly) NSString* details;
@property (readonly) NSString* author;
@property (readonly) NSString* license;
@property (readonly) BOOL placeholder;
@property (readonly) BOOL quantized;
@property (readonly) NSString *type;
@property (readonly) NSString *backend;
@property (readonly) TIOModelModes *modes;
@property (readonly) BOOL loaded;

@property (readonly) NSArray<TIOLayerInterface*> *inputs;
@property (readonly) NSArray<TIOLayerInterface*> *outputs;

// MARK: - Model Protocol Methods

- (nullable instancetype)initWithBundle:(TIOModelBundle*)bundle NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)load:(NSError**)error;
- (void)unload;

/**
 * Performs inference on the provided input and returns the results. The primary
 * interface to a conforming class.
 *
 * @param input Any class conforming to `TIOData` that you want to run
 *  inference on
 *
 * @return TIOData The results of performing inference, or an empty dictionary
 *  if the model has not been loaded yet and a load error occurs.
 */

- (id<TIOData>)runOn:(id<TIOData>)input;

- (id<TIOLayerDescription>)descriptionOfInputAtIndex:(NSUInteger)index;
- (id<TIOLayerDescription>)descriptionOfInputWithName:(NSString*)name;

- (id<TIOLayerDescription>)descriptionOfOutputAtIndex:(NSUInteger)index;
- (id<TIOLayerDescription>)descriptionOfOutputWithName:(NSString*)name;

@end

// MARK: - Training

@interface TIOTensorFlowModel (TIOTrainableModel) <TIOTrainableModel>

/**
 * Calls the underlying training op with a single batch.
 *
 * A complete round of training will involve iterating over all the available
 * batches for a certain number of epochs. It is the responsibility of other
 * objects to execute those loops and prepare batches for calls to this method.
 *
 * This method will return an empty dictionary if the model has not been loaded
 * yet and a load error occurs.
 */

- (id<TIOData>)train:(TIOBatch*)batch;

/**
 * Exports the results of training to the specified directory. The directory
 * must already exist.
 *
 * A TensorFlow export appends "checkpoint" to the file URL and exports two
 * files into that dirctory:
 *
 * checkpoint.index
 * checkpoint.data-XXXXX-of-YYYYY, e.g. checkpoint.data-00000-of-00001
 *
 * @param fileURL File URL to the directory in which the export will be saved
 * @param error Set to any error that occurs during the export, otherwise `nil`
 *
 * @return `YES` if the export was successful,`NO` otherwise
 */

- (BOOL)exportTo:(NSURL*)fileURL error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
