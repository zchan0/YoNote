//
//  YNItemsViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNBaseViewController.h"

@interface YNItemsViewController : YNBaseViewController

@property (nonatomic, strong) NSMutableArray *datasource;

- (instancetype)initWithTitle:(NSString *)title;

@end
