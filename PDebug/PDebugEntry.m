//
//  PDebugEntry.m
//  Portal
//
//  Created by Ethan on 15/3/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "PDebugEntry.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import "fishhook.h"
#import "PBMTool.h"

static void * (*orig_dlsym)(void *, const char *);

int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data)
{
    return 0;
}

void * my_dlsym(void * __handle, const char * __symbol)
{
    if (strcmp(__symbol, "ptrace") == 0) {
        return &my_ptrace;
    }
    
    return orig_dlsym(__handle, __symbol);
}

@interface _CryptoCommon: NSObject

@end

@implementation _CryptoCommon

+ (id)aesDecrypt:(id)arg0 filename:(id)arg1
{
    NSData *result = [_CryptoCommon aesDecrypt:arg0 filename:arg1];
    
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"%@ %@", arg0, arg1);
    NSLog(@"%@", result);
    NSLog(@"%@", str);
    return result;
}

@end


@implementation PDebugEntry

+ (void)decrypt:(NSString *)idx
{
    NSString *docRoot = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *decryptPath = [docRoot stringByAppendingPathComponent:@"decrypt"];
    NSError *error = nil;
    [[NSFileManager defaultManager]
     createDirectoryAtPath:decryptPath
     withIntermediateDirectories:NO
     attributes:nil
     error:&error];

    decryptPath = [decryptPath stringByAppendingPathComponent:idx];
    [[NSFileManager defaultManager]
     createDirectoryAtPath:decryptPath
     withIntermediateDirectories:NO
     attributes:nil
     error:&error];
    
    NSString *resPath = [[docRoot stringByAppendingPathComponent:@"gameResource"] stringByAppendingPathComponent:idx];
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:resPath];
    for (NSString *path in subpaths) {
        [self decrypt:[resPath stringByAppendingPathComponent:path] toPath:decryptPath];
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

- (void)scanSuccessWithInfo:(id)treasures
{
    
}

+(void)load
{
    orig_dlsym = dlsym(RTLD_DEFAULT, "dlsym");
    rebind_symbols((struct rebinding[1]){{"dlsym", my_dlsym}}, 1);
    
    NSLog(@"PDebug injected.");
    
//    Class c1 = NSClassFromString(@"CryptoCommon");
//    Class c2 = NSClassFromString(@"_CryptoCommon");
//    SEL sel = @selector(aesDecrypt:filename:);
//    
//    Method ori_Method = class_getClassMethod(c1, sel);
//    Method my_Method = class_getClassMethod(c2, sel);
//    method_exchangeImplementations(ori_Method, my_Method);
//    [self decrypt];
    
    
//    Method m1 = class_getInstanceMethod(self, NSSelectorFromString(@"addGameChapter:"));
//    Method m2 = class_getInstanceMethod(NSClassFromString(@"GameChapter"), NSSelectorFromString(@"addGameChapter:"));
//    method_exchangeImplementations(m1, m2);
//    [PBMTool start];
    [PDebugEntry decrypt:@"10024"];
}

- (void)addGameChapter:(id)chapter
{
    
}

+ (NSDictionary *)result:(id)vc
{
    NSString *docRoot = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *resPath = [[[docRoot stringByAppendingPathComponent:@"gameResource"]
                         stringByAppendingPathComponent:@"103"]
                         stringByAppendingPathComponent:@"jpg_24.jpg"];
    
    id model = [[NSClassFromString(@"GameChapterModel") alloc] init];
    [model performSelector:@selector(setChapterTitle:) withObject:@"123"];
    [model performSelector:@selector(setChapterIconPath:) withObject:resPath];
    
    NSDictionary *dict = @{
                           @"chapter": @1,
                           @"next": @2,
                           @"point": @"{240, 320}",
                           @"result": @213,
                           @"model": model
                           };
    return dict;
}

+ (id)chapter
{
    id chapter = [[NSClassFromString(@"GameChapter") alloc] init];
    [chapter performSelector:NSSelectorFromString(@"setChapterID:") withObject:@2];
    [chapter performSelector:NSSelectorFromString(@"setPointIndex:") withObject:@3];
    return chapter;
}

@end
