//
//  WeiboInputViewController.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-20.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "WeiboInputViewController.h"

@interface WeiboInputViewController () <UITextViewDelegate> {
    UITextView *inputTextView;
    UILabel *wordNumberLabel;
    
    InputType inputType;
}

- (IBAction)cancelButtonClicked:(id)sender;

@end

@implementation WeiboInputViewController

@synthesize delegate;
@synthesize titleLabel;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 120)];
    inputTextView.font = [UIFont systemFontOfSize:17];
    inputTextView.delegate = self;
    [self.view addSubview:inputTextView];
    
    wordNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 190, 100, 30)];
    wordNumberLabel.backgroundColor = [UIColor clearColor];
    wordNumberLabel.font = [UIFont systemFontOfSize:16];
    wordNumberLabel.textAlignment = UITextAlignmentRight;
    wordNumberLabel.text = @"140";
    [self.view addSubview:wordNumberLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [inputTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inputType:(InputType)type title:(NSString*)title {
    inputType = type;
    self.titleLabel.text = title;
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)rightButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    if ([delegate respondsToSelector:@selector(sendButtonClicked:type:)] && [inputTextView.text length]) {
        NSString *content = [inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [delegate sendButtonClicked:content type:inputType];
    }
}



- (void)textViewDidChange:(UITextView *)textView {
    wordNumberLabel.text = [NSString stringWithFormat:@"%d", 140 - textView.text.length];
}

@end
