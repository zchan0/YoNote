//
//  YNItemCell.m
//  YoNote
//
//  Created by Zchan on 15/5/7.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemCell.h"

#define kItemContentViewFrame self.contentView.frame

@interface YNItemCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation YNItemCell

- (void)setupViews {
    /*** collection label ***/
    self.collectionNameLabel = [UILabel newAutoLayoutView];
    [self.collectionNameLabel setTextColor:UIColorFromRGB(0x3CA9D2)];
    
    /*** memo label ***/
    self.memoLabel = [UILabel newAutoLayoutView];
    [self.memoLabel setNumberOfLines:2];
    [self.memoLabel setTextColor:UIColorFromRGB(0x4A4A4A)];
    self.memoLabel.contentMode = UIViewContentModeScaleAspectFit;
    //[self.memoLabel setPreferredMaxLayoutWidth:kMemoLabelWidthToSize];
    
    /*** tag label ***/
    self.tagLabel  = [UILabel newAutoLayoutView];
    [self.tagLabel setTextColor:UIColorFromRGB(0xffffff)];
    [self.tagLabel setBackgroundColor:UIColorFromRGB(0x3CA9D2)];
    
    /*** imageview ***/
    self.iv = [[UIImageView alloc]initForAutoLayout];
    
    //CGRect contentFrame = kItemContentViewFrame;
    //contentFrame.size.width *= 0.8;
    self.iv.frame = kItemContentViewFrame;
    self.iv.contentMode = UIViewContentModeScaleAspectFill;
    self.iv.contentMode = UIViewContentModeCenter;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    [self.contentView addSubview:self.iv];
    [self.contentView addSubview:self.collectionNameLabel];
    [self.contentView addSubview:self.memoLabel];
    [self.contentView addSubview:self.tagLabel];
    
    [self updateFonts];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
        
    }
    
    return self;
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        // To Superview Edge
        [self.iv autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(kLabelVerticalInsets, kLabelHorizontalInsets, kLabelVerticalInsets, kLabelHorizontalInsets) excludingEdge:ALEdgeLeading];
        
        [self.memoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.memoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        
        [self.collectionNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        
        [self.tagLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        
        
        //  Fixed Size
        [self.memoLabel autoSetDimension:ALDimensionHeight toSize:kMemoLabelHeightToSize];
        [self.iv autoSetDimension:ALDimensionWidth toSize: kItemContentViewFrame.size.width * 0.4];
        
        //  To Other View Edge
        [self.memoLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.iv withOffset:-kLabelHorizontalInsets relation:NSLayoutRelationLessThanOrEqual];
        [self.collectionNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.memoLabel withOffset:kLabelVerticalInsets];
        [self.collectionNameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tagLabel withOffset:-kLabelVerticalInsets];

        
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
    self.collectionNameLabel.font = [UIFont systemFontOfSize:kCaptionFontSize];
    self.memoLabel.font = [UIFont systemFontOfSize:kHeaderFontSize];
    self.tagLabel.font = [UIFont systemFontOfSize:kCaptionFontSize];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
