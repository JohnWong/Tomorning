//
//  WLViewController.h
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLNavigationController : UINavigationController

@end

@interface WLViewController : UITableViewController

@property (nonatomic, assign, readonly) int gameId;

- (instancetype)initWithGameId:(int)gameId;

@end
