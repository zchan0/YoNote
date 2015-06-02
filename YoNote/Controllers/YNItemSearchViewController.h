//
//  YNItemSearchViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/16.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNItemEditToolbar.h"
#import "YNItem.h"

@interface YNItemSearchViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) YNItem  *item;
@property (nonatomic, strong) YNItemEditToolbar *searchItemToolbar;
@property (nonatomic) BOOL isNew;

- (instancetype)initWithNavTitle:(NSString *)title;


@end
