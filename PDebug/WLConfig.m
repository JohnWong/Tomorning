//
//  WLConfig.m
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLConfig.h"

@implementation WLConfig

+ (NSString *)decryptedPath
{
    NSString *docRoot = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *decryptPath = [docRoot stringByAppendingPathComponent:@"decrypt"];
    NSError *error;
    [[NSFileManager defaultManager]
     createDirectoryAtPath:decryptPath
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

@end
