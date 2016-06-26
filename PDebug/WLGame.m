//
//  WLGame.m
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLGame.h"
#import "WLConfig.h"

@implementation WLStep

- (instancetype)initWithDictionary:(NSDictionary *)dict path:(NSString *)baseBath
{
    self = [super init];
    if (self) {
        _index = [dict[@"index"] intValue];
        _type = [dict[@"type"] intValue];
        _chap = [dict[@"chap"] intValue];
        _title = dict[@"title"];
        _englishTitle = dict[@"english_title"];
        _pic = [baseBath stringByAppendingPathComponent:dict[@"pic"] ? : @""];
        _tailPic = [baseBath stringByAppendingPathComponent:dict[@"tail_pic"] ? : @""];
        _content = dict[@"content"];
        _options = dict[@"options"];
        _password = dict[@"password"];
        if (dict[@"audio"]) {
            _audio = [baseBath stringByAppendingPathComponent:dict[@"audio"] ? : @""];
        }
        _raw = dict;
    }
    return self;
}

@end

@implementation WLChapter

- (instancetype)initWithDictionary:(NSDictionary *)dict path:(NSString *)baseBath
{
    self = [super init];
    if (self) {
        _index = [dict[@"index"] intValue];
        _type = [dict[@"type"] intValue];
        _title = dict[@"title"];
        _englishTitle = dict[@"english_title"];
        _pic = [baseBath stringByAppendingPathComponent:dict[@"pic"] ? : @""];
        _steps = [NSMutableArray array];
        _raw = dict;
        _latitude = [dict[@"latitude"] doubleValue];
        _longitude = [dict[@"longitude"] doubleValue];
    }
    return self;
}

- (void)addStep:(WLStep *)step
{
    NSMutableArray *steps = (NSMutableArray *)_steps;
    [steps addObject:step];
}

@end

@implementation WLGame

+ (NSDictionary *)dictWithPath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    if (data.length  == 0) {
        NSLog(@"%@: %d %@ %@", self, __LINE__, path, error);
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"%@: %d %@ %@", self, __LINE__, path, error);
        return nil;
    }
    return dict;
}

- (instancetype)initWithGameId:(int)gameId
{
    self = [super init];
    if (self) {
        _gameId = gameId;
        NSString *decryptedPath = [[WLConfig decryptedPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @(_gameId)]];
        NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:decryptedPath];
        NSMutableArray *chapters = [NSMutableArray array];
        NSMutableArray *steps = [NSMutableArray array];
        for (NSString *path in subpaths) {
            NSArray *splited = [path componentsSeparatedByString:@"_"];
            NSString *type = splited.firstObject;
            NSString *filePath = [decryptedPath stringByAppendingPathComponent:path];
            if ([type isEqualToString:@"chap"]) {
                NSDictionary *dict = [self.class dictWithPath:filePath];
                if (!dict) {
                    NSLog(@"%@: %d", self.class, __LINE__);
                    continue;
                }
                WLChapter *chapter = [[WLChapter alloc] initWithDictionary:dict path:decryptedPath];
                [chapters addObject:chapter];
            } else if ([type isEqualToString:@"step"]) {
                NSDictionary *dict = [self.class dictWithPath:filePath];
                if (!dict) {
                    NSLog(@"%@: %d", self.class, __LINE__);
                    continue;
                }
                WLStep *step = [[WLStep alloc] initWithDictionary:dict path:decryptedPath];
                [steps addObject:step];
            } else {
                
            }
        }
        NSMutableDictionary *chapterDict = [NSMutableDictionary dictionaryWithCapacity:chapters.count];
        for (WLChapter *chapter in chapters) {
            [chapterDict setObject:chapter forKey:@(chapter.index)];
        }
        for (WLStep *step in steps) {
            WLChapter *chapter = chapterDict[@(step.chap)];
            if (!chapter) {
                NSLog(@"%@: %d", self.class, __LINE__);
                continue;
            }
            [chapter addStep:step];
        }
        [chapters removeAllObjects];
        for (NSNumber *key in [chapterDict.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
            [chapters addObject:chapterDict[key]];
        }
        _chapters = chapters;
    }
    return self;
}

@end
