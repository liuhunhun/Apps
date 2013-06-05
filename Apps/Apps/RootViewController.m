//
//  RootViewController.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "RootCell.h"
#import "ContainerViewController.h"

@class LoginViewController;
@class SinaWeiboController;
@class TencentWeiboController;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate> {
    LoginViewController *loginViewController;
    
    UINavigationController *containerNav;
    ContainerViewController *containerViewController;
}

@property (nonatomic, readonly, retain) UINavigationController *containerNav;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    needTableView = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView.frame = CGRectMake(0, 0, 270, 460);
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"root_tableview_bg.jpg"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self sinaWeiboAuthValid] && ![self tencentWeiboAuthValid]) {
        if (!loginViewController) {
            loginViewController = [[LoginViewController alloc] init];
            loginViewController.delegate = self;
        }
        [self presentModalViewController:loginViewController animated:YES];
    }
    else {
        [self.view addSubview:self.containerNav.view];
    }
}

#pragma mark - Private Method

- (UINavigationController*)createNavControllerWithRootController:(UIViewController*)controller {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationitem_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    return nav;
}

- (UINavigationController*)containerNav {
    if (!containerNav) {
        containerViewController = [[ContainerViewController alloc] init];
        containerNav = [self createNavControllerWithRootController:containerViewController];
        containerNav.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return containerNav;
}

- (void)leftTableViewDidSelected:(NSIndexPath*)indexPath {
    switch (indexPath.row) {
        case 0:
            [containerViewController ChangeClientStatus:AppsClientIsSinaWeibo];
            break;
        case 1:
            [containerViewController ChangeClientStatus:AppsClientIsTencentWeibo];
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    [(MyGestureController*)containerNav.visibleViewController restoreViewLocation:YES];
}

#pragma mark - LoginViewController Delegate

- (void)loginDidSuccessed:(AppLoginStatus)status {
    switch (status) {
        case 0:
            [containerViewController ChangeClientStatus:AppsClientIsSinaWeibo];
            break;
        case 1:
            [containerViewController ChangeClientStatus:AppsClientIsTencentWeibo];
            break;
        default:
            break;
    }
    [(MyGestureController*)containerNav.visibleViewController restoreViewLocation:YES];
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self leftTableViewDidSelected:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    sectionView.image = [UIImage imageNamed:@"root_section_bg.jpg"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    [sectionView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"社交";
            break;
        default:
            break;
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 3;
            break;
        case 2:
            row = 2;
            break;
        case 3:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RootCell";
    RootCell *cell = (RootCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[RootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RootCell *_rootCell = (RootCell*)cell;
    switch (indexPath.section) {
        case 0:
            if (0 == indexPath.row) {
                _rootCell.imageView.image = [UIImage imageNamed:@"sina_weibo_icon.png"];
                _rootCell.titleLable.text = @"新浪微博";
            }
            else if (1 == indexPath.row) {
                _rootCell.imageView.image = [UIImage imageNamed:@"tencent_weibo_icon.png"];
                _rootCell.titleLable.text = @"腾讯微博";
            }
            break;
        default:
            break;
    }
    _rootCell.selectionStyle = UITableViewCellSelectionStyleGray;
    _rootCell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_selected.png"]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
