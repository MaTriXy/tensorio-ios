//
//  TIOPixelBuffer+TIOTensorFlowData.m
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

#import "TIOPixelBuffer+TIOTensorFlowData.h"
#import "TIOPixelBufferLayerDescription.h"
#import "TIOVisionPipeline.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#include "tensorflow/core/framework/tensor.h"
#pragma clang diagnostic pop

/**
 * Copies a pixel buffer in ARGB or BGRA format to a tensor.
 *
 * The pixel buffer must already be in the shape and format expected by the input tensor,
 * with the shape parameter describing its dimensions. The alpha channel will be ignored.
 *
 * If a normalizer is provided then the pixel buffer's values will be scaled using the
 * normalizer.
 *
 * `tensor_t` will be `float_t` (32 bits) for an unquantized model or `uint8_t` (8 bits)
 * for a quantized model.
 *
 * @param pixelBuffer The pixel buffer that will be copied to the tensor.
 * @param tensor The tensor that will receive the pixel buffer values.
 * @param shape The shape, i.e. width, height, and number of channels of the tensor.
 * @param normalizer A scaling function that will be applied to the pixel values as
 * they are copied to the tensor. May be `nil`.
 */

template <typename T>
void TIOCopyCVPixelBufferToTensorFlowTensor(CVPixelBufferRef pixelBuffer, tensorflow::Tensor tensor, TIOImageVolume shape, _Nullable TIOPixelNormalizer normalizer, size_t offset) {
    
    CFRetain(pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, kNilOptions);
    
    OSType sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    const int bytes_per_row = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    const int image_width = (int)CVPixelBufferGetWidth(pixelBuffer);
    const int image_height = (int)CVPixelBufferGetHeight(pixelBuffer);
    const int image_channels = 4; // by definition (ARGB, BGRA)
    const int tensor_channels = shape.channels; // should be 3 by definition (ARG, BGR)
    const int tensor_bytes_per_row = shape.width * tensor_channels;
    const int channel_offset = sourcePixelFormat == kCVPixelFormatType_32ARGB
        ? 1
        : 0;
    
    assert(sourcePixelFormat == kCVPixelFormatType_32ARGB
        || sourcePixelFormat == kCVPixelFormatType_32BGRA);
    
    assert(image_width == shape.width);
    assert(image_height == shape.height);
    assert(image_channels >= shape.channels);
    
    uint8_t* in = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
    T* out = tensor.flat<T>().data() + offset;
    
    if ( normalizer == nil ) {
        for (int y = 0; y < image_height; y++) {
            for (int x = 0; x < image_width; x++) {
                auto* in_pixel = in + (y * bytes_per_row) + (x * image_channels);
                auto* out_pixel = out + (y * tensor_bytes_per_row) + (x * tensor_channels);
                for (int c = 0; c < tensor_channels; ++c) {
                    out_pixel[c] = in_pixel[c+channel_offset];
                }
            }
        }
    } else {
        for (int y = 0; y < image_height; y++) {
            for (int x = 0; x < image_width; x++) {
                auto* in_pixel = in + (y * bytes_per_row) + (x * image_channels);
                auto* out_pixel = out + (y * tensor_bytes_per_row) + (x * tensor_channels);
                for (int c = 0; c < tensor_channels; ++c) {
                    out_pixel[c] = normalizer(in_pixel[c+channel_offset], c);
                }
            }
        }
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kNilOptions);
    CFRelease(pixelBuffer);
}

// TODO: ensure 16 byte pixel buffer alignment

/**
 * Copies tensor bytes directly into a pixel buffer from a tensor, applying a denormalization
 * function and adjusting for the pixel format.
 *
 * The resulting pixel buffer will (eventually) be 16 byte aligned. The caller must release the
 * pixelBuffer with `CVPixelBufferRelease`.
 *
 * @param pixelBuffer A pointer to the pixel buffer that will be filled with the transformed tensor data
 * @param tensor A pointer to the tensor that contains the image data
 * @param shape The width, height, and number of channels of the tensor. Number of channels should be three.
 * @param pixelFormat The format of the tensor image data, must be kCVPixelFormatType_32ARGB or kCVPixelFormatType_32BGRA.
 * Note that the alpha channel is ignored.
 * @param denormalizer A function that can convert the tensor image data to pixel values, may be `nil`.
 *
 * @return CVReturn `kCVReturnSuccess` if the operation was successful, some other value if not
 */

