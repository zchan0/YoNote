//
//  YNItemSearchViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/16.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNItemSearchViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSString *collectionResult;
@property (nonatomic, strong) NSMutableArray  *tagResults;
@property (nonatomic, strong) NSArray  *items;


- (instancetype)initWithNavTitle:(NSString *)title;


@end
