//
//  YNCollection.h
//  YoNote
//
//  Created by Zchan on 15/5/24.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNCollection : NSManagedObject

@property (nonatomic, retain) NSString * collection;
@property (nonatomic, retain) UIImage * thumbnail;
@property (nonatomic, retain) NSSet *collectionItem;
@end

@interface YNCollection (CoreDataGeneratedAccessors)

- (void)addCollectionItemObject:(YNItem *)value;
- (void)removeCollectionItemObject:(YNItem *)value;
- (void)addCollectionItem:(NSSet *)values;
- (void)removeCollectionItem:(NSSet *)values;

@end