template <typename T>
CVReturn TIOCreateCVPixelBufferFromTensorFlowTensor(_Nonnull CVPixelBufferRef * _Nonnull pixelBuffer, tensorflow::Tensor tensor, TIOImageVolume shape, OSType pixelFormat, _Nullable TIOPixelDenormalizer denormalizer) {
    
    assert( pixelFormat == kCVPixelFormatType_32ARGB || pixelFormat == kCVPixelFormatType_32BGRA );
    assert( shape.width % 16 == 0);
    
    const int tensor_channels = shape.channels;
    const int tensor_bytes_per_row = shape.width * tensor_channels;
    const int image_width = shape.width;
    const int image_height = shape.height;
    const int bytes_per_row = shape.width * 4;
    const int image_channels = 4; // by definition (ARGB, BGRA)
    
    CVPixelBufferRef outputBuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(
        kCFAllocatorDefault,
        image_width,
        image_height,
        pixelFormat,
        NULL,
        &outputBuffer);
    
    // Error handling
    
    if ( status != kCVReturnSuccess ) {
        NSLog(@"Couldn't create pixel buffer");
        return status;
    }
    
    // Copy the pixel data
    
    // channel_offset is used to skip the alpha channel when copying to the tensor
    // it is 1 for ARGB images and 0 for BGRA images.
    
    CVPixelBufferLockBaseAddress(outputBuffer, kNilOptions);
    
    const int channel_offset = pixelFormat == kCVPixelFormatType_32ARGB
        ? 1
        : 0;
    
    const int alpha_channel = pixelFormat == kCVPixelFormatType_32ARGB
        ? 0
        : 3;
    
    T* in_addr = tensor.flat<T>().data();
    uint8_t* out_addr = (uint8_t *)CVPixelBufferGetBaseAddress(outputBuffer);
    
    if ( denormalizer == nil ) {
        for (int y = 0; y < image_height; y++) {
            for (int x = 0; x < image_width; x++) {
                auto* in_pixel = in_addr + (y * tensor_bytes_per_row) + (x * tensor_channels);
                auto* out_pixel = out_addr + (y * bytes_per_row) + (x * image_channels);
                for (int c = 0; c < tensor_channels; ++c) {
                    out_pixel[c+channel_offset] = in_pixel[c];
                }
                out_pixel[alpha_channel] = 255;
            }
        }
    } else {
        for (int y = 0; y < image_height; y++) {
            for (int x = 0; x < image_width; x++) {
                auto* out_pixel = out_addr + (y * bytes_per_row) + (x * image_channels);
                auto* in_pixel = in_addr + (y * tensor_bytes_per_row) + (x * tensor_channels);
                for (int c = 0; c < tensor_channels; ++c) {
                    out_pixel[c+channel_offset] = denormalizer(in_pixel[c], c);
                }
                out_pixel[alpha_channel] = 255;
            }
        }
    }
    
    // Clean up
    
    CVPixelBufferUnlockBaseAddress(outputBuffer, kNilOptions);
    *pixelBuffer = outputBuffer;
    
    return kCVReturnSuccess;
}

// MARK: -

@interface TIOPixelBuffer (TIOTensorFlowData_Protected)

@property (readwrite) CVPixelBufferRef transformedPixelBuffer;

@end

@implementation TIOPixelBuffer (TIOTensorFlowData)

- (nullable instancetype)initWithTensor:(tensorflow::Tensor)tensor description:(id<TIOLayerDescription>)description {
    assert([description isKindOfClass:TIOPixelBufferLayerDescription.class]);
    
    TIOPixelBufferLayerDescription *pixelBufferDescription = (TIOPixelBufferLayerDescription *)description;
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn result;
    
    if ( description.isQuantized ) {
        result = TIOCreateCVPixelBufferFromTensorFlowTensor<uint8_t>(
            &pixelBuffer,
            tensor,
            pixelBufferDescription.imageVolume,
            pixelBufferDescription.pixelFormat,
            pixelBufferDescription.denormalizer
        );
    } else {
        result = TIOCreateCVPixelBufferFromTensorFlowTensor<float_t>(
            &pixelBuffer,
            tensor,
            pixelBufferDescription.imageVolume,
            pixelBufferDescription.pixelFormat,
            pixelBufferDescription.denormalizer
        );
    }
    
    if ( result != kCVReturnSuccess ) {
        NSLog(@"There was a problem creating the pixel buffer from the tensor");
        return nil;
    }
    
    return [self initWithPixelBuffer:pixelBuffer orientation:kCGImagePropertyOrientationUp];
}

- (tensorflow::Tensor)tensorWithDescription:(id<TIOLayerDescription>)description {
    return [TIOPixelBuffer tensorWithColumn:@[self] description:description];
}

// MARK: - Batch (Training)

