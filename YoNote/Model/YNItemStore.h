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
@property (nonatomic, readonly) NSArray *allImages;

+ (instancetype)sharedStore;
- (YNItem *)createItem;
- (void)removeItem: (YNItem *)item;
- (BOOL)saveChanges;

- (void)createCollection:(NSString *)collectionName;
- (void)removeCollection:(YNCollection *)collection;
- (void)addCollectionForItem:(NSString *)collection forItem:(YNItem *)item;
- (YNCollection *)getCollectionByName:(NSString *)collectionName;


- (void)createTag:(NSString *)tagName;
- (void)removeTag:(YNTag *)tag;
- (void)addTagsForItem:(NSSet *)tags forItem:(YNItem *)item;
- (YNTag *)getTagByName: (NSString *)tagName;
- (NSArray *)getTagsByItem: (YNItem *)item;

- (void)createImage:(NSString *)imageName;
- (void)addImagesForItem:(NSSet *)images forItem:(YNItem *)item;
- (void)removeImage:(YNImage *)image;
- (YNImage *)getImageByName: (NSString *)imageName;
- (NSArray *)getImagesByItem:(YNItem *)item;
- (NSArray *)getSameNameImages:(YNImage *)image;
- (NSArray *)getImageNamesByItem:(YNItem *)item;

@end
