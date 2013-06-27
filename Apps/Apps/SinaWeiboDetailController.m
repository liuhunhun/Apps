//
//  SinaWeiboDetailController.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-23.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SinaWeiboDetailController.h"

#import "STTweetLabel.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "MyActivityIndicator.h"
#import "BWStatusBarOverlay.h"
#import "ToolBarView.h"
#import "WeiboCommentCell.h"

#import "SinaWeiboContentView.h"
#import "ImagePreviewController.h"
#import "WeiboInputViewController.h"

#import "SinaWeiboCommentDataSource.h"

#import "SinaWeibo.h"


@interface SinaWeiboDetailController () <SinaWeiboRequestDelegate, WeiboInputViewDelegate> {
    NSMutableDictionary *weiboDic;

    EGOImageView *coverImageView;
    EGOImageButton *avatarButton;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UIImageView *genderImageView;
    
    SinaWeiboContentView *sinaWeiboContentView;
    ImagePreviewController *imagePreviewController;
    WeiboInputViewController *inputController;
    
    SinaWeiboCommentDataSource *commentDataSource;
}

@end

@implementation SinaWeiboDetailController

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
    needToolBarView = YES;
    needTableView = YES;
    toolBarItemImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"collection_btn.png"], [UIImage imageNamed:@"comment_btn.png"], [UIImage imageNamed:@"retweet_btn.png"], [UIImage imageNamed:@"refresh_btn.png"], nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    coverImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"cover_image.png"]];
    coverImageView.frame = CGRectMake(0, 0, 320, 98);
    [self.view addSubview:coverImageView];
    
    avatarButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_avatar.png"]];
    avatarButton.frame = CGRectMake(10, 14, 70, 70);
    [self.view addSubview:avatarButton];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 200, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:nameLabel];
    
    genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(97, 24, 16, 16)];
    [self.view addSubview:genderImageView];
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 200, 30)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:locationLabel];
    
    _tableView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + coverImageView.frame.size.height, self.view.bounds.size.width
                                  , self.view.bounds.size.height - coverImageView.frame.size.height);
    
    commentDataSource = [[SinaWeiboCommentDataSource alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Super Method

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)toolBarItemClicked:(NSInteger)tag {
    switch (tag) {
        case 1:
            if ([[weiboDic valueForKey:@"favorited"] boolValue]) {
                [requestsArray addObject:[[self sinaWeibo] requestWithURL:@"favorites/destroy.json" params:[NSMutableDictionary dictionaryWithObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"] httpMethod:@"POST" delegate:self]];
            }
            else {
                [requestsArray addObject:[[self sinaWeibo] requestWithURL:@"favorites/create.json" params:[NSMutableDictionary dictionaryWithObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"] httpMethod:@"POST" delegate:self]];
            }
            break;
        case 2:
            if (!inputController) {
                inputController = [[WeiboInputViewController alloc] init];
                inputController.delegate = self;
            }
            [self presentModalViewController:inputController animated:YES];
            [inputController inputType:IsComment title:@"评论"];
            break;
        case 3:
            [requestsArray addObject:[[self sinaWeibo] requestWithURL:@"comments/create.json" params:nil httpMethod:@"GET" delegate:self]];
            break;
        default:
            break;
    }
}

- (void)requestMoreData {
    if (!isAskForMore) {
        
        [_activityIndicator addBounceAnimation];
        
        isAskForMore = YES;
        
        SinaWeibo *sinaWeibo = [self sinaWeibo];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"];
        if ([[commentDataSource lastCommentID] length]) {
            [params setObject:[commentDataSource lastCommentID] forKey:@"max_id"];
        }
        [sinaWeibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
    }
}

#pragma mark - Private Method

- (void)createByWeiboInfo:(NSDictionary*)info {
    weiboDic = [NSMutableDictionary dictionaryWithDictionary:info];

    [avatarButton setImageURL:[NSURL URLWithString:[[info objectForKey:@"user"] objectForKey:@"avatar_large"]]];
    
    nameLabel.text = [[info objectForKey:@"user"] objectForKey:@"name"];
    [nameLabel sizeToFit];
    
    if ([[[info objectForKey:@"user"] objectForKey:@"gender"] isEqualToString:@"m"]) {
        genderImageView.image = [UIImage imageNamed:@"male_icon.png"];
    }
    else {
        genderImageView.image = [UIImage imageNamed:@"female_icon.png"];
    }
    genderImageView.frame = CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 5, genderImageView.frame.origin.y, genderImageView.frame.size.width, genderImageView.frame.size.height);
    
    locationLabel.text = [[info objectForKey:@"user"] objectForKey:@"location"];
    
    sinaWeiboContentView = [[SinaWeiboContentView alloc] initWithWeiboInfo:info];
    [sinaWeiboContentView.weiboContentImageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sinaWeiboContentView.retweetContentImageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = sinaWeiboContentView;
        
    [requestsArray addObject:[[self sinaWeibo] requestWithURL:@"favorites/show.json" params:[NSMutableDictionary dictionaryWithObject:[[info objectForKey:@"id"] stringValue] forKey:@"id"] httpMethod:@"GET" delegate:self]];
    
    [self requestComments];
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

#pragma -
#pragma mark WeiboInputView Delegate

- (void)sendButtonClicked:(NSString *)content type:(InputType)type {
    NSMutableDictionary *params;
    switch (type) {
        case IsNewWeibo:
            break;
        case IsComment:
            params = [[NSMutableDictionary alloc] init];
            [params setObject:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"comment"];
            [params setObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"];
            [[self sinaWeibo] requestWithURL:@"comments/create.json" params:params httpMethod:@"POST" delegate:self];
            [BWStatusBarOverlay showWithMessage:@"评论发送中..." loading:YES animated:YES];
            break;
        default:
            break;
    }
}

#pragma -
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = [NSString stringWithFormat:@" 评 论 ( %d )", [commentDataSource dataSourceTotalNumber]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = [WeiboCommentCell cellHeight:[commentDataSource dataSourceAtIndex:indexPath.row]];
    return cellHeight > 50 ? cellHeight : 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - SinaWeiboRequest Delegate

- (void)requestComments {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"];
    [[self sinaWeibo] requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"favorites/create.json"]) {
        [BWStatusBarOverlay showErrorWithMessage:@"收藏失败" duration:2 animated:YES];
    }
    else if ([request.url hasSuffix:@"comments/create.json"]) {
        [BWStatusBarOverlay showSuccessWithMessage:@"评论失败" duration:2 animated:YES];
    }
    [_activityIndicator addDismissAnimation];
    [requestsArray removeObject:request];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"favorites/create.json"]) {
        [BWStatusBarOverlay showSuccessWithMessage:@"收藏成功" duration:2 animated:YES];
        [toolBarView changeButtonImageWithTag:1 image:[UIImage imageNamed:@"has_collection_btn.png"]];
        [weiboDic setValue:@"1" forKey:@"favorited"];
    }
    else if ([request.url hasSuffix:@"favorites/show.json"]) {
        if (![[result objectForKey:@"error"] length]) {
            [toolBarView changeButtonImageWithTag:1 image:[UIImage imageNamed:@"has_collection_btn.png"]];
            [weiboDic setValue:@"1" forKey:@"favorited"];
        }
    }
    else if ([request.url hasSuffix:@"favorites/destroy.json"]) {
        [BWStatusBarOverlay showSuccessWithMessage:@"取消收藏成功" duration:2 animated:YES];
        [toolBarView changeButtonImageWithTag:1 image:[UIImage imageNamed:@"collection_btn.png"]];
        [weiboDic setValue:@"0" forKey:@"favorited"];
    }
    else if ([request.url hasSuffix:@"comments/create.json"]) {
        [BWStatusBarOverlay showSuccessWithMessage:@"评论成功" duration:2 animated:YES];
    }
    else if ([request.url hasSuffix:@"comments/show.json"]) {
        NSMutableArray *weiboArray = [NSMutableArray arrayWithArray:[result objectForKey:@"comments"]];
        if (!isAskForMore) {
            [commentDataSource cleanDataSource];
        }
        [commentDataSource fillDataSources:weiboArray];
        _tableView.dataSource = commentDataSource;
        [_tableView reloadData];
        isAskForMore = NO;
    }
    [self revertTableView];
    [_activityIndicator addDismissAnimation];
    [requestsArray removeObject:request];
}

@end
