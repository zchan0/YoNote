//
//  YNItemStore.h
//  YoNote
//
//  Created by Zchan on 15/5/23.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNItem.h"
#import "YNCollection.h"
#import "YNTag.h"

@import CoreData;

@interface YNItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSArray *allCollections;
@property (nonatomic, readonly) NSArray *allTags;

+ (instancetype)sharedStore;
- (YNItem *)createItem;
- (void)removeItem: (YNItem *)item;
- (BOOL)saveChanges;

- (void)createCollection:(NSString *)collectionName;
- (void)addCollectionForItem:(NSString *)collection forItem:(YNItem *)item;
- (void)createTag:(NSString *)tagName;
- (void)addTagsForItem:(NSArray *)tags forItem:(YNItem *)item;

@end
