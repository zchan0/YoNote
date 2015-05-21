//
//  YNImagesViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/21.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNImagesViewController.h"
#import "RDVTabBarController.h"
#import "YNImageStore.h"

@interface YNImagesViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YNImagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self displayImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayImage {
    NSString *path = [NSString stringWithFormat:@"img_%d.jpg", (int)self.index + 1];
    UIImage  *image= [[YNImageStore sharedStore]imageForKey:path];
    self.imageView.image = image;
    
    //  Add aciton to imageView
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
}

- (IBAction)tapImage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
