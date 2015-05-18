//
//  YNItemsViewController.h
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNBaseViewController.h"
#import "RDVTabBarController.h"

@interface YNItemsViewController : YNBaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) RDVTabBarController *tabBarController;

@end
