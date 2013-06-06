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

@interface SinaWeiboDetailController () {
    NSDictionary *weiboDic;
    
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    coverImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"cover_image.png"]];
    coverImageView.frame = CGRectMake(0, 0, 320, 98);
    [self.view addSubview:coverImageView];
    
    avatarButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"avatar_default.png"]];
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

- (void)createViewByData:(NSDictionary*)dic {
    weiboDic = [NSDictionary dictionaryWithDictionary:dic];
}

#pragma mark - Super Method

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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

@end
