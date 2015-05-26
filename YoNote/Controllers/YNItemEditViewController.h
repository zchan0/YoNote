//
//  YNItemEditViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNItem.h"

@interface YNItemEditViewController : UIViewController

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) YNItem *item;

- (instancetype)initForNewItem:(BOOL)isNew;

@end
