//
//  YNItemDetailViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/18.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemDetailViewController.h"
#import "YNItemEditViewController.h"
#import "YNImageStore.h"

@interface YNItemDetailViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YNItemDetailViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNaviBar];
    [self customImageView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customImageView {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.6)];
    
    UIImage *image = [[YNImageStore sharedStore]imageForKey:@"img_4.jpg"];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.image = image;
    
    [self.view addSubview:self.imageView];
}

- (void)customNaviBar {
   
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - IBActions

- (IBAction)Edit:(id)sender {
    YNItemEditViewController *editViewController = [[YNItemEditViewController alloc]initForNewItem:NO];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

@end
