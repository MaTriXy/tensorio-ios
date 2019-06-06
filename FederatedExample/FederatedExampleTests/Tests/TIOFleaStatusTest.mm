//
//  TIOFleaStatusTest.m
//  FederatedExampleTests
//
//  Created by Phil Dow on 5/23/19.
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

#import <XCTest/XCTest.h>
#import <TensorIO/TensorIO-umbrella.h>
#import "MockURLSession.h"

@interface TIOFleaStatusTest : XCTestCase

@end

@implementation TIOFleaStatusTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// MARK: -

- (void)testGETHealthStatusWithServingStatusSucceeds {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for health status response"];
    
    MockURLSession *session = [[MockURLSession alloc] initWithJSONResponse:@{
        @"status": @"SERVING"
    }];
    
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@""] session:session downloadSession:session];
    
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {
        XCTAssertNil(error);
        XCTAssertNotNil(status);
        XCTAssert(status.status == TIOFleaStatusValueServing);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0];
    
    XCTAssert(session.responses.count == 0); // queue exhausted
    XCTAssert(task.calledResume);
}

- (void)testGETHealthStatusURL {
    MockURLSession *session = [[MockURLSession alloc] init];
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://storage.googleapis.com/doc-ai-models"] session:session downloadSession:session];
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {}];
    
    NSURL *expectedURL = [[NSURL
        URLWithString:@"https://storage.googleapis.com/doc-ai-models"]
        URLByAppendingPathComponent:@"healthz"];
    
    XCTAssertEqualObjects(task.currentRequest.URL, expectedURL);
}

// MARK: -

- (void)testGETHealthStatusWithOtherStatusFails {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for health status response"];
    
    MockURLSession *session = [[MockURLSession alloc] initWithJSONResponse:@{
        @"status": @"FAILURE"
    }];
    
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@""] session:session downloadSession:session];
    
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssert(status.status == TIOFleaStatusValueUnknown);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0];
    
    XCTAssert(session.responses.count == 0); // queue exhausted
    XCTAssert(task.calledResume);
}

- (void)testGETHealthStatusWithoutStatusFails {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for health status response"];
    
    MockURLSession *session = [[MockURLSession alloc] initWithJSONResponse:@{
        @"foo": @"bar"
    }];
    
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@""] session:session downloadSession:session];
    
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssertNil(status);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0];
    
    XCTAssert(session.responses.count == 0); // queue exhausted
    XCTAssert(task.calledResume);
}

// MARK: -

- (void)testGETHealthStatusWithErrorFails {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for health status response"];
    
    MockURLSession *session = [[MockURLSession alloc] initWithError:[[NSError alloc] init]];
    
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@""] session:session downloadSession:session];
    
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssertNil(status);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0];
    
    XCTAssert(session.responses.count == 0); // queue exhausted
    XCTAssert(task.calledResume);
}

- (void)testGETHealthStatusWithoutDataFails {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for health status response"];
    
    MockURLSession *session = [[MockURLSession alloc] initWithJSONData:[NSData data]];
    
    TIOFleaClient *client = [[TIOFleaClient alloc] initWithBaseURL:[NSURL URLWithString:@""] session:session downloadSession:session];
    
    MockSessionDataTask *task = (MockSessionDataTask*)[client GETHealthStatus:^(TIOFleaStatus * _Nullable status, NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssertNil(status);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0];
    
    XCTAssert(session.responses.count == 0); // queue exhausted
    XCTAssert(task.calledResume);
}

@end