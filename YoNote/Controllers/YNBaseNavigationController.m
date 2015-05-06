//
//  YNBaseNavigationController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNBaseNavigationController.h"

@implementation YNBaseNavigationController

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}



@end
