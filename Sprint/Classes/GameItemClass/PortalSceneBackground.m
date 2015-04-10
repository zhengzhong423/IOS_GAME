//
//  PortalSceneBackground.m
//  MetaLand
//
//  Created by 崔 乘瑜 on 7/10/14.
//  Copyright 2014 崔 乘瑜. All rights reserved.
//

#import "PortalSceneBackground.h"
#import "Coin.h"

@implementation PortalSceneBackground
{
    int _screenWidth;
    int _screenHeight;
}

@synthesize _ground;
@synthesize _background1;
@synthesize _background2;
@synthesize _topBackground;
@synthesize _middleSeperator1;
@synthesize _middleSeperator2;
@synthesize _bgTop;
@synthesize _bgBot;


-(id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Initialize the screen size
    _screenWidth = [[UIScreen mainScreen] bounds].size.height;
    _screenHeight = [[UIScreen mainScreen] bounds].size.width;
    
    _bgTop = [CCNode node];
    _bgBot = [CCNode node];
    
    // Create the sprites
    [self createGroundSprite];
    [self createBackgroundSprite];
    [self createTopBackgroundSprite];
    [self createMiddleSeperator];
    
    /*
    CCSprite *spr = [Coin generateRandomCoinGroupForPortalScene];
    spr.positionType = CCPositionTypeNormalized;
    spr.position = ccp(0.5 ,0.5);
    [_background1 addChild:spr];
    
    spr = [Coin generateRandomCoinGroupForPortalScene];
    spr.positionType = CCPositionTypeNormalized;
    spr.position = ccp(0.5 ,0.5);
    [_background2 addChild:spr];
     */
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Create background sprites
// -----------------------------------------------------------------------
-(void)createGroundSprite
{
    _ground = [CCSprite spriteWithImageNamed:@"ground_PortalScene.png"];
    _ground.anchorPoint = CGPointZero;
    _ground.position = CGPointZero;
    _ground.opacity = 0;
    _ground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ground.contentSize} cornerRadius:0];
    _ground.physicsBody.type = CCPhysicsBodyTypeStatic;

    [_bgBot addChild:_ground z:1];

}

-(void)createBackgroundSprite
{
    _background1 = [CCSprite spriteWithImageNamed:@"pd_tilemap4.png"];
    _background1.anchorPoint = CGPointZero;
    _background1.position = CGPointZero;

    _background2 = [CCSprite spriteWithImageNamed:@"pd_tilemap4.png"];
    _background2.anchorPoint = CGPointZero;
    _background2.position = ccp(_background1.contentSize.width-1, 0);

    
    [_bgTop addChild:_background1 z:0];
    [_bgTop addChild:_background2 z:0];
}

-(void)createTopBackgroundSprite
{
    _topBackground = [CCSprite spriteWithImageNamed:@"topBackground_PortalScene.png"];
    _topBackground.opacity = 0;
    _topBackground.anchorPoint = CGPointZero;
    _topBackground.position = ccp(0, _screenHeight - _topBackground.contentSize.height);
    _topBackground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _topBackground.contentSize} cornerRadius:0];
    _topBackground.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    [_bgTop addChild:_topBackground z:1];
}

-(void)createMiddleSeperator
{
    _middleSeperator1 = [CCSprite spriteWithImageNamed:@"middleSeperator1.png"];
    _middleSeperator1.anchorPoint = CGPointZero;
    _middleSeperator1.position = ccp( 0, _screenHeight/2 );
    _middleSeperator1.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _middleSeperator1.contentSize} cornerRadius:0];
    _middleSeperator1.physicsBody.type = CCPhysicsBodyTypeStatic;
    _middleSeperator1.physicsBody.collisionType = @"seperator1Collision";
    [_bgTop addChild:_middleSeperator1 z:1];
    
    _middleSeperator2 = [CCSprite spriteWithImageNamed:@"middleSeperator2.png"];
    _middleSeperator2.anchorPoint = CGPointZero;
    _middleSeperator2.position = ccp( 0, _screenHeight/2-_middleSeperator2.contentSize.height );
    _middleSeperator2.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _middleSeperator2.contentSize} cornerRadius:0];
    _middleSeperator2.physicsBody.type = CCPhysicsBodyTypeStatic;
    _middleSeperator2.physicsBody.collisionType = @"seperatorCollision";

    [_bgBot addChild:_middleSeperator2 z:1];
}

@end
