//
//  YNCollectionCell.h
//  YoNote
//
//  Created by Zchan on 15/5/9.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCollectionCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *collectionNameLabel;

- (void)updateFonts;

@end
