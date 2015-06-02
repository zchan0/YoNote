//
//  YNTagsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNTagsViewController.h"
#import "YNItemsViewController.h"
#import "RDVTabBarController.h"
#import "YNCollectionCell.h"
#import "YNImageStore.h"
#import "YNItemStore.h"

#define kCollectionImageRect        CGRectMake(0, 0, 320, 120)
#define kCollectionTableCellHeight  160.0

static NSString *YNCollectionCellIndentifier = @"YNCollectionCellIndentifier";

@interface YNTagsViewController ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation YNTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
    [self getDatasource];
    [self.tableView registerClass:[YNCollectionCell class] forCellReuseIdentifier:YNCollectionCellIndentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"标签";
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:YNCollectionCellIndentifier];
    YNTag *tag = self.datasource[indexPath.row];
    cell.collectionNameLabel.text = tag.tag;
    NSSet *items = tag.items;
    YNItem *item = [items anyObject];
    NSSet *images = item.images;
    YNImage *YNImage = [images anyObject];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:YNImage.imageName];
    UIImage *thumbnail = [[YNImageStore sharedStore]setThumbnailFromImage:image newRect:kCollectionImageRect];
    cell.iv.image = thumbnail;
    cell.separatorInset = ALEdgeInsetsZero; // make separator below imageview visible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell updateFonts];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YNTag *tag = self.datasource[indexPath.row];
    YNItemsViewController *itemsViewController = [[YNItemsViewController alloc]initWithTitle:tag.tag];
    [self.navigationController pushViewController:itemsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCollectionTableCellHeight;
}

#pragma mark - Datasource

- (void)getDatasource {
    self.tags = [NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allTags]];
    self.datasource  = [NSMutableArray array];
    
    NSMutableArray *tagNames = [NSMutableArray array];
    for (YNTag *tag in self.tags) {
        if (![tagNames containsObject:tag.tag])
            [tagNames addObject:tag.tag];
    }
    
    for (NSString *tagName in tagNames) {
        YNTag *tag = [[YNItemStore sharedStore]getTagByName:tagName];
        // exclude collection without items
        if (tag.items.count)
            [self.datasource addObject:tag];
    }
}


@end
