//
//  WeiBoCell.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "WeiBoCell.h"
#import "EGOImageButton.h"
#import "MyServer.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentImageCache.h"

@implementation WeiBoCell 

@synthesize avatarButton;
@synthesize contentImageButton;
@synthesize contentLabel;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize retweetContentLabel;
@synthesize retweetContentImageButton;
@synthesize weiboID;

+ (CGFloat)cellHeight:(NSDictionary*)weiboInfo {
    CGFloat cellHeight = 60;
    
    CGSize size = [[[weiboInfo objectForKey:@"user"] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 30) lineBreakMode:UILineBreakModeWordWrap];
    cellHeight += size.height;
    
    size = [[weiboInfo objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeWordWrap];
    cellHeight += size.height;

    CGSize imageSize = CGSizeMake(0, 0);
    if ([[weiboInfo objectForKey:@"thumbnail_pic"] length]) {
        UIImage *image = [ContentImageCache getContentImageForKey:[weiboInfo objectForKey:@"thumbnail_pic"]];
        if (image) {
            imageSize = [MyServer getImageRightSize:image.size];
        }
        else {
            imageSize.height = 68;
        }
    }
    cellHeight += imageSize.height;
    
    imageSize = CGSizeMake(0, 0);
    if ([weiboInfo objectForKey:@"retweeted_status"]) {
        size = [[[weiboInfo objectForKey:@"retweeted_status"] objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(220, 1000) lineBreakMode:UILineBreakModeWordWrap];
        cellHeight += size.height;
       
        if ([[[weiboInfo objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"] length]) {
            UIImage *image = [ContentImageCache getContentImageForKey:[[weiboInfo objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]];
            if (image) {
                imageSize = [MyServer getImageRightSize:image.size];
            }
            else {
                imageSize.height = 68;
            }
        }
        cellHeight += imageSize.height + 30;
    }
    return cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        avatarButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_avatar.png"]];
        avatarButton.frame = CGRectMake(10, 10, 40, 40);
        avatarButton.layer.cornerRadius = 5.0;
        avatarButton.layer.masksToBounds = YES;
        [self addSubview:avatarButton];
        
        contentImageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_image.png"]];
        contentImageButton.frame = CGRectMake(10, 10, 0, 0);
        [self addSubview:contentImageButton];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 250, 10000)];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = UILineBreakModeWordWrap;
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:contentLabel];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 30)];
        nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameLabel];
        
        UIImage *image = [UIImage imageNamed:@"retweet_bg.png"];
        image = [image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
        retweetBgImageView = [[UIImageView alloc] initWithImage:image];
        retweetBgImageView.frame = CGRectMake(60, 0, 240, 0);
        [self addSubview:retweetBgImageView];
        retweetBgImageView.userInteractionEnabled = YES;
        
        retweetContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 220, 0)];
        retweetContentLabel.numberOfLines = 0;
        retweetContentLabel.backgroundColor = [UIColor clearColor];
        retweetContentLabel.textAlignment = UILineBreakModeWordWrap;
        [retweetContentLabel setFont:[UIFont systemFontOfSize:15]];
        [retweetBgImageView addSubview:retweetContentLabel];
        
        retweetContentImageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_image.png"]];
        retweetContentImageButton.frame = CGRectMake(10, 10, 0, 0);
        [retweetBgImageView addSubview:retweetContentImageButton];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 250, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    nameLabel.text = @"";
    timeLabel.text = @"";
    contentLabel.text = @"";
    retweetContentLabel.text = @"";
    [retweetContentImageButton setImageURL:nil];
    [retweetContentImageButton cancelImageLoad];
    [retweetContentImageButton setImage:[UIImage imageNamed:@"default_image.png"] forState:UIControlStateNormal];
    [avatarButton setImageURL:nil];
    [avatarButton cancelImageLoad];
    [avatarButton setImage:[UIImage imageNamed:@"default_avatar.png"] forState:UIControlStateNormal];
    [contentImageButton setImageURL:nil];
    [contentImageButton cancelImageLoad];
    [contentImageButton setImage:[UIImage imageNamed:@"default_image.png"] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = contentLabel.frame;
    CGSize size = [contentLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(250, 10000) lineBreakMode:UILineBreakModeWordWrap];
    contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
    
    if (contentImageButton.imageURL) {
        if (contentImageButton.imageView.image) {
            CGSize size = [MyServer getImageRightSize:contentImageButton.imageView.image.size];
            contentImageButton.frame = CGRectMake(60, contentLabel.frame.origin.y + contentLabel.frame.size.height + 6, size.width, size.height);
        }
        else {
            contentImageButton.frame = CGRectMake(60, contentLabel.frame.origin.y + contentLabel.frame.size.height + 6, 90, 68);
        }
    }
    else {
        contentImageButton.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height, contentImageButton.frame.size.width, 0);
    }
    
    rect = contentImageButton.frame;
    if ([retweetContentLabel.text length]) {
        size = [retweetContentLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:UILineBreakModeWordWrap];
        retweetContentLabel.frame = CGRectMake(retweetContentLabel.frame.origin.x, retweetContentLabel.frame.origin.y, size.width, size.height);
        
        if (retweetContentImageButton.imageURL) {
            if (retweetContentImageButton.imageView.image) {
                CGSize size = [MyServer getImageRightSize:retweetContentImageButton.imageView.image.size];
                retweetContentImageButton.frame = CGRectMake(retweetContentLabel.frame.origin.x, retweetContentLabel.frame.origin.y + retweetContentLabel.frame.size.height + 6, size.width, size.height);
            }
            else {
                retweetContentImageButton.frame = CGRectMake(retweetContentLabel.frame.origin.x, retweetContentLabel.frame.origin.y + retweetContentLabel.frame.size.height + 6, 90, 68);
            }
            retweetBgImageView.frame = CGRectMake(retweetBgImageView.frame.origin.x, rect.origin.y + rect.size.height + 5, retweetBgImageView.frame.size.width, retweetContentLabel.frame.size.height + retweetContentImageButton.frame.size.height + 31);
        }
        else {
            retweetBgImageView.frame = CGRectMake(retweetBgImageView.frame.origin.x, rect.origin.y + rect.size.height + 5, retweetBgImageView.frame.size.width, retweetContentLabel.frame.size.height + 31);
            retweetContentImageButton.frame = CGRectMake(retweetContentImageButton.frame.origin.x, retweetContentImageButton.frame.origin.y, 0, 0);
        }
    }
    else {
        retweetBgImageView.frame = CGRectMake(contentImageButton.frame.origin.x, contentImageButton.frame.origin.y + contentImageButton.frame.size.height, retweetBgImageView.frame.size.width, 0);
        retweetContentImageButton.frame = CGRectMake(retweetContentImageButton.frame.origin.x, retweetContentImageButton.frame.origin.y, 0, 0);
    }
    
    timeLabel.frame = CGRectMake(60, retweetBgImageView.frame.origin.y + retweetBgImageView.frame.size.height + 6, timeLabel.frame.size.width, timeLabel.frame.size.height);
}

@end
