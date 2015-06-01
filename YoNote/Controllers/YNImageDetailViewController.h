//
//  YNImageDetailViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/21.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNImageDetailViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *images;

@end
