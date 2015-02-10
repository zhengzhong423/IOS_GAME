//
//  HelloWorldScene.h
//  MetaLand
//
//  Created by Weiwei Zheng on 6/3/14.
//  Copyright Weiwei Zheng 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface mainScene : CCScene <CCPhysicsCollisionDelegate>

// -----------------------------------------------------------------------

+ (mainScene *)scene;
- (id)init;
-(void) startGame;

// -----------------------------------------------------------------------
@end