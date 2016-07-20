//
//  LrcModal.h
//  day22-歌词解析
//
//  Created by Aaron on 15/8/12.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcModal : NSObject
@property (nonatomic,copy) NSString *lrc;
@property (nonatomic,retain) NSNumber *mSecond;
-(NSComparisonResult)compareToOther:(LrcModal *)other;
@end
