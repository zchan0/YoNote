//
//  YNCollection.h
//  YoNote
//
//  Created by Zchan on 15/5/25.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNCollection : NSManagedObject

@property (nonatomic, retain) NSString * collection;
@property (nonatomic, retain) UIImage * thumbnail;
@property (nonatomic, retain) NSSet *allItems;
@end

@interface YNCollection (CoreDataGeneratedAccessors)

- (void)addAllItemsObject:(YNItem *)value;
- (void)removeAllItemsObject:(YNItem *)value;
- (void)addAllItems:(NSSet *)values;
- (void)removeAllItems:(NSSet *)values;

@end
