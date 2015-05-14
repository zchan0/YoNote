//
//  YNItemEditViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditViewController.h"
#import "YNItemEditToolbar.h"

@interface YNItemEditViewController ()

@property (nonatomic, strong) UITextView *editTextView;

@end

@implementation YNItemEditViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    [self.editTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.editTextView resignFirstResponder];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Views

- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customBarItem];
    [self setupTextView];
}

- (void)setupTextView {
    CGFloat width = self.view.frame.size.width;
    self.editTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 170)];
    self.editTextView.delegate = self;
    self.editTextView.scrollEnabled = YES;
    
    //Appearence
    [self.editTextView setFont:[UIFont systemFontOfSize:kTitleFontSize]];
    [self.editTextView setTintColor:UIColorFromRGB(0x3CA9D2)];  // iOS 7.0 later
    
    //Toolbar
    UIToolbar *toolbar = [[YNItemEditToolbar alloc]init].YNItemEditToolbar;
    self.editTextView.inputAccessoryView = toolbar;
    
    [self.view addSubview:self.editTextView];
    
    
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

#pragma mark - Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardFrameDidChange:)
                                          name:UIKeyboardWillChangeFrameNotification
                                          object:nil];
    
}

- (void)keyboardFrameDidChange:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    self.editTextView.frame = aRect;
    

}


- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

@end
