//
//  YNItem.h
//  YoNote
//
//  Created by Zchan on 15/5/25.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YNCollection, YNImage, YNTag;

@interface YNItem : NSManagedObject

@property (nonatomic, retain) NSDate * dateAlarmed;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) UIImage * thumbnaiil;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) YNCollection *collection;
@property (nonatomic, retain) NSSet *tags;
@end

@interface YNItem (CoreDataGeneratedAccessors)

- (void)addImagesObject:(YNImage *)value;
- (void)removeImagesObject:(YNImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addTagsObject:(YNTag *)value;
- (void)removeTagsObject:(YNTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
