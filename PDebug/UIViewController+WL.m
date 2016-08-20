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
    } else if (self == NSClassFromString(@"FeaturedDetailViewController")) {
        [self exchangeSelector:@selector(viewDidLoad) with:@selector(FD_viewDidLoad)];
    } else if (self == NSClassFromString(@"DiscoverGameViewController")) {
        [self exchangeSelector:@selector(WL_wonderDidFetchDiscoverGameWorldItem:node:) with:@selector(wonderDidFetchDiscoverGameWorldItem:node:)];
        [self exchangeSelector:@selector(WL_exchangeItem:) with:@selector(exchangeItem:)];
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

- (void)WG_viewDidLoad
{
    [self WG_viewDidLoad];
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *hint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showHint)];
    self.navigationItem.rightBarButtonItems = rightItem ? @[ rightItem, hint ] : @[ hint ];
}

- (void)WG_viewDidAppear:(BOOL)animated
{
    static dispatch_once_t onceToken;
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
    UIBarButtonItem *hint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(autoPlay)];
    self.navigationItem.rightBarButtonItems = @[ rightItem, hint ];
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
    NSNumber *gameId = @(122);
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
