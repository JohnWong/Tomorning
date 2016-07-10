//
//  WLGame.h
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WLStep : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int chap;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *englishTitle;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *tailPic;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSDictionary *raw;
@property (nonatomic, strong) NSString *audio;

@end

@interface WLChapter : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *englishTitle;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, copy) NSArray<WLStep *> *steps;
@property (nonatomic, copy) NSArray<WLStep *> *filteredSteps;
@property (nonatomic, strong) NSDictionary *raw;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end


@interface WLGame : NSObject

@property (nonatomic, readonly) int gameId;
@property (nonatomic, strong) NSArray<WLChapter *> *chapters;

- (instancetype)initWithGameId:(int)gameId;

@end
