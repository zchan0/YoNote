//
//  YNImageDetailViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/21.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNImageDetailViewController.h"
#import "YNImagesViewController.h"
#import "YNItemStore.h"
#import "YNImageStore.h"

@implementation YNImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self initPageViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPageViewController {
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    YNImagesViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

#pragma mark - Delegate Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YNImagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YNImagesViewController *)viewController index];
    
    index++;
    
    if (index == _images.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (YNImagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    YNImagesViewController *imageViewController = [[YNImagesViewController alloc] initWithNibName:@"YNImagesViewController" bundle:nil];
    imageViewController.index = index;
    UIImage *image = [[YNImageStore sharedStore]imageForKey:[_images[index] imageName]];
    imageViewController.image = image;
    return imageViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return _images.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
