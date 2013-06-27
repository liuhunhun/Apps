//
//  GodDataSource.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GodDataSource : NSObject <UITableViewDataSource> {
    NSMutableArray *weiboArray;
}

- (NSInteger)dataSourceTotalNumber;

- (NSMutableArray*)fillDataSources:(NSMutableArray*)array;

- (void)cleanDataSource;

- (BOOL)dataSourceIsEmpty;

- (NSDictionary*)dataSourceAtIndex:(NSInteger)index;

@end
