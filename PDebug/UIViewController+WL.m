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
    }
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
    
//    UIBarButtonItem *photo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(showPhoto)];
//    self.navigationItem.rightBarButtonItems = rightItem ? @[ rightItem, hint, photo ] : @[ hint, photo ];
    if (rightItem) {
        self.navigationItem.rightBarButtonItems = @[ rightItem, hint ];
    } else {
        self.navigationItem.rightBarButtonItem = hint;
    }
    onceToken = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScanSuccess) name:@"didScanSuccess" object:nil];
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
    [self WG_viewDidAppear:animated];
    
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    if (!rightItem) {
        UIBarButtonItem *hint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showHint)];
        hint.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = hint;
    }
    
    dispatch_once(&onceToken, ^{
        
        if ([WLConfig sharedInstance].isAutoMode) {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
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

- (void)showPhoto
{
    NSMutableArray *photos = [NSMutableArray array];
    
    // Add photos
//    [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b.jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b.jpg"]]];
    
    // Add video with poster photo
    MWPhoto *video = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/e15/11192696_824079697688618_1761661_n.jpg"]];
    video.videoURL = [[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xpa1/t50.2886-16/11200303_1440130956287424_1714699187_n.mp4"];
    [photos addObject:video];
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    
    // Present
    [self presentViewController:browser animated:YES completion:nil];
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
