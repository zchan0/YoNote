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
#import "RDVTabBarController.h"

#define kFrameHeight self.view.frame.size.height
#define kFrameWidth  self.view.frame.size.width
#define kTestString  @"概念模型，从用户角度建模，有利于实现数据库的, 概念模型，从用户角度建模，有利于实现数据库的"

@interface YNItemDetailViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIView *background;

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
    [self customTextArea];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customImageView {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight * 0.6)];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:@"img_2.jpg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = image;
    
    [self.view addSubview:self.imageView];
}

- (void)customTextArea {
    
}

- (void)customNaviBar {
    
    /*** This is Plan B ***/
    //UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 20)];
    //[editButton setBackgroundImage:[UIImage imageNamed:@"navi_edit"] forState:UIControlStateNormal];
    //[editButton addTarget:self action:@selector(Edit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    //UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = editItem;
    
    /*UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;*/
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

#pragma mark - IBActions

- (IBAction)Edit:(id)sender {
    YNItemEditViewController *editViewController = [[YNItemEditViewController alloc]initForNewItem:NO];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

/*
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}*/

@end
