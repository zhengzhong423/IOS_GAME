//
//  Robot.m
//  MetaLand
//
//  Created by yuwen lian on 6/12/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "Robot.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

@implementation Robot

static bool spriteFramesInitialized;
CCSpriteFrame *initialSpriteFrame;
CCSprite *sprite;


+ (void)initializeSpriteFrames : (int)type {
    switch (type)
    {
        case CHARACTER_ROBOT_RUN:
        case CHARACTER_SHADOW_RUN:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_1.plist"];
            initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_1-1.png"];
            
            sprite = [Robot spriteWithSpriteFrame:initialSpriteFrame];
            
            if (sprite) {
                // ************* RUNNING ANIMATION ********************
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for(int i = 1; i <= 10; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"player_1-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [sprite runAction:run];
            }
        }
            break;
            
        case CHARACTER_ROBOT_FLY:
        case CHARACTER_SHADOW_FLY:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_2.plist"];
            initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player_2-1.png"];
            sprite = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (sprite) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for(int i = 1; i <= 7; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"player_2-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [sprite runAction:run];
            }
        }
            break;
            
        case CHARACTER_ROBOT_FALL:
        case CHARACTER_SHADOW_FALL:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_2.plist"];
            initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player_2-1.png"];
            sprite = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (sprite) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for(int i = 1; i <= 7; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"player_2-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [sprite runAction:run];
            }
        }

            break;
            
        case CHARACTER_ROBOT_DIE:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_3.plist"];
            initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player_3-1.png"];
            
            sprite = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (sprite) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for (int i = 1; i <= 10; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"player_3-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [sprite runAction:run];
            }
        }
            break;
            
        case CHARACTER_ROBOT_SHOTED:
        {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_4.plist"];
            initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player_4-1.png"];
            
            sprite = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];
            if (sprite) {
                NSMutableArray *animationFramesRun = [NSMutableArray array];
                
                for (int i = 1; i <= 12; ++i) {
                    [animationFramesRun addObject:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"player_4-%d.png", i]]];
                }
                
                //Create an animation from the set of frames you created earlier
                CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
                
                //Create an action with the animation that can then be assigned to a sprite
                CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
                [sprite runAction:run];
            }
        }
            break;
        case CHARACTER_ROBOT_BOOST:
        {
            sprite = [Robot spriteWithImageNamed:@"robot_boost.png"];
            break;
        }
        default:
            break;
    }
    //animation_knight.plist
}

+(id)createCharacter:(int)type {
    //add animation
    if (!spriteFramesInitialized)
    {
        switch (type)
        {
            case CHARACTER_ROBOT_RUN:
            {
                [Robot initializeSpriteFrames: CHARACTER_ROBOT_RUN];
                sprite.physicsBody.collisionType = @"robotCollision";
                //sprite.scale = 1.2f;
            }
                break;
            case CHARACTER_SHADOW_RUN:
            {
                [Robot initializeSpriteFrames: CHARACTER_SHADOW_RUN];
                sprite.physicsBody.collisionType = @"shadowCollision";
                //sprite.scaleY = -1.2f;
                //sprite.scaleX = 1.2f;
                sprite.opacity = 0.6f;
                sprite.scaleY = -1;
            }
                break;
            case CHARACTER_ROBOT_FLY:
            {
                [Robot initializeSpriteFrames: CHARACTER_ROBOT_FLY];
                sprite.physicsBody.collisionType = @"robotCollision";
                //sprite.scale = 1.2f;
            }
                break;
            case CHARACTER_SHADOW_FLY:
            {
                [Robot initializeSpriteFrames: CHARACTER_SHADOW_FLY];
                sprite.physicsBody.collisionType = @"shadowCollision";
                //sprite.scaleY = -1.2f;
                //sprite.scaleX = 1.2f;
                sprite.opacity = 0.6f;
                sprite.scaleY = -1;
            }
                break;
            case CHARACTER_ROBOT_FALL:
            {
                [Robot initializeSpriteFrames: CHARACTER_ROBOT_FALL];
                sprite.physicsBody.collisionType = @"robotCollision";
                //sprite.scale = 1.2f;
            }
                break;
            case CHARACTER_SHADOW_FALL:
            {
                [Robot initializeSpriteFrames: CHARACTER_SHADOW_FALL];
                sprite.physicsBody.collisionType = @"shadowCollision";
                //sprite.scaleY = -1.2f;
                //sprite.scaleX = 1.2f;
                sprite.scaleY = -1;
                sprite.opacity = 0.6f;
            }
                break;
            case CHARACTER_ROBOT_DIE:
            {
                [Robot initializeSpriteFrames:CHARACTER_ROBOT_DIE];
                sprite.physicsBody.collisionType = @"robotCollision";
                sprite.physicsBody.collisionGroup = @"gameSceneGroup";
                //sprite.scale = 1.2f;
            }
                break;
            case CHARACTER_ROBOT_SHOTED:
            {
                [Robot initializeSpriteFrames:CHARACTER_ROBOT_SHOTED];
                sprite.physicsBody.collisionType = @"robotCollision";
                sprite.physicsBody.collisionGroup = @"gameSceneGroup";
                //sprite.scale = 1.2f;
            }
                break;
            case CHARACTER_ROBOT_BOOST:
            {
                [Robot initializeSpriteFrames:CHARACTER_ROBOT_BOOST];
                sprite.physicsBody.collisionType = @"robotCollision";
                sprite.physicsBody.collisionGroup = @"gameSceneGroup";
                //sprite.scale = 1.2f;
            }
            default:
                break;
        }
                
        //add robot as a physics object
        
        if( CHARACTER_ROBOT_FALL==type || CHARACTER_SHADOW_FALL==type || CHARACTER_ROBOT_FLY==type || CHARACTER_SHADOW_FLY==type )
        {
            [sprite setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){ccp(0, sprite.contentSize.height*0.2f), CGSizeMake(sprite.contentSize.width, sprite.contentSize.height*0.8f)}  cornerRadius:0]];
        }
        else
        {
            [sprite setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, sprite.contentSize}  cornerRadius:0]];
        }
        sprite.physicsBody.friction = 0.0f;
        sprite.physicsBody.allowsRotation = false;
        sprite.physicsBody.density = 1.0/sprite.physicsBody.area;
        sprite.name = @"robot";
        

    
    }
    return sprite;
}

@end
