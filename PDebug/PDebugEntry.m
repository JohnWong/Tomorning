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
#import "CTBlockDescription.h"
#import "CTObjectiveCRuntimeAdditions.h"
#import "WLConfig.h"

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

typedef void(^WLScanResult)(NSDictionary *dict, bool b, long l);

@implementation PDebugEntry

- (void)WL_scanTagWithImageData:(id)data withResult:(WLScanResult)result
{
    CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:result];
    
    // getting a method signature for this block
    NSMethodSignature *methodSignature = blockDescription.blockSignature;
    NSLog(@"%@", methodSignature);
    
    __block WLScanResult resultBlock = [result copy];
    WLScanResult block = ^(NSDictionary *dict, bool b, long l) {
        if (b) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *scanData = [WLConfig sharedInstance].lastScanData;
                int gameId = [WLConfig currentGameId];
                if (scanData.length > 0 && gameId > 0) {
                    NSString *filePath = [WLConfig decryptedPath];
                    filePath = [filePath stringByAppendingPathComponent:@"scan"];
                    NSError *error;
                    [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                              withIntermediateDirectories:NO
                                                               attributes:nil
                                                                    error:&error];
                    
                    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @(gameId)]];
                    [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                              withIntermediateDirectories:NO
                                                               attributes:nil
                                                                    error:&error];
                    
                    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"chap_%@.jpg", dict[@"chapter"]]];
                    [scanData writeToFile:filePath atomically:YES];
                }
            });
        }
        resultBlock(dict, b, l);
    };
    [self WL_scanTagWithImageData:data withResult:block];
}

- (void)toFeaturedDetailWithGameID:(id)gameId type:(int)type
{
    
}

+(void)load
{
    orig_dlsym = dlsym(RTLD_DEFAULT, "dlsym");
    rebind_symbols((struct rebinding[1]){{"dlsym", my_dlsym}}, 1);
    NSLog(@"PDebug injected.");
    
    {
        Class c = NSClassFromString(@"WonderTreasureHelper");
        SEL originalSelector = NSSelectorFromString(@"scanTagWithImageData:withResult:");
        SEL swizzledSelector = @selector(WL_scanTagWithImageData:withResult:);
        Method m = class_getInstanceMethod(self, swizzledSelector);
        class_addMethod(c, swizzledSelector, method_getImplementation(m), method_getTypeEncoding(m));
        
        class_swizzleSelector(c, originalSelector, swizzledSelector);
    }
    {
        Class c = NSClassFromString(@"FeaturedTableViewController");
        SEL sel = @selector(toFeaturedDetailWithGameID:type:);
        Method m1 = class_getInstanceMethod(self, sel);
        Method m2 = class_getInstanceMethod(c, sel);
//        method_exchangeImplementations(m1, m2);
    }
    
//    [[NSObject class] performSelector:@selector(WL_hookStart)];
    
}

@end
