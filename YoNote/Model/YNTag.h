//
//  YNTag.h
//  YoNote
//
//  Created by Zchan on 15/5/24.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNTag : NSManagedObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) UIImage * thumbnail;
@property (nonatomic, retain) NSSet *tagItems;
@end

@interface YNTag (CoreDataGeneratedAccessors)

- (void)addTagItemsObject:(YNItem *)value;
- (void)removeTagItemsObject:(YNItem *)value;
- (void)addTagItems:(NSSet *)values;
- (void)removeTagItems:(NSSet *)values;

@end
