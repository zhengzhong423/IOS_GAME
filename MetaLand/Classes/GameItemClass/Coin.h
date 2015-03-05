//
//  Coin.h
//  MetaLand
//
//  Created by yuwen lian on 6/12/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "cocos2d.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

#define COIN_SHAPE_LINE 0
#define COIN_SHAPE_RECT 1
#define COIN_SHAPE_DIAMOND 2
#define COIN_SHAPE_HEART 3
#define COIN_SHAPE_USC 4
#define COIN_SHAPE_Z 5
#define COIN_SHAPE_LONGLINE 6

@interface Coin : CCSprite

+ (CCSprite*)initCoin;

+ (CCSprite*)initCoinGroup : (int)type;

+ (CCSprite*)generateRandomCoinGroupForPortalScene;

@end
