//
//  YNCollectionsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNCollectionsViewController.h"
#import "YNCollectionCell.h"
#import "YNImageStore.h"

#define kCollectionImageRect        CGRectMake(0, 0, 320, 120)
#define kCollectionTableCellHeight  160.0

static NSString *YNCollectionCellIndentifier = @"YNCollectionCellIndentifier";


@implementation YNCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
    
    [self.tableView registerClass:[YNCollectionCell class] forCellReuseIdentifier:YNCollectionCellIndentifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTabBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tabBarController setTabBarHidden:YES animated:YES];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"图片集";
}

#pragma mark -Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:YNCollectionCellIndentifier];
    
    [cell updateFonts];
    cell.collectionNameLabel.text = @"高级数据库";
        
    NSString *path = [NSString stringWithFormat:@"img_%d.jpg", ((int)indexPath.row)+1];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:path];
    UIImage *thumbnail = [[YNImageStore sharedStore]setThumbnailFromImage:image newRect:kCollectionImageRect];
    cell.iv.image = thumbnail;
    cell.separatorInset = ALEdgeInsetsZero; // make separator below imageview visible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCollectionTableCellHeight;
}


@end
