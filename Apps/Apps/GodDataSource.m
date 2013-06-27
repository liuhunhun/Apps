//
//  GodDataSource.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodDataSource.h"

@implementation GodDataSource

- (NSInteger)dataSourceTotalNumber {
    return [weiboArray count];
}

- (NSMutableArray*)fillDataSources:(NSMutableArray*)array {
    if (!weiboArray) {
        weiboArray = [[NSMutableArray alloc] init];
    }
    else if ([array count]) {
        [array removeObjectAtIndex:0];
    }
    [weiboArray addObjectsFromArray:array];

    return array;
}

- (void)cleanDataSource {
    [weiboArray removeAllObjects];
}

- (BOOL)dataSourceIsEmpty {
    return [weiboArray count] ? NO : YES;
}

- (NSDictionary*)dataSourceAtIndex:(NSInteger)index {
    return [weiboArray objectAtIndex:index];
}

@end
