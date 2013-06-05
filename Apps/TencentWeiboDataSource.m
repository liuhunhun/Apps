//
//  TencentWeiboDataSource.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "TencentWeiboDataSource.h"

@implementation TencentWeiboDataSource

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
//    [wbCell.avatarButton setImageURL:[NSURL URLWithString:[[dic objectForKey:@"user"] objectForKey:@"profile_image_url"]]];
//    [wbCell.nameLabel setText:[[dic objectForKey:@"user"] objectForKey:@"name"]];
//    [wbCell.contentLabel setText:[dic objectForKey:@"text"]];
//    [wbCell.timeLabel setText:[MyServer intervalSinceNow:[dic objectForKey:@"created_at"]]];
//    [wbCell.contentImageButton setImageURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail_pic"]]];
//    [wbCell.contentImageButton setTitle:[dic objectForKey:@"original_pic"] forState:UIControlStateNormal];
//}

@end
