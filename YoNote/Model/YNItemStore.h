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
#import "YNImage.h"

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
- (YNCollection *)getCollectionByName:(NSString *)collectionName;
- (void)addCollectionForItem:(NSString *)collection forItem:(YNItem *)item;

- (void)createTag:(NSString *)tagName;
- (YNTag *)getTagByName: (NSString *)tagName;
- (NSArray *)getTagsByItem: (YNItem *)item;
- (void)addTagsForItem:(NSSet *)tags forItem:(YNItem *)item;

- (void)createImage:(NSString *)imageName;
- (void)addImagesForItem:(NSSet *)images forItem:(YNItem *)item;
- (YNImage *)getImageByName: (NSString *)imageName;
- (NSArray *)getImagesByItem:(YNItem *)item;

@end
