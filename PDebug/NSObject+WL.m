//
//  NSObject+WL.m
//  Tomorning
//
//  Created by John Wong on 8/17/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "NSObject+WL.h"
#import <objc/runtime.h>

@implementation NSObject (WL)


+ (void)WL_hookStart
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"WonderBL") exchangeSelector:@selector(WL_pushDiscoverGame:cheatCode:) with:@selector(pushDiscoverGame:cheatCode:)];
        [NSClassFromString(@"WonderBL") exchangeSelector:@selector(itemDiscoverGame:logicID:) with:@selector(WL_itemDiscoverGame:logicID:)];
    });
}

+ (void)exchangeSelector:(SEL)s1 with:(SEL)s2
{
    Method m1 = class_getInstanceMethod(self, s1);
    Method m2 = class_getInstanceMethod(self, s2);
    method_exchangeImplementations(m1, m2);
}

- (void)WL_pushDiscoverGame:(id)game cheatCode:(NSString *)cheatCode
{
    for (int i = 0; i < 20; i++) {
        [self WL_pushDiscoverGame:game cheatCode:cheatCode];
    }
}

- (void)WL_itemDiscoverGame:(id)game logicID:(id)logicID
{
    for (int i = 0; i < 20; i ++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self WL_itemDiscoverGame:game logicID:logicID];
        });
    }
}

@end
