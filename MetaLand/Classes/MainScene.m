//
//  HelloWorldScene.m
//  MetaLand
//
//  Created by Weiwei Zheng on 6/3/14.
//  Copyright Weiwei Zheng 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainScene.h"
#import "IntroScene.h"
#import "ScrollingNode.h"
//#import "SKPhysicsBody.h"


// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation mainScene
{
    CCSprite *_robot;
    CCSprite *_floor;
    CCSprite *_missile;
    CCSprite *_background;
    CCPhysicsNode *_physicsWorld;
    SKScrollingNode *floor;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (mainScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    //[[OALSimpleAudio sharedInstance] playBg:@"background-music-acc.caf" loop:YES];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background z:0];
   
    [self setupBackgroundImage];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.1f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    //Create a physics world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,-50);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addRobot];
    [self createFloor];
    [self addChild:_physicsWorld];
    
    

	return self;
}

//Create our scrolling background
- (void)setupBackgroundImage
{
    //create both sprite to handle background
    _background = [CCSprite spriteWithImageNamed:@"background.jpg"];
    
    _background.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    
    //add them to main layer
    [self addChild:_background z:0];
    
    //add schedule to move backgrounds
    //[self schedule:@selector(scroll:)];
}

-(void)addRobot
{
 //Add robot
 _robot = [CCSprite spriteWithImageNamed:@"robot.png"];
 _robot.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
 _robot.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _robot.contentSize} cornerRadius:0];
 _robot.physicsBody.collisionGroup = @"robotGroup";
 _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorld addChild:_robot z:1];
}

-(void)addCoins:(CCTime)dt
{

}


-(void)addMissle:(CCTime)dt
{
    _missile =[CCSprite spriteWithImageNamed:@"missile.png"];
    
    //Add missile with 20 pixel saved for the 'menu' button
    
    int maxY = self.contentSize.height - _missile.contentSize.height/2-20;
    int minY = _missile.contentSize.height/2+20;
    int rangeY = maxY - minY;
    int randomY = (arc4random()%rangeY)+minY;
    
    _missile.position = CGPointMake(self.contentSize.width + _missile.contentSize.width/2, randomY);
    
    //Add physics body to missile
    
    _missile.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _missile.contentSize} cornerRadius:0];
    _missile.physicsBody.collisionGroup = @"missileGroup";
    _missile.physicsBody.collisionType = @"missileCollision";
    _missile.physicsBody.affectedByGravity=false;
    [_physicsWorld addChild:_missile z:1];
    
    int minDuration = 5;
    int maxDuration = 6;
    int rangeDuration = maxDuration - minDuration;
    int randomDuraion = (arc4random()%rangeDuration)+minDuration;
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuraion position:CGPointMake(-_missile.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [_missile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];

}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot missileCollision:(CCNode *)missile
{
    [missile removeFromParent];
    _robot.physicsBody.allowsRotation=NO;
    [robot removeFromParent];
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot floorCollision:(CCNode *)floor
{
    //[robot removeFromParent];
    _robot.physicsBody.elasticity=1;
    _floor.physicsBody.elasticity=1;
    _floor.physicsBody.allowsRotation=NO;
    return YES;
}

-(void)startGame
{
    
}


- (void)createFloor
{
    _floor=[CCSprite spriteWithImageNamed:@"floor.png"];
    _floor.position=ccp(self.contentSize.width/2, self.contentSize.height/7);
    _floor.scaleY=0.05;
    _floor.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _floor.contentSize} cornerRadius:0];
    _floor.physicsBody.type =CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:_floor z:1];
}
/*
    floor = [ScrollingNode scrollingNodeWithImageNamed:@"floor" inContainerWidth:WIDTH(self)];
    [floor setScrollingSpeed:3];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:floor];
}
*/

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    [self schedule:@selector(addMissle:) interval:0.1];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.5f position: ccp(self.contentSize.width/8,50+self.contentSize.height/2)];
    [_robot runAction:actionMove];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

// -----------------------------------------------------------------------
@end
