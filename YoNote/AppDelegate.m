//
//  AppDelegate.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "AppDelegate.h"
#import "YNRootTabViewController.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //  Return Rect with status bar
    //  [[UIScreen mainScreen] applicationFrame] return Rect without status bar
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    YNRootTabViewController *rootViewController = [[YNRootTabViewController alloc] init];
    self.window.rootViewController = rootViewController;

    //TestViewController *viewController = [[TestViewController alloc]init];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    //self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self customNaviBar];
    [self.window makeKeyAndVisible];    // Make current window visible
    
    [self registerNotification];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Havn't tested it  
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - Private Methods

- (void)customNaviBar {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColorFromRGB(0xFFFFFF);
    shadow.shadowOffset = CGSizeMake(0, 0.5);
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                    UIColorFromRGB(0xFFFFFF), NSForegroundColorAttributeName,
                    shadow, NSShadowAttributeName,
                    [UIFont fontWithName:kBarTitleFontFamily size:20.0], NSFontAttributeName,
                    nil]];

    [navigationBarAppearance setBarTintColor:UIColorFromRGB(0x3CA9D2)];

}

- (void)registerNotification {
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}


@end
