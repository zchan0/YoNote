//
//  YNItemEditViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/10.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditViewController.h"
#import "HSDatePickerViewController.h"
#import "YNItemSearchViewController.h"
#import "YNItemEditToolbar.h"

#define kDay    @"d"
#define kMonth  @"M"
#define kYear   @"yyyy"

@interface YNItemEditViewController ()<UITextViewDelegate, YNItemEditToolbarDelegate, HSDatePickerViewControllerDelegate>

@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong) YNItemEditToolbar *toolbar;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) HSDatePickerViewController *hsdpVC;

@end

@implementation YNItemEditViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _formatter = [[NSDateFormatter alloc]init];
    _formatter.dateFormat = kDateFormat;
    self.navigationItem.title = [_formatter stringFromDate:[NSDate date]];
    
    self.hsdpVC = [HSDatePickerViewController new];
    self.hsdpVC.delegate = self;

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
    [self setupTextView];
    [self customNaviBar];
}

- (void)customNaviBar {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel:)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelItem;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
    
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
    self.toolbar = [[YNItemEditToolbar alloc]init];
    self.toolbar.delegate = self;
    self.editTextView.inputAccessoryView = self.toolbar.YNItemEditToolbar;
    
    [self.view addSubview:self.editTextView];
    
}

#pragma mark - IBActions

- (void)Save:(id)sender {
    if (self.toolbar.dateAlarmed) {
        [self createLocalNotificationWithDateAlarmed:self.toolbar.dateAlarmed];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)Cancel:(id)sender {
    
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

- (void)pickDateCreated {
    self.toolbar.dateCreatedButton.tag = 1;
    [self presentViewController:self.hsdpVC animated:YES completion:nil];
    
}

- (void)pickDateAlarmed {
    self.toolbar.dateAlarmedButton.tag = 1;
    [self presentViewController:self.hsdpVC animated:YES completion:nil];
}

- (void)selectCollection {
    YNItemSearchViewController *collectionSearchViewController = [[YNItemSearchViewController alloc]initWithNavTitle:@"图片集"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:collectionSearchViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)selectTags {
    YNItemSearchViewController *tagsSearchViewController = [[YNItemSearchViewController alloc]initWithNavTitle:@"标签"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tagsSearchViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    
}

#pragma mark - Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardFrameDidChange:)
                                          name:UIKeyboardWillChangeFrameNotification
                                          object:nil];
    
}

//  Dynamiclly change editTextView height
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

// Scroll UITextView
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

#pragma mark - Private Methods

- (void)hsDatePickerPickedDate:(NSDate *)date {
    if (self.toolbar.dateCreatedButton.tag) {
        self.toolbar.dateCreated = date;
        self.toolbar.dateCreatedButton.tag = 0;
        self.navigationItem.title = [_formatter stringFromDate:date];
    }
    
    if (self.toolbar.dateAlarmedButton.tag) {
        self.toolbar.dateAlarmed = date;
        self.toolbar.dateAlarmedButton.tag = 0;
        [self.toolbar.dateAlarmedButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackground"] forState:UIControlStateNormal];
        _formatter.dateFormat = kDayFormat;
        [self.toolbar.dateAlarmedButton setTitle:[_formatter stringFromDate:date] forState:UIControlStateNormal];
        _formatter.dateFormat = kDateFormat;
        
    }
}

- (void)createLocalNotificationWithDateAlarmed: (NSDate *)date {
    _formatter.dateFormat = kDay;
    NSInteger day = [[_formatter stringFromDate:date] integerValue];
    _formatter.dateFormat = kMonth;
    NSInteger month = [[_formatter stringFromDate:date] integerValue];
    _formatter.dateFormat = kYear;
    NSInteger year = [[_formatter stringFromDate:date] integerValue];
    _formatter.dateFormat = kDateFormat;
    NSLog(@"date: %@", date);
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:day];
    [dateComps setMonth:month];
    [dateComps setYear:year];
    [dateComps setHour:8]; // after Hour later
    [dateComps setMinute:35];
    NSDate *dateReminder = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = dateReminder;NSLog(@"fireDate: %@", dateReminder);
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = @"⏰提醒时间到了";
    localNotif.alertAction = @"查看详情";
    localNotif.alertTitle = @"Yo";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
