//
//  TIOFleaClientSessionDelegate.h
//  TensorIO
//
//  Created by Phil Dow on 6/7/19.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A utility session delegate that proxies an NSURL Session delegate and
 * forwards the methods to a `TIOFleaClient`, allowing a flea client to support
 * background tranfers and progress updates.
 *
 * Inject an instance of this session delegate into the download NSURLSession
 * that you create for your `TIOFleClient` instance.
 */

@interface TIOFleaClientSessionDelegate : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (weak) id<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate> client;

@end

NS_ASSUME_NONNULL_END