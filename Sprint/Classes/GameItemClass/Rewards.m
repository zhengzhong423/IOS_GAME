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


+(CCSprite*)coinsInit {
    CCSprite *coins = [CCSprite spriteWithImageNamed:@"coins.png"];
    coins.anchorPoint = ccp(0, 0);
    [coins setPhysicsBody:[CCPhysicsBody bodyWithRect:coins.boundingBox cornerRadius:0]];
    coins.physicsBody.type = CCPhysicsBodyTypeStatic;
    coins.physicsBody.collisionGroup = @"gameSceneGroup";
    coins.physicsBody.collisionType = @"starCollision";
    coins.name = @"star";
    
    return coins;
}


+(CCSprite*)bluediamondInit {
    CCSprite *bluediamond = [CCSprite spriteWithImageNamed:@"bluediamond.png"];
    bluediamond.anchorPoint = ccp(0, 0);
    [bluediamond setPhysicsBody:[CCPhysicsBody bodyWithRect:bluediamond.boundingBox cornerRadius:0]];
    bluediamond.physicsBody.type = CCPhysicsBodyTypeStatic;
    bluediamond.physicsBody.collisionGroup = @"gameSceneGroup";
    bluediamond.physicsBody.collisionType = @"starCollision";
    bluediamond.name = @"star";
    
    return bluediamond;
}

+(CCSprite*)LineShapeStars {
    CCSprite *sprite = [CCSprite node];
    
    //CCSprite *spr0 = [Enemies laserDiagonalInit:0];
    //CCSprite *spr1 = [Enemies laserHorizontalInit];
    //CCSprite *spr2 = [Enemies laserDiagonalInit:1];
    CCSprite *obj0 = [Rewards coinsInit];
    CCSprite *obj1 = [Rewards coinsInit];
    CCSprite *obj2 = [Rewards coinsInit];
    CCSprite *obj3 = [Rewards coinsInit];
    CCSprite *obj4 = [Rewards coinsInit];
    CCSprite *obj5 = [Rewards coinsInit];
    CCSprite *obj6 = [Rewards coinsInit];
    CCSprite *obj7 = [Rewards coinsInit];
    CCSprite *obj8 = [Rewards coinsInit];
    
    //spr0.position = ccp(0, 0);
    //spr1.position = ccp(spr0.contentSize.width + 50, 10);
    //spr2.position = ccp(spr1.position.x + spr1.contentSize.width + 50 + spr2.contentSize.width, 0);
    obj0.position = ccp(obj0.position.x, 15);
    obj1.position = ccp(obj0.position.x + obj1.contentSize.width*1.2, 15);
    obj2.position = ccp(obj1.position.x + obj2.contentSize.width*1.2, 15);
    obj3.position = ccp(obj2.position.x + obj3.contentSize.width*1.2, 15);
    obj4.position = ccp(obj3.position.x + obj4.contentSize.width*1.2, 15);
    obj5.position = ccp(obj4.position.x + obj5.contentSize.width*1.2, 15);
    obj6.position = ccp(obj5.position.x + obj6.contentSize.width*1.2, 15);
    obj7.position = ccp(obj6.position.x + obj7.contentSize.width*1.2, 15);
    obj8.position = ccp(obj7.position.x + obj8.contentSize.width*1.2, 15);
    
    //[sprite addChild:spr0];
    //[sprite addChild:spr1];
    //[sprite addChild:spr2];
    [sprite addChild:obj0];
    [sprite addChild:obj1];
    [sprite addChild:obj2];
    [sprite addChild:obj3];
    [sprite addChild:obj4];
    [sprite addChild:obj5];
    [sprite addChild:obj6];
    [sprite addChild:obj7];
    [sprite addChild:obj8];
    
    //sprite.contentSize = CGSizeMake(spr2.position.x, spr2.contentSize.height);
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    return sprite;
}

