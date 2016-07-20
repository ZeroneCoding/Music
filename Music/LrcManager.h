//
//  LrcManager.h
//  day22-歌词解析
//
//  Created by Aaron on 15/8/12.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcManager : NSObject
/*
 用歌词文件名来初始化对象
 */
-(instancetype)initWithLrcFile:(NSString *)fileName;

/*
 提供时间,查询歌词
 00:00.00
 */
-(NSString *)lrcForTime:(NSString *)timeString;

/*
 开启自动浏览
 */
-(void)startShow;
@end










