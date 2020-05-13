//
//  TIOModelBundleValidatorTests.m
//  TensorIO_Tests
//
//  Created by Philip Dow on 8/7/18.
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

@import XCTest;
@import TensorIO;

@interface TIOModelBundleValidatorTests : XCTestCase

@end

@implementation TIOModelBundleValidatorTests

- (void)setUp { }

- (void)tearDown { }

/**
 * Creates a validator from a model bundle at filename
 */

- (TIOModelBundleValidator *)validatorForFilename:(NSString *)filename {
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"models-tests" ofType:nil];
    NSString *path = [modelsPath stringByAppendingPathComponent:filename];
    TIOModelBundleValidator *validator = [[TIOModelBundleValidator alloc] initWithModelBundleAtPath:path];
    return validator;
}

// MARK: - Path and Bundle Validation

- (void)testBundleAtInvalidPathDoesNotValidate {
    // it should not validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"qwerty.tiobundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

- (void)testBundleWithoutTIOBundleExtensionDoesNotValidate {
    // it should not validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"invalid-model-ext"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

- (void)testBundleWithoutJSONDoesNotValidate {
    // it should not validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"invalid-model-no-json.tiobundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

- (void)testBundleWithBadJSONDoesNotValidate {
    // it should not validate is model.json is invalid json
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"invalid-model-bad-json.tiobundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

- (void)testBundleWithDeprecatedExtensionStillValidates {
    // it should validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"deprecated.tfbundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

// MARK: - Assets Validation

- (void)testAnIncorrectlyNamedModelFileDoesNotValidate {
    // it should not validate if the model.file does not exist
    
    TIOModelBundleValidator *validator = [self validatorForFilename:@"invalid-model-incorrect-model-file.tiobundle"];
    NSError *error;
    
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

- (void)testAnIncorrectNamedLabelsFileDoesNotValidate {
    // it should not validate if a labels file does not exist
    
    TIOModelBundleValidator *validator = [self validatorForFilename:@"invalid-model-incorrect-labels-file.tiobundle"];
    NSError *error;
    
    BOOL valid = [validator validate:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNotNil(error);
}

// MARK: - Custom Validation

- (void)testInvalidCustomValidationDoesNotValidate {
    // it should not validate
    
    NSError *error;
    BOOL (^block)(NSString *path, NSDictionary *JSON, NSError **error) = ^BOOL(NSString *path, NSDictionary *JSON, NSError **error) {
        return NO;
    };
    
    TIOModelBundleValidator *modelValidator = [[TIOModelBundleValidator alloc] initWithModelBundleAtPath:@""];
    BOOL valid = [modelValidator validateCustomValidator:@{} validator:block error:&error];
    
    XCTAssertFalse(valid);
    XCTAssertNil(error);
}

- (void)testInvalidCustomValidationReturnsError {
    // it should return an error
    
    NSError *error;
    NSError *blockError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BOOL (^block)(NSString *path, NSDictionary *JSON, NSError **error) = ^BOOL(NSString *path, NSDictionary *JSON, NSError **error) {
        *error = blockError;
        return NO;
    };
    
    TIOModelBundleValidator *modelValidator = [[TIOModelBundleValidator alloc] initWithModelBundleAtPath:@""];
    BOOL valid = [modelValidator validateCustomValidator:@{} validator:block error:&error];
    
    XCTAssertFalse(valid);
    XCTAssertEqualObjects(error, blockError);
}

- (void)testValidCustomValidatorValidates {
    // it should validate
    
    NSError *error;
    BOOL (^block)(NSString *path, NSDictionary *JSON, NSError **error) = ^BOOL(NSString *path, NSDictionary *JSON, NSError **error) {
        return YES;
    };
    
    TIOModelBundleValidator *modelValidator = [[TIOModelBundleValidator alloc] initWithModelBundleAtPath:@""];
    BOOL valid = [modelValidator validateCustomValidator:@{} validator:block error:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

// MARK: - Valid Models

- (void)testValidModelsValidate {
    TIOModelBundleValidator *validator;
    NSError *error;
    BOOL valid;
    
    // it should validate
    
    error = nil;
    valid = NO;
    
    validator = [self validatorForFilename:@"1_in_1_out_number_test.tiobundle"];
    valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
    
    // it should validate
    
    error = nil;
    valid = NO;
    
    validator = [self validatorForFilename:@"1_in_1_out_string_test.tiobundle"];
    valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
    
    // it should validate
    
    error = nil;
    valid = NO;
    
    validator = [self validatorForFilename:@"2_in_2_out_matrices_test.tiobundle"];
    valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
    
    // it should validate
    
    error = nil;
    valid = NO;
    
    validator = [self validatorForFilename:@"mobilenet_v2_1.4_224.tiobundle"];
    valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

- (void)testModelWithoutBackendValidates {
    // it should validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"no-backend.tiobundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

- (void)testModelWithoutModesValidates {
    // it should validate
    
    NSError *error;
    TIOModelBundleValidator *validator = [self validatorForFilename:@"no-modes.tiobundle"];
    BOOL valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

// MARK: - Placeholder Models

- (void)testPlaceholderModelValidates {
    TIOModelBundleValidator *validator;
    NSError *error;
    BOOL valid;
    
    // it should validate
    
    error = nil;
    valid = NO;
    
    validator = [self validatorForFilename:@"placeholder.tiobundle"];
    valid = [validator validate:&error];
    
    XCTAssertTrue(valid);
    XCTAssertNil(error);
}

@end
