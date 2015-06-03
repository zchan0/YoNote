//
//  YNItemEditViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNItem.h"
#import "YNItemsViewController.h"

@protocol YNItemEditViewDelegate <NSObject>

- (void)refreshData;

@end

@interface YNItemEditViewController : UIViewController

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesNames;
@property (nonatomic, strong) YNItem *item;
@property (nonatomic) id<YNItemEditViewDelegate> delegate;

- (instancetype)initForNewItem:(BOOL)isNew;

@end
