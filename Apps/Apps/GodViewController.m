//
//  GodViewController.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "TCWBEngine.h"
#import "MyActivityIndicator.h"
#import "MenuView.h"
#import "ToolBarView.h"
#import "BWStatusBarOverlay.h"

@interface GodViewController () <UITableViewDelegate, UITableViewDataSource, SinaWeiboDelegate, ToolBarViewDelegate> {
    BOOL isScrollUp;
    BOOL isScrollDown;
}

@end

@implementation GodViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    if (needTableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    
    if (needActivityIndicator) {
        _activityIndicator = [[MyActivityIndicator alloc] initWithFrame:self.view.bounds];
        _activityIndicator.center = self.view.center;
        [self.view addSubview:_activityIndicator];
        _activityIndicator.userInteractionEnabled = NO;
    }
    
    if (needTopMenu) {
        topMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.view addSubview:topMenuView];
    }
    
    if (needToolBarView) {
        toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, 320, 44) itemImages:toolBarItemImages];
        toolBarView.delegate = self;
        [self.view addSubview:toolBarView];
    }
    
    requestsArray = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BWStatusBarOverlay dismissAnimated];
    [_activityIndicator addDismissAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearRequestsDelegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (SinaWeibo*)sinaWeibo {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate = self;
    return delegate.sinaweibo;
}

- (BOOL)sinaWeiboAuthValid {
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaWeibo isAuthValid])
    {
        sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        return YES;
    }
    return NO;
}

- (TCWBEngine*)tencentWeibo {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.tencentWeibo;
}

- (BOOL)tencentWeiboAuthValid {
    return ![[self tencentWeibo] isAuthorizeExpired];
}

- (void)backButtonClicked {
}

- (void)toolBarItemClicked:(NSInteger)tag {
    
}

- (void)requestMoreData {

}

- (void)revertTableView {
    [UIView animateWithDuration:0.3 animations:^(void) {_tableView.contentInset = UIEdgeInsetsZero;}];
}

- (void)clearRequestsDelegate {
    if ([requestsArray count]) {
        for (SinaWeiboRequest *request in requestsArray) {
            request.delegate = nil;
        }
    }
    [requestsArray removeAllObjects];
}

#pragma mark -  ToolBarView Delegate

- (void)toolBarViewButtonClicked:(NSInteger)tag {
    switch (tag) {
        case 0:
            [self backButtonClicked];
            break;
        default:
            [self toolBarItemClicked:tag];
            break;
    }
}

- (void)authorizeSuccessed:(AppLoginStatus)status {
    
}

#pragma mark - UIScrollView Delgate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        [self requestMoreData];
    }
    static int _lastPosition = 0;
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 0 && !isScrollUp) {
        isScrollUp = YES;
        isScrollDown = NO;
        [UIView animateWithDuration:0.5 animations:^() {
            topMenuView.frame = CGRectMake(0, 0, 320, 44);
            toolBarView.frame = CGRectMake(0, self.view.bounds.size.height + 44, 320, 44);
        }];
    }
    else if (_lastPosition - currentPostion > 0 && !isScrollDown)
    {
        isScrollDown = YES;
        isScrollUp = NO;
        [UIView animateWithDuration:0.5 animations:^() {
            topMenuView.frame = CGRectMake(0, -44, 320, 44);
            toolBarView.frame = CGRectMake(0, self.view.bounds.size.height - 44, 320, 44);
        }];
    }
    _lastPosition = currentPostion;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaLoginButtonClicked {
    [_activityIndicator addBounceAnimation];
    [[self sinaWeibo] logIn];
}

- (void)sinaWeiboAuthData
{
    SinaWeibo *sinaweibo = [self sinaWeibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [_activityIndicator addDismissAnimation];
    
    [self sinaWeiboAuthData];
    
    [self authorizeSuccessed:SinaWeiboLogin];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [_activityIndicator addDismissAnimation];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    [_activityIndicator addDismissAnimation];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    [_activityIndicator addDismissAnimation];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [_activityIndicator addDismissAnimation];
}

#pragma mark - TencentWeibo delegate

//登录成功回调
- (void)onSuccessLogin
{
    [self authorizeSuccessed:TencentWeiboLogin];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [_activityIndicator addDismissAnimation];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error {
    [_activityIndicator addDismissAnimation];
}

@end
