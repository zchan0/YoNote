//
//  YNItemEditViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNItemEditViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) NSString *memo;

- (instancetype)initForNewItem:(BOOL)isNew;

@end
