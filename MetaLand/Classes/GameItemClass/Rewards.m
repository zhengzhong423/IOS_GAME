//
//  Rewards.m
//  MetaLand
//
//  Created by yuwen lian on 7/19/14.
//  Copyright (c) 2014 yuwen lian. All rights reserved.
//

#import "Rewards.h"
#import "Enemies.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

@implementation Rewards

+(CCSprite*)portalInInit {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"portalIn.plist"];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"portalIn-1.png"];
    CCSprite *portalIn = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];;
    
    if (portalIn) {
        NSMutableArray *animationFramesRun = [NSMutableArray array];
        
        for(int i = 1; i <= 7; ++i) {
            [animationFramesRun addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"portalIn-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
        [portalIn runAction:run];
    }
    
    //Add physics body to portalIn
    [portalIn setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, portalIn.contentSize} cornerRadius:0]];
    portalIn.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    portalIn.physicsBody.collisionGroup = @"gameSceneGroup";
    portalIn.physicsBody.collisionType = @"portalCollision";
    portalIn.name = @"portalIn";
    
    return portalIn;
}

+(CCSprite*)portalOutInit {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"portalOut.plist"];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"portalOut-1.png"];
    CCSprite *portalOut = [CCSprite spriteWithSpriteFrame:initialSpriteFrame];;
    
    if (portalOut) {
        NSMutableArray *animationFramesRun = [NSMutableArray array];
        
        for(int i = 1; i <= 6; ++i) {
            [animationFramesRun addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"portalOut-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
        [portalOut runAction:run];
    }
    
    portalOut.name = @"portalOut";
    
    return portalOut;
}

+(CCSprite*)magnetInit {
    CCSprite *magnet = [CCSprite spriteWithImageNamed:@"magnet.png"];
    
    magnet.anchorPoint = ccp(0,0);
    [magnet setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, magnet.contentSize} cornerRadius:0]];
    
    magnet.physicsBody.affectedByGravity = NO;
    magnet.physicsBody.allowsRotation = NO;
    
    magnet.physicsBody.collisionGroup = @"gameSceneGroup";
    magnet.physicsBody.collisionType = @"magnetCollision";
    
    return magnet;
}

+(CCSprite*)boostInit{
    CCSprite *boost = [CCSprite spriteWithImageNamed:@"boost_bonus.png"];
    
    boost.anchorPoint = ccp(0,0);
    [boost setPhysicsBody:[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, boost.contentSize} cornerRadius:0]];
    
    boost.physicsBody.affectedByGravity = NO;
    boost.physicsBody.allowsRotation = NO;
    
    boost.physicsBody.collisionGroup = @"gameSceneGroup";
    boost.physicsBody.collisionType = @"boostCollision";
    
    return boost;
}

+(CCSprite*)starInit {
    CCSprite *star = [CCSprite spriteWithImageNamed:@"star.png"];
    star.anchorPoint = ccp(0, 0);
    [star setPhysicsBody:[CCPhysicsBody bodyWithRect:star.boundingBox cornerRadius:0]];
    star.physicsBody.type = CCPhysicsBodyTypeStatic;
    star.physicsBody.collisionGroup = @"gameSceneGroup";
    star.physicsBody.collisionType = @"starCollision";
    star.name = @"star";
    
    return star;
}

+(CCSprite*)threeStarsInit {
    CCSprite *sprite = [CCSprite node];
    
    //CCSprite *spr0 = [Enemies laserDiagonalInit:0];
    //CCSprite *spr1 = [Enemies laserHorizontalInit];
    //CCSprite *spr2 = [Enemies laserDiagonalInit:1];
    CCSprite *star0 = [Rewards starInit];
    CCSprite *star1 = [Rewards starInit];
    CCSprite *star2 = [Rewards starInit];
    
    star0.position = ccp(0, 0);
    star1.position = ccp(star0.contentSize.width + 50, 10);
    star2.position = ccp(star1.position.x + star1.contentSize.width + 50 + star2.contentSize.width, 0);
    //star0.position = ccp(spr0.position.x + spr0.contentSize.width - star2.contentSize.width, 0);
    //star1.position = ccp(spr1.position.x + spr1.contentSize.width/2 - star1.contentSize.width/2, 40);
    //star2.position = ccp(spr2.position.x - spr2.contentSize.width, 0);
    //[sprite addChild:spr0];
    //[sprite addChild:spr1];
    //[sprite addChild:spr2];
    [sprite addChild:star0];
    [sprite addChild:star1];
    [sprite addChild:star2];
    
    //sprite.contentSize = CGSizeMake(star2.position.x, star2.contentSize.height);
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    return sprite;
}

+(CCSprite*)threeStarsReverseInit {
    CCSprite *sprite = [CCSprite node];
    
    CCSprite *spr0 = [Enemies laserDiagonalInit:1];
    CCSprite *spr1 = [Enemies laserHorizontalInit];
    CCSprite *spr2 = [Enemies laserDiagonalInit:0];
    CCSprite *star0 = [Rewards starInit];
    CCSprite *star1 = [Rewards starInit];
    CCSprite *star2 = [Rewards starInit];
    spr0.position = ccp(spr0.contentSize.width, 0);
    spr1.position = ccp(spr0.contentSize.width + 50, 65);
    spr2.position = ccp(spr1.position.x + spr1.contentSize.width + 50, 0);
    star0.position = ccp(spr0.position.x, 50);
    star1.position = ccp(spr1.position.x + spr1.contentSize.width/2 - star1.contentSize.width/2, 25);
    star2.position = ccp(spr2.position.x - star2.contentSize.width, 50);
    [sprite addChild:spr0];
    [sprite addChild:spr1];
    [sprite addChild:spr2];
    [sprite addChild:star0];
    [sprite addChild:star1];
    [sprite addChild:star2];
    
    sprite.contentSize = CGSizeMake(spr2.position.x + spr2.contentSize.width, spr2.contentSize.height);
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    
    return sprite;
}

@end
