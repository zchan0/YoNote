//
//  YNItemsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemsViewController.h"
#import "YNItemCell.h"
#import "YNImageStore.h"

static NSString *YNItemCellIndentifier = @"YNItemCellIdentifier";


@implementation YNItemsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
    [self customButtonItem];
    
    [self.tableView registerClass:[YNItemCell class] forCellReuseIdentifier:YNItemCellIndentifier];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"首页";
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

#pragma mark -Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YNItemCellIndentifier];
    [cell updateFonts];
    cell.collectionNameLabel.text = @"Collection Name";
    cell.memoLabel.text = @"Memo Memo Memo";
    cell.tagLabel.text = @"Tag";
    /*
    NSString *path = [NSString stringWithFormat:@"img_%d.jpg", ((int)indexPath.row)+1];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:path];
    cell.imageView.image = image;*/
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}


@end
