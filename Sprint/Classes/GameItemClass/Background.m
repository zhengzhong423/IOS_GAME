//
//  Background.m
//  MetaLand
//
//  Created by yuwen lian on 6/16/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "Background.h"

@implementation Background {
    int _screenWidth;
    int _screenHeight;
}

@synthesize _ground;
@synthesize _ceiling;
@synthesize _background1;
@synthesize _background2;
@synthesize _topBackground;

// -----------------------------------------------------------------------
#pragma mark - Initialize the background
// -----------------------------------------------------------------------
-(id)init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Initialize the screen size
    _screenWidth = [[UIScreen mainScreen] bounds].size.height;
    _screenHeight = [[UIScreen mainScreen] bounds].size.width;
    
    // Create the sprites
    [self createGroundSprite];
    [self createCeilingSprite];
    [self createBackgroundSprite];
    [self createTopBackgroundSprite];
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Create background sprites
// -----------------------------------------------------------------------
-(void)createGroundSprite {
    _ground = [CCSprite spriteWithImageNamed:@"pd_ground.png"];
    _ground.anchorPoint = CGPointZero;
    _ground.position = ccp(0, 0);
    _ground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ground.contentSize} cornerRadius:0];
    _ground.physicsBody.type = CCPhysicsBodyTypeStatic;
    _ground.physicsBody.collisionType = @"hellCollision";
    _ground.physicsBody.friction=0.0f;
    _ground.scaleX = 1.0;
    
    [self addChild:_ground];
}
-(void)createCeilingSprite {
    _ceiling = [CCSprite spriteWithImageNamed:@"pd_ground.png"];
    _ceiling.anchorPoint = CGPointZero;
    _ceiling.position = ccp(0, 0);
    _ceiling.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ceiling.contentSize} cornerRadius:0];
    _ceiling.physicsBody.type = CCPhysicsBodyTypeStatic;
    _ceiling.physicsBody.collisionType = @"ceilingCollision";
    _ceiling.physicsBody.friction=0.0f;
    _ceiling.scaleX = 1.2;
    
    [self addChild:_ceiling];
}

-(void)createBackgroundSprite {
    _background1 = [CCSprite spriteWithImageNamed:@"backgroundGameSceneFinalThree.png"];
    _background1.anchorPoint = CGPointZero;
    _background1.position = CGPointZero;
    _background1.physicsBody.friction=0.0f;
    /*
     CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bg1" fontName:@"Verdana-Bold" fontSize:15];
     label.positionType = CCPositionTypeNormalized;
     label.position = ccp(0.5f, 0.5f);
     [_background1 addChild:label];
     */
    _background2 = [CCSprite spriteWithImageNamed:@"backgroundGameSceneFinalThree.png"];
    _background2.anchorPoint = CGPointZero;
    _background2.position = ccp(_background1.contentSize.width-1, 0);
    _background2.physicsBody.friction=0.0f;
    /*
     CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Bg2" fontName:@"Verdana-Bold" fontSize:15];
     label2.positionType = CCPositionTypeNormalized;
     label2.position = ccp(0.5f, 0.5f);
     [_background2 addChild:label2];
     */
    
    [self addChild:_background1];
    [self addChild:_background2];
}

-(void)createTopBackgroundSprite {
    _topBackground = [CCSprite spriteWithImageNamed:@"topBackground.png"];
    _topBackground.anchorPoint = ccp(0, 0);
    _topBackground.position = ccp(0, _screenHeight - _topBackground.contentSize.height);
    _topBackground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _topBackground.contentSize} cornerRadius:0];
    _topBackground.physicsBody.type = CCPhysicsBodyTypeStatic;
    _topBackground.opacity = 0;
    
    [self addChild:_topBackground];
}

+(CCSprite*)generateFlyingGround {
    CCSprite *spr;
    spr = [CCSprite spriteWithImageNamed:@"fly_ground.png"];
    spr.anchorPoint = ccp(0, 0);
    [spr setPhysicsBody:[CCPhysicsBody bodyWithRect:spr.boundingBox cornerRadius:0]];
    spr.physicsBody.type = CCPhysicsBodyTypeStatic;
    spr.physicsBody.friction=0.0f;
 
    spr.physicsBody.collisionType = @"groundCollision";
    
    return spr;
}

@end
