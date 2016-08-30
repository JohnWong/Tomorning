//
//  UIViewController+WL.m
//  Tomorning
//
//  Created by John Wong on 6/27/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIViewController+WL.h"
#import <objc/runtime.h>
#import <MapKit/MapKit.h>
#import "WLConfig.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "UIView+RSAdditions.h"
#import <AVFoundation/AVFoundation.h>

static char kAssociatedObjectKey;

@implementation UIViewController (WL)

+ (void)initialize
{
    if (self == NSClassFromString(@"TreasureMapViewController")) {
        [self exchangeSelector:@selector(mapView:viewForAnnotation:) with:@selector(WL_mapView:viewForAnnotation:)];
        [self exchangeSelector:@selector(viewDidLoad) with:@selector(TM_viewDidLoad)];
    } else if (self == NSClassFromString(@"WonderGameViewController")) {
        [self exchangeSelector:@selector(viewDidLoad) with:@selector(WG_viewDidLoad)];
        [self exchangeSelector:@selector(viewDidAppear:) with:@selector(WG_viewDidAppear:)];
        [self exchangeSelector:@selector(takePhoto:) with:@selector(WG_takePhoto:)];
    } else if (self == NSClassFromString(@"FeaturedTableViewController")) {
        [self exchangeSelector:@selector(viewDidLoad) with:@selector(TB_viewDidLoad)];
        [self exchangeSelector:@selector(viewDidAppear:) with:@selector(TB_viewDidAppear:)];
    } else if (self == NSClassFromString(@"FeaturedDetailViewController")) {
        [self exchangeSelector:@selector(viewDidLoad) with:@selector(FD_viewDidLoad)];
    } else if (self == NSClassFromString(@"DiscoverGameViewController")) {
        [self exchangeSelector:@selector(WL_wonderDidFetchDiscoverGameWorldItem:node:) with:@selector(wonderDidFetchDiscoverGameWorldItem:node:)];
        [self exchangeSelector:@selector(WL_exchangeItem:) with:@selector(exchangeItem:)];
    } else if (self == NSClassFromString(@"TagDetailViewController")) {
        [self exchangeSelector:@selector(viewDidAppear:) with:@selector(TD_viewDidAppear:)];
    } else if (self == NSClassFromString(@"WonderMoreViewController")) {
        [self exchangeSelector:@selector(viewDidAppear:) with:@selector(WM_viewDidAppear:)];
    } else if (self == NSClassFromString(@"MineViewController")) {
        [self exchangeSelector:@selector(wonderDidFetchUserInfo:medalList:playingList:) with:@selector(MN_wonderDidFetchUserInfo:medalList:playingList:)];
    }
}

- (void)MN_wonderDidFetchUserInfo:(id)info medalList:(NSMutableArray *)medal playingList:(id)list
{
    // 奖章
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSMutableArray *arr in medal) {
//        for (id badge in arr) {
//            [badge setValue:@(1465009546) forKey:@"badgeGetTime"];
//            [array addObject:badge];
//        }
//    }
//    medal = [NSMutableArray arrayWithObject:array];
    [self MN_wonderDidFetchUserInfo:info medalList:medal playingList:list];
}

- (void)WM_viewDidAppear:(BOOL)animated
{
    [self WM_viewDidAppear:animated];
    int gameId = [WLConfig currentGameId];
    if (gameId == [WLConfig gameId]) {
//        [self tableView:[self performSelector:@selector(tableView)] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
//        id gameId = [self performSelector:@selector(partyID)];
//        id gameInvite = [self performSelector:@selector(teamInvite)];
//        [gameInvite performSelector:@selector(leaveTeamWithTeamID:) withObject:gameId];
    }
}

- (void)TD_viewDidAppear:(BOOL)animated
{
    [self TD_viewDidAppear:animated];
    if ([WLConfig sharedInstance].isAutoMode) {
        UITableView *tableView = [self performSelector:@selector(tableView)];
        NSUInteger row = [tableView numberOfRowsInSection:0];
        if (row == 4) {
            
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                if (cell.class == NSClassFromString(@"SelectCell")) {
                    [self performSelector:@selector(tapButton:) withObject:[cell performSelector:@selector(selectButton)]];
                }
            }
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                if (cell.class == NSClassFromString(@"ConfirmCell")) {
                    [self performSelector:@selector(tapDoneButton:) withObject:[cell performSelector:@selector(confirmButton)]];
                    [self performSelector:@selector(dismisView:)];
                    UITabBarController *tabController = self.presentingViewController;
                    UINavigationController *navController = tabController.selectedViewController;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navController.topViewController performSelector:@selector(back:) withObject:nil];
                    });
                }
            }
        }
    }
}

