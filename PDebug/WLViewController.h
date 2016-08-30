//
//  WLViewController.h
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface WLNavigationController : UINavigationController

@end

@interface WLViewController : UITableViewController<MWPhotoBrowserDelegate>

@property (nonatomic, assign, readonly) int gameId;
@property (nonatomic, strong) NSMutableArray *photos;

- (instancetype)initWithGameId:(int)gameId;

@end
