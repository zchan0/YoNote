//
//  YNTag.h
//  YoNote
//
//  Created by Zchan on 15/5/28.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNTag : NSManagedObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) UIImage  * thumbnail;
@property (nonatomic, retain) NSSet *items;
@end

@interface YNTag (CoreDataGeneratedAccessors)

- (void)addItemsObject:(YNItem *)value;
- (void)removeItemsObject:(YNItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
