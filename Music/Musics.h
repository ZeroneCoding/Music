//
//  Musics.h
//  Music
//
//  Created by 李银 on 15/12/10.
//  Copyright © 2015年 liyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Musics : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *mType;
- (instancetype)initMusicsWithName:(NSString *)name andType:(NSString *)type;
@end
