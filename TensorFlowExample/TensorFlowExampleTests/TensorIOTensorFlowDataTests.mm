//
//  TIOTensorFlowDataTests.m
//  TensorFlowExampleTests
//
//  Created by Phil Dow on 4/11/19.
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#include "tensorflow/core/framework/tensor.h"

#pragma clang diagnostic pop

@interface TIOTensorFlowDataTests : XCTestCase

@end

@implementation TIOTensorFlowDataTests

- (void)setUp { }

- (void)tearDown { }

// Note that the zeroth index of a mapped tensor is always the batch
// Our tests use batch sizes of 1

// MARK: - NSNumber + TIOData Get Tensor

- (void)testNumberGetTensorFloatUnquantized {
    // It should get the float_t numeric value
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    NSNumber *number = @(1.0f);
    tensorflow::Tensor tensor = [number tensorWithDescription:description];
    auto maped = tensor.tensor<float_t, 2>();
    XCTAssertEqual(maped(0,0), 1.0f);
}

- (void)testNumberGetTensorUInt8QuantizedWithoutQuantizer {
    // It should get the uint8_t numeric value
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    NSNumber *n0 = @(0);
    tensorflow::Tensor t0 = [n0 tensorWithDescription:description];
    auto m0 = t0.tensor<uint8_t, 2>();
    XCTAssertEqual(m0(0,0), 0);
    
    NSNumber *n1 = @(1);
    tensorflow::Tensor t1 = [n1 tensorWithDescription:description];
    auto m1 = t1.tensor<uint8_t, 2>();
    XCTAssertEqual(m1(0,0), 1);
    
    NSNumber *n255 = @(255);
    tensorflow::Tensor t255 = [n255 tensorWithDescription:description];
    auto m255 = t255.tensor<uint8_t, 2>();
    XCTAssertEqual(m255(0,0), 255);
}

- (void)testNumberGetTensorUInt8QuantizedWithQuantizer {
    // It should convert the float_t numeric value to a uint8_t value
    
    TIODataQuantizer quantizer = ^uint8_t(float_t value) {
        return (uint8_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:YES
        quantizer:quantizer
        dequantizer:nil];
    
    NSNumber *n0 = @(0.0f);
    tensorflow::Tensor t0 = [n0 tensorWithDescription:description];
    auto m0 = t0.tensor<uint8_t, 2>();
    XCTAssertEqual(m0(0,0), 0);
    
    NSNumber *n1 = @(1.0f);
    tensorflow::Tensor t1 = [n1 tensorWithDescription:description];
    auto m1 = t1.tensor<uint8_t, 2>();
    XCTAssertEqual(m1(0,0), 1);
    
    NSNumber *n255 = @(255.0f);
    tensorflow::Tensor t255 = [n255 tensorWithDescription:description];
    auto m255 = t255.tensor<uint8_t, 2>();
    XCTAssertEqual(m255(0,0), 255);
}

// MARK: - NSNumber + TIOTFLiteData Init with Tensor

- (void)testNumberInitWithTensorFloatUnquantized {
    // It should return a number with the float_t numeric value
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_FLOAT, tensorflow::TensorShape({1,1}));
    tensor.tensor<float_t, 2>()(0,0) = 1.0f;
    
    NSNumber *number = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(number.floatValue, 1.0f);
}

- (void)testNumberInitWithTensorUInt8QuantizedWithoutDequantizer {
    // It should return a number with the uint8_t numeric value
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,1}));
    
    tensor.tensor<uint8_t, 2>()(0,0) = 0;
    NSNumber *n0 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n0.unsignedCharValue, 0);
    
    tensor.tensor<uint8_t, 2>()(0,0) = 1;
    NSNumber *n1 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n1.unsignedCharValue, 1);
    
    tensor.tensor<uint8_t, 2>()(0,0) = 255;
    NSNumber *n255 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n255.unsignedCharValue, 255);
}