+ (tensorflow::Tensor)tensorWithColumn:(NSArray<id<TIOTensorFlowData>>*)column description:(id<TIOLayerDescription>)description {
    assert([description isKindOfClass:TIOPixelBufferLayerDescription.class]);
    
    int32_t batch_size = (int32_t)column.count;
    
    TIOPixelBufferLayerDescription *pixelBufferDescription = (TIOPixelBufferLayerDescription *)description;
    
    // Tensor shape
    
    const int t_channels = pixelBufferDescription.imageVolume.channels;
    const int t_width = pixelBufferDescription.imageVolume.width;
    const int t_height = pixelBufferDescription.imageVolume.height;
    const int length = t_height * t_width * t_channels;
    
    std::vector<tensorflow::int64> dims;
    
    if ( description.isBatched ) {
        dims.push_back(batch_size);
    }
    
    dims.push_back(t_height);
    dims.push_back(t_width);
    dims.push_back(t_channels);
    
    tensorflow::gtl::ArraySlice<tensorflow::int64> dim_sizes(dims);
    tensorflow::TensorShape shape = tensorflow::TensorShape(dim_sizes);
    
    // Typed enumeration over the column
    
    if ( description.isQuantized ) {
        tensorflow::Tensor tensor(tensorflow::DT_UINT8, shape);
        
        [column enumerateObjectsUsingBlock:^(id<TIOTensorFlowData> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            size_t offset = idx * length;
           
            CVPixelBufferRef pixelBuffer = ((TIOPixelBuffer *)obj).pixelBuffer;
            CGImagePropertyOrientation orientation = ((TIOPixelBuffer *)obj).orientation;
            
            CVPixelBufferRef transformedPixelBuffer;
            
            int width = (int)CVPixelBufferGetWidth(pixelBuffer);
            int height = (int)CVPixelBufferGetHeight(pixelBuffer);
            OSType pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
            
            // Transform image using vision pipeline
            
            if ( width == pixelBufferDescription.imageVolume.width
                && height == pixelBufferDescription.imageVolume.height
                && pixelFormat == pixelBufferDescription.pixelFormat
                && orientation == kCGImagePropertyOrientationUp ) {
                transformedPixelBuffer = pixelBuffer;
            } else {
                TIOVisionPipeline *pipeline = [[TIOVisionPipeline alloc] initWithTIOPixelBufferDescription:pixelBufferDescription];
                transformedPixelBuffer = [pipeline transform:pixelBuffer orientation:orientation];
            }
            
            CVPixelBufferRetain(transformedPixelBuffer);
            ((TIOPixelBuffer *)obj).transformedPixelBuffer = transformedPixelBuffer;
            
            TIOCopyCVPixelBufferToTensorFlowTensor<uint8_t>(
                transformedPixelBuffer,
                tensor,
                pixelBufferDescription.imageVolume,
                pixelBufferDescription.normalizer,
                offset);
        }];
        
        return tensor;
    } else {
        tensorflow::Tensor tensor(tensorflow::DT_FLOAT, shape);
        
        [column enumerateObjectsUsingBlock:^(id<TIOTensorFlowData> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            size_t offset = idx * length;
            
            CVPixelBufferRef pixelBuffer = ((TIOPixelBuffer *)obj).pixelBuffer;
            CGImagePropertyOrientation orientation = ((TIOPixelBuffer *)obj).orientation;
            
            CVPixelBufferRef transformedPixelBuffer;
            
            int width = (int)CVPixelBufferGetWidth(pixelBuffer);
            int height = (int)CVPixelBufferGetHeight(pixelBuffer);
            OSType pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
            
            // Transform image using vision pipeline
            
            if ( width == pixelBufferDescription.imageVolume.width
                && height == pixelBufferDescription.imageVolume.height
                && pixelFormat == pixelBufferDescription.pixelFormat
                && orientation == kCGImagePropertyOrientationUp ) {
                transformedPixelBuffer = pixelBuffer;
            } else {
                TIOVisionPipeline *pipeline = [[TIOVisionPipeline alloc] initWithTIOPixelBufferDescription:pixelBufferDescription];
                transformedPixelBuffer = [pipeline transform:pixelBuffer orientation:orientation];
            }
            
            CVPixelBufferRetain(transformedPixelBuffer);
            ((TIOPixelBuffer *)obj).transformedPixelBuffer = transformedPixelBuffer;
            
            TIOCopyCVPixelBufferToTensorFlowTensor<float_t>(
                transformedPixelBuffer,
                tensor,
                pixelBufferDescription.imageVolume,
                pixelBufferDescription.normalizer,
                offset);
        }];
        
        return tensor;
    }
}

@end