- (void)WL_wonderDidFetchDiscoverGameWorldItem:(id)item node:(id)node
{
    // 兑换
    [self WL_wonderDidFetchDiscoverGameWorldItem:item node:node];
}

- (void)WL_exchangeItem:(id)item
{
    // 打开
    [self WL_exchangeItem:item];
}

+ (void)exchangeSelector:(SEL)s1 with:(SEL)s2
{
    Method m1 = class_getInstanceMethod(self, s1);
    Method m2 = class_getInstanceMethod(self, s2);
    method_exchangeImplementations(m1, m2);
}

- (void)TM_viewDidLoad
{
    [self TM_viewDidLoad];
    [self setValue:@(YES) forKeyPath:@"mapView.showsUserLocation"];
}

static dispatch_once_t onceToken;

- (void)WG_viewDidLoad
{
    [self WG_viewDidLoad];
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *hint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showHint)];
    hint.tintColor = [UIColor whiteColor];
    
    if (rightItem) {
        self.navigationItem.rightBarButtonItems = @[ rightItem, hint ];
    } else {
        self.navigationItem.rightBarButtonItem = hint;
    }
    onceToken = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScanSuccess) name:@"didScanSuccess" object:nil];
    
    [self upgradeCamera];
}

- (void)upgradeCamera
{
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    UIView *treasureCamera = [self performSelector:@selector(treasureCamera)];
    
    [treasureCamera addSubview:({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 44, 44, 44)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = color.CGColor;
        btn.layer.cornerRadius = btn.frame.size.height / 2.0;
        [btn setTitle:@"灯" forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(toggleFlash) forControlEvents:UIControlEventTouchUpInside];
        btn;
    })];
    
    [treasureCamera addSubview:({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 104, 44, 44)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = color.CGColor;
        btn.layer.cornerRadius = btn.frame.size.height / 2.0;
        [btn setTitle:@"图" forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        btn;
    })];
}

- (void)toggleFlash
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.hasTorch) {
        [device lockForConfiguration:nil];
        if (device.torchMode == AVCaptureTorchModeOn) {
            device.torchMode = AVCaptureTorchModeOff;
        } else {
            device.torchMode = AVCaptureTorchModeOn;
        }
        [device unlockForConfiguration];
    }
}

- (void)selectPhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [WLConfig sharedInstance].fakeImage = image;
    [self dismissViewControllerAnimated:NO completion:^{
        self.navigationController.navigationBar.left = - [UIScreen mainScreen].bounds.size.width;
    }];
    [self performSelector:@selector(takePhoto:) withObject:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.navigationController.navigationBar.left = - [UIScreen mainScreen].bounds.size.width;
    }];
}

- (void)didScanSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(tapTagButton:) withObject:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self collectionView:[self performSelector:@selector(collectionView)] didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        });
    });   
}

- (void)WG_viewDidAppear:(BOOL)animated
{
//    [self WG_viewDidAppear:animated];
    
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    if (!rightItem) {
        UIBarButtonItem *hint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showHint)];
        hint.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = hint;
    }
    
    dispatch_once(&onceToken, ^{
        
        if ([WLConfig sharedInstance].isAutoMode) {
            for (UIView *view in self.view.subviews) {
                if (view.class == [UIScrollView class]) {
                    CGFloat width = [UIScreen mainScreen].bounds.size.width;
                    ((UIScrollView *)view).contentOffset = CGPointMake(width * 1, 0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(takePhoto:) withObject:nil];
                    });                    
                }
            }
        }
    });
}

- (void)WG_takePhoto:(id)sender
{
    [self WG_takePhoto:sender];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@: %@", self.class, change);
}

- (void)TB_viewDidLoad
{
    [self TB_viewDidLoad];
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(autoPlay)];
    play.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[ rightItem, play ];
}

- (void)TB_viewDidAppear:(BOOL)animated
{
    [self TB_viewDidAppear:YES];
    if ([WLConfig sharedInstance].isAutoMode) {
        [self autoPlay];
    }
}

- (void)FD_viewDidLoad
{
    [self FD_viewDidLoad];
    if ([WLConfig sharedInstance].isAutoMode) {
        [self performSelector:@selector(tapBottomButton:) withObject:nil];
    }
}

- (void)showHint
{
    [[UIApplication sharedApplication] performSelector:@selector(showHelper)];
}

- (void)autoPlay
{
    [WLConfig sharedInstance].isAutoMode = YES;
    SEL sel = @selector(toFeaturedDetailWithGameID:type:);
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = sel;
    invocation.target = self;
    NSNumber *gameId = @([WLConfig gameId]);
    int type = 0;
    [invocation setArgument:&gameId atIndex:2];
    [invocation setArgument:&type atIndex:3];
    [invocation invoke];
}

- (nullable MKAnnotationView *)WL_mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    return [self WL_mapView:mapView viewForAnnotation:annotation];
}

@end
