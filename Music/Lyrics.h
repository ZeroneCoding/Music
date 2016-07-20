//
//  Lyrics.h
//  Music
//
//  Created by 李银 on 15/12/11.
//  Copyright © 2015年 liyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lyrics : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mType;
@property (nonatomic, strong) NSMutableDictionary *lrcDictionary;
@property (nonatomic, strong) NSMutableArray *timesArray;
- (instancetype)initLyricsWithName:(NSString *)name andType:(NSString *)mType;
- (NSString *)displayLyricsWithCurrentTime:(NSInteger)time;
- (void)loadLyricsDataWithName:(NSString *)name andType:(NSString *)mType;
@end
