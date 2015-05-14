//
//  YNItemEdit.m
//  YoNote
//
//  Created by Zchan on 15/5/11.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditToolbar.h"

#define kButtonWidth  44.0f
#define kButtonHeight 33.0f

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
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"YNItemEditToolbar" owner:self options:nil];
    self.YNItemEditToolbar = [subviewArray objectAtIndex:0];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)updateFonts {
    
}


@end
