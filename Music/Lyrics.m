//
//  Lyrics.m
//  Music
//
//  Created by 李银 on 15/12/11.
//  Copyright © 2015年 liyin. All rights reserved.
//

#import "Lyrics.h"

@implementation Lyrics
- (instancetype)initLyricsWithName:(NSString *)name andType:(NSString *)mType{
    if (self = [super init]) {
        self.name = name;
        self.mType = mType;
    }
    return self;
}

- (void)loadLyricsDataWithName:(NSString *)name andType:(NSString *)mType{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:mType];
    NSString *contentStrings = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *linesArray = [contentStrings componentsSeparatedByString:@"\n"];
    NSMutableArray *timeLinesArray = [NSMutableArray array];
    for (NSString *obj in linesArray) {
        if ([obj characterAtIndex:1] >= 0 && [obj characterAtIndex:1] <= 9) {
            [timeLinesArray addObject:obj];
        }
    }

    //[01:21.56][00:04.12]词：张思尔 曲：林俊杰
    for (NSString *obj in timeLinesArray) {
        NSArray *array = [obj componentsSeparatedByString:@"]"];
        NSString *lrcValue = [array lastObject];
        for (NSString *timesStr in array) {
            NSInteger minute = [[timesStr substringWithRange:NSMakeRange(1, 2)] integerValue];
            NSInteger second = [[timesStr substringWithRange:NSMakeRange(4, 2)] integerValue];
            NSInteger msecond = [[timesStr substringWithRange:NSMakeRange(7, 2)] integerValue];
            NSString *totalMS = [NSString stringWithFormat:@"%ld", (minute*60 + second)*100 + msecond];
            [_lrcDictionary setValue:lrcValue forKey:totalMS];
            [_timesArray addObject:totalMS];
        }
    }
}

- (NSString *)displayLyricsWithCurrentTime:(NSInteger)time{
    NSString *str = @"";
    for (int i = 0; i < _timesArray.count; i ++) {
        if (time < [_timesArray[i] integerValue]) {
            if (i == 0) {
                str = nil;
            }else{
                str = [_lrcDictionary valueForKey:_timesArray[i-1]];
            }
        }
        if (i == _timesArray.count -1) {
            str = [_lrcDictionary valueForKey:[_timesArray lastObject]];
        }
    }
    return str;
}

@end
