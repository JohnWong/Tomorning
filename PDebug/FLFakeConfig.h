//
//  FLFakeConfig.h
//  FakeLocation
//
//  Created by John Wong on 8/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#define flessthan(a,b) (fabs(a) < fabs(b)+FLT_EPSILON)

@interface  FLFakeConfig : NSObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D selectedCoordinate;

- (CLLocationCoordinate2D)fakeCoordinate;

+ (instancetype)sharedInstance;

@end
