//
//  Enemies.h
//  MetaLand
//
//  Created by yuwen lian on 6/16/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "cocos2d.h"
#define MISSILE_NORMAL 0
#define MISSILE_GOLDEN 1

@interface Enemies : CCNode

+(CCSprite*)missileInit : (int)type;
+(CCSprite*)laserHorizontalInit;
+(CCSprite*)laserVerticalInit;
+(CCSprite*)laserDiagonalInit : (int)type;
+(CCSprite*)laserRotatingInit;
+(CCSprite*)gearInit;

@end
