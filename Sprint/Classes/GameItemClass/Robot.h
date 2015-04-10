//
//  Robot.h
//  MetaLand
//
//  Created by yuwen lian on 6/12/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "cocos2d.h"
//#import "cocos2d-ui.h"

#define CHARACTER_ROBOT_RUN 0
#define CHARACTER_SHADOW_RUN 1
#define CHARACTER_ROBOT_FLY 2
#define CHARACTER_SHADOW_FLY 3
#define CHARACTER_ROBOT_FALL 4
#define CHARACTER_SHADOW_FALL 5
#define CHARACTER_ROBOT_DIE 6
#define CHARACTER_ROBOT_SHOTED 7
#define CHARACTER_ROBOT_BOOST 8

@interface Robot : CCSprite

+ (id)createCharacter : (int)type;

@end
