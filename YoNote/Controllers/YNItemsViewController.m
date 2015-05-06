//
//  YNItemsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemsViewController.h"

@implementation YNItemsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
    [self customButtonItem];
}

#pragma mark -Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"HOME";
}

- (void)customButtonItem {
    UIImage *leftImage = [UIImage imageNamed:@"navi_search"];
    UIImage *rightImage = [UIImage imageNamed:@"navi_add"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(searchItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

#pragma mark - IBActions

- (IBAction)addNewItem:(id)sender {
    
}

- (IBAction)searchItem:(id)sender {
    
}

@end
