//
//  PortalSceneBackground.h
//  MetaLand
//
//  Created by 崔 乘瑜 on 7/10/14.
//  Copyright 2014 崔 乘瑜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PortalSceneBackground : CCNode {
    CCSprite *_ground;
    CCSprite *_background1;
    CCSprite *_background2;
    CCSprite *_topBackground;
    CCSprite *_middleSeperator1;
    CCSprite *_middleSeperator2;
    
    CCNode *_bgTop;
    CCNode *_bgBot;
}

@property (atomic) CCSprite *_ground;
@property (atomic) CCSprite *_background1;
@property (atomic) CCSprite *_background2;
@property (atomic) CCSprite *_topBackground;
@property (atomic) CCSprite *_middleSeperator1;
@property (atomic) CCSprite *_middleSeperator2;
@property (atomic) CCNode *_bgTop;
@property (atomic) CCNode *_bgBot;



@end
