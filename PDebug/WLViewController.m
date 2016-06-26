//
//  WLViewController.m
//  Tomorning
//
//  Created by John Wong on 6/18/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "WLViewController.h"
#import "WonderlandHelper.h"
#import "WLGame.h"
#import "WLChapterController.h"
#import "WLStepController.h"
#import "WLConfig.h"

@implementation WLNavigationController

@end

@implementation WLViewController
{
    WLGame *_game;
}

- (instancetype)initWithGameId:(int)gameId
{
    self = [super init];
    if (self) {
        _gameId = gameId;
        [self decryptAndReload];
    }
    return self;
}

- (void)decryptAndReload
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [WonderlandHelper decrypt:_gameId];
        _game = [[WLGame alloc] initWithGameId:_gameId];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"%@", @(_game.gameId)];
            [self.tableView reloadData];
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WLChapter *chapter = _game.chapters[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, view.bounds.size.height - 16, view.bounds.size.height - 16)];
    image.image = [UIImage imageWithContentsOfFile:chapter.pic];
    [view addSubview:image];
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@", @(chapter.index), chapter.title, chapter.englishTitle];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 8, 0, view.bounds.size.width - CGRectGetMaxX(image.frame) - 16, view.bounds.size.height)];
    label.text = message;
    view.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:label];
    view.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChapter:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (void)selectChapter:(UITapGestureRecognizer *)tap
{
    WLChapter *chapter = _game.chapters[tap.view.tag];
    if (chapter) {
        WLChapterController *chapterController = [[WLChapterController alloc] initWithChapter:chapter];
        [self.navigationController pushViewController:chapterController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    WLChapter *chapter = _game.chapters[indexPath.section];
    WLStep *step = chapter.steps[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"%@ %@", @(step.index), step.content];
    cell.textLabel.text = message;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _game.chapters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WLChapter *chapter = _game.chapters[section];
    return chapter.steps.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarItem];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    
}

- (void)setupBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear)];
    
}

- (void)clear
{
    NSString *idx = [NSString stringWithFormat:@"%@", @(_gameId)];
    NSString *decryptPath = [[WLConfig decryptedPath] stringByAppendingPathComponent:idx];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:decryptPath error:&error];
    if (error) {
        NSLog(@"%@: %d %@", self.class, __LINE__, error);
    }
    [self decryptAndReload];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WLChapter *chapter = _game.chapters[indexPath.section];
    WLStep *step = chapter.steps[indexPath.row];
    WLStepController *vc = [[WLStepController alloc] initWithStep:step];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
