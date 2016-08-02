//
//  FKViewController.h
//  pokemongo
//
//  Created by John Wong on 7/11/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKViewControllerDelegate <NSObject>

- (void)dismiss;

@end

@interface FKViewController : UINavigationController

@property (nonatomic, weak) id<FKViewControllerDelegate> fkDelegate;

@end
