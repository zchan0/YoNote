//
//  YNSettingsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNSettingsViewController.h"

@implementation YNSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"设置";
}

@end
