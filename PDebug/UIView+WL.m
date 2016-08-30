//
//  UIView+WL.m
//  Tomorning
//
//  Created by John Wong on 8/28/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIView+WL.h"
#import "NSObject+WL.h"

@implementation UIView (WL)

+ (void)initialize
{
    if (self == NSClassFromString(@"TreasureCamera")) {
        [self exchangeSelector:@selector(buttonLoading) with:@selector(TC_buttonLoading)];
    }
}

- (int)TC_buttonLoading
{
    // 去掉拍摄按钮的加载动画
    return 0;
}
    

@end
