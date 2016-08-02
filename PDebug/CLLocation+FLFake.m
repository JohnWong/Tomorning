//
//  CLLocation+FLFake.m
//  FakeLocation
//
//  Created by John Wong on 8/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "CLLocation+FLFake.h"
#import <objc/runtime.h>
#import "FLFakeConfig.h"

@implementation CLLocation (FLFake)

+ (void)load {
    {
        Method originMethod = class_getInstanceMethod([CLLocation class], @selector(coordinate));
        Method swizzleMethod = class_getInstanceMethod([CLLocation class], @selector(fl_coordinate));
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

- (CLLocationCoordinate2D)fl_coordinate {
    NSLog(@"Start updating location");
    FLFakeConfig *fakeConfig = [FLFakeConfig sharedInstance];
    if (fakeConfig.enabled) {
        return fakeConfig.fakeCoordinate;
    } else {
        return [self fl_coordinate];
    }
}

@end
