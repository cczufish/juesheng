//
//  configViewController.m
//  juesheng
//
//  Created by runes on 13-11-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "configViewController.h"

@interface configViewController ()

@end

@implementation configViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"参数选择";
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createModel {
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"视频分辨率",
                       [TTTableTextItem itemWithText:@"1280*720" delegate:self selector:@selector(configDidSelect:)],
                       [TTTableTextItem itemWithText:@"640*480" delegate:self selector:@selector(configDidSelect:)],
                       [TTTableTextItem itemWithText:@"480*360" delegate:self selector:@selector(configDidSelect:)],
                       [TTTableTextItem itemWithText:@"352*288(默认)" delegate:self selector:@selector(configDidSelect:)],
                       [TTTableTextItem itemWithText:@"192*144" delegate:self selector:@selector(configDidSelect:)],
                       nil];
}

- (void)configDidSelect:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    TTTableTextItem *tableTextItem = (TTTableTextItem*)sender;
    if ([tableTextItem.text isEqualToString:@"1280*720"]) {
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"videosolution"];
    }
    else if ([tableTextItem.text isEqualToString:@"640*480"]) {
        [defaults setObject:[NSNumber numberWithInt:1] forKey:@"videosolution"];
    }
    else if ([tableTextItem.text isEqualToString:@"480*360"]) {
        [defaults setObject:[NSNumber numberWithInt:2] forKey:@"videosolution"];
    }
    else if ([tableTextItem.text isEqualToString:@"352*288(默认)"]) {
        [defaults setObject:[NSNumber numberWithInt:3] forKey:@"videosolution"];
    }
    else if ([tableTextItem.text isEqualToString:@"192*144"]) {
        [defaults setObject:[NSNumber numberWithInt:4] forKey:@"videosolution"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