+(CCSprite*)RectShapeStars {
    CCSprite *sprite = [CCSprite node];
    
    //CCSprite *spr0 = [Enemies laserDiagonalInit:1];
    //CCSprite *spr1 = [Enemies laserHorizontalInit];
    //CCSprite *spr2 = [Enemies laserDiagonalInit:0];
    CCSprite *obj0 = [Rewards coinsInit];
    CCSprite *obj1 = [Rewards coinsInit];
    CCSprite *obj2 = [Rewards coinsInit];
    CCSprite *obj3 = [Rewards coinsInit];
    CCSprite *obj4 = [Rewards coinsInit];
    CCSprite *obj5 = [Rewards coinsInit];
    CCSprite *obj6 = [Rewards coinsInit];
    CCSprite *obj7 = [Rewards coinsInit];
    CCSprite *obj8 = [Rewards coinsInit];
    CCSprite *obj9 = [Rewards coinsInit];
    CCSprite *obj10 = [Rewards coinsInit];
    CCSprite *obj11 = [Rewards coinsInit];
    
    //spr0.position = ccp(spr0.contentSize.width, 0);
    //spr1.position = ccp(spr0.contentSize.width + 50, 65);
    //spr2.position = ccp(spr1.position.x + spr1.contentSize.width + 50, 0);
    obj0.position = ccp(obj0.position.x, 15);
    obj1.position = ccp(obj0.position.x + obj1.contentSize.width*1.2, 15);
    obj2.position = ccp(obj1.position.x + obj2.contentSize.width*1.2, 15);
    obj3.position = ccp(obj2.position.x + obj3.contentSize.width*1.2, 15);
    obj4.position = ccp(obj0.position.x, obj0.position.y - obj4.contentSize.height*1.2);
    obj5.position = ccp(obj1.position.x, obj1.position.y - obj5.contentSize.height*1.2);
    obj6.position = ccp(obj2.position.x, obj2.position.y - obj6.contentSize.height*1.2);
    obj7.position = ccp(obj3.position.x, obj3.position.y - obj7.contentSize.height*1.2);
    obj8.position = ccp(obj4.position.x, obj4.position.y - obj8.contentSize.height*1.2);
    obj9.position = ccp(obj5.position.x, obj5.position.y - obj9.contentSize.height*1.2);
    obj10.position = ccp(obj6.position.x, obj6.position.y - obj10.contentSize.height*1.2);
    obj11.position = ccp(obj7.position.x, obj7.position.y - obj11.contentSize.height*1.2);
    
    //[sprite addChild:spr0];
    //[sprite addChild:spr1];
    //[sprite addChild:spr2];
    [sprite addChild:obj0];
    [sprite addChild:obj1];
    [sprite addChild:obj2];
    [sprite addChild:obj3];
    [sprite addChild:obj4];
    [sprite addChild:obj5];
    [sprite addChild:obj6];
    [sprite addChild:obj7];
    [sprite addChild:obj8];
    [sprite addChild:obj9];
    [sprite addChild:obj10];
    [sprite addChild:obj11];
    
    //sprite.contentSize = CGSizeMake(spr2.position.x + spr2.contentSize.width, spr2.contentSize.height);
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    
    return sprite;
}

