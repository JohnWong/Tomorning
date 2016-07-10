//
//  WonderlandHelper.m
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WonderlandHelper.h"
#import "WLConfig.h"

@implementation WonderlandHelper

+ (void)decrypt:(int)index
{
    NSString *idx = [NSString stringWithFormat:@"%@", @(index)];
    NSString *decryptPath = [[WLConfig decryptedPath] stringByAppendingPathComponent:idx];
    NSError *error;
    [[NSFileManager defaultManager]
     createDirectoryAtPath:decryptPath
     withIntermediateDirectories:NO
     attributes:nil
     error:&error];
    if (error) {
        NSLog(@"%@: %d %@", self.class, __LINE__, error);
        return;
    }
    
    NSString *resPath = [[WLConfig gameResourcePath] stringByAppendingPathComponent:idx];
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:resPath];
    for (NSString *path in subpaths) {
        NSString *src = [resPath stringByAppendingPathComponent:path];
        if ([path.pathExtension isEqualToString:@"mp3"]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:src toPath:[decryptPath stringByAppendingPathComponent:path] error:&error];
            if (error) {
                NSLog(@"%@: %d %@", self, __LINE__, error);
            }
            continue;
        }
        [self decrypt:src toPath:decryptPath];
    }
}

+ (void)decrypt:(NSString *)filePath toPath:(NSString *)toPath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fileName = [filePath lastPathComponent];
    Class cls = NSClassFromString(@"CryptoCommon");
    NSData *result = [cls performSelector:@selector(aesDecrypt:filename:) withObject:data withObject:fileName];
    [result writeToFile:[toPath stringByAppendingPathComponent:fileName] atomically:YES];
}

+ (void)decryptIfNeed
{
    
}

@end
