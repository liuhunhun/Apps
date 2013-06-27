//
//  SinaWeiboCache.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-3-1.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SinaWeiboCache.h"

@implementation SinaWeiboCache

@synthesize weiboid;
@synthesize weiboinfo;

+ (void)clearCache {
    NSArray *cacheArray = [SinaWeiboCache allObjects];
    for (SinaWeiboCache *cache in cacheArray) {
        [cache deleteObject];
    }
}

+ (BOOL)cacheIsEmpty {
    return [[SinaWeiboCache allObjects] count] ? NO : YES;
}

+ (BOOL)saveWeiboWithInfo:(NSArray*)weiboArray {
    if (![weiboArray count]) {
        return NO;
    }
    for (NSDictionary *dic in weiboArray) {
        SinaWeiboCache *weiboCache = [[SinaWeiboCache alloc] init];
        weiboCache.weiboid = [[dic objectForKey:@"id"] stringValue];
        weiboCache.weiboinfo = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [weiboCache save];
    }
    return YES;
}

+ (NSDictionary*)getWeiboByID:(NSString*)weiboID {
    SinaWeiboCache *weiboCache = (SinaWeiboCache*)[SinaWeiboCache findFirstByCriteria:@"WHERE weiboid = '%@'", weiboID];
    if (weiboCache) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:weiboCache.weiboinfo];
    }
    return nil;
}

+ (NSMutableArray*)allData {
    NSArray *cacheArray = [SinaWeiboCache allObjects];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([cacheArray count]) {
        for (SinaWeiboCache *cache in cacheArray) {
            [array addObject:[NSKeyedUnarchiver unarchiveObjectWithData:cache.weiboinfo]];
        }
        return array;
    }
    return nil;
}

+ (void)updateWeiboInfoByID:(NSString*)weiboID info:(NSDictionary*)weiboInfo {
    SinaWeiboCache *weiboCache = (SinaWeiboCache*)[SinaWeiboCache findFirstByCriteria:@"WHERE weiboid = '%@'", weiboID];
    if (weiboCache) {
        weiboCache.weiboinfo = [NSKeyedArchiver archivedDataWithRootObject:weiboInfo];
        [weiboCache save];
    }
}

@end
