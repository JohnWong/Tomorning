//
//  WLChapterController.m
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLChapterController.h"
#import "UIView+RSAdditions.h"
#import "WLStepController.h"

@implementation WLChapterController
{
    WLChapter *_chapter;
}

- (instancetype)initWithChapter:(WLChapter *)chapter
{
    self = [super init];
    if (self) {
        _chapter = chapter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _chapter.title;
    
    if (_chapter.latitude > 0 && _chapter.longitude > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(gotoMap)];
    }
    
    
    UIScrollView *_contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, _contentView.frame.size.width - 16 * 2, 32)];
    title.text = [NSString stringWithFormat:@"%@ %@", _chapter.title, _chapter.englishTitle];
    [_contentView addSubview:title];
    
    UIImage *image = [UIImage imageWithContentsOfFile:_chapter.pic];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat imageWidth = self.view.frame.size.width - 16 * 2;
    imageView.frame = CGRectMake(16, title.bottom + 8, imageWidth, image.size.height * imageWidth / MAX(image.size.width, 0.00001));
    [_contentView addSubview:imageView];
    
    for (int i = 0; i < _chapter.steps.count; i ++) {
        WLStep *step = _chapter.steps[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, imageView.bottom + 8 + 44 * i, self.view.width - 16 * 2, 44)];
        [btn setTitle:[NSString stringWithFormat:@"%@ %@", @(step.index), step.content] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(selectStep:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, imageView.bottom + 8 * 2 + 44 * _chapter.steps.count, self.view.frame.size.width - 16 * 2, 2000)];
    label.numberOfLines = 0;
    label.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_chapter.raw options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    label.height = [label sizeThatFits:label.frame.size].height;
    [_contentView addSubview:label];
    
    _contentView.contentSize = CGSizeMake(_contentView.width, label.bottom + 16);
}

- (void)gotoMap
{
    NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@&q=%@", @(_chapter.latitude), @(_chapter.longitude), [_chapter.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)selectStep:(UITapGestureRecognizer *)tap
{
    WLStep *step = _chapter.steps[tap.view.tag];
    WLStepController *vc = [[WLStepController alloc] initWithStep:step];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
