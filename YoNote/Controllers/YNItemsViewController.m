//
//  YNItemsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemsViewController.h"
#import "YNItemCell.h"
#import "RDVTabBarController.h"
#import "YNItemDetailViewController.h"
#import "YNItemEditViewController.h"
#import "YNItemStore.h"
#import "YNImageStore.h"
#import <CTAssetsPickerController.h>

static NSString *YNItemCellIndentifier = @"YNItemCellIdentifier";

@interface YNItemsViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *selectedImagesNames;
@property (nonatomic) BOOL isHome;

@end

@implementation YNItemsViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedImagesNames  = [NSMutableArray array];
    
    [self isHomePage];
    if (_isHome) {
        [self customNavBar];
        self.datasource = [NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allItems]];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        NSString *name = self.navigationItem.title;
        YNCollection *collection = [[YNItemStore sharedStore]getCollectionByName:name];
        YNTag *tag = [[YNItemStore sharedStore]getTagByName:name];
        NSSet *items;
        if (collection != nil)
            items = collection.items;
        if (tag != nil)
            items = tag.items;
        
        self.datasource = [NSMutableArray array];
        for (YNItem *item in items)
            [self.datasource addObject:item];
    }
    
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //put the bar back to default
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    if (_isHome) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        [self refreshTableView];
    }
    else
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

#pragma mark - Views

- (void)customTableView {
    [self.tableView registerClass:[YNItemCell class] forCellReuseIdentifier:YNItemCellIndentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)customNavBar {
    
    UINavigationItem *navItem = self.navigationItem;
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

- (void)refreshTableView {
    self.datasource = [NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allItems]];
    [self.tableView reloadData];
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
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YNItemCellIndentifier];
    
    YNItem *item = self.datasource[indexPath.row];
    
    //configure cell with YNItem
    cell.collectionNameLabel.text = item.collection.collectionName;
    cell.memoLabel.text = item.memo;
    
    NSSet *tagsSet = [item tags];
    NSArray *tags  = [self tagsSetToArray:tagsSet];
    cell.tagLabel.text = [tags componentsJoinedByString:@", "];
    
    NSString *imageName = [[self imagesSetToArray:[item images]]firstObject];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:imageName];
    cell.iv.image = [[YNImageStore sharedStore]setThumbnailFromImage:image newRect:kItemImageViewRect];;
    
    cell.clipsToBounds = YES;
    cell.separatorInset = ALEdgeInsetsZero; // make separator below imageview visible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell updateFonts];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete YNItem
        YNItem *item = self.datasource[indexPath.row];
        NSArray *images = [[YNItemStore sharedStore]getImagesByItem:item];
        for (YNImage *image in images) {
            NSString *imageName = image.imageName;
            [[YNItemStore sharedStore] removeImage:image];
            NSArray *sameNamesImages = [[YNItemStore sharedStore]getSameNameImages:image];
            if (sameNamesImages.count < 1) {
                NSLog(@"要删除的图片: %@", imageName);
                [[YNImageStore sharedStore] deleteImageForKey:imageName];
            }
        }
        
        [[YNItemStore sharedStore] removeItem: item];
        [self.datasource removeObjectIdenticalTo:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        BOOL success = [[YNItemStore sharedStore] saveChanges];
        if (success) {
            NSLog(@"Saved coredata changes!");
        } else {
            NSLog(@"Could not save coredata changes");
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YNItemDetailViewController *detailViewController = [[YNItemDetailViewController alloc]init];
    detailViewController.item = self.datasource[indexPath.row];
    
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
            
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:picker animated:NO completion:nil];
                }];
                
            } else {
                [self presentViewController:picker animated:YES completion:nil];
            }
            break;
        }
        
        default:
            break;
    }
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    
    for (ALAsset *asset in assets) {
        [self.selectedImagesNames addObject:[[asset defaultRepresentation] filename]];
    }
    
    YNItemEditViewController *itemEditViewController = [[YNItemEditViewController alloc]initForNewItem:YES];
    self.selectedImages = [NSMutableArray arrayWithArray:assets];
    itemEditViewController.images = [NSArray arrayWithArray:self.selectedImages];
    itemEditViewController.imagesNames = [NSArray arrayWithArray:self.selectedImagesNames];
    
    YNItem *newItem = [[YNItemStore sharedStore]createItem];
    itemEditViewController.item = newItem;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:itemEditViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    // Set All Photos as default album and it will be shown initially.
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

#pragma mark - Private Methods

- (void)isHomePage {
    if ([self.navigationItem.title isEqualToString:@"首页"])
        _isHome = YES;
    else
        _isHome = NO;
}

- (NSArray *)tagsSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNTag *element in set) {
        [array addObject:element.tag];
    }
    return array;
}

- (NSArray *)imagesSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNImage *element in set) {
        [array addObject:element.imageName];
    }
    return array;
}

@end
