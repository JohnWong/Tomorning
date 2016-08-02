//
//  CLLocation+FLFake.h
//  FakeLocation
//
//  Created by John Wong on 8/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (FLFake)

- (CLLocationCoordinate2D)fl_coordinate;

@end
