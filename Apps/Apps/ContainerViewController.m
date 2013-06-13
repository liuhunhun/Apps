//
//  ContainerViewController.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "ContainerViewController.h"
#import "EGOImageButton.h"
#import "SinaWeiBoDataSource.h"
#import "TencentWeiboDataSource.h"
#import "SinaWeibo.h"
#import "TCWBEngine.h"
#import "SinaWeiboRequest.h"
#import "MyActivityIndicator.h"
#import "ImagePreviewController.h"
#import "WeiboInputViewController.h"
#import "SinaWeiboDetailController.h"
#import "WeiBoCell.h"
#import "ContentImageCache.h"
#import "STTweetLabel.h"
#import "BWStatusBarOverlay.h"
#import "SinaWeiboCache.h"

@interface ContainerViewController () <SinaWeiboRequestDelegate, WeiboInputViewDelegate, EGOImageButtonDelegate> {
    SinaWeiBoDataSource *sinaWeiboDataSource;
    TencentWeiboDataSource *tencentWeiboDataSource;
    
    WeiboInputViewController *inputController;
    
    ImagePreviewController *imagePreviewController;
    
    AppsClientStatus clientStatus;
    
    BOOL isAskForMore;
}

@end

@implementation ContainerViewController

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
    needGestureRecognizer = YES;
    needTableView = YES;
    needActivityIndicator = YES;
    needTopMenu = YES;
    needToolBarView = YES;
    toolBarItemImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"input_btn.png"], [UIImage imageNamed:@"refresh_btn.png"], nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        UIImage *image = [UIImage imageNamed:@"navigationbar_bg.png"];
        image = [image stretchableImageWithLeftCapWidth:8 topCapHeight:44];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    sinaWeiboDataSource = [[SinaWeiBoDataSource alloc] init];
    _tableView.dataSource = nil;
        
    if ([self sinaWeiboAuthValid]) {
        clientStatus = AppsClientIsSinaWeibo;
        if ([SinaWeiboCache cacheIsEmpty]) {
            [self requestSinaWeibo];
        }
        else {
            [sinaWeiboDataSource fillDataSources:[SinaWeiboCache allData]];
            _tableView.dataSource = sinaWeiboDataSource;
            [_tableView reloadData];
        }
    }
    else if(![self tencentWeiboAuthValid]) {
        clientStatus = AppsClientIsTencentWeibo;
        if ([sinaWeiboDataSource dataSourceIsEmpty]) {
            [self requestSinaWeibo];
        }
        else {
            _tableView.dataSource = sinaWeiboDataSource;
            [_tableView reloadData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)ChangeClientStatus:(AppsClientStatus)status {
    switch (status) {
        case AppsClientIsSinaWeibo:
            if ([self sinaWeiboAuthValid]) {
                if (status == clientStatus) return;
                if (![sinaWeiboDataSource dataSourceIsEmpty]) {
                    _tableView.dataSource = sinaWeiboDataSource;
                }
                else {
                    [self requestSinaWeibo];
                }
            }
            else {
                [[self sinaWeibo] logIn];
            }
            break;
        case AppsClientIsTencentWeibo:
            if ([self tencentWeiboAuthValid]) {
                if (status == clientStatus) return;
            }
            else {
                [[self tencentWeibo] logInWithDelegate:self onSuccess:@selector(onSuccessLogin)
                                             onFailure:@selector(onFailureLogin:)];
            }
            break;
        default:
            break;
    }
    clientStatus = status;
}

- (void)imageButtonClicked:(id)sender {
    EGOImageButton *button = (EGOImageButton*)sender;
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:button.bounds fromView:button];
    if (!imagePreviewController) {
        imagePreviewController = [[ImagePreviewController alloc] init];
        imagePreviewController.view.frame = self.view.window.bounds;
        [self.view.window addSubview:imagePreviewController.view];
    }
    imagePreviewController.view.hidden = NO;
    [imagePreviewController coverScreenWithFrame:rect imageURL:[button titleForState:UIControlStateNormal] defaultImage:button.imageView.image];
}

#pragma mark - SuperClass Method

- (void)backButtonClicked {
    [self moveToRightSide:YES];
}

- (void)toolBarItemClicked:(NSInteger)tag {
    switch (tag) {
        case 1:
            if (!inputController) {
                inputController = [[WeiboInputViewController alloc] initWithNibName:@"WeiboInputViewController" bundle:nil];
                inputController.delegate = self;
            }
            [self presentModalViewController:inputController animated:YES];
            break;
        case 2:
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self requestSinaWeibo];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_activityIndicator addDismissAnimation];
    if (clientStatus == AppsClientIsSinaWeibo) {
        SinaWeiboDetailController *sinaWeiboDetailController = [[SinaWeiboDetailController alloc] init];
        [self.navigationController pushViewController:sinaWeiboDetailController animated:YES];
        [sinaWeiboDetailController createByWeiboInfo:[sinaWeiboDataSource dataSourceAtIndex:indexPath.row]];
    }
    else if (clientStatus == AppsClientIsTencentWeibo) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_activityIndicator addBounceAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = [WeiBoCell cellHeight:[sinaWeiboDataSource dataSourceAtIndex:indexPath.row]];
    return cellHeight > 52 ? cellHeight : 52 ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiBoCell *wbCell = (WeiBoCell*)cell;
    wbCell.contentImageButton.delegate = self;
    [wbCell.contentImageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    wbCell.retweetContentImageButton.delegate = self;
    [wbCell.retweetContentImageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark WeiboInputView Delegate

- (void)sendNewWeibo:(NSString *)weiboContent {
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    [sinaWeibo requestWithURL:@"statuses/update.json" params:[NSMutableDictionary dictionaryWithObject:[weiboContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"status"] httpMethod:@"POST" delegate:self];
    [BWStatusBarOverlay showWithMessage:@"微博发送中..." loading:YES animated:YES];
}

#pragma mark - EGOImageButton Delegate

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton {
    [ContentImageCache saveContentImage:imageButton.imageView.image forKey:[imageButton.imageURL absoluteString]];
    [_tableView reloadData];
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error {
    
}

#pragma mark - SinaWeiboRequest Delegate

- (void)requestSinaWeibo {
    [_activityIndicator addBounceAnimation];
    
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    [sinaWeibo requestWithURL:@"statuses/friends_timeline.json" params:nil httpMethod:@"GET" delegate:self];
}

- (void)requestMoreData {
    if (!isAskForMore) {
        
        [_activityIndicator addBounceAnimation];
        
        isAskForMore = YES;
        
        SinaWeibo *sinaWeibo = [self sinaWeibo];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[sinaWeiboDataSource lastWeiboID] forKey:@"max_id"];
        [sinaWeibo requestWithURL:@"statuses/friends_timeline.json" params:params httpMethod:@"GET" delegate:self];
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [_activityIndicator addDismissAnimation];
    if ([request.url hasSuffix:@"statuses/friends_timeline.json"]) {
        [BWStatusBarOverlay showErrorWithMessage:@"请求失败" duration:2 animated:YES];
    }
    else if([request.url hasSuffix:@"statuses/update.json"]) {
       [BWStatusBarOverlay showErrorWithMessage:@"发送失败" duration:2 animated:YES];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/friends_timeline.json"]) {
        if ([[result objectForKey:@"statuses"] count]) {
            NSMutableArray *weiboArray = [NSMutableArray arrayWithArray:[result objectForKey:@"statuses"]];
            if (!isAskForMore) {
                [sinaWeiboDataSource cleanDataSource];
                [SinaWeiboCache clearCache];
            }
            else {
                [weiboArray removeLastObject];
            }
            [sinaWeiboDataSource fillDataSources:weiboArray];
            [SinaWeiboCache saveWeiboWithInfo:weiboArray];
            _tableView.dataSource = sinaWeiboDataSource;
            [_tableView reloadData];
        }
    }
    else if([request.url hasSuffix:@"statuses/update.json"]) {
        if ([result objectForKey:@"id"]) {
            [BWStatusBarOverlay showSuccessWithMessage:@"微博发送成功" duration:2 animated:YES];
            [self requestSinaWeibo];
        }
    }
    isAskForMore = NO;
    [self revertTableView];
    [_activityIndicator addDismissAnimation];
}

@end