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
@property (nonatomic, weak)   IBOutlet UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) IBOutlet UILabel     *memoLabel;
@property (nonatomic, strong) IBOutlet UILabel     *tagLabel;
@property (nonatomic, strong) IBOutlet UILabel     *dateCreatedLabel;


@property (nonatomic, strong) IBOutlet UIButton    *imageBrowserButton;
@property (nonatomic, strong) IBOutlet UIButton    *exportButton;

@property (nonatomic, strong) NSDateFormatter *formatter;


@end

@implementation YNItemDetailViewController

#pragma mark - Lifecycle

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  formatter initialization
    _formatter = [[NSDateFormatter alloc]init];
    _formatter.dateFormat = kDateFormat;
    
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
    
    //put the bar back to default
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customNaviBar {

    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    //  make the navigationBar transparent
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setTranslucent:YES];
}

- (void)customImageView {

    UIImage *image = [[YNImageStore sharedStore]imageForKey:@"img_2.jpg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = image;
}

- (void)customTextArea {

    self.memoLabel.text = kTestString;
    self.dateCreatedLabel.text = [_formatter stringFromDate:[NSDate date]];
    
    self.visualEffectView.backgroundColor = UIColorFromRGB(0x3CA9D2);
    
}

#pragma mark - IBActions

- (IBAction)Edit:(id)sender {
    YNItemEditViewController *editViewController = [[YNItemEditViewController alloc]initForNewItem:NO];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}


@end
