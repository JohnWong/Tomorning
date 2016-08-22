//
//  WLConfig.h
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLConfig : NSObject

+ (NSString *)decryptedPath;
+ (NSString *)scanPath;
+ (NSString *)gameResourcePath;
+ (int)gameId;

+ (instancetype)sharedInstance;

+ (int)currentGameId;

@property (nonatomic, strong) NSData *lastScanData;
@property (nonatomic, assign) BOOL isAutoMode;
@end
