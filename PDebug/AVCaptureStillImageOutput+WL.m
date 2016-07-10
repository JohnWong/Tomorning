//
//  AVCaptureStillImageOutput+WL.m
//  Tomorning
//
//  Created by John Wong on 7/9/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "AVCaptureStillImageOutput+WL.h"
#import <objc/runtime.h>
#import "WLConfig.h"

@implementation AVCaptureStillImageOutput (WL)


+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(WL_captureStillImageAsynchronouslyFromConnection:completionHandler:));
    Method m2 = class_getInstanceMethod(self, @selector(captureStillImageAsynchronouslyFromConnection:completionHandler:));
    method_exchangeImplementations(m1, m2);
}

- (void)WL_captureStillImageAsynchronouslyFromConnection:(AVCaptureConnection *)connection completionHandler:(void (^)(CMSampleBufferRef, NSError *))handler
{
    [self WL_captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(imageDataSampleBuffer);
                size_t blockBufferLength;
                char *blockBufferPointer;
                CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &blockBufferLength, &blockBufferPointer);
                NSData *data = [NSData dataWithBytes:blockBufferPointer length:blockBufferLength];
                [WLConfig sharedInstance].lastScanData = data;
            });
        }
        handler(imageDataSampleBuffer, error);
    }];
}

@end
