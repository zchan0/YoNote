//
//  YNItemCell.m
//  YoNote
//
//  Created by Zchan on 15/5/7.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemCell.h"

@interface YNItemCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIImageView *iv;

@end

@implementation YNItemCell

- (void)setupLabelViews {
    /*** collection label ***/
    self.collectionNameLabel = [UILabel newAutoLayoutView];
    [self.collectionNameLabel setTextColor:UIColorFromRGB(0x3CA9D2)];
    self.collectionNameLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    /*** memo label ***/
    self.memoLabel = [UILabel newAutoLayoutView];
    [self.memoLabel setNumberOfLines:2];
    [self.memoLabel setTextColor:UIColorFromRGB(0x9B9B9B)];
    self.memoLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    /*** tag label ***/
    self.tagLabel  = [UILabel newAutoLayoutView];
    [self.tagLabel setTextColor:UIColorFromRGB(0x3CA9D2)];
    self.tagLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    [self.contentView addSubview:self.collectionNameLabel];
    [self.contentView addSubview:self.memoLabel];
    [self.contentView addSubview:self.tagLabel];
    
    [self updateFonts];
    
}


- (void)setupImageViews {
    
    /*** imageview holdplacor ***/
    self.iv = [[UIImageView alloc]initForAutoLayout];
    self.iv.frame = CGRectMake(0, 0, 152, 125);
    [self.contentView addSubview:self.iv];
    
    self.iv.image = self.imageView.image;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupLabelViews];
        //[self setupImageViews];
    }
    
    return self;
}



- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        //self.contentView.bounds = CGRectMake(0.0f, 0.0f, 99999.0f, 99999.0f);
        
        ALEdgeInsets defInsets = ALEdgeInsetsMake(kLabelVerticalInsets, kLabelHorizontalInsets, kLabelVerticalInsets, kLabelHorizontalInsets);
        
        //[self.iv autoPinEdgesToSuperviewEdgesWithInsets:defInsets excludingEdge:ALEdgeTrailing];
        
        [self.collectionNameLabel autoPinEdgesToSuperviewEdgesWithInsets:defInsets excludingEdge:ALEdgeBottom];
        [self.memoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        [self.memoLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
        [self.memoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.collectionNameLabel withOffset:kLabelVerticalInsets];
        [self.tagLabel autoPinEdgesToSuperviewEdgesWithInsets:defInsets excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];  // must call and must at every end
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.memoLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.memoLabel.frame);
}


- (void)updateFonts {
    self.collectionNameLabel.font = [UIFont fontWithName:kBarTitleFontFamily size:kTitleFontSize];
    self.memoLabel.font = [UIFont fontWithName:kBarTitleFontFamily size:kBodyFontSize];
    self.tagLabel.font = [UIFont fontWithName:kBarTitleFontFamily size:kCaptionFontSize];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
