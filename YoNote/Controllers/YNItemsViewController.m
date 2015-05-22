//
//  YNItemsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemsViewController.h"
#import "YNItemCell.h"
#import "YNImageStore.h"
#import "RDVTabBarController.h"
#import "YNItemDetailViewController.h"

static NSString *YNItemCellIndentifier = @"YNItemCellIdentifier";

@interface YNItemsViewController ()

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) NSMutableArray *selectedImages;

@end

@implementation YNItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavBar];
    [self customTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //put the bar back to default
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - Views

- (void)customTableView {
    [self.tableView registerClass:[YNItemCell class] forCellReuseIdentifier:YNItemCellIndentifier];
}

- (void)customNavBar {
    
    UINavigationItem *navItem = self.navigationItem;
    // custom title attributes
    navItem.title = @"首页";
    
    UIImage *leftImage = [UIImage imageNamed:@"navi_search"];
    UIImage *rightImage = [UIImage imageNamed:@"navi_add"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(searchItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    navItem.leftBarButtonItem = leftBarItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    navItem.rightBarButtonItem = rightBarItem;
        
}


#pragma mark - IBActions

- (IBAction)addNewItem:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
    
}

- (IBAction)searchItem:(id)sender {
    
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YNItemCellIndentifier];
    [cell updateFonts];
    cell.collectionNameLabel.text = @"高级数据库";
    cell.memoLabel.text = @"概念模型，从用户角度建模，有利于实现数据库的, 概念模型，从用户角度建模，有利于实现数据库的";
    cell.tagLabel.text = @"笔记";
    
    NSString *path = [NSString stringWithFormat:@"img_%d.jpg", ((int)indexPath.row)+1];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:path];
    UIImage *thumbnail = [[YNImageStore sharedStore]setThumbnailFromImage:image newRect:kItemImageRect];
    cell.iv.image = thumbnail;
    cell.separatorInset = ALEdgeInsetsZero; // make separator below imageview visible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemDetailViewController *detailViewController = [[YNItemDetailViewController alloc]init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kItemTableCellHeight;
}

#pragma mark - Camera

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                //[self presentViewController:picker animated:YES completion:nil];
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [self presentViewController:picker animated:NO completion:nil];
                    }];
                }
                else{
                    [self presentViewController:picker animated:NO completion:nil];
                }
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            if (!_selectedImages) {
                _selectedImages = [[NSMutableArray alloc]init];
            }
            
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
            picker.delegate             = self;
            picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selectedImages];
            // Set navigation bar's tint color
            picker.childNavigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            // iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popover.delegate = self;
                
                [self.popover
                 presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                 permittedArrowDirections:UIPopoverArrowDirectionAny
                 animated:YES];
            }
            else
            {
                [self presentViewController:picker animated:YES completion:nil];
            }

            
            
            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.selectedImages = [NSMutableArray arrayWithArray:assets];
    NSLog(@"%@", _selectedImages);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    // Set All Photos as default album and it will be shown initially.
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}


@end
