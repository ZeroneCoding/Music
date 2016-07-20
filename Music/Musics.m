//
//  Musics.m
//  Music
//
//  Created by 李银 on 15/12/10.
//  Copyright © 2015年 liyin. All rights reserved.
//

#import "Musics.h"

@implementation Musics
-(instancetype)initMusicsWithName:(NSString *)name andType:(NSString *)type{
    if (self = [super init]) {
        self.name = name;
        self.mType = type;
    }
    return self;
}
@end
