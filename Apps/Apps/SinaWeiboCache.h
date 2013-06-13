//
//  SinaWeiboCache.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-3-1.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"
#import "GodCacheObject.h"

@interface SinaWeiboCache : GodCacheObject

//created_at; 微博创建时间
//weiboID; 微博ID
//weiboMID; 微博MID
//text; 微博信息内容
//source; 微博来源
//favorited; 是否已收藏，true：是，false：否
//thumbnail_pic; 缩略图片地址，没有时不返回此字段
//bmiddle_pic; 中等尺寸图片地址，没有时不返回此字段
//original_pic; 原始图片地址，没有时不返回此字段
//geo; 地理信息字段
//user; 微博作者的用户信息字段
//retweeted_status; 被转发的原微博信息字段，当该微博为转发微博时返回
//reposts_count; 转发数
//comments_count; 评论数;
//attitudes_count; 表态数;
//visible; 微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指                                      定分组微博，4：密友微博；list_id为分组的组号

@property (nonatomic, readwrite, copy) NSString *weiboid;
@property (nonatomic, readwrite, retain) NSData *weiboinfo;

+ (BOOL)cacheIsEmpty;

+ (BOOL)saveWeiboWithInfo:(NSArray*)weiboArray;

+ (NSDictionary*)getWeiboByID:(NSString*)weiboID;

+ (NSMutableArray*)allData;

+ (void)updateWeiboInfoByID:(NSString*)weiboID info:(NSDictionary*)weiboInfo;

@end
