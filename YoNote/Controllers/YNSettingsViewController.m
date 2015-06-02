//
//  YNSettingsViewController.m
//  YoNote
//
//  Created by Zchan on 15/5/6.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNSettingsViewController.h"
#import "YNAlarmDetailViewController.h"
#import "RDVTabBarController.h"

@implementation YNSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}


#pragma mark - Views

- (void)customNavigationItem {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"设置";
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"提醒时间";
            break;
        case 1:
            return @"关于";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemSearchCellIdentifier = @"settingsCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: itemSearchCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemSearchCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"查看提醒时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            if (indexPath.row == 0)
                cell.textLabel.text = @"意见反馈";
            if (indexPath.row == 1) {
                cell.textLabel.text = @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            YNAlarmDetailViewController *alarmDetailViewController = [[YNAlarmDetailViewController alloc]init];
            [self.navigationController pushViewController:alarmDetailViewController animated:YES];
        
            break;
        }
        case 1:
        
        default:
            break;
    }

}


@end
