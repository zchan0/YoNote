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
#import "YNItem.h"
#import "YNCollection.h"
#import "YNTag.h"
#import "YNItemStore.h"
#import <CTAssetsPickerController.h>

@interface YNItemEditViewController ()<UITextViewDelegate, YNItemEditToolbarDelegate, HSDatePickerViewControllerDelegate, CTAssetsPickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong) YNItemEditToolbar *toolbar;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) HSDatePickerViewController *hsdpVC;
@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) NSMutableArray *editedImages;

@end

@implementation YNItemEditViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  formatter initialization
    _formatter = [[NSDateFormatter alloc]init];
    _formatter.dateFormat = kDateFormat;
    
    //  hsdpVC initialization
    self.hsdpVC = [HSDatePickerViewController new];
    self.hsdpVC.delegate = self;
    
    [self setupTextView];
    [self customNaviBar];

}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    [self.editTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    [self.editTextView resignFirstResponder];
    
    // "Save" changes to item
    YNItem *item = _item;
    item.tags        = [NSSet setWithArray:self.toolbar.tags];
    item.dateCreated = self.toolbar.dateCreated;
    item.dateAlarmed = self.toolbar.dateAlarmed;
    item.collection.collection  = self.toolbar.collection;
    
    NSLog(@"viewWillDisappear, item: %@", item);
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self   = [super initWithNibName:nil bundle:nil];
    _isNew = isNew;
    self.editedImages = [NSMutableArray array];

    if (self) {
        if (!isNew) {
            self.toolbar.dateCreated = _item.dateCreated;
            self.toolbar.dateAlarmed = _item.dateAlarmed;
            self.editedImages  = [NSMutableArray arrayWithArray:_images];
            self.toolbar.collection  = _item.collection.collection;
            self.toolbar.tags        = [_item mutableArrayValueForKeyPath:@"tags.tag"];
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

- (void)customNaviBar {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel:)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelItem;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    if (_isNew) {
        self.toolbar.dateCreated = [NSDate date];
    }
    self.navigationItem.title = [_formatter stringFromDate:self.toolbar.dateCreated];
    
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
    
    if (!_isNew) {
        self.editTextView.text = _item.memo;
        [self addImagesOnButton];
        [self addNumberOnButton:self.toolbar.dateAlarmedButton withDate:self.toolbar.dateAlarmed];
    }
    
    [self.view addSubview:self.editTextView];
    
}

- (void)addImagesOnButton {
    CGRect frame = self.toolbar.imageButton.frame;
    UIImageView *iv = [[UIImageView alloc]initWithFrame:frame];
    iv.image = [self.editedImages firstObject];
    [self.toolbar.imageButton addSubview:iv];
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = [NSString stringWithFormat:@"%d", (int)self.editedImages.count];
    label.tintColor = [UIColor grayColor];
    [self.toolbar.imageButton addSubview:label];
    
}

- (void)addNumberOnButton:(UIButton *)onButton withDate: (NSDate *)date {
    [onButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackground"] forState:UIControlStateNormal];
    _formatter.dateFormat = kDayFormat;
    [onButton setTitle:[_formatter stringFromDate:date] forState:UIControlStateNormal];
    _formatter.dateFormat = kDateFormat;
}

#pragma mark - IBActions

- (void)Save:(id)sender {
    if (self.toolbar.dateAlarmed) {
        [self createLocalNotificationWithDateAlarmed:self.toolbar.dateAlarmed];
    }
    
    BOOL success = [[YNItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved coredata changes!");
    } else {
        NSLog(@"Could not save coredata changes");
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)Cancel:(id)sender {
    [[YNItemStore sharedStore] removeItem:self.item];
    
    BOOL success = [[YNItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved coredata changes!");
    } else {
        NSLog(@"Could not save coredata changes");
    }
    
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
    collectionSearchViewController.searchItemToolbar = self.toolbar;
    collectionSearchViewController.item = _item;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:collectionSearchViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)selectTags {
    YNItemSearchViewController *tagsSearchViewController = [[YNItemSearchViewController alloc]initWithNavTitle:@"标签"];
    tagsSearchViewController.searchItemToolbar = self.toolbar;
    tagsSearchViewController.item = _item;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tagsSearchViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)pickImages {
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.editedImages];
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

}

#pragma mark - Camera

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.editedImages = [NSMutableArray arrayWithArray:assets];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    // Set All Photos as default album and it will be shown initially.
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
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
        
        [self addNumberOnButton:self.toolbar.dateAlarmedButton withDate:date];
    }
}

- (void)createLocalNotificationWithDateAlarmed: (NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:date];
    NSDate *dateReminder = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = dateReminder;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = @"⏰提醒时间到了";
    localNotif.alertAction = @"查看详情";
    localNotif.alertTitle = @"Yo";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
