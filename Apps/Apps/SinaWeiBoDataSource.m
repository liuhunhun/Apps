//
//  SinaWeiBoDataSource.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SinaWeiBoDataSource.h"
#import "WeiBoCell.h"
#import "EGOImageButton.h"
#import "STTweetLabel.h"
#import "MyServer.h"

@implementation SinaWeiBoDataSource

- (void)removeLastObject {
    [weiboArray removeLastObject];
}

- (NSString*)lastWeiboID {
    if (![weiboArray count]) {
        return @"";
    }
    NSDictionary *dic = [weiboArray lastObject];
    return [[dic objectForKey:@"id"] stringValue];
}

#pragma -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([weiboArray count]) {
        tableView.hidden = NO;
        return 1;
    }
    tableView.hidden = YES;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weiboArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WeiBoCell";
    WeiBoCell *cell = (WeiBoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[WeiBoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WeiBoCell *wbCell = (WeiBoCell*)cell;
    NSDictionary *dic = [weiboArray objectAtIndex:indexPath.row];
    [wbCell.avatarButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"user"] objectForKey:@"profile_image_url"]]];
    [wbCell.nameLabel setText:[[dic objectForKey:@"user"] objectForKey:@"name"]];
    [wbCell.contentLabel setText:[dic objectForKey:@"text"]];
    [wbCell.timeLabel setText:[MyServer intervalSinceNow:[dic objectForKey:@"created_at"]]];
    [wbCell.contentImageButton setImageURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail_pic"]]];
    [wbCell.contentImageButton setTitle:[dic objectForKey:@"original_pic"] forState:UIControlStateNormal];
    
    [wbCell.retweetContentLabel setText:[[dic objectForKey:@"retweeted_status"] objectForKey:@"text"]];
    [wbCell.retweetContentImageButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]]];
    [wbCell.retweetContentImageButton setTitle:[[dic objectForKey:@"retweeted_status"] objectForKey:@"original_pic"] forState:UIControlStateNormal];
    
    wbCell.weiboID = [dic objectForKey:@"id"];
}

@end
