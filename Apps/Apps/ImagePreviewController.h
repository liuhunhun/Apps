//
//  ImagePreviewController.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-3-22.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GodViewController.h"

@interface ImagePreviewController : GodViewController

- (void)coverScreenWithFrame:(CGRect)frame imageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage;

@end
