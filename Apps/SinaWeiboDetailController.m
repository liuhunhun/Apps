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
#import "SinaWeiboContentView.h"
#import "ImagePreviewController.h"
#import "SinaWeibo.h"
#import "MyActivityIndicator.h"
#import "BWStatusBarOverlay.h"
#import "ToolBarView.h"

@interface SinaWeiboDetailController () <SinaWeiboRequestDelegate> {
    NSDictionary *weiboDic;
    NSArray *commentArray;
    
    EGOImageView *coverImageView;
    EGOImageButton *avatarButton;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UIImageView *genderImageView;
    
    SinaWeiboContentView *sinaWeiboContentView;
    ImagePreviewController *imagePreviewController;
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
            [[self sinaWeibo] requestWithURL:@"favorites/create.json" params:[NSMutableDictionary dictionaryWithObject:[[weiboDic objectForKey:@"id"] stringValue] forKey:@"id"] httpMethod:@"POST" delegate:self];
            break;
        case 2:
            break;
        case 3:
            [[self sinaWeibo] requestWithURL:@"comments/create.json" params:nil httpMethod:@"GET" delegate:self];
            break;
        default:
            break;
    }
}

#pragma mark - Private Method

- (void)createByWeiboInfo:(NSDictionary*)info {
    weiboDic = [NSDictionary dictionaryWithDictionary:info];

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
        
    if ([[info valueForKey:@"favorited"] boolValue]) {
        [toolBarView changeButtonImageWithTag:1 image:[UIImage imageNamed:@"has_collection_btn.png"]];
    }
}

#pragma -
#pragma mark Private Method

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
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"     评 论 ( %d )", [commentArray count]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"WeiBoCell";
//    WeiBoCell *cell = (WeiBoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (nil == cell) {
//        cell = [[WeiBoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    }
//    [self configureCell:cell atIndexPath:indexPath];
    return nil;
}

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    WeiBoCell *wbCell = (WeiBoCell*)cell;
//    NSDictionary *dic = [weiboArray objectAtIndex:indexPath.row];
//    [wbCell.avatarButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"user"] objectForKey:@"profile_image_url"]]];` 
//    [wbCell.nam12eLabel setText:[[dic objectForKey:@"user"] objectForKey:@"name"]];//    [wbCell.contentLabel setText:[dic objectForKey:@"text"]];
//    [wbCell.timeLabel setText:[MyServer intervalSinceNow:[dic objectForKey:@"created_at"]]];
//    [wbCell.contentImageButton setImageURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail_pic"]]];
//    [wbCell.contentImageButton setTitle:[dic objectForKey:@"original_pic"] forState:UIControlStateNormal];
//    
//    [wbCell.retweetContentLabel setText:[[dic objectForKey:@"retweeted_status"] objectForKey:@"text"]];
//    [wbCell.retweetContentImageButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]]];
//    [wbCell.retweetContentImageButton setTitle:[[dic objectForKey:@"retweeted_status"] objectForKey:@"original_pic"] forState:UIControlStateNormal];
//    
//    wbCell.weiboID = [dic objectForKey:@"id"];
//}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"favorites/create.json"]) {
        [BWStatusBarOverlay showErrorWithMessage:@"收藏失败" duration:2 animated:YES];
    }
    [_activityIndicator addDismissAnimation];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"favorites/create.json"]) {
        [BWStatusBarOverlay showSuccessWithMessage:@"收藏成功" duration:2 animated:YES];
        [toolBarView changeButtonImageWithTag:1 image:[UIImage imageNamed:@"has_collection_btn.png"]];
    }    [self revertTableView];
    [_activityIndicator addDismissAnimation];
}

@end
