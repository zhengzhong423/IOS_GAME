//
//  Enemies.m
//  MetaLand
//
//  Created by yuwen lian on 6/16/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "Enemies.h"
#import "Rewards.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

@implementation Enemies


// -----------------------------------------------------------------------
#pragma mark - Create enemy sprites
// -----------------------------------------------------------------------
+(CCSprite*)missileInit : (int)type
{
    CCSprite *missile;
    
    switch (type) {
        case MISSILE_NORMAL:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"missile_2.plist"];
            CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"missile_2-1.png"];
            
            
            missile = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (missile) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for(int i = 1; i <= 10; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"missile_2-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.4f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [missile runAction:run];
            }

            //missile = [CCSprite spriteWithImageNamed:@"missile1.png"];
            missile.name = @"missile";
            break;
        }
        case MISSILE_GOLDEN:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"missile_1.plist"];
            CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"missile_1-1.png"];
            
            
            missile = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (missile) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for(int i = 1; i <= 7; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"missile_1-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.5f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [missile runAction:run];
            }

            //missile = [CCSprite spriteWithImageNamed:@"goldenmissile.png"];
            missile.name = @"goldenMissile";
            break;
        }
        default:
            break;
    }
    missile.anchorPoint = ccp(0, 0);
    
    //Add physics body to missile
    [missile setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, missile.contentSize} cornerRadius:0]];
    missile.physicsBody.affectedByGravity = NO;
    missile.physicsBody.allowsRotation = NO;
    
    missile.physicsBody.collisionGroup = @"gameSceneGroup";
    missile.physicsBody.collisionType = @"missileCollision";
    
    return missile;
}

+(CCSprite*)laserHorizontalInit {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"laserHorizontal.plist"];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"laserHorizontal-1.png"];
    
    
    CCSprite *laserHorizontal = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
    if (laserHorizontal) {
        NSMutableArray *animationFramesRun = [NSMutableArray array];
        
        for(int i = 1; i <= 8; ++i) {
            [animationFramesRun addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"laserHorizontal-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
        [laserHorizontal runAction:run];
    }

    //CCSprite* laserHorizontal = [CCSprite spriteWithImageNamed:@"laser1.png"];
    laserHorizontal.anchorPoint = ccp(0, 0);
    
    //Add physics body to obstacle
    [laserHorizontal setPhysicsBody:[CCPhysicsBody bodyWithRect:laserHorizontal.boundingBox cornerRadius:0]];
    laserHorizontal.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    laserHorizontal.physicsBody.collisionGroup = @"gameSceneGroup";
    laserHorizontal.physicsBody.collisionType = @"obstacleCollision";
    laserHorizontal.name = @"laserHorizontal";
    
    return laserHorizontal;
}

+(CCSprite*)laserVerticalInit {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"laserVertical.plist"];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"laserVertical-1.png"];
    
    
    CCSprite *laserVertical = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
    if (laserVertical) {
        NSMutableArray *animationFramesRun = [NSMutableArray array];
        
        for(int i = 1; i <= 8; ++i) {
            [animationFramesRun addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"laserVertical-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
        [laserVertical runAction:run];
    }

    //CCSprite *laserVertical = [CCSprite spriteWithImageNamed:@"laser2.png"];
    laserVertical.anchorPoint = ccp(0, 0);
    
    //Add physics body to obstacle
    [laserVertical setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, laserVertical.contentSize} cornerRadius:0]];
    laserVertical.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    laserVertical.physicsBody.collisionGroup = @"gameSceneGroup";
    laserVertical.physicsBody.collisionType = @"obstacleCollision";
    laserVertical.name = @"laserVertical";
    
    return laserVertical;
}

+(CCSprite*)laserDiagonalInit : (int)type {
    CCSprite *laserDigaonal = [self laserVerticalInit];
    if (type == 0) {
        laserDigaonal.rotation = 45;
        laserDigaonal.anchorPoint = ccp(1, 0);
        laserDigaonal.name = @"laserDiagonalRight";
    }
    else {
        laserDigaonal.rotation = -45;
        laserDigaonal.anchorPoint = ccp(0, 0);
        laserDigaonal.name = @"laserDiagonalLeft";
    }
    laserDigaonal.contentSize = CGSizeMake(0.75*laserDigaonal.contentSize.height, 0.75*laserDigaonal.contentSize.height);
    return laserDigaonal;
}

+(CCSprite*)laserRotatingInit {
    float direction;
    
    if (arc4random()%2 == 1) {
        direction = 1.0f;
    }
    else {
        direction = -1.0f;
    }
    
    CCSprite *laserRotating = [Enemies laserVerticalInit];
    CCAction* action = [CCActionRotateBy actionWithDuration:30.0f angle:30*60*direction];
    laserRotating.anchorPoint = ccp(0.5f, 0.5f);
    laserRotating.name = @"laserRotating";
    laserRotating.scaleY = 1.5f;
    [laserRotating runAction:action];
    
    if (arc4random()%2 == 1) {
        CCSprite *star = [Rewards starInit];
        star.position = ccp(30, arc4random()%(int)(laserRotating.contentSize.height));
        star.scaleY = 0.67f;
        [laserRotating addChild:star];
    }
    return laserRotating;
}

+(CCSprite*)gearInit {
    CCSprite *gear = [CCSprite spriteWithImageNamed:@"gear.png"];
    gear.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:gear.contentSize.width*0.45f andCenter:ccp(gear.contentSize.width*0.45f, gear.contentSize.height*0.45f)];
    gear.physicsBody.type = CCPhysicsBodyTypeStatic;
    gear.physicsBody.collisionGroup = @"gameSceneGroup";
    gear.physicsBody.collisionType = @"gearCollision";
    gear.name = @"gear";
    
    CCAction *actionRotate = [CCActionRotateBy actionWithDuration:10.0f angle:720];
    CCAction *actionRemove = [CCActionRemove action];
    
    [gear runAction:[CCActionSequence actionWithArray:@[actionRotate, actionRemove]]];
    
    return gear;
}

+(CCSprite*)whirlpool {
    CCSprite *whirlpool = [CCSprite spriteWithImageNamed:@"whirlpool.png"];
    whirlpool.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:whirlpool.contentSize.width*0.45f andCenter:ccp(whirlpool.contentSize.width*0.45f, whirlpool.contentSize.height*0.45f)];
    whirlpool.physicsBody.type = CCPhysicsBodyTypeStatic;
    whirlpool.physicsBody.collisionGroup = @"gameSceneGroup";
    whirlpool.physicsBody.collisionType = @"gearCollision";
    whirlpool.name = @"whirlpool";
    
    CCAction *actionRotate = [CCActionRotateBy actionWithDuration:10.0f angle:720];
    CCAction *actionRemove = [CCActionRemove action];
    
    [whirlpool runAction:[CCActionSequence actionWithArray:@[actionRotate, actionRemove]]];
    
    return whirlpool;

}

// -----------------------------------------------------------------------
#pragma mark - Random number generators
// -----------------------------------------------------------------------
-(int)random:(int)minimum withArg2:(int)maximum {
    int range = maximum - minimum;
    return (arc4random() % range) + minimum;
}

@end
