//
//  WLStepController.m
//  Tomorning
//
//  Created by John Wong on 6/24/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLStepController.h"
#import "UIView+RSAdditions.h"
#include <AVFoundation/AVFoundation.h>


@interface WLStepController () <AVAudioPlayerDelegate>

@end

@implementation WLStepController
{
    WLStep *_step;
    AVAudioPlayer *_audioPlayer;
}
- (instancetype)initWithStep:(WLStep *)step
{
    self = [super init];
    if (self) {
        _step = step;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _step.title;
    if (_step.audio.length > 0) {
        NSURL *fileURL = [NSURL fileURLWithPath:_step.audio];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if (error) {
            NSLog(@"%@: %d %@", self.class, __LINE__, error);
        }
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAudio:)];
        
    }
    
    UIScrollView *_contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, _contentView.frame.size.width - 16 * 2, 32)];
    title.text = [NSString stringWithFormat:@"%@ %@", _step.title, _step.englishTitle];
    [_contentView addSubview:title];
    
    UIImage *image = [UIImage imageWithContentsOfFile:_step.tailPic];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat imageWidth = self.view.frame.size.width - 16 * 2;
    imageView.frame = CGRectMake(16, title.bottom + 8, imageWidth, image.size.height * imageWidth / MAX(image.size.width, 0.0001));
    [_contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, imageView.bottom + 8, self.view.frame.size.width - 16 * 2, 2000)];
    label.numberOfLines = 0;
    label.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_step.raw options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    label.height = [label sizeThatFits:label.frame.size].height;
    [_contentView addSubview:label];
    _contentView.contentSize = CGSizeMake(_contentView.width, label.bottom + 16);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_audioPlayer stop];
}

- (void)playAudio:(id)sender
{
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAudio:)];
    } else {
        [_audioPlayer play];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playAudio:)];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

@end
