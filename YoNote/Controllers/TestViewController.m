//
//  TestViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/28.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "TestViewController.h"
#import "YNItemStore.h"
#import "YNImageStore.h"
#import <CTAssetsPickerController.h>

#define kWidth  self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface TestViewController ()<CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submit;
@property (nonatomic, strong) YNItem *item;

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *selectedImagesNames;

@end

@implementation TestViewController

- (void)loadView {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.item = [[YNItemStore sharedStore]createItem];
    self.item.dateAlarmed = [NSDate date];
    self.item.dateCreated = [NSDate date];
    self.item.memo        = @"我是萌萌的测试备注";
    
    [self customNavBar];
    [self customTextView];
    
    _selectedImages = [NSMutableArray array];
    _selectedImagesNames = [NSMutableArray array];
}

- (void)customTextView {
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
}

- (void)customNavBar {
    UIImage *rightImage = [UIImage imageNamed:@"navi_add"];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;

}

- (IBAction)submit:(id)sender {
    NSString *textInput = self.textField.text;
    NSArray *tags = @[textInput];
    NSSet *textSet = [NSSet setWithArray:tags];
    NSSet *imageNamesSet = [NSSet setWithArray:self.selectedImagesNames];
    
    [[YNItemStore sharedStore]createTag:textInput];
    [[YNItemStore sharedStore]addTagsForItem:textSet forItem:_item];
    [[YNItemStore sharedStore]addImagesForItem:imageNamesSet forItem:_item];
    
    BOOL success = [[YNItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"添加成功.");
    } else {
        NSLog(@"添加失败");
    }
    
   
}

- (IBAction)addNewItem:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
    
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
            /*if (!_selectedImages) {
                _selectedImages = [[NSMutableArray alloc]init];
            }*/
            
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
            picker.delegate             = self;
            picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selectedImages];
            // Set navigation bar's tint color
            picker.childNavigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            [self presentViewController:picker animated:YES completion:nil];
        
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
    [[YNImageStore sharedStore] saveImages:assets];
    
    self.selectedImagesNames = [NSMutableArray arrayWithArray:[self getImageNames:assets]];
    for (NSString *imageName in self.selectedImagesNames) {
        [[YNItemStore sharedStore] createImage:imageName];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    // Set All Photos as default album and it will be shown initially.
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (NSArray *)getImageNames:(NSArray *)assets {
    NSMutableArray *imageNames = [NSMutableArray array];
    
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *imageRep = [asset defaultRepresentation];
        [imageNames addObject:[imageRep filename]];
    }
    
    return imageNames;
}

@end
