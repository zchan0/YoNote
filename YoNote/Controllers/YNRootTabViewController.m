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
    
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"home", @"collection", @"tag", @"settings"];
    //NSArray *tabBarItemTitles = @[@"首页", @"图片集", @"标签", @"设置"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        //[item setTitle:[tabBarItemTitles objectAtIndex:index]];
        
        index++;
    }

}


@end
