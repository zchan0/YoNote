//
//  YNCollectionCell.m
//  YoNote
//
//  Created by Zchan on 15/5/9.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNCollectionCell.h"
#import "FXBlurView.h"

#define kCollectionImageViewWidth       320.0f
#define kCollectionImageViewHeight      127.5f

@interface YNCollectionCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) FXBlurView *fxView;

@end

@implementation YNCollectionCell

- (void)setupViews {
    /*** collection label ***/
    self.collectionNameLabel = [UILabel newAutoLayoutView];
    [self.collectionNameLabel setNumberOfLines:0];
    [self.collectionNameLabel setTextColor:[UIColor whiteColor]];
    self.collectionNameLabel.textAlignment = NSTextAlignmentCenter;
    
    /*** imageview ***/
    self.iv = [[UIImageView alloc]initForAutoLayout];
    self.iv.frame = CGRectMake(0, 0, kCollectionImageViewWidth, kCollectionImageViewHeight);
    self.iv.contentMode = UIViewContentModeScaleToFill;
    
    self.fxView = [[FXBlurView alloc]init];
    self.fxView.blurRadius = 8;
    self.fxView.tintColor = [UIColor blackColor];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    [self.contentView addSubview:self.iv];
    [self.contentView addSubview:self.fxView];
    [self.contentView addSubview:self.collectionNameLabel];
    
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
        [self.iv autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(kLabelVerticalInsets, kLabelHorizontalInsets, kLabelVerticalInsets, kLabelHorizontalInsets)];
        
        //  Fixed Size
        [self.collectionNameLabel autoSetDimension:ALDimensionHeight toSize:kCollectionImageViewHeight];
        
        //  Margins
        self.iv.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.collectionNameLabel autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeBottom];
        
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
    
    self.fxView.frame = self.iv.frame;
    self.collectionNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.collectionNameLabel.frame);
    
}


- (void)updateFonts {
    self.collectionNameLabel.font = [UIFont boldSystemFontOfSize:kHeaderFontSize];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
