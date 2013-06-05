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
}
@end

@implementation SinaWeiboContentView

@synthesize weiboContentImageButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        weiboContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 290, 0)];
        [weiboContentLabel setFont:[UIFont systemFontOfSize:17.0]];
        [weiboContentLabel setTextColor:[UIColor blackColor]];
        [weiboContentLabel setNumberOfLines:0];
        [self addSubview:weiboContentLabel];
        
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
        
        [weiboContentImageButton setImageURL:[NSURL URLWithString:[info objectForKey:@"thumbnail_pic"]]];
        [weiboContentImageButton setTitle:[info objectForKey:@"original_pic"] forState:UIControlStateNormal];
        
        CGRect rect = weiboContentLabel.frame;
        CGSize size = [[weiboInfo objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        weiboContentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, size.height);
        
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
        self.frame = CGRectMake(0, 0, self.frame.size.width, weiboContentImageButton.frame.origin.y + weiboContentImageButton.frame.size.height + 20);
    }
    return self;
}

@end
