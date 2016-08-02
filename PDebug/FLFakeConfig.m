//
//  FLFakeConfig.m
//  FakeLocation
//
//  Created by John Wong on 8/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "FLFakeConfig.h"

@interface FLFakeConfig ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

static NSString * const kFLDeltaLatitude = @"FLDeltaLatitude";
static NSString * const kFLDeltaLongitude = @"FLDeltaLongitude";
static NSString * const kFLEnabled = @"kFLEnabled";

@implementation FLFakeConfig

+ (instancetype)sharedInstance {
    static FLFakeConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [[NSUserDefaults alloc] initWithUser:@"com.johnwong.FakeLocation"];
        _userCoordinate = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

- (BOOL)enabled {
    return [_userDefaults boolForKey:kFLEnabled];
}

- (void)setEnabled:(BOOL)enabled
{
    [_userDefaults setBool:enabled forKey:kFLEnabled];
    [_userDefaults synchronize];
}

- (CLLocationCoordinate2D)fakeCoordinate
{
    id deltaLatitude = [_userDefaults valueForKey:kFLDeltaLatitude];
    id deltaLongitude = [_userDefaults valueForKey:kFLDeltaLongitude];
    if (CLLocationCoordinate2DIsValid(_userCoordinate) && deltaLatitude && deltaLongitude) {
        return CLLocationCoordinate2DMake(_userCoordinate.latitude += [deltaLatitude doubleValue], _userCoordinate.longitude += [deltaLongitude doubleValue]);
    } else {
        return CLLocationCoordinate2DMake(-33.8921472, 151.1851398);;
    }
}

- (void)setSelectedCoordinate:(CLLocationCoordinate2D)selectedCoordinate
{
    if (CLLocationCoordinate2DIsValid(_userCoordinate)) {
        double deltaLatitude = selectedCoordinate.latitude - _userCoordinate.latitude;
        double deltaLongitude = selectedCoordinate.longitude - _userCoordinate.longitude;
        
        [_userDefaults setValue:@(deltaLatitude) forKey:kFLDeltaLatitude];
        [_userDefaults setValue:@(deltaLongitude) forKey:kFLDeltaLongitude];
        [_userDefaults synchronize];
    }
}

@end
