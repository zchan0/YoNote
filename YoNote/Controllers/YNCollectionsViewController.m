//
//  YNCollectionsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNCollectionsViewController.h"
#import "YNItemsViewController.h"
#import "RDVTabBarController.h"
#import "YNCollectionCell.h"
#import "YNImageStore.h"
#import "YNItemStore.h"

#define kCollectionImageRect        CGRectMake(0, 0, 320, 120)
#define kCollectionTableCellHeight  160.0

static NSString *YNCollectionCellIndentifier = @"YNCollectionCellIndentifier";

@interface YNCollectionsViewController ()

@property (nonatomic, strong) NSMutableArray *collections;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation YNCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
    [self getDatasource];
    [self.tableView registerClass:[YNCollectionCell class] forCellReuseIdentifier:YNCollectionCellIndentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"图片集";
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:YNCollectionCellIndentifier];
    YNCollection *collection = self.datasource[indexPath.row];
    cell.collectionNameLabel.text = collection.collectionName;
    NSSet *items = collection.items;
    YNItem *item = [items anyObject];
    NSSet *images = item.images;
    YNImage *YNImage = [images anyObject];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:YNImage.imageName];
    if (!image) {
        image = [[YNImageStore sharedStore]imageForKey:@"default.JPG"];
    }
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
    YNCollection *collection = self.collections[indexPath.row];
    NSSet *itemsSet = collection.items;
    NSArray *items = [self itemSettoArray:itemsSet];
    for (YNItem *item in items) {
        NSLog(@"%@", item.collection.collectionName);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCollectionTableCellHeight;
}

#pragma mark - Datasource

- (void)getDatasource {
    self.collections = [NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allCollections]];
    self.datasource  = [NSMutableArray array];
    
    NSMutableArray *collectionNames = [NSMutableArray array];
    for (YNCollection *collection in self.collections) {
        if (![collectionNames containsObject:collection.collectionName])
            [collectionNames addObject:collection.collectionName];
    }
    
    for (NSString *collectionName in collectionNames) {
        YNCollection *collection = [[YNItemStore sharedStore]getCollectionByName:collectionName];
        // exclude collection without items
        if (collection.items.count)
            [self.datasource addObject:collection];
    }
}

#pragma mark - Private Methods
- (NSArray *)itemSettoArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNItem *item in set) {
        [array addObject:item];
    }
    return array;
}

@end
