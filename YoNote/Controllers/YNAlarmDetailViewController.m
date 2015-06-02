//
//  YNAlarmDetailViewController.m
//  YoNote
//
//  Created by Zchan on 15/6/2.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNAlarmDetailViewController.h"
#import "RDVTabBarController.h"
#import "YNItemStore.h"

#define kAlarmedDateFormat @"M月d日 H:mm"

@interface YNAlarmDetailViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation YNAlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  formatter initialization
    _formatter = [[NSDateFormatter alloc]init];
    _formatter.dateFormat = kAlarmedDateFormat;
    
    //  config navigationBar
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"提醒时间";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //  data
    _items = [NSMutableArray arrayWithArray:[[YNItemStore sharedStore]allItems]];
    _datasource = [NSMutableArray array];
    for (YNItem *item in _items) {
        if (item.dateAlarmed) {
            [_datasource addObject:item];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemSearchCellIdentifier = @"alarmedDateCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: itemSearchCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemSearchCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //  config cell
    YNItem *item = self.datasource[indexPath.row];
    NSDate *date = item.dateAlarmed;
    cell.textLabel.text = [_formatter stringFromDate:date];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        YNItem *item = _datasource[indexPath.row];
        item.dateAlarmed = nil;
        [_datasource removeObjectIdenticalTo:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
