//
//  SinaWeiboCommentDataSource.m
//  Apps
//
//  Created by waiting_alone on 13-6-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SinaWeiboCommentDataSource.h"
#import "WeiboCommentCell.h"
#import "EGOImageButton.h"
#import "MyServer.h"

@implementation SinaWeiboCommentDataSource

- (void)removeLastObject {
    [weiboArray removeLastObject];
}

- (NSString*)lastCommentID {
    if (![weiboArray count]) {
        return @"";
    }
    NSDictionary *dic = [weiboArray lastObject];
    return [[dic objectForKey:@"id"] stringValue];
}

#pragma -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weiboArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WeiboCommentCell";
    WeiboCommentCell *cell = (WeiboCommentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[WeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WeiboCommentCell *wbCell = (WeiboCommentCell*)cell;
    NSDictionary *dic = [weiboArray objectAtIndex:indexPath.row];
    [wbCell.avatarButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"user"] objectForKey:@"profile_image_url"]]];
    [wbCell.nameLabel setText:[[dic objectForKey:@"user"] objectForKey:@"name"]];
    [wbCell.contentLabel setText:[dic objectForKey:@"text"]];
    [wbCell.timeLabel setText:[MyServer intervalSinceNow:[dic objectForKey:@"created_at"]]];
    wbCell.commentDic = dic;
}

@end
