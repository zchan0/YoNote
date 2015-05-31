//
//  YNCollection.h
//  YoNote
//
//  Created by Zchan on 15/5/31.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNCollection : NSManagedObject

@property (nonatomic, retain) NSString * collectionName;
@property (nonatomic, retain) NSSet *items;
@end

@interface YNCollection (CoreDataGeneratedAccessors)

- (void)addItemsObject:(YNItem *)value;
- (void)removeItemsObject:(YNItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
