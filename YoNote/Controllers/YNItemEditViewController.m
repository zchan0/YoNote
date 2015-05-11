//
//  YNItemEditViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditViewController.h"
#import "YNItemEditView.h"

@interface YNItemEditViewController ()


@end

@implementation YNItemEditViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
        }
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Views

- (void)loadView {
    [super loadView];
    //self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = [[YNItemEditView alloc]init];
    self.view.backgroundColor = [UIColor redColor];
    [self customBarItem];
    
}

- (void)customBarItem {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel:)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelItem;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
}


#pragma mark - IBActions

- (void)Save:(id)sender {
    
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)Cancel:(id)sender {
    
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
