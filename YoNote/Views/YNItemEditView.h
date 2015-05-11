//
//  YNItemEdit.h
//  YoNote
//
//  Created by Zchan on 15/5/11.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNItemEditView : UIView<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *inputTextView;
@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *dateCreated;
@property (nonatomic, strong) NSString *dateAlarmed;
@property (nonatomic, strong) NSArray  *tags;
@property (nonatomic, strong) NSString *collection;


- (void)updateFonts;

@end
