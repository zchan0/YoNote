//
//  YNTag.h
//  YoNote
//
//  Created by Zchan on 15/5/25.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNTag : NSManagedObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) UIImage  * thumbnail;
@property (nonatomic, retain) NSSet *tagItem;
@end

@interface YNTag (CoreDataGeneratedAccessors)

- (void)addTagItemObject:(YNItem *)value;
- (void)removeTagItemObject:(YNItem *)value;
- (void)addTagItem:(NSSet *)values;
- (void)removeTagItem:(NSSet *)values;

@end