+(CCSprite*)DiamondShapeStars {
    CCSprite *sprite = [CCSprite node];
    
    CCSprite *obj0 = [Rewards coinsInit];
    CCSprite *obj1 = [Rewards coinsInit];
    CCSprite *obj2 = [Rewards coinsInit];
    CCSprite *obj3 = [Rewards coinsInit];
    CCSprite *obj4 = [Rewards coinsInit];
    CCSprite *obj5 = [Rewards coinsInit];
    CCSprite *obj6 = [Rewards coinsInit];
    CCSprite *obj7 = [Rewards coinsInit];
    CCSprite *obj8 = [Rewards coinsInit];
    CCSprite *obj9 = [Rewards coinsInit];
    CCSprite *obj10 = [Rewards coinsInit];
    
    obj0.position = ccp(obj0.position.x, 15);
    obj1.position = ccp(obj0.position.x + obj1.contentSize.width*1.3, 15);
    obj2.position = ccp(obj1.position.x + obj2.contentSize.width*1.3, 15);
    obj3.position = ccp(obj0.position.x - obj3.contentSize.width*.5, obj0.position.y - obj3.contentSize.height*1.2);
    obj4.position = ccp(obj3.position.x + obj4.contentSize.width*1.2, obj0.position.y - obj4.contentSize.height*1.2);
    obj5.position = ccp(obj4.position.x + obj5.contentSize.width*1.2, obj0.position.y - obj5.contentSize.height*1.2);
    obj6.position = ccp(obj5.position.x + obj6.contentSize.width*1.2, obj0.position.y - obj6.contentSize.height*1.2);
    obj7.position = ccp(obj0.position.x, obj3.position.y - obj7.contentSize.height*1.2);
    obj8.position = ccp(obj1.position.x, obj3.position.y - obj8.contentSize.height*1.2);
    obj9.position = ccp(obj2.position.x, obj3.position.y - obj9.contentSize.height*1.2);
    obj10.position = ccp(obj8.position.x, obj7.position.y - obj10.contentSize.height*1.1);
    
    [sprite addChild:obj0];
    [sprite addChild:obj1];
    [sprite addChild:obj2];
    [sprite addChild:obj3];
    [sprite addChild:obj4];
    [sprite addChild:obj5];
    [sprite addChild:obj6];
    [sprite addChild:obj7];
    [sprite addChild:obj8];
    [sprite addChild:obj9];
    [sprite addChild:obj10];
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    
    return sprite;
}

+(CCSprite*)HeartShapeStars{
    CCSprite *sprite = [CCSprite node];
    
    CCSprite *obj0 = [Rewards coinsInit];
    CCSprite *obj1 = [Rewards coinsInit];
    CCSprite *obj2 = [Rewards coinsInit];
    CCSprite *obj3 = [Rewards coinsInit];
    CCSprite *obj4 = [Rewards coinsInit];
    CCSprite *obj5 = [Rewards coinsInit];
    CCSprite *obj6 = [Rewards coinsInit];
    CCSprite *obj7 = [Rewards coinsInit];
    CCSprite *obj8 = [Rewards coinsInit];
    CCSprite *obj9 = [Rewards coinsInit];
    CCSprite *obj10 = [Rewards coinsInit];
    CCSprite *obj11 = [Rewards coinsInit];
    CCSprite *obj12 = [Rewards coinsInit];
    CCSprite *obj13 = [Rewards coinsInit];
    CCSprite *obj14 = [Rewards coinsInit];
    CCSprite *obj15 = [Rewards coinsInit];
    CCSprite *obj16 = [Rewards coinsInit];
    CCSprite *obj17 = [Rewards coinsInit];
    CCSprite *obj18 = [Rewards coinsInit];
    
    obj0.position = ccp(obj0.position.x, 15);
    obj1.position = ccp(obj0.position.x + obj1.contentSize.width*1.2, 15);
    obj2.position = ccp(obj1.position.x + obj2.contentSize.width*1.2, 15);
    obj3.position = ccp(obj2.position.x + obj3.contentSize.width*1.2, 15);
    obj4.position = ccp(obj3.position.x + obj4.contentSize.width*1.2, 15);
    obj5.position = ccp(obj4.position.x + obj5.contentSize.width*1.2, 15);
    obj6.position = ccp(obj0.position.x + obj6.contentSize.width*.5, obj0.position.y + obj6.contentSize.height*1.2);
    obj7.position = ccp(obj1.position.x + obj7.contentSize.width*.5, obj0.position.y + obj7.contentSize.height*1.2);
    obj8.position = ccp(obj3.position.x + obj8.contentSize.width*.5, obj0.position.y + obj8.contentSize.height*1.2);
    obj9.position = ccp(obj4.position.x + obj9.contentSize.width*.5, obj0.position.y + obj9.contentSize.height*1.2);
    obj10.position = ccp(obj0.position.x + obj10.contentSize.width*.5, obj0.position.y - obj10.contentSize.height*1.2);
    obj11.position = ccp(obj10.position.x + obj11.contentSize.width*1.3, obj0.position.y - obj11.contentSize.height*1.2);
    obj12.position = ccp(obj11.position.x + obj12.contentSize.width*1.3, obj0.position.y - obj12.contentSize.height*1.2);
    obj13.position = ccp(obj12.position.x + obj13.contentSize.width*1.3, obj0.position.y - obj13.contentSize.height*1.2);
    obj14.position = ccp(obj13.position.x + obj14.contentSize.width*1.3, obj0.position.y - obj14.contentSize.height*1.2);
    obj15.position = ccp(obj11.position.x, obj10.position.y - obj15.contentSize.height*1.2);
    obj16.position = ccp(obj12.position.x, obj10.position.y - obj16.contentSize.height*1.2);
    obj17.position = ccp(obj13.position.x, obj10.position.y - obj17.contentSize.height*1.2);
    obj18.position = ccp(obj16.position.x, obj15.position.y - obj18.contentSize.height*1.2);
    
    [sprite addChild:obj0];
    [sprite addChild:obj1];
    [sprite addChild:obj2];
    [sprite addChild:obj3];
    [sprite addChild:obj4];
    [sprite addChild:obj5];
    [sprite addChild:obj6];
    [sprite addChild:obj7];
    [sprite addChild:obj8];
    [sprite addChild:obj9];
    [sprite addChild:obj10];
    [sprite addChild:obj11];
    [sprite addChild:obj12];
    [sprite addChild:obj13];
    [sprite addChild:obj14];
    [sprite addChild:obj15];
    [sprite addChild:obj16];
    [sprite addChild:obj17];
    [sprite addChild:obj18];
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    
    return sprite;
}

