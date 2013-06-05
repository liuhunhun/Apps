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
    
//    if (leftButtonImage || leftButtonImagesArray) {
//        if (leftButtonImage) {
//            UIButton *leftButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, leftButtonImage.size.width, leftButtonImage.size.height)];
//            leftButtonItem.showsTouchWhenHighlighted = YES;
//            [leftButtonItem setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
//            [leftButtonItem.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//            [leftButtonItem addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonItem];
//            self.navigationItem.leftBarButtonItem = leftItem;
//        }
//        else if(leftButtonImagesArray) {
//            NSMutableArray *itemArray = [NSMutableArray array];
//            for (UIImage *image in leftButtonImagesArray) {
//                UIButton *leftButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//                leftButtonItem.showsTouchWhenHighlighted = YES;
//                [leftButtonItem setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
//                [leftButtonItem.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//                [leftButtonItem addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//                UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonItem];
//                [itemArray addObject:leftItem];
//            }
//            self.navigationItem.leftBarButtonItems = itemArray;
//        }
//    }
//    if (rightButtonImage || rightButtonImagesArray) {
//        if (rightButtonImage) {
//            UIButton *rightButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightButtonImage.size.width, rightButtonImage.size.height)];
//            rightButtonItem.showsTouchWhenHighlighted = YES;
//            [rightButtonItem setBackgroundImage:rightButtonImage forState:UIControlStateNormal];
//            [rightButtonItem.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//            [rightButtonItem addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonItem];
//            self.navigationItem.rightBarButtonItem = rightItem;
//        }
//        else if(rightButtonImagesArray) {
//            NSMutableArray *itemArray = [NSMutableArray array];
//            NSInteger tag = 0;
//            for (UIImage *image in rightButtonImagesArray) {
//                UIButton *rightButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//                rightButtonItem.tag = tag;
//                rightButtonItem.showsTouchWhenHighlighted = YES;
//                [rightButtonItem setBackgroundImage:image forState:UIControlStateNormal];
//                [rightButtonItem.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//                [rightButtonItem addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonItem];
//                [itemArray addObject:rightItem];
//                tag++;
//            }
//            self.navigationItem.rightBarButtonItems = itemArray;
//        }
//    }
    
    if (needTableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
