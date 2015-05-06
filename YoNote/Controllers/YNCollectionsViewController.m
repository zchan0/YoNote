//
//  YNCollectionsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNCollectionsViewController.h"

@implementation YNCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"文件";
}

@end
