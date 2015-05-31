//
//  TestViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/28.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "TestViewController.h"
#import "YNItemStore.h"
#import "YNImageStore.h"
#import "YNItemCell.h"

static NSString *YNItemCellIndentifier = @"YNItemCellIdentifier";


@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[YNItemCell class] forCellReuseIdentifier:YNItemCellIndentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    self.items =[NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allItems]];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YNItemCellIndentifier];
    
    YNItem *item = self.items[indexPath.row];
    
    //configure cell with YNItem
    cell.collectionNameLabel.text = item.collection.collectionName;
    cell.memoLabel.text = item.memo;
    
    NSSet *tagsSet = [item tags];
    NSArray *tags  = [self tagsSetToArray:tagsSet];
    cell.tagLabel.text = [tags componentsJoinedByString:@", "];
    
    NSString *imageName = [[self imagesSetToArray:[item images]]firstObject];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:imageName];
    cell.iv.image = [[YNImageStore sharedStore]setThumbnailFromImage:image newRect:kItemImageViewRect];;
    
    cell.clipsToBounds = YES;
    cell.separatorInset = ALEdgeInsetsZero; // make separator below imageview visible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell updateFonts];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kItemTableCellHeight;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete YNItem
        YNItem *item = self.items[indexPath.row];
        NSArray *images = [[YNItemStore sharedStore]getImagesByItem:item];
        for (YNImage *image in images) {
            NSString *imageName = image.imageName;
            [[YNItemStore sharedStore] removeImage:image];
            NSArray *sameNamesImages = [[YNItemStore sharedStore]getSameNameImages:image];
            if (sameNamesImages.count < 1) {
                NSLog(@"要删除的图片: %@", imageName);
                [[YNImageStore sharedStore] deleteImageForKey:imageName];
            }
        }
        
        [[YNItemStore sharedStore] removeItem: item];
        [self.items removeObjectIdenticalTo:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        BOOL success = [[YNItemStore sharedStore] saveChanges];
        if (success) {
            NSLog(@"Saved coredata changes!");
        } else {
            NSLog(@"Could not save coredata changes");
        }
    }
}

#pragma mark - Private Methods

- (NSArray *)tagsSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNTag *element in set) {
        [array addObject:element.tag];
    }
    return array;
}

- (NSArray *)imagesSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNImage *element in set) {
        [array addObject:element.imageName];
    }
    return array;
}


@end
