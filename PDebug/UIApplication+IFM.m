//
//  UIApplication+IFM.m
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIApplication+IFM.h"
#import "WLViewController.h"
#import <objc/runtime.h>
#import "WLConfig.h"

@implementation UIApplication (IFM)

+ (void)load
{
    Method original = class_getInstanceMethod(self, @selector(sendEvent:));
    Method swizzled = class_getInstanceMethod(self, @selector(ifm_sendEvent:));
    method_exchangeImplementations(original, swizzled);
}

- (void)ifm_sendEvent:(UIEvent *)event
{
    [self ifm_sendEvent:event];
    if (event && (event.subtype == UIEventSubtypeMotionShake)) {
        if ([[event valueForKey:@"shakeState"] boolValue]) {
//            [self showHelper];
        }
    }
}

- (void)showHelper
{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    if ([root isKindOfClass:[WLNavigationController class]]) {
        return;
    }
    
    int gameId = [WLConfig currentGameId];
    if (gameId > 0) {
        UIViewController *vc = [[WLViewController alloc] initWithGameId:gameId];
        UIViewController *navVc = [[WLNavigationController alloc] initWithRootViewController:vc];
        [root presentViewController:navVc animated:YES completion:nil];
    }
}

@end
