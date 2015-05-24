//
//  YNImage.h
//  YoNote
//
//  Created by Zchan on 15/5/24.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNItem;

@interface YNImage : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSSet *imageItems;
@end

@interface YNImage (CoreDataGeneratedAccessors)

- (void)addImageItemsObject:(YNItem *)value;
- (void)removeImageItemsObject:(YNItem *)value;
- (void)addImageItems:(NSSet *)values;
- (void)removeImageItems:(NSSet *)values;

@end
