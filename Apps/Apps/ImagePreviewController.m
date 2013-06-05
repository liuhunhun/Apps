//
//  ImagePreviewController.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-3-22.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "ImagePreviewController.h"
#import "EGOImageView.h"
#import "ContentImageCache.h"
#import "MyActivityIndicator.h"
#import "MyServer.h"

@interface ImagePreviewController () <EGOImageViewDelegate, UIScrollViewDelegate> {    
    UIScrollView *_scrollView;
    EGOImageView *_imageView;
    
    CGRect srcRect;
}

@end

@implementation ImagePreviewController

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
	// Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.maximumZoomScale = 5.0;
    _scrollView.delegate = self;
    
    needActivityIndicator = YES;
    [self.view addSubview:_scrollView];
    
    _imageView = [[EGOImageView alloc] init];
    _imageView.delegate = self;
    [_scrollView addSubview:_imageView];
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)coverScreenWithFrame:(CGRect)frame imageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage {
    
    srcRect = frame;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UIImage *image = [ContentImageCache getContentImageForKey:imageURL];
    
    if (image) {
        _imageView.image = image;
    }
    else {
        _imageView.imageURL = [NSURL URLWithString:imageURL];
        _imageView.image = defaultImage;
        [_activityIndicator addBounceAnimation];
    }
    _imageView.frame = frame;
    [self imageViewZoomIn];
}

- (void)imageViewZoomIn {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView animateWithDuration:0.5 animations:^ {
        CGSize size = [MyServer calculateImageSize:_imageView.image.size deviceFrame:self.view.bounds];
        _imageView.frame = CGRectMake((self.view.frame.size.width - size.width) / 2, (self.view.frame.size.height - size.height) / 2, size.width, size.height);
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self imageViewZommOut];
}

- (void)imageViewZommOut {
    _scrollView.zoomScale = 1.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.3 animations:^ {
        _imageView.frame = srcRect;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [_imageView cancelImageLoad];
        self.view.hidden = YES;
    }];
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    [_activityIndicator addDismissAnimation];
    
    [ContentImageCache saveContentImage:imageView.image forKey:[imageView.imageURL absoluteString]];
    
    [self imageViewZoomIn];
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error {
    [_activityIndicator addDismissAnimation];
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView; // 返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    _imageView.center = CGPointMake(xcenter, ycenter);
}

@end
