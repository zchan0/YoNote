//
//  YNItemSearchViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/16.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemSearchViewController.h"

@interface YNItemSearchViewController ()

@property (nonatomic, strong) NSString    *navTitle;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cellSelected; // for multiple selection

@end

@implementation YNItemSearchViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    [self customNaviBar];
    [self customTextView];
}

- (instancetype)initWithNavTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.navTitle = title;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"高级数据库", @"高级计算机网络", @"组合数学", @"数据挖掘", @"设计模式"];
    self.dataSource = [NSMutableArray arrayWithArray:self.items];
    self.tagResults = [NSMutableArray array];
    self.cellSelected = [NSMutableArray array];
    
    [self.inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customNaviBar {
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Done:)];
    doneItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneItem;
    
}

- (void)customTextView {
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.backgroundView.backgroundColor = UIColorFromRGB(0xD1D5DB);
    
    self.inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(kLabelHorizontalInsets, kLabelVerticalInsets, self.view.frame.size.width - 2*kLabelHorizontalInsets, 30)];
    self.inputTextField.backgroundColor = [UIColor whiteColor];
    self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputTextField.placeholder = [NSString stringWithFormat:@"添加%@", self.navTitle];
    self.inputTextField.delegate = self;
    
    [self.backgroundView addSubview:self.inputTextField];
}

#pragma mark - IBAcitons

- (IBAction)Done:(id)sender {
    
    if ([self.navTitle isEqualToString:@"标签"]) {
        //handle tagsResult
        
        for (NSIndexPath *selectedPath in self.cellSelected) {
            NSString *selectedTag = self.dataSource[selectedPath.row];
            [self.tagResults addObject:selectedTag];
        }
        
        [self outputArray:self.tagResults];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.inputTextField) {
        [self.dataSource addObject:self.inputTextField.text];
        [self.tableView reloadData];
        self.inputTextField.text = nil;
    }
    
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemSearchCellIdentifier = @"itemSearchCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: itemSearchCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemSearchCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    self.tableView.tableHeaderView = self.backgroundView;
    
    if ([self.cellSelected containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.navTitle isEqualToString:@"图片集"]) {
        self.collectionResult = self.dataSource[indexPath.row];
        
        NSLog(@"collectionResult: %@", self.collectionResult);
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([self.navTitle isEqualToString:@"标签"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([self.cellSelected containsObject:indexPath]) {
            [self.cellSelected removeObject:indexPath];
        } else {
            [self.cellSelected addObject:indexPath];
        }
        
        [tableView reloadData];
    }

}

#pragma mark - Private Methods

- (void)outputArray: (NSMutableArray *) array{
    for (NSString *str in array) {
        NSLog(@"%@", str);
    }
}


@end