+(CCSprite*)USCShapeStars{
    CCSprite *sprite = [CCSprite node];
    
    CCSprite *star0 = [Rewards coinsInit];
    CCSprite *star1 = [Rewards coinsInit];
    CCSprite *star2 = [Rewards coinsInit];
    CCSprite *star3 = [Rewards coinsInit];
    CCSprite *star4 = [Rewards coinsInit];
    CCSprite *star5 = [Rewards coinsInit];
    CCSprite *star6 = [Rewards coinsInit];
    CCSprite *star7 = [Rewards coinsInit];
    CCSprite *star8 = [Rewards coinsInit];
    CCSprite *star9 = [Rewards coinsInit];
    CCSprite *star10 = [Rewards coinsInit];
    CCSprite *star11 = [Rewards coinsInit];
    CCSprite *star12 = [Rewards coinsInit];
    CCSprite *star13 = [Rewards coinsInit];
    CCSprite *star14 = [Rewards coinsInit];
    CCSprite *star15 = [Rewards coinsInit];
    CCSprite *star16 = [Rewards coinsInit];
    CCSprite *star17 = [Rewards coinsInit];
    CCSprite *star18 = [Rewards coinsInit];
    CCSprite *star19 = [Rewards coinsInit];
    CCSprite *star20 = [Rewards coinsInit];
    CCSprite *star21 = [Rewards coinsInit];
    CCSprite *star22 = [Rewards coinsInit];
    CCSprite *star23 = [Rewards coinsInit];
    CCSprite *star24 = [Rewards coinsInit];
    CCSprite *star25 = [Rewards coinsInit];
    CCSprite *star26 = [Rewards coinsInit];
    CCSprite *star27 = [Rewards coinsInit];
    CCSprite *star28 = [Rewards coinsInit];
    CCSprite *star29 = [Rewards coinsInit];
    CCSprite *star30 = [Rewards coinsInit];
    
    
    
    star0.position = ccp(star0.position.x, 5);
    star1.position = ccp(star0.position.x + star1.contentSize.width*1.3, 5);
    star2.position = ccp(star1.position.x + star2.contentSize.width*1.3, 5);
    star3.position = ccp(star2.position.x + star3.contentSize.width*2, 5);
    star4.position = ccp(star3.position.x + star4.contentSize.width*1.3, 5);
    star5.position = ccp(star4.position.x + star5.contentSize.width*1.3, 5);
    star6.position = ccp(star5.position.x + star6.contentSize.width*2, 5);
    star7.position = ccp(star6.position.x + star7.contentSize.width*1.3, 5);
    star8.position = ccp(star7.position.x + star8.contentSize.width*1.3, 5);
    star9.position = ccp(star5.position.x, star0.position.y + star9.contentSize.height*1.2);
    star10.position = ccp(star0.position.x, star9.position.y + star10.contentSize.height*1.2);
    star11.position = ccp(star2.position.x, star9.position.y + star11.contentSize.height*1.2);
    star12.position = ccp(star3.position.x, star9.position.y + star12.contentSize.height*1.2);
    star13.position = ccp(star4.position.x, star9.position.y + star13.contentSize.height*1.2);
    star14.position = ccp(star5.position.x, star9.position.y + star14.contentSize.height*1.2);
    star15.position = ccp(star6.position.x, star9.position.y + star15.contentSize.height*1.2);
    star16.position = ccp(star12.position.x, star10.position.y + star16.contentSize.height*1.2);
    star17.position = ccp(star10.position.x, star16.position.y + star17.contentSize.height*1.2);
    star18.position = ccp(star11.position.x, star16.position.y + star18.contentSize.height*1.2);
    star19.position = ccp(star12.position.x, star16.position.y + star19.contentSize.height*1.2);
    star20.position = ccp(star13.position.x, star16.position.y + star20.contentSize.height*1.2);
    star21.position = ccp(star14.position.x, star16.position.y + star21.contentSize.height*1.2);
    star22.position = ccp(star15.position.x, star16.position.y + star22.contentSize.height*1.2);
    star23.position = ccp(star7.position.x, star16.position.y + star23.contentSize.height*1.2);
    star24.position = ccp(star8.position.x, star16.position.y + star24.contentSize.height*1.2);
    star25.position = ccp(star0.position.x, star0.position.y + star25.contentSize.height*1.2);
    star26.position = ccp(star10.position.x, star10.position.y + star26.contentSize.height*1.2);
    star27.position = ccp(star11.position.x, star10.position.y + star27.contentSize.height*1.2);
    star28.position = ccp(star2.position.x, star0.position.y + star28.contentSize.height*1.2);
    star29.position = ccp(star6.position.x, star0.position.y + star29.contentSize.height*1.2);
    star30.position = ccp(star15.position.x, star10.position.y + star30.contentSize.height*1.2);
    
    [sprite addChild:star0];
    [sprite addChild:star1];
    [sprite addChild:star2];
    [sprite addChild:star3];
    [sprite addChild:star4];
    [sprite addChild:star5];
    [sprite addChild:star6];
    [sprite addChild:star7];
    [sprite addChild:star8];
    [sprite addChild:star9];
    [sprite addChild:star10];
    [sprite addChild:star11];
    [sprite addChild:star12];
    [sprite addChild:star13];
    [sprite addChild:star14];
    [sprite addChild:star15];
    [sprite addChild:star16];
    [sprite addChild:star17];
    [sprite addChild:star18];
    [sprite addChild:star19];
    [sprite addChild:star20];
    [sprite addChild:star21];
    [sprite addChild:star22];
    [sprite addChild:star23];
    [sprite addChild:star24];
    [sprite addChild:star25];
    [sprite addChild:star26];
    [sprite addChild:star27];
    [sprite addChild:star28];
    [sprite addChild:star29];
    [sprite addChild:star30];
    
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.name = @"threeStars";
    
    return sprite;
}

@end
