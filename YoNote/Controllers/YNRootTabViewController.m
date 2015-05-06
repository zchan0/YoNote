//
//  RootTabViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNRootTabViewController.h"
#import "YNItemsViewController.h"
#import "YNCollectionsViewController.h"
#import "YNTagsViewController.h"
#import "YNSettingsViewController.h"
#import "YNBaseNavigationController.h"
#import "RDVTabBarItem.h"

@interface YNRootTabViewController ()

@end

@implementation YNRootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {
    YNItemsViewController *homeViewController = [[YNItemsViewController alloc]init];
    UINavigationController *navHome = [[YNBaseNavigationController alloc]initWithRootViewController:homeViewController];
    
    YNCollectionsViewController *collectionsViewController = [[YNCollectionsViewController alloc]init];
    UINavigationController *navCollection = [[YNBaseNavigationController alloc]initWithRootViewController:collectionsViewController];
    
    YNTagsViewController *tagsViewController = [[YNTagsViewController alloc]init];
    UINavigationController *navTag = [[YNBaseNavigationController alloc]initWithRootViewController:tagsViewController];
    
    YNSettingsViewController *settingsViewController = [[YNSettingsViewController alloc]init];
    UINavigationController *navSettings = [[YNBaseNavigationController alloc]initWithRootViewController:settingsViewController];
    
    [self setViewControllers:@[navHome, navCollection, navTag, navSettings]];
    
    [self customizeTabBarForController];
    self.delegate = self;
}

- (void)customizeTabBarForController {
    [self.tabBar setHeight:kTabBarHeight];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemTitles = @[@"首页", @"文件", @"标签", @"设置"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        item.unselectedTitleAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
                    UIColorFromRGB(0x929292), NSForegroundColorAttributeName,
                    [UIFont fontWithName:kBarTitleFontFamily size:kBarTitleFontSize], NSFontAttributeName,
                    nil];
        item.selectedTitleAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
                    UIColorFromRGB(0x3CA9D2), NSForegroundColorAttributeName,
                    [UIFont fontWithName:kBarTitleFontFamily size:kBarTitleFontSize], NSFontAttributeName,
                    //@(NSUnderlineStyleSingle), NSUnderlineStyleAttributeName,
                    nil];
        
        index++;
    }

}


@end
