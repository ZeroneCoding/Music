//
//  LrcManager.m
//  day22-歌词解析
//
//  Created by Aaron on 15/8/12.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import "LrcManager.h"
#import "LrcModal.h"
@interface LrcManager ()
@property (nonatomic,retain) NSMutableArray *timeArray;
@end

@implementation LrcManager
-(instancetype)initWithLrcFile:(NSString *)fileName
{
    if(self = [super init])
    {
        //先创建容器
        _timeArray = [[NSMutableArray alloc] init];
        //解析歌词
        [self pareseLrcByFileName:fileName];
    }
    return self;
}

#pragma mark -- 解析歌词
-(void)pareseLrcByFileName:(NSString *)file
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"lrc"];
    //NSString *path = [MUSIC_PATH stringByAppendingPathComponent:file];
    //读取歌词内容
    NSString *lrcContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //将歌词切成一行行,并且删掉没有时间的行
    NSArray *allLines = [self removeNoTimeLineFromAllLines:[lrcContent componentsSeparatedByString:@"\n"]];
    //处理每一行
    [self pareseAllLines:allLines];
    //时间排序
    [self sortByTime];
}

#pragma mark 排除掉没有时间的行
-(NSArray *)removeNoTimeLineFromAllLines:(NSArray *)allLines
{
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *oneLine in allLines)
    {
        //检测每一行是否以时间开头
        if(oneLine.length >= 2)
        {
            unichar c = [oneLine characterAtIndex:1];
            if(c >= '0' && c <= '9')
            {
                //如果是数字,就添加到新的数组
                [array addObject:oneLine];
            }
        }
    }
    return array;
}

#pragma mark 处理所有行
-(void)pareseAllLines:(NSArray *)allLines
{
    for(NSString *oneLine in allLines)
    {
        NSArray *contents = [oneLine componentsSeparatedByString:@"]"];
        /*
         [02:11.27
         [01:50.22
         [00:21.95
         穿过幽暗地岁月
         */
        //取到歌词
        NSString *lrc = [contents lastObject];
        //将一行里面所有的时间都与歌词关联
        for(int i = 0; i < contents.count-1; i++)
        {
            //排除切割出来的空字符串
            if(![contents[i] isEqualToString:@""])
            {
                //以时间做key,歌词做value
                //计算出毫秒
                NSNumber *mSecond = [self numberForTime:[contents[i] substringFromIndex:1]];
                //创建歌词对象
                LrcModal *modal = [[LrcModal alloc] init];
                //将数据保存到歌词对象里
                modal.lrc = lrc;
                modal.mSecond = mSecond;
                //保存时间
                [_timeArray addObject:modal];
            }
        }
    }
}

#pragma  mark 将时间格式转换成毫秒
//时间格式为 00:21.95
-(NSNumber *)numberForTime:(NSString *)timeString
{
    NSInteger minute = [[timeString substringToIndex:2] integerValue];
    NSInteger second = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger mSecond = [[timeString substringFromIndex:6] integerValue];
    return [NSNumber numberWithInteger:(minute*60+second)*100+mSecond];
}

#pragma mark -- 时间排序
-(void)sortByTime
{
    _timeArray = (NSMutableArray *)[_timeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(LrcModal *)obj1 compareToOther:obj2];
    }];
}

#pragma mark -- 查询歌词
-(NSString *)lrcForTime:(NSString *)timeString
{
    NSNumber *time = [self numberForTime:timeString];
    for(int i = 0; i < _timeArray.count; i++)
    {
        //如果输入的时间比当前元素要小
        LrcModal *modal = _timeArray[i];
        if([time compare:modal.mSecond] == NSOrderedAscending)
        {
            if(i == 0)
            {
                return nil;
            }
            else
            {
                return [_timeArray[i-1] lrc];
            }
        }
        if(i == _timeArray.count-1)
        {
            return [[_timeArray lastObject] lrc];
        }

    }
    return nil;
}



-(void)startShow
{
    for(LrcModal *obj in _timeArray)
    {
        NSLog(@"%@ : %@",obj.mSecond,obj.lrc);
    }
}
@end