- (void)testNumberInitWithTensorUInt8QuantizedWithDequantizer {
    // It should return a number by converting a uint8_t value to a float_t value
    
    TIODataDequantizer dequantizer = ^float_t(uint8_t value) {
        return (float_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(1)]
        length:1
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:dequantizer];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,1}));
    
    tensor.tensor<uint8_t, 2>()(0,0) = 0;
    NSNumber *n0 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n0.floatValue, 0.0f);
    
    tensor.tensor<uint8_t, 2>()(0,0) = 1;
    NSNumber *n1 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n1.floatValue, 1.0f);
    
    tensor.tensor<uint8_t, 2>()(0,0) = 255;
    NSNumber *n255 = [[NSNumber alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(n255.floatValue, 255.0f);
}

// MARK: - NSArray + TIOTFLiteData Get Tensor

- (void)testArrayGetTensorFloatUnquantized {
    // It should get the float_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    NSArray *numbers = @[@(-1.0f), @(0.0f), @(1.0f)];
    tensorflow::Tensor tensor = [numbers tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<float_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), -1.0f);
    XCTAssertEqual(tensor_mapped(0,1), 0.0f);
    XCTAssertEqual(tensor_mapped(0,2), 1.0f);
}

- (void)testArrayGetTensorUInt8QuantizedWithoutQuantizer {
    // It should get the uint8_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    NSArray *numbers = @[ @(0), @(1), @(255)];
    tensorflow::Tensor tensor = [numbers tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), 0);
    XCTAssertEqual(tensor_mapped(0,1), 1);
    XCTAssertEqual(tensor_mapped(0,2), 255);
}

- (void)testArrayGetTensorUInt8QuantizedWithQuantizer {
    // It should convert the float_t numeric values to uint8_t values
    
    TIODataQuantizer quantizer = ^uint8_t(float_t value) {
        return (uint8_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:quantizer
        dequantizer:nil];
    
    NSArray *numbers = @[ @(0.0f), @(1.0f), @(255.0f)];
    tensorflow::Tensor tensor = [numbers tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), 0);
    XCTAssertEqual(tensor_mapped(0,1), 1);
    XCTAssertEqual(tensor_mapped(0,2), 255);
}

// MARK: - NSArray + TIOTFLiteData Init with Tensor

