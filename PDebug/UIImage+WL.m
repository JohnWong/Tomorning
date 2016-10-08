//
//  UIImage+WL.m
//  Tomorning
//
//  Created by John Wong on 8/22/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIImage+WL.h"
#import <objc/runtime.h>
#import "WLConfig.h"
#import "UIImage+fixOrientation.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation UIImage (WL)

+ (void)load
{
    Method m1 = class_getClassMethod(self, @selector(WL_scaleFromeOrignalTo480_640:));
    Method m2 = class_getClassMethod(self, @selector(scaleFromeOrignalTo480_640:));
    method_exchangeImplementations(m1, m2);
}

+ (UIImage *)WL_scaleFromeOrignalTo480_640:(UIImage *)image
{
    if ([WLConfig sharedInstance].isAutoMode) {
        NSString *filePath = [WLConfig scanPath];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @([WLConfig gameId])]];
        filePath = [filePath stringByAppendingPathComponent:@"chap_1.jpg"];
        UIImage *fakeImage = [[UIImage alloc] initWithContentsOfFile:filePath];
        if (fakeImage) {
            image = fakeImage;
        }
    } else if ([WLConfig sharedInstance].fakeImage) {
        // fake数据扫描之后清理掉
        image = [WLConfig sharedInstance].fakeImage;
        [WLConfig sharedInstance].fakeImage = nil;
    } else {
        [WLConfig sharedInstance].lastScanData = UIImageJPEGRepresentation([image fixOrientation], 0.9);
    }
    UIImage *ret = [self WL_scaleFromeOrignalTo480_640:image];
    return ret;
}

@end
