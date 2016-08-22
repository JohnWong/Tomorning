//
//  WLConfig.m
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLConfig.h"
#import <UIKit/UIKit.h>
#import "WLViewController.h"

@implementation WLConfig

+ (instancetype)sharedInstance
{
    static WLConfig *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (int)gameId
{
    return 122;
}

+ (NSString *)decryptedPath
{
    return [self docPathWithFolder:@"decrypt"];
}

+ (NSString *)scanPath
{
    return [self docPathWithFolder:@"scan"];
}

+ (NSString *)docPathWithFolder:(NSString *)folder
{
    NSString *docRoot = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *decryptPath = [docRoot stringByAppendingPathComponent:folder];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:decryptPath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:&error];
    return decryptPath;
}

+ (NSString *)gameResourcePath
{
    NSString *docRoot = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *resPath = [docRoot stringByAppendingPathComponent:@"gameResource"];
    return resPath;
}

+ (int)currentGameId
{
    UIViewController *currentVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (currentVc) {
        if (currentVc.presentedViewController) {
            currentVc = currentVc.presentedViewController;
        } else if ([currentVc isKindOfClass:[UITabBarController class]]) {
            currentVc = ((UITabBarController *)currentVc).selectedViewController;
        } else if ([currentVc isKindOfClass:[UINavigationController class]]) {
            currentVc = ((UINavigationController *)currentVc).topViewController;
        } else {
            break;
        }
    }
    int gameId;
    if ([currentVc isKindOfClass:NSClassFromString(@"WonderGameViewController")]
        || [currentVc isKindOfClass:NSClassFromString(@"WonderDetailViewController")]
        || [currentVc isKindOfClass:NSClassFromString(@"WonderChatViewController")]
        || [currentVc isKindOfClass:NSClassFromString(@"WonderStatusViewController")]
        || [currentVc isKindOfClass:NSClassFromString(@"WonderMoreViewController")]) {
        gameId = [[currentVc valueForKey:@"gameID"] intValue];
    }
    return gameId;
}

@end
