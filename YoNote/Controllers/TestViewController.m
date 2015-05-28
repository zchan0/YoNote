//
//  TestViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/28.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "TestViewController.h"
#import "YNItemStore.h"

#define kWidth  self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface TestViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submit;
@property (nonatomic, strong) YNItem *item;

@end

@implementation TestViewController

- (void)loadView {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(kWidth * 0.3, kHeight * 0.5, kWidth * 0.5, 40)];
    self.textField.backgroundColor = [UIColor greenColor];
    self.textField.textColor = [UIColor redColor];
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake(kWidth * 0.3, kHeight * 0.3 , kWidth * 0.5, 40)];
    self.submit.backgroundColor = [UIColor blackColor];
    [self.submit setTitle:@"提交" forState:UIControlStateNormal];
    self.submit.titleLabel.tintColor = [UIColor whiteColor];
    [self.submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.submit];
    
    self.item = [[YNItemStore sharedStore]createItem];
    
    self.item.dateAlarmed = [NSDate date];
    self.item.dateCreated = [NSDate date];
    self.item.memo        = @"我是萌萌的备注";
}

- (IBAction)submit:(id)sender {
    NSString *textInput = self.textField.text;
    NSArray *tags = @[textInput];
    NSSet *textSet = [NSSet setWithArray:tags];
    
    NSLog(@"%@", textSet);
    [[YNItemStore sharedStore]createTag:textInput];
    [[YNItemStore sharedStore]addTagsForItem:textSet forItem:_item];
    
    BOOL success = [[YNItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"添加成功.");
    } else {
        NSLog(@"添加失败");
    }
    
   
}



@end
