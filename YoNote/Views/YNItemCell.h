//
//  YNItemCell.h
//  YoNote
//
//  Created by Zchan on 15/5/7.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *collectionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *memoLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

- (void)updateFonts;

@end
