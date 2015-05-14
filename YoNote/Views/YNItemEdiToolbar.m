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

/*
- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        
        [_imageButton autoCenterInSuperview];
        [_imageButton autoSetDimensionsToSize:CGSizeMake(kButtonWidth, kButtonHeight)];
        
        [self.dateAlarmedButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.dateAlarmedButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        [self.dateAlarmedButton autoSetDimension: ALDimensionWidth toSize:kButtonWidth];
        [self.dateAlarmedButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:_imageButton withOffset:kLabelHorizontalInsets];
        
        [self.dateCreatedButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.dateCreatedButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        [self.dateCreatedButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [self.dateCreatedButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.dateAlarmedButton withOffset:kLabelHorizontalInsets];
        
        [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        [self.deleteButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [self.deleteButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_imageButton withOffset:kLabelHorizontalInsets];
        
        [self.tagsButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.tagsButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        [self.tagsButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        
        
        self.didSetupConstraints = YES;

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


@end
