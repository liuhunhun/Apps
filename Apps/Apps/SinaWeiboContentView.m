//
//  SinaWeiboContentView.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-6-2.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SinaWeiboContentView.h"
#import "EGOImageButton.h"
#import "MyServer.h"

@interface SinaWeiboContentView () <EGOImageButtonDelegate> {
    NSDictionary *weiboInfo;
    
    UILabel *weiboContentLabel;
    UILabel *timeLabel;
    
    UIImageView *retweetBgImageView;
    UILabel *retweetContentLabel;
}
@end

@implementation SinaWeiboContentView

@synthesize weiboContentImageButton;
@synthesize retweetContentImageButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        weiboContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 0)];
        [weiboContentLabel setFont:[UIFont systemFontOfSize:17.0]];
        [weiboContentLabel setTextColor:[UIColor blackColor]];
        [weiboContentLabel setNumberOfLines:0];
        [self addSubview:weiboContentLabel];
        
        UIImage *image = [UIImage imageNamed:@"retweet_bg.png"];
        image = [image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
        retweetBgImageView = [[UIImageView alloc] initWithImage:image];
        retweetBgImageView.frame = CGRectMake(20, 0, 280, 0);
        [self addSubview:retweetBgImageView];
        retweetBgImageView.userInteractionEnabled = YES;
        
        retweetContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 0)];
        retweetContentLabel.numberOfLines = 0;
        retweetContentLabel.backgroundColor = [UIColor clearColor];
        retweetContentLabel.textAlignment = UILineBreakModeWordWrap;
        [retweetContentLabel setFont:[UIFont systemFontOfSize:15]];
        [retweetBgImageView addSubview:retweetContentLabel];
        
        retweetContentImageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_image.png"]];
        retweetContentImageButton.frame = CGRectMake(10, 10, 0, 0);
        [retweetBgImageView addSubview:retweetContentImageButton];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:timeLabel];
        
        weiboContentImageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_image.png"] delegate:self];
        [self addSubview:weiboContentImageButton];
    }
    return self;
}

- (id)initWithWeiboInfo:(NSDictionary*)info {
    self = [self initWithFrame:CGRectMake(0, 0, 320, 0)];
    if (self) {
        weiboInfo = [NSDictionary dictionaryWithDictionary:info];
        [weiboContentLabel setText:[info objectForKey:@"text"]];
        
        CGRect rect = weiboContentLabel.frame;
        CGSize size = [[weiboInfo objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        weiboContentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, size.height);
        
        [weiboContentImageButton setImageURL:[NSURL URLWithString:[info objectForKey:@"thumbnail_pic"]]];
        [weiboContentImageButton setTitle:[info objectForKey:@"original_pic"] forState:UIControlStateNormal];
        
        if (weiboContentImageButton.imageURL) {
            if (weiboContentImageButton.imageView.image) {
                CGSize size = [MyServer getImageRightSize:weiboContentImageButton.imageView.image.size];
                weiboContentImageButton.frame = CGRectMake(15, weiboContentLabel.frame.origin.y + weiboContentLabel.frame.size.height + 6, size.width, size.height);
            }
            else {
                weiboContentImageButton.frame = CGRectMake(15, weiboContentLabel.frame.origin.y + weiboContentLabel.frame.size.height + 6, 90, 68);
            }
        }
        else {
            weiboContentImageButton.frame = CGRectMake(weiboContentLabel.frame.origin.x, weiboContentLabel.frame.origin.y + weiboContentLabel.frame.size.height, weiboContentImageButton.frame.size.width, 0);
        }

        rect = weiboContentImageButton.frame;
        if ([[[info objectForKey:@"retweeted_status"] objectForKey:@"text"] length]) {
            [retweetContentLabel setText:[[info objectForKey:@"retweeted_status"] objectForKey:@"text"]];
            size = [retweetContentLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 10000) lineBreakMode:UILineBreakModeWordWrap];
            retweetContentLabel.frame = CGRectMake(retweetContentLabel.frame.origin.x, retweetContentLabel.frame.origin.y, size.width, size.height);
            
            [retweetContentImageButton setImageURL:[NSURL URLWithString:[[info objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]]];
            [retweetContentImageButton setTitle:[[info objectForKey:@"retweeted_status"] objectForKey:@"original_pic"] forState:UIControlStateNormal];
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
            retweetBgImageView.frame = CGRectMake(retweetBgImageView.frame.origin.x, rect.origin.y + rect.size.height + 5, retweetBgImageView.frame.size.width, retweetContentLabel.frame.size.height);
            retweetContentImageButton.frame = CGRectMake(retweetContentImageButton.frame.origin.x, retweetContentImageButton.frame.origin.y, 0, 0);
        }
    
        [timeLabel setText:[MyServer intervalSinceNow:[info objectForKey:@"created_at"]]];
        timeLabel.frame = CGRectMake(timeLabel.frame.origin.x, retweetBgImageView.frame.origin.y + retweetBgImageView.frame.size.height + 6, timeLabel.frame.size.width, timeLabel.frame.size.height);
        
        self.frame = CGRectMake(0, 0, self.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height + 20);
    }
    return self;
}

@end
