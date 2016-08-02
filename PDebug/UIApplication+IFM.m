//
//  UIApplication+IFM.m
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIApplication+IFM.h"
#import <objc/runtime.h>
#import "FKViewController.h"

@interface UIApplication (IFM) <FKViewControllerDelegate>

@end

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
            [self showHelper];
        }
    }
}

- (UIWindow *)tweakWindow
{
    const void *key = @"tweakWindow";
    UIWindow *window = objc_getAssociatedObject(self, key);
    if (!window) {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = [self controller];
        window.windowLevel = UIWindowLevelStatusBar + 100;
        objc_setAssociatedObject(self, key, window, OBJC_ASSOCIATION_RETAIN);
    }
    return window;
}

- (UIViewController *)controller
{
    FKViewController *viewController = [[FKViewController alloc] init];
    viewController.fkDelegate = self;
    return viewController;
}

- (void)showHelper
{
    UIWindow *window = [self tweakWindow];
    window.rootViewController = [self controller];
    [window makeKeyAndVisible];
}

- (void)dismiss
{
    UIWindow *window = [self tweakWindow];
    [window resignKeyWindow];
    window.hidden = YES;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    window.rootViewController = nil;
}

@end
