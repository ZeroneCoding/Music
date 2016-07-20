//
//  LrcModal.m
//  day22-歌词解析
//
//  Created by Aaron on 15/8/12.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import "LrcModal.h"

@implementation LrcModal
-(NSComparisonResult)compareToOther:(LrcModal *)other
{
    return [self.mSecond compare:other.mSecond];
}
@end
