//
//  LoginViewController.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-27.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "LoginViewController.h"
#import "MyActivityIndicator.h"
#import "SinaWeibo.h"
#import "TCWBEngine.h"

@interface LoginViewController () <SinaWeiboDelegate> {
    UIButton *sinaButton;
    UIButton *tencentButton;
}

@end

@implementation LoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIImage *sinaLoginButtonImage = [UIImage imageNamed:@"sina_login_btn.png"];
        sinaButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - sinaLoginButtonImage.size.width) / 2, self.view.bounds.size.height - sinaLoginButtonImage.size.height - 150, sinaLoginButtonImage.size.width, sinaLoginButtonImage.size.height)];
        [sinaButton setImage:sinaLoginButtonImage forState:UIControlStateNormal];
        [self.view addSubview:sinaButton];
        [sinaButton addTarget:self action:@selector(sinaLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *tencentLoginButtonImage = [UIImage imageNamed:@"tencent_login_btn.png"];
        tencentButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - tencentLoginButtonImage.size.width) / 2, self.view.bounds.size.height - tencentLoginButtonImage.size.height - 50, tencentLoginButtonImage.size.width, tencentLoginButtonImage.size.height)];
        [tencentButton setImage:tencentLoginButtonImage forState:UIControlStateNormal];
        [self.view addSubview:tencentButton];
        [tencentButton addTarget:self action:@selector(tencentLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)viewDidLoad
{
    needActivityIndicator = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeibo Delegate

- (void)sinaLoginButtonClicked {
    [_activityIndicator addBounceAnimation];
    [[self sinaWeibo] logIn];
}

#pragma mark - TencentWeibo delegate

- (void)tencentLoginButtonClicked {
    [_activityIndicator addBounceAnimation];
    [[self tencentWeibo] logInWithDelegate:self
                                 onSuccess:@selector(onSuccessLogin)
                                 onFailure:@selector(onFailureLogin:)];
}

- (void)authorizeSuccessed:(AppLoginStatus)status {
    if ([delegate respondsToSelector:@selector(loginDidSuccessed:)]) {
        [delegate loginDidSuccessed:status];
    }
    [self dismissModalViewControllerAnimated:YES];
    [_activityIndicator addDismissAnimation];
}

//登录成功回调
- (void)onSuccessLogin
{
    if ([delegate respondsToSelector:@selector(loginDidSuccessed:)]) {
        [delegate loginDidSuccessed:SinaWeiboLogin];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    [_activityIndicator addDismissAnimation];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error {
    [_activityIndicator addDismissAnimation];
}

@end