- (void)testArrayInitWithTensorFloatUnquantized {
    // It should return an array of numbers with the float_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_FLOAT, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<float_t, 2>();
    tensor_mapped(0,0) = -1.0f;
    tensor_mapped(0,1) = 0.0f;
    tensor_mapped(0,2) = 1.0f;
    
    NSArray<NSNumber*> *numbers = [[NSArray alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(numbers[0].floatValue, -1.0f);
    XCTAssertEqual(numbers[1].floatValue, 0.0f);
    XCTAssertEqual(numbers[2].floatValue, 1.0f);
}

- (void)testArrayInitWithTensorUInt8QuantizedWithoutDequantizer {
    // It should return an array of numbers with the uint8_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    tensor_mapped(0,0) = 0;
    tensor_mapped(0,1) = 1;
    tensor_mapped(0,2) = 255;
    
    NSArray<NSNumber*> *numbers = [[NSArray alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(numbers[0].unsignedCharValue, 0);
    XCTAssertEqual(numbers[1].unsignedCharValue, 1);
    XCTAssertEqual(numbers[2].unsignedCharValue, 255);
}

- (void)testArrayInitWithTensorUInt8QuantizedWithDequantizer {
    // It should return an array of numbers by converting uint8_t values to float_t values
    
    TIODataDequantizer dequantizer = ^float_t(uint8_t value) {
        return (float_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:dequantizer];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    tensor_mapped(0,0) = 0;
    tensor_mapped(0,1) = 1;
    tensor_mapped(0,2) = 255;
    
    NSArray<NSNumber*> *numbers = [[NSArray alloc] initWithTensor:tensor description:description];
    XCTAssertEqual(numbers[0].unsignedCharValue, 0.0);
    XCTAssertEqual(numbers[1].unsignedCharValue, 1.0);
    XCTAssertEqual(numbers[2].unsignedCharValue, 255.0);
}

// MARK: - NSData + TIOTFLiteData Get Tensor

- (void)testDataGetTensorFloatUnquantized {
    // It should get the float_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    size_t len = 3 * sizeof(float_t);
    float_t bytes[3] = { -1.0f, 0.0f, 1.0f};
    NSData *data = [NSData dataWithBytes:bytes length:len];
    tensorflow::Tensor tensor = [data tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<float_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), -1.0f);
    XCTAssertEqual(tensor_mapped(0,1), 0.0f);
    XCTAssertEqual(tensor_mapped(0,2), 1.0f);
}

- (void)testDataGetTensorUInt8QuantizedWithoutQuantizer {
    // It should get the uint8_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    size_t len = 3 * sizeof(uint8_t);
    uint8_t bytes[3] = {0, 1, 255};
    NSData *data = [NSData dataWithBytes:bytes length:len];
    tensorflow::Tensor tensor = [data tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), 0);
    XCTAssertEqual(tensor_mapped(0,1), 1);
    XCTAssertEqual(tensor_mapped(0,2), 255);
}

- (void)testDataGetTensorUInt8QuantizedWithQuantizer {
    // It should convert the float_t numeric values to uint8_t values
    
    TIODataQuantizer quantizer = ^uint8_t(float_t value) {
        return (uint8_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:quantizer
        dequantizer:nil];
    
    size_t len = 3 * sizeof(float_t);
    float_t bytes[3] = { 0.0f, 1.0f, 255.0f};
    NSData *data = [NSData dataWithBytes:bytes length:len];
    tensorflow::Tensor tensor = [data tensorWithDescription:description];
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    
    XCTAssertEqual(tensor_mapped(0,0), 0);
    XCTAssertEqual(tensor_mapped(0,1), 1);
    XCTAssertEqual(tensor_mapped(0,2), 255);
}

// MARK: - NSData + TIOTFLiteData Init with Tensor

- (void)testDataInitWithTensorFloatUnquantized {
    // It should return an array of numbers with the float_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:NO
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_FLOAT, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<float_t, 2>();
    tensor_mapped(0,0) = -1.0f;
    tensor_mapped(0,1) = 0.0f;
    tensor_mapped(0,2) = 1.0f;
    
    NSData *numbers = [[NSData alloc] initWithTensor:tensor description:description];
    float_t *buffer = (float_t *)numbers.bytes;
    XCTAssertEqual(buffer[0], -1.0f);
    XCTAssertEqual(buffer[1], 0.0f);
    XCTAssertEqual(buffer[2], 1.0f);
}

- (void)testDataInitWithTensorUInt8QuantizedWithoutDequantizer {
    // It should return an array of numbers with the uint8_t numeric values
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:nil];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    tensor_mapped(0,0) = 0;
    tensor_mapped(0,1) = 1;
    tensor_mapped(0,2) = 255;
    
    NSData *numbers = [[NSData alloc] initWithTensor:tensor description:description];
    uint8_t *buffer = (uint8_t *)numbers.bytes;
    XCTAssertEqual(buffer[0], 0);
    XCTAssertEqual(buffer[1], 1);
    XCTAssertEqual(buffer[2], 255);
}

- (void)testDataInitWithTensorUInt8QuantizedWithDequantizer {
    // It should return an array of numbers by converting uint8_t values to float_t values
    
    TIODataDequantizer dequantizer = ^float_t(uint8_t value) {
        return (float_t)value;
    };
    
    TIOVectorLayerDescription *description = [[TIOVectorLayerDescription alloc]
        initWithShape:@[@(1),@(3)]
        length:3
        labels:nil
        quantized:YES
        quantizer:nil
        dequantizer:dequantizer];
    
    tensorflow::Tensor tensor(tensorflow::DT_UINT8, tensorflow::TensorShape({1,3}));
    auto tensor_mapped = tensor.tensor<uint8_t, 2>();
    tensor_mapped(0,0) = 0;
    tensor_mapped(0,1) = 1;
    tensor_mapped(0,2) = 255;
    
    NSData *numbers = [[NSData alloc] initWithTensor:tensor description:description];
    float_t *buffer = (float_t *)numbers.bytes;
    XCTAssertEqual(buffer[0], 0.0);
    XCTAssertEqual(buffer[1], 1.0);
    XCTAssertEqual(buffer[2], 255.0);
}

@end