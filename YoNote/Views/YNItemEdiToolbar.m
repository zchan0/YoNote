//
//  YNItemEdit.m
//  YoNote
//
//  Created by Zchan on 15/5/11.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditToolbar.h"

@interface YNItemEditToolbar ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *dateCreatedButton;
@property (nonatomic, strong) UIButton *dateAlarmedButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *tagsButton;

@end

@implementation YNItemEditToolbar

- (void)setupViews {
    /*
    self.frame = [UIScreen mainScreen].applicationFrame;
    CGFloat width = self.frame.size.width;
    self.editTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 170)];
    self.editTextView.delegate = self;
    [self addSubview:self.inputView];
     */
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"YNItemEditToolbar" owner:self options:nil];
    self.YNItemEditToolbar = [subviewArray objectAtIndex:0];
    //self.editTextView.inputAccessoryView = self.YNItemEditToolbar;
    
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
        //[self.editTextView becomeFirstResponder];
    }
    
    return self;
}

/*
 - (void)updateConstraints {
 if (!self.didSetupConstraints) {
 
 }
 
 [super updateConstraints];  // must call and must at every end
 }
 - (void)layoutSubviews {
 [super layoutSubviews];
 
 // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
 // need to use to set the preferredMaxLayoutWidth below.
 [self setNeedsLayout];
 [self layoutIfNeeded];
 
 }*/

- (void)updateFonts {
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
