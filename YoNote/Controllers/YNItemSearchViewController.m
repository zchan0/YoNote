//
//  YNItemSearchViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/16.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemSearchViewController.h"
#import "YNItemStore.h"

@interface YNItemSearchViewController ()

@property (nonatomic, strong) NSString    *navTitle;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cellSelected; // for multiple selection
@property (nonatomic, strong) NSMutableArray *tags; // already chosen tags' name
@property (nonatomic, strong) NSString *collectionResult;
@property (nonatomic, strong) NSMutableArray  *tagResults;

@property (nonatomic) BOOL  isCollection;
@property (nonatomic) BOOL  isTags;

@end

@implementation YNItemSearchViewController

#pragma mark - Lifecycle

- (instancetype)initWithNavTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.navTitle = title;
        self.navigationItem.title = title;
        self.dataSource = [NSMutableArray array];
        [self isCollectionOrTags];
        if (_isCollection) {
            for (YNCollection *collection in [[YNItemStore sharedStore] allCollections]) {
                [self.dataSource addObject:collection.collectionName];
            }
        }
        if (_isTags) {
            for (YNTag *tag in [[YNItemStore sharedStore] allTags]) {
                [self.dataSource addObject:tag.tag];
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNaviBar];
    [self customTextView];
        
    self.tagResults = [NSMutableArray array];
    self.cellSelected = [NSMutableArray array];
    
    if (!_isNew) {
        if (_isTags) {
            self.tags = [NSMutableArray array];
            for (YNTag *tag in _item.tags) {
                [self.tags addObject:tag.tag];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self refreshTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customNaviBar {
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel:)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
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
    self.tableView.tableHeaderView = self.backgroundView;
}

#pragma mark - IBAcitons

- (IBAction)Done:(id)sender {
    
    if (_isTags) {
        //handle tagsResult
        for (NSIndexPath *selectedPath in self.cellSelected) {
            NSString *selectedTag = self.dataSource[selectedPath.row];
            [self.tagResults addObject:selectedTag];
        }
        _searchItemToolbar.tags = [NSArray arrayWithArray:self.tagResults];
        
        if (!_isNew) {
            NSSet *oldTags = _item.tags;
            [_item removeTags:oldTags];
        }
        
        NSSet *tagsSet = [NSSet setWithArray:self.tagResults];
        [[YNItemStore sharedStore]addTagsForItem:tagsSet forItem:_item];
    }
    
    [self.presentingViewController
            dismissViewControllerAnimated:YES
            completion:^{
                BOOL success = [[YNItemStore sharedStore] saveChanges];
                if (success) {
                    NSLog(@"添加tags成功.");
                } else {
                    NSLog(@"添加tags失败");
                }
     }];
}

- (IBAction)Cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.inputTextField) {
        [self.dataSource addObject:self.inputTextField.text];
        [self.tableView reloadData];
        
        if (_isCollection) {
            [[YNItemStore sharedStore]createCollection:self.inputTextField.text];
        }
        if (_isTags) {
            [[YNItemStore sharedStore]createTag:self.inputTextField.text];
        }
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
    
    if ([self.cellSelected containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isCollection) {
        self.collectionResult = self.dataSource[indexPath.row];
        if (_isNew)
            [[YNItemStore sharedStore]addCollectionForItem:self.collectionResult forItem:self.item];
        else
            _item.collection.collectionName = self.collectionResult;
        
        _searchItemToolbar.collection = self.collectionResult;
        [self.presentingViewController
                dismissViewControllerAnimated:YES
                completion:^{
                    BOOL success = [[YNItemStore sharedStore] saveChanges];
                    if (success) {
                        NSLog(@"添加colleciton成功.");
                    } else {
                        NSLog(@"添加collection失败.");
                    }
         }];
    }
    if (_isTags) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([self.cellSelected containsObject:indexPath]) {
            [self.cellSelected removeObject:indexPath];
        } else {
            [self.cellSelected addObject:indexPath];
        }
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_isCollection) {
            YNCollection *collection = self.dataSource[indexPath.row];
            NSSet *items = collection.items;
            [collection removeItems:items];
            [[YNItemStore sharedStore]removeCollection:collection];
        }
        
        if (_isTags) {
            YNTag *tag = self.dataSource[indexPath.row];
            NSSet *items = tag.items;
            for (YNItem *item in items) {
                [item removeTagsObject:tag];
            }
            [[YNItemStore sharedStore]removeTag:tag];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        BOOL success = [[YNItemStore sharedStore] saveChanges];
        if (success) {
            NSLog(@"Saved coredata changes!");
        } else {
            NSLog(@"Could not save coredata changes");
        }
    }
}

#pragma mark - Private Methods

- (void)isCollectionOrTags {
    if ([self.navTitle isEqualToString:@"图片集"]) {
        self.isCollection = YES;
        self.isTags = NO;
    }
    if ([self.navTitle isEqualToString:@"标签"]) {
        self.isTags = YES;
        self.isCollection = NO;
    }
}

- (NSArray *)tagsSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNTag *element in set) {
        [array addObject:element];
    }
    return array;
}

@end
