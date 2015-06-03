//
//  YNItemDetailViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/18.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemDetailViewController.h"
#import "YNItemEditViewController.h"
#import "YNImageDetailViewController.h"
#import "RDVTabBarController.h"
#import "YNItemStore.h"

@interface YNItemDetailViewController ()<YNItemEditViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak)   IBOutlet UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) IBOutlet UILabel     *memoLabel;
@property (nonatomic, strong) IBOutlet UILabel     *tagLabel;
@property (nonatomic, strong) IBOutlet UILabel     *dateCreatedLabel;

@property (nonatomic, strong) IBOutlet UIButton    *exportButton;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSArray *images;

@end

@implementation YNItemDetailViewController

#pragma mark - Lifecycle

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
    [self makeNaviBarTransparent];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)customNaviBar {

    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    [self makeNaviBarTransparent];
    
}

- (void)makeNaviBarTransparent {
    //  make the navigationBar transparent
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setTranslucent:YES];
}

- (void)customImageView {
    _images = [[YNItemStore sharedStore]getImagesByItem:_item];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:[[_images firstObject] imageName]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = image;
    
    //  Add aciton to imageView
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
}

- (void)customTextArea {
    NSSet *tagsSet = _item.tags;
    NSArray *tags  = [self tagsSetToArray:tagsSet];
    self.tagLabel.text = [tags componentsJoinedByString:@", "];
    self.memoLabel.text = _item.memo;
    self.dateCreatedLabel.text = [_formatter stringFromDate:_item.dateCreated];
    self.visualEffectView.backgroundColor = UIColorFromRGB(0x3CA9D2);
}

#pragma mark - IBActions

- (IBAction)Edit:(id)sender {
    YNItemEditViewController *editViewController = [[YNItemEditViewController alloc]initForNewItem:NO];
    editViewController.item = _item;
    editViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)tapImage:(id)sender {
    YNImageDetailViewController *imageDetailViewController = [[YNImageDetailViewController alloc]initWithNibName:@"YNImageDetailViewController" bundle:nil];
    imageDetailViewController.images = _images;
    imageDetailViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:imageDetailViewController animated:YES completion:nil];
    
}

#pragma mark - Private Methods
- (NSArray *)tagsSetToArray:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray array];
    for (YNTag *element in set) {
        [array addObject:element.tag];
    }
    return array;
}

- (void)refreshData {
    _images = [[YNItemStore sharedStore]getImagesByItem:_item];
    UIImage *image = [[YNImageStore sharedStore]imageForKey:[[_images firstObject] imageName]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = image;
    [self customTextArea];
}

@end
