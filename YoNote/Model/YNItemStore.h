//
//  YNItemStore.h
//  YoNote
//
//  Created by Zchan on 15/5/23.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;

@interface YNItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (YNItem *)createItem;
- (void)removeItem: (YNItem *)item;
- (BOOL)saveChanges;


@end
