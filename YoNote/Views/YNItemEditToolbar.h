//
//  YNItemEdit.h
//  YoNote
//
//  Created by Zchan on 15/5/11.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNItemEditToolbarDelegate <NSObject>

- (void)pickDateCreated;
- (void)pickDateAlarmed;
- (void)selectCollection;
- (void)selectTags;

@end

@interface YNItemEditToolbar : UIView

@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSDate *dateAlarmed;
@property (nonatomic, strong) NSArray  *tags;
@property (nonatomic, strong) NSString *collection;

@property (nonatomic, weak) IBOutlet UIButton *imageButton;
@property (nonatomic, weak) IBOutlet UIButton *dateCreatedButton;
@property (nonatomic, weak) IBOutlet UIButton *dateAlarmedButton;
@property (nonatomic, weak) IBOutlet UIButton *tagsButton;
@property (nonatomic, weak) IBOutlet UIButton *collectionButton;
@property (nonatomic, weak) IBOutlet YNItemEditToolbar *YNItemEditToolbar;

@property (nonatomic) id<YNItemEditToolbarDelegate> delegate;

@end
