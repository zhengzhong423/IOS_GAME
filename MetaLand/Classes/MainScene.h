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
#import "Robot.h"
// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface mainScene : CCScene <CCPhysicsCollisionDelegate>

// -----------------------------------------------------------------------

+ (mainScene *)scene;
- (id)init;
-(void) startGame;
//-(void)refreshRobot: (int) state
//              pos_x: (CGFloat) px
//              pos_y: (CGFloat) py ;
// -----------------------------------------------------------------------
@end