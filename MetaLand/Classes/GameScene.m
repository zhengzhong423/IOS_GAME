//
//  GameScene.m
//  MetaLand
//
//  Copyright MetaLand Team 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "Background.h"
#import "Enemies.h"
#import "Rewards.h"
#import "GameScene.h"
#import "GameOverScene.h"
#import "IntroScene.h"
#import "Storescene.h"
#import "PortalScene.h"

#import "Robot.h"
#import "Coin.h"

#import "CCAnimatedSprite.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------

#define SHIELD_NORMAL 0
#define SHIELD_GOLDEN 1

@implementation GameScene {
    CCPhysicsNode *_physicsWorld;
    Background *_background;
    CCSprite *_robot;
    CCSprite *_coin;
    NSUserDefaults *_userDefault;
    
    double _duration;
    
    int _distance;
    int _record;
    int _numOfCoins;
    
    BOOL _isShieldOn;
    BOOL _isBoostOn;
    BOOL _isMagnetOn;
    BOOL _isDoubleOn;
    BOOL _isPortalOn;
    BOOL _isGameOver;
    BOOL _isInvulnerable;
    BOOL _isCoinProgressFull;
    BOOL _recordSignFlag;
    
    
    int _goldenShieldLevel;
    
    int _time;
    int _shieldTime;
    int _boostTime;
    int _magnetTime;
    int _doubleTime;
    int _portalTime;
    
    int _sceneCounter;
    int _targetScene;
    
    float _scrollSpeed;
    float _speedBeforeBoost;
    float _forceUpward;
    float _maxDownwardSpeed;
    
    float _groundInitialY;
    float _ceilingInitialY;
    
    //CCButton *_buttonCoinProgressBar;
    
    CCProgressNode *_coinProgressBar;
    
    //animate
    CCAnimatedSprite *animatedSprite;
    
    //count touch
    int touches;
    int preY;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+(GameScene *)scene {
    return [[self alloc] init];
}

// -----------------------------------------------------------------------
#pragma mark - Initialize the Game Scene
// -----------------------------------------------------------------------
-(id)init {
    // Apple recommend assigning self with supers return value

    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    _duration = 0.0f;
    
    // Set up the datbase
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    //[_userDefault setInteger:350 forKey:@"record"];
    _record = (int)[_userDefault integerForKey:@"record"];
    _targetScene = _record/100;

    
    //Create the physics world
    [self createPhysicsWorld];
    [self initialScrollingBackground];
    [self generateHorizentalGround:_background._background1];
    [self generateRandomGround:_background._background2];
    
    // Add a robot and enemies
    [self addRobot];
    
    // Initilize the variables
    _time = 0;
    _shieldTime = 0;
    _boostTime = 0;
    _magnetTime = 0;
    _doubleTime = 0;
    _portalTime = 0;
    _sceneCounter = 0;
    _goldenShieldLevel = 0;
    
    _isShieldOn = NO;
    _isBoostOn = NO;
    _isMagnetOn = NO;
    _isDoubleOn = NO;
    _isPortalOn = NO;
    _isGameOver = NO;
    _isInvulnerable = NO;
    _recordSignFlag = NO;
    _isCoinProgressFull = NO;
    
    _forceUpward = 0.0f;
    
    //[self performSelector:@selector(boost) withObject:nil afterDelay:2.0f];
    //[self addButtonGoldenShield];
    _scrollSpeed = 5;
    
    // Initialize distance and coin
    _distance = 0;
    _numOfCoins = 0.0f;
    
    //Initialize ground and ceiling position
    _groundInitialY = 20;
    
    //[self boost];
    
    CCLabelTTF* labelDistance = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Distance: %d M", _distance] fontName:@"Verdana-Bold" fontSize:12.0f];
    labelDistance.anchorPoint = ccp(0,0);
    labelDistance.positionType = CCPositionTypeNormalized;
    labelDistance.position = ccp(0.01f,0.95f);
    labelDistance.name = @"labelDistance";
    [self addChild:labelDistance z:9];
    
    // Set record label
    /*CCLabelTTF* labelRecord;
    _record = [[_userDefault objectForKey:@"record"] intValue];
    if (_record) {
        labelRecord = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Record: %d M", _record] fontName:@"Verdana-Bold" fontSize:15.0f];
    }
    else {
        labelRecord = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Record: %d M", 0] fontName:@"Verdana-Bold" fontSize:15.0f];
    }
    labelRecord.positionType = CCPositionTypeNormalized;
    labelRecord.position = ccp(0.40f, 0.95f);
    labelRecord.name = @"labelRecord";
    [self addChild:labelRecord z:9];
    */
    // Add the label for coins
    CCLabelTTF* labelCoin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins] fontName:@"Verdana-Bold" fontSize:10.0f];
    labelCoin.anchorPoint = ccp(0,0);
    labelCoin.positionType = CCPositionTypeNormalized;
    labelCoin.position = ccp(0.01f,0.90f);
    labelCoin.name = @"labelCoin";
    [self addChild:labelCoin z:9];
    
    // Add the buttons in the game UI
    [self addButtonPause];
    [self addButtonSoundControl];
    [self addButtonJump];
    [self addCoinProgressBar];
    
    [self generateStaticObstacles:_background._background2];
    [self schedule:@selector(tick) interval:0.1];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Initial the Physics World
// -----------------------------------------------------------------------
-(void)createPhysicsWorld {
    //Create physics-world
    _physicsWorld = [CCPhysicsNode node];

    _physicsWorld.gravity = ccp(0, -500.0f);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
}

-(void)initialScrollingBackground {
    _background = [Background node];
    
    _groundInitialY = 20;
    _ceilingInitialY = [_background._background1 boundingBox].size.height;
    _background._ceiling.position = ccp(0,_ceilingInitialY);
    
    if (_targetScene==0)
        [self addRecordSign:_background._background1];
    else if(_targetScene==1)
        [self addRecordSign:_background._background2];
    
    [_physicsWorld addChild:_background];
}

// -----------------------------------------------------------------------
#pragma mark - Add sprites
// -----------------------------------------------------------------------
-(void)addRobot {
    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
    _robot.position  = ccp(self.contentSize.width/4, _background._ground.contentSize.height + _groundInitialY + _robot.contentSize.height / 2);
    _robot.physicsBody.allowsRotation = false;
    _robot.physicsBody.friction = 0.0f;
    [_physicsWorld addChild:_robot z:1];
}

-(void)addRobotAfterPortal {
    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
    _robot.position = ccp(self.contentSize.width/4 - _robot.contentSize.width/2 - 15, _background._ground.contentSize.height + _groundInitialY + _robot.contentSize.height / 2);
    CCAction *moveOut = [CCActionMoveBy actionWithDuration:1 position:ccp(15, 0)];
    [_robot runAction:moveOut];
    if (_isShieldOn) {
        [self getShield];
    }
    else if (_goldenShieldLevel > 0) {
        if (_goldenShieldLevel == 3) {
            [self getGoldenShield];
        }
        else if (_goldenShieldLevel == 2) {
            [self getGoldenShield];
            _goldenShieldLevel = 2;
           // [_robot getChildByName:@"goldenShield" recursively:NO].opacity = 0.7;
        }
        else {
            [self getGoldenShield];
            _goldenShieldLevel = 1;
            //[_robot getChildByName:@"goldenShield" recursively:NO].opacity = 0.3;
        }
    }
    _robot.physicsBody.allowsRotation = false;
    _robot.physicsBody.friction = 0.0f;
    [_physicsWorld addChild:_robot z:1];
    
}

-(void)addRobotdie:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_DIE];
    _robot.position = ccp( px, py );
    _robot.physicsBody.collisionGroup = @"gameSceneGroup";
    [_physicsWorld addChild:_robot z:1];
}

-(void)addRobotshoted:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_SHOTED];
    _robot.position = ccp( px, py );
    _robot.physicsBody.collisionGroup = @"gameSceneGroup";
    [_physicsWorld addChild:_robot z:1];
}

-(void)generateItem {
    float willMagnetBeGenerated = arc4random()%1000000/1000000.0f;
    
    if (willMagnetBeGenerated >= 0.005) {
        return;
    }
    
    if (_isMagnetOn) {
        [self generateBoost];
    }
    //else if (_isBoostOn) {
     //   [self generateMagnet];
    //}
    else {
        //if(arc4random()%100/100.0f <= 0.5f){
        //    [self generateMagnet];
        //}
        //else{
            [self generateBoost];
        //}
    }
}
/*
-(void)generateMagnet {
    CCSprite *magnet = [Rewards magnetInit];
    //magnet.positionType = CCPositionTypeNormalized;
    magnet.position = ccp(self.contentSize.width+magnet.contentSize.width, self.contentSize.height/2);
    
    ccBezierConfig bezierUp;
    bezierUp.controlPoint_1 = ccp(-160, 80);
    bezierUp.controlPoint_2 = ccp(-170, 80);
    bezierUp.endPosition = ccp(-360,0);
    
    ccBezierConfig bezierDown;
    bezierDown.controlPoint_1 = ccp(-160, -80);
    bezierDown.controlPoint_2 = ccp(-170, -80);
    bezierDown.endPosition = ccp(-360,0);
    CCActionBezierBy *actionUp = [CCActionBezierBy actionWithDuration:3 bezier:bezierUp];
    CCActionBezierBy *actionDown = [CCActionBezierBy actionWithDuration:3 bezier:bezierDown];
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{
        [magnet stopAllActions];
    }];
    CCActionCallBlock *actionAfterMoving = [CCActionCallBlock actionWithBlock:^{
        [magnet removeFromParentAndCleanup:YES];
    }];
    [magnet runAction:[CCActionSequence actions:actionUp, actionDown, actionUp, actionDown, block, actionAfterMoving,nil]];
    
    [_physicsWorld addChild:magnet z:1];
    
}
 */

-(void)generateBoost {
    CCSprite *boost = [Rewards boostInit];
    boost.position = ccp(self.contentSize.width+boost.contentSize.width, self.contentSize.height/2);
    
    ccBezierConfig bezierUp;
    bezierUp.controlPoint_1 = ccp(-160, 80);
    bezierUp.controlPoint_2 = ccp(-170, 80);
    bezierUp.endPosition = ccp(-360,0);
    
    ccBezierConfig bezierDown;
    bezierDown.controlPoint_1 = ccp(-160, -80);
    bezierDown.controlPoint_2 = ccp(-170, -80);
    bezierDown.endPosition = ccp(-360,0);
    CCActionBezierBy *actionUp = [CCActionBezierBy actionWithDuration:3 bezier:bezierUp];
    CCActionBezierBy *actionDown = [CCActionBezierBy actionWithDuration:3 bezier:bezierDown];
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{
        [boost stopAllActions];
    }];
    CCActionCallBlock *actionAfterMoving = [CCActionCallBlock actionWithBlock:^{
        [boost removeFromParentAndCleanup:YES];
    }];
    [boost runAction:[CCActionSequence actions:actionUp, actionDown, actionUp, actionDown, block, actionAfterMoving,nil]];
    _robot.physicsBody.allowsRotation = false;
    [_physicsWorld addChild:boost z:1];
    
}

-(void)generateRandomMissile {
    float willMissileBeGenerated = arc4random()%1000000/1000000.0f;
    
    if (willMissileBeGenerated >= 0.002 || _isBoostOn) {
        return;
    }
    
    CCSprite *missile;
    CCAction *actionMove;
    //OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    
    // Set random missile position
    int maxY = self.contentSize.height - missile.contentSize.height - _background._topBackground.contentSize.height;
    int minY = _groundInitialY + _background._ground.contentSize.height+_groundInitialY;
    int randomY = [self random:minY withArg2:maxY];
    
    //float typeFlag = arc4random()%100/100.0f;
    //CCSprite* warningLine = [CCSprite spriteWithImageNamed:@"flashline.png"];
    CCSprite* warning = [CCSprite spriteWithImageNamed:@"warning.png"];

        missile = [Enemies missileInit:MISSILE_NORMAL];
        //[audio playEffect:@"warning.wav"];

        actionMove = [CCActionMoveBy actionWithDuration:1 position:ccp(-_background._background1.contentSize.width-2*missile.contentSize.width,0)];
        
        
       // warningLine.anchorPoint = ccp(0,0);
        //warningLine.position = ccp(0,randomY+10);
        
//        warning.anchorPoint = ccp(0, 0);
//        warning.position = ccp(self.contentSize.width - warning.contentSize.width, randomY);
//        CCAction* actionFadeOut = [CCActionFadeOut actionWithDuration:.4f];
//        CCAction* actionFadeIn = [CCActionFadeIn actionWithDuration:.4f];
//        CCActionCallBlock* callBlock = [CCActionCallBlock actionWithBlock:^{
//            //warning.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"warning_missile_normal_2.png"];
//            [self performSelector:@selector(changeWarning:) withObject:warning];
//        }];
    
        missile.position = ccp(self.contentSize.width + warning.contentSize.width + missile.contentSize.width, warning.position.y);
        
        //CCAction *warningDelay = [CCActionDelay actionWithDuration:.5f];
        //CCAction *warningRemove = [CCActionRemove action];
        //[warning runAction:[CCActionSequence actionWithArray:@[actionFadeOut, actionFadeIn, actionFadeOut, callBlock, actionFadeIn, warningDelay, warningRemove]]];
        //[warningLine runAction:[CCActionSequence actionWithArray:@[actionFadeOut,actionFadeIn,actionFadeOut,actionFadeIn,warningDelay,warningRemove]]];
        //[self addChild:warning z:2];
        //[self addChild:warningLine z:2];
    
    
    
    
    
    
    //avoid missiles are generated so closed that they would interfere each other
    int counter=0;
    while(counter<_physicsWorld.children.count) {
        for (CCSprite* spr in _physicsWorld.children) {
            counter++;
            if( CGRectContainsPoint(CGRectMake(spr.boundingBox.origin.x, spr.boundingBox.origin.y-missile.contentSize.height*.5, spr.boundingBox.size.width, spr.boundingBox.size.height+missile.contentSize.height*.5), missile.position)) {
                randomY = [self random:minY withArg2:maxY];
                missile.position = ccp(self.contentSize.width + warning.contentSize.width + missile.contentSize.width, randomY);
                counter=0;
            }
        }
    }
    
    // Set missile move action with random speed
    CCAction *actionRemove = [CCActionRemove action];
    CCAction *actionDelay = [CCActionDelay actionWithDuration:2];
    CCActionCallBlock *actionAfterMoving = [CCActionCallBlock actionWithBlock:^{
        [missile removeFromParentAndCleanup:YES];
    }];
    [missile runAction:[CCActionSequence actionWithArray:@[actionDelay, actionMove, actionRemove, actionAfterMoving]]];

    // Add missile to the physics world
    [_physicsWorld addChild:missile z:1];
    
}

-(void)addCoinProgressBar {
    _coinProgressBar = [CCProgressNode progressWithSprite:[CCSprite spriteWithImageNamed:@"progressBar.png"]];
    _coinProgressBar.type = CCProgressNodeTypeBar;
    //_coinProgressBar.rotation = 0;
    _coinProgressBar.midpoint = ccp(0, 0);
    _coinProgressBar.barChangeRate = ccp(1, 0);
    _coinProgressBar.positionType = CCPositionTypeNormalized;
    _coinProgressBar.position = ccp(0.15f, 0.84f);
    _coinProgressBar.name = @"coinProgressBar";
    [self addChild:_coinProgressBar z:0];
    
    CCSprite *border = [CCSprite spriteWithImageNamed:@"progressBarFrame.png"];
    border.position = ccp(0, 0);
    border.anchorPoint = ccp(0.15, 0.35);
    [_coinProgressBar addChild:border z:9];

    /*
    CCSpriteFrame *progressBarFrame = [CCSpriteFrame frameWithImageNamed:@"progressBarFrame.png"];
    _buttonCoinProgressBar = [CCButton buttonWithTitle:nil spriteFrame:progressBarFrame];
    _buttonCoinProgressBar.position = ccp(0, 0);
    _buttonCoinProgressBar.anchorPoint = ccp(0, 0);
    _buttonCoinProgressBar.name = @"buttonGoldenShield";
    _buttonCoinProgressBar.enabled = NO;
    [_coinProgressBar addChild:_buttonCoinProgressBar z:9];
    [_buttonCoinProgressBar setTarget:self selector:@selector(onProgressBarClicked:)];
     */
}

// -----------------------------------------------------------------------
#pragma mark - Update function
// -----------------------------------------------------------------------
-(void)update:(CCTime)delta {
    /*
    if (_coinProgressBar.percentage >= 100.0/3.0) {
        _buttonCoinProgressBar.enabled = YES;
    }
     */
    //detect if fall down
    
    _robot.rotation=0.0f;
    
    if(_robot.position.y < -10) {
        [self died];
    }
    if(!_isGameOver)
    {
        
        if(_robot.position.x<self.contentSize.width/5)
        {
            CCAction *move = [CCActionMoveBy actionWithDuration:0.3f position:ccp(15, 0)];
            [_robot runAction:move];
        }
    
        if(_robot.position.x > self.contentSize.width/3)
        {
            CCAction *move = [CCActionMoveBy actionWithDuration:0.3f position:ccp(15, 0)];
            [_robot runAction:move];
        }
    }
    
    if (_isPortalOn) {
        self.userInteractionEnabled = NO;
    }
    else {
        self.userInteractionEnabled = YES;
    }
    
    if (_robot.physicsBody.velocity.x) {
        _robot.physicsBody.velocity = ccp(0, _robot.physicsBody.velocity.y);
    }
    
    if (!_isBoostOn && !_isPortalOn && !_isGameOver ) {
        _scrollSpeed += 0.001;
    }
  
    if (_scrollSpeed > 10) {
        _scrollSpeed = 10;
    }
    
    _maxDownwardSpeed = -100 - _scrollSpeed * 20;
    

    
    [self generateRandomMissile];
    
    [self backgroundScroll : _scrollSpeed];
    
    [self coinDetection];
    
    
    // Magnet effect
    if (_isMagnetOn && !_isPortalOn ) {
        for (CCSprite *temp in _background._background1.children) {
            if ([temp.name isEqualToString:@"coinGroup"]) {
                for (CCSprite *sprite in temp.children) {
                    float distance = ccpDistance([temp convertToNodeSpace:_robot.position], sprite.position);
                    if (distance < 60) {
                        _duration = 0.005*distance/5.0f;
                        CCAction *action = [CCActionMoveBy actionWithDuration:_duration position: ccp(([temp convertToNodeSpace:_robot.position].x-sprite.position.x)/5, ([temp convertToNodeSpace:_robot.position].y-sprite.position.y)/5)];
                        CCAction *blockChangeAction = [CCActionCallBlock actionWithBlock:^{
                            _duration /= 5.0f;
                            CCAction *action = [CCActionMoveBy actionWithDuration:_duration position:ccp(([temp convertToNodeSpace:_robot.position].x-sprite.position.x)/5, ([temp convertToNodeSpace:_robot.position].y-sprite.position.y)/5)];
                            [sprite runAction:action];
                        }];
                        CCAction *blockRemove = [CCActionCallBlock actionWithBlock:^{
                            [self coinRemove:sprite];
                        }];
                        [sprite runAction:[CCActionSequence actionWithArray:@[action,blockChangeAction,blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockRemove]]];
                        
                    }
                }
            }
        }
        for (CCSprite *temp in _background._background2.children) {
            if ([temp.name isEqualToString:@"coinGroup"]) {
                for (CCSprite *sprite in temp.children) {
                    float distance = ccpDistance([temp convertToNodeSpace:_robot.position], sprite.position);
                    if (distance < 60) {
                        
                        _duration = 0.005*distance/5.0f;
                        CCAction *action = [CCActionMoveBy actionWithDuration:_duration position:ccp(([temp convertToNodeSpace:_robot.position].x-sprite.position.x)/5, ([temp convertToNodeSpace:_robot.position].y-sprite.position.y)/5)];
                        
                        CCAction *blockChangeAction = [CCActionCallBlock actionWithBlock:^{
                            _duration/=5.0f;
                            CCAction *action = [CCActionMoveBy actionWithDuration:_duration position:ccp(([temp convertToNodeSpace:_robot.position].x-sprite.position.x)/5, ([temp convertToNodeSpace:_robot.position].y-sprite.position.y)/5)];
                            [sprite runAction:action];
                        }];
                        CCAction *blockRemove = [CCActionCallBlock actionWithBlock:^{
                            [self coinRemove:sprite];
                        }];
                        [sprite runAction:[CCActionSequence actionWithArray:@[action,blockChangeAction,blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockChangeAction, blockRemove]]];

                    }
                }
            }
        }
        
        _magnetTime++;
        // Magnet effect last for 20 seconds
        if (_magnetTime == 1200) {
            _isMagnetOn = NO;
            _magnetTime = 0;
        }
    }
    
}
-(void)screenShake {
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.05f position:ccp(-5, 5)];
    CCActionInterval *reverseMovement = [moveBy reverse];
    CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement,moveBy,reverseMovement,moveBy,reverseMovement,moveBy, reverseMovement,moveBy,reverseMovement,moveBy,reverseMovement]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
    [self runAction:bounce];
}

-(void)coinRemove:(CCNode*) sprite {
    // Sound effect
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"Pickup_Coin.wav"];
    
    [sprite stopAllActions];
    [sprite removeFromParentAndCleanup:YES];
    
    _numOfCoins++;
    if (!_isCoinProgressFull) {
        //_coinProgressBar.percentage += 20;
        _coinProgressBar.percentage += 100.0/150.0;
        
        if (_coinProgressBar.percentage >= 100) {
            _isCoinProgressFull = YES;
        }
    }
    
    [(CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO] setString:[NSString stringWithFormat:@"Coin: %d",_numOfCoins]];
}

-(void)getShield {
    _isShieldOn = YES;
    CCSprite *shield = [CCSprite spriteWithImageNamed:@"normalShield.png"];
    shield.name = @"shield";
    shield.positionType = CCPositionTypeNormalized;
    shield.position = ccp(0.5f, 0.5f);
    [_robot addChild:shield];
}

-(void)getGoldenShield {
    CCSprite *shield = [CCSprite spriteWithImageNamed:@"goldenShield.png"];
    shield.name = @"goldenShield";
    shield.positionType = CCPositionTypeNormalized;
    shield.position = ccp(0.5f, 0.5f);
    [_robot addChild:shield];
    
    //if (_goldenShieldLevel == 2) {
        //shield.opacity= 0.7f;
   // }
   // else if (_goldenShieldLevel == 1) {
       // shield.opacity = 0.6f;
    //}
}
/*
-(void)getBoostShield {
    //CCSprite *shield = [CCSprite spriteWithImageNamed:@"shieldGreen.png"];
    //shield.name = @"boostShield";
    //shield.positionType = CCPositionTypeNormalized;
    //shield.position = ccp(0.5f, 0.5f);
    //[_robot addChild:shield];
}
*/
-(void)loseShield {
    [self screenShake];
    if (_isShieldOn) {
        _isShieldOn = NO;
    }
    [_robot removeAllChildrenWithCleanup:YES];
    
}

// -----------------------------------------------------------------------
#pragma mark - Collision Handler
// -----------------------------------------------------------------------
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot missileCollision:(CCNode *)missile {
  //  return NO;
    if (!strcmp([missile.name UTF8String] , "goldenMissile")) {
        CCAction *actionFall = [CCActionMoveTo actionWithDuration:0.5 position:CGPointMake(missile.position.x, 20)];
        CCAction *actionFallRemove = [CCActionRemove action];
        [_robot.physicsBody applyImpulse:ccp(0, 0.2f)];
        missile.physicsBody.allowsRotation = YES;
        [missile runAction:[CCActionSequence actionWithArray:@[actionFall,actionFallRemove]]];
        
        [self boost];
        
        return NO;
    }
    
    [missile removeFromParentAndCleanup:YES];
    if (_isBoostOn) {
        [self screenShake];
        return NO;
    }
    else if (_isShieldOn) {
        [self loseShield];
        return NO;
    }
    else if (_goldenShieldLevel > 0) {
        _goldenShieldLevel--;
        //[_robot getChildByName:@"goldenShield" recursively:NO].opacity -= 0.3;
        
        if (_goldenShieldLevel == 0) {
            [self loseShield];
        }
        return NO;
    }
    else {
        // Sound effect
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"Explosion.wav"];
        
        CGFloat x = robot.position.x;
        CGFloat y = robot.position.y;
        [_robot removeFromParentAndCleanup:YES];
        [self addRobotshoted: x andNb: y];
        [missile removeFromParent];
        
        [_userDefault setObject:[NSString stringWithFormat:@"%d", _distance] forKey:@"distance"];
        [_userDefault synchronize];

        [self died];
        return YES;
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot obstacleCollision:(CCNode *)obstacle {
  //  return NO;
    [obstacle removeFromParentAndCleanup:YES];
    if (_isBoostOn) {
        [self screenShake];
        return NO;
    }
    else if (_isShieldOn) {
        [self loseShield];
        return NO;
    }
    else if (_goldenShieldLevel > 0) {
        _goldenShieldLevel--;
        [_robot getChildByName:@"goldenShield" recursively:NO].opacity -= 0.3;
        
        if (_goldenShieldLevel == 0) {
            [self loseShield];
        }
        [self screenShake];
        return NO;
    }
    else {
        // Sound effect
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"eletricshock.wav"];
        
        //add
        CGFloat x = robot.position.x;
        CGFloat y = robot.position.y;
        [_robot removeFromParentAndCleanup:YES];
        [self addRobotdie: x andNb: y];
        [obstacle removeFromParent];
        
        
        [_userDefault setObject:[NSString stringWithFormat:@"%d", _distance] forKey:@"distance"];
        [_userDefault synchronize];
        
        //[self performSelector:@selector(gameOver) withObject:nil afterDelay:0.5f];
        [self died];
        return YES;
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot groundCollision:(CCNode *)ground
{
    robot.physicsBody.friction=0.0f;
    ground.physicsBody.friction=0.0f;
    
    if( _isGameOver )
        return YES;
    if (robot.position.y<ground.position.y || _isBoostOn) {
        return NO;
    }
    touches=0;
    CGFloat x = _robot.position.x;
    CGFloat y = _robot.position.y;
    [_robot removeFromParentAndCleanup:YES];
    [self addRobotBackToRun:x andNb:y];
    
    return YES;
}

//colission between robot and lower ground -- to die
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot hellCollision:(CCNode *)hell
{
    //add
    CGFloat x = robot.position.x;
    CGFloat y = robot.position.y;
    [_robot removeFromParentAndCleanup:YES];
    [self addRobotdie: x andNb: y];
    [self died];
    
    return YES;
}

//colission between robot and ceiling
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot ceilingCollision:(CCNode *)ceiling
{
    
    return YES;
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot magnetCollision:(CCNode *)magnet{
    if (!_isMagnetOn) {
        [self magnet];
    }
    [magnet removeFromParentAndCleanup:YES];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot boostCollision:(CCNode *)boost{
    if (!_isBoostOn) {
        [self boost];
    }
    [boost removeFromParentAndCleanup:YES];
    return NO;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot portalCollision:(CCNode *)portal {
    if (_isBoostOn) {
        return NO;
    }
    _isPortalOn = YES;
    [portal removeFromParentAndCleanup:YES];
    [robot removeFromParentAndCleanup:YES];

    _speedBeforeBoost = _scrollSpeed;
    _scrollSpeed = 0;
    
    [_userDefault setInteger:_numOfCoins forKey:@"numOfCoins"];
    [_userDefault setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
    [_userDefault setBool:_isShieldOn forKey:@"isShieldOn"];
    [_userDefault setInteger:_goldenShieldLevel forKey:@"goldenShieldLevel"];
    [_userDefault setFloat:_coinProgressBar.percentage forKey:@"coinProgressPercentage"];
    [_userDefault synchronize];

    [[CCDirector sharedDirector] pushScene:[PortalScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot starCollision:(CCNode *)star {
    _numOfCoins += 15;
    [star removeFromParentAndCleanup:YES];
    [(CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO] setString:[NSString stringWithFormat:@"Coin: %d",_numOfCoins]];
    
    if (!_isCoinProgressFull) {
        _coinProgressBar.percentage += 15*100.0/150.0;

        if (_coinProgressBar.percentage >= 100.0) {
            _isCoinProgressFull = YES;
        }
    }
    return NO;
}
//
//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot obstacleCollision:(CCNode *)obstacle {
//    return NO;
//}
//
//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot missileCollision:(CCNode *)missile {
//    return NO;
//}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot portalCollision:(CCNode *)portal {
    
    [portal removeFromParentAndCleanup:YES];
    [robot removeFromParentAndCleanup:YES];
    
    _isPortalOn = YES;
    _speedBeforeBoost = _scrollSpeed;
    _scrollSpeed = 0;
    
    [_userDefault setInteger:_numOfCoins forKey:@"numOfCoins"];
    [_userDefault setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
    [_userDefault setBool:_isShieldOn forKey:@"isShieldOn"];
    [_userDefault synchronize];
    
    [[CCDirector sharedDirector] pushScene:[PortalScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot magnetCollision:(CCNode *)magnet{
    
    [self magnet];
    [magnet removeFromParentAndCleanup:YES];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot boostCollision:(CCNode *)boost{
    if (!_isBoostOn) {
        [self boost];
    }
    [boost removeFromParentAndCleanup:YES];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair superRobotCollision:(CCNode *)robot starCollision:(CCNode *)star {
    _numOfCoins += 15;
    [star removeFromParentAndCleanup:YES];
    [(CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO] setString:[NSString stringWithFormat:@"Coin: %d",_numOfCoins]];
    
    if (!_isCoinProgressFull) {
        _coinProgressBar.percentage += 15*100.0/150.0;
        if (_coinProgressBar.percentage >= 100.0) {
            _isCoinProgressFull = YES;
        }
    }
    return NO;
}

// -----------------------------------------------------------------------
#pragma mark - Game Over
// -----------------------------------------------------------------------
-(void)died {
    _isGameOver = YES;
}

-(void)afterLife {
    [self unscheduleAllSelectors];
    [self lottery];
}

-(void)lottery {
    CCNodeColor *lotteryLayer = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(255, 0, 0, 255)] width:400 height:200];
    lotteryLayer.name = @"LayerLottery";
    lotteryLayer.positionType = CCPositionTypeNormalized;
    lotteryLayer.position = ccp(0.5f, 0.5f);
    lotteryLayer.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:lotteryLayer z:9];
    
    CCButton *btnFinish = [CCButton buttonWithTitle:@"BACK"];
    btnFinish.positionType = CCPositionTypeNormalized;
    btnFinish.position = ccp(0.5f, 0.5f);
    [btnFinish setTarget:self selector:@selector(onFinishClicked:)];
    [lotteryLayer addChild:btnFinish];
}

-(void)gameOver {
    // Update the record
    if (_distance > _record) {
        _record = _distance;
        //[(CCLabelTTF*)[self getChildByName:@"labelRecord" recursively:NO] setString:[NSString stringWithFormat:@"Record: %d", _distance]];
        [_userDefault setInteger:_record forKey:@"record"];
        [_userDefault synchronize];
    }
    
    [_userDefault setInteger:_distance forKey:@"distance"];
    [_userDefault setInteger:_numOfCoins forKey:@"numOfCoins"];
    [_userDefault synchronize];
    
    [[CCDirector sharedDirector] replaceScene:[GameOverScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];

}

//Selectors
-(void)changeWarning : (CCSprite*)warning {
    warning.texture = ((CCSprite*)[CCSprite spriteWithImageNamed:@"warning_missile_normal_2.png"]).texture;
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    //CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    //[_robot.physicsBody applyForce:ccp(0, 2000)];
    // Move the robot upward
    /*
    if(_scrollSpeed < 6) {
        [_robot.physicsBody applyImpulse:ccp(0,0.05f)];
    }
    else {
        [_robot.physicsBody applyImpulse:ccp(0,0.1f)];
        
    }*/
    if(_isBoostOn)
        return;
    if (!_isGameOver) {
        
        touches++;
        if  (touches==2)
        {
            _robot.physicsBody.velocity=ccp(0.0f, 0.0f);
            [_robot.physicsBody applyForce:ccp(0,15.0f)];
            return;
        }
        if (touches==3) {
            CGFloat px = _robot.position.x;
            CGFloat py = _robot.position.y;
            
            [_robot removeFromParentAndCleanup:YES];
            _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
            _robot.position = ccp(px, py);
            _robot.physicsBody.collisionGroup = @"robotGroup";
            _robot.physicsBody.collisionType = @"robotCollision";
            
            [_physicsWorld addChild:_robot z:1];
            [self schedule:@selector(applyForceWhenTouched) interval:1.0f/10.0f];
            return;
        }
        if(touches>=3)
            return;
        
//        CGFloat x = self.contentSize.width/4;
//        CGFloat y = _robot.position.y;
//        if(!_isBoostOn){
//            [_robot removeFromParentAndCleanup:YES];
//            [self addRobotJump:x andNb:y];
//        }else{
//            [_robot removeFromParentAndCleanup:YES];
//
//            [self addRobotBoost:x andNb:y];
//        }
//        
//        if(_scrollSpeed < 6) {
//            [_robot.physicsBody applyImpulse:ccp(0,0.05f)];
//        }
//        else {
//            [_robot.physicsBody applyImpulse:ccp(0,0.1f)];
//        }
        [_robot.physicsBody applyForce:ccp(0,14.0f)];
        _robot.physicsBody.velocity=CGPointZero;
        
    }
    else {
        self.userInteractionEnabled = NO;
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (touches>=3) {
        [self unschedule:@selector(applyForceWhenTouched)];

    }
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self whenTouchEndedORCancelled];
}

-(void)whenTouchEndedORCancelled
{
    [self unschedule:@selector(applyForceWhenTouched)];
    
    if(!_isGameOver) {
        [_robot removeFromParentAndCleanup:YES];
        
        if(!_isPortalOn) {
            CGFloat x = _robot.position.x;
            CGFloat y = _robot.position.y;
            
            if(_isBoostOn){
                [_robot removeFromParentAndCleanup:YES];
                
                [self addRobotBoost:x andNb:y];
                
            }
            else{
                [_robot removeFromParentAndCleanup:YES];
                [self addRobotFall:x andNb:y];
            }
            
            
            if(_scrollSpeed < 6) {
                [_robot.physicsBody applyImpulse:ccp(0,0.05f)];
            }
            else {
                [_robot.physicsBody applyImpulse:ccp(0,0.1f)];
            }
        }
        
    }
    else {
        self.userInteractionEnabled = NO;
    }
    float forceDownward;
    forceDownward = -1.0f - _scrollSpeed * 0.8f;
    [_robot.physicsBody applyForce:ccp(0, forceDownward)];
    if (forceDownward < -5.0f) {
        [_robot.physicsBody applyForce:ccp(0,5.0f)];
    }

}

-(void)addRobotJump:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
    _robot.position = ccp(px, py);
    [_physicsWorld addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self getShield];
    }
    else if (_goldenShieldLevel) {
        [self getGoldenShield];
    }
    //else if (_isBoostOn) {
       // [self getBoostShield];
    //}
   // else if (_isInvulnerable) {
        //_robot.opacity = 0.5f;
    //}
}

-(void)addRobotBackToRun:(CGFloat) px andNb:(CGFloat) py {
    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
    _robot.physicsBody.allowsRotation=false;
    _robot.position = ccp(px, py);
    [_physicsWorld addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self getShield];
    }
    else if (_goldenShieldLevel) {
        [self getGoldenShield];
    }
    //else if (_isBoostOn) {
      //  [self getBoostShield];
   // }
    //else if (_isInvulnerable) {
     //   _robot.opacity = 0.5f;
   // }
}
-(void)addRobotBoost:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_BOOST];
    _robot.position = ccp(px, py);
    _robot.physicsBody.affectedByGravity=false;
    [_physicsWorld addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self getShield];
    }
    else if (_goldenShieldLevel) {
        [self getGoldenShield];
    }
    //else if (_isBoostOn) {
     //   [self getBoostShield];
    //}
    //else if (_isInvulnerable) {
       // _robot.opacity = 0.5f;
   // }
}

-(void)addRobotFall:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_FALL];
    _robot.position = ccp(px, py);
    [_physicsWorld addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self getShield];
    }
    else if (_goldenShieldLevel) {
        [self getGoldenShield];
    }
    //else if (_isBoostOn) {
    //    [self getBoostShield];
    //}
    //else if (_isInvulnerable) {
      //  _robot.opacity = 0.5f;
   // }
}



// -----------------------------------------------------------------------
#pragma mark - Add Buttons
// -----------------------------------------------------------------------
-(void)addButtonJump {
    CCSpriteFrame *jumpFrame = [CCSpriteFrame frameWithImageNamed:@"jump.png"];
    CCButton *buttonJump = [CCButton buttonWithTitle:nil spriteFrame:jumpFrame];
    buttonJump.positionType = CCPositionTypeNormalized;
    buttonJump.position = ccp(0.15f, 0.15f); // Top Right of screen
    buttonJump.name = @"buttonJump";
//    [buttonJump setTarget:self selector:@selector(onJumpClicked:)];
    [self addChild:buttonJump z:9];
}

-(void)addButtonPause {
    CCSpriteFrame *pauseFrame = [CCSpriteFrame frameWithImageNamed:@"pause.png"];
    CCButton *buttonPause = [CCButton buttonWithTitle:nil spriteFrame:pauseFrame];
    buttonPause.positionType = CCPositionTypeNormalized;
    buttonPause.position = ccp(0.95f, 0.95f); // Top Right of screen
    buttonPause.name = @"buttonPause";
    [buttonPause setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:buttonPause z:0];
}

-(void)addButtonSoundControl {
    CCSpriteFrame *soundFrame = [CCSpriteFrame frameWithImageNamed:@"sound.png"];
    CCSpriteFrame *muteFrame = [CCSpriteFrame frameWithImageNamed:@"mute.png"];
    CCButton *buttonSound;
    if ([[OALSimpleAudio sharedInstance] muted]) {
        buttonSound = [CCButton buttonWithTitle:nil spriteFrame:muteFrame];
    }
    else {
        buttonSound = [CCButton buttonWithTitle:nil spriteFrame:soundFrame];
    }
    buttonSound.positionType = CCPositionTypeNormalized;
    buttonSound.position = ccp(0.90f, 0.95f); // Top Right of screen
    buttonSound.name = @"buttonSound";
    [buttonSound setTarget:self selector:@selector(onSoundClicked:)];
    [self addChild:buttonSound z:0];
}

-(void)addButtonResume {
    CCButton* buttonResume = [CCButton buttonWithTitle:@"[ Resume ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    //CCButton *buttonResume = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"resume.png"]];
    buttonResume.positionType = CCPositionTypeNormalized;
    buttonResume.position = ccp(0.5, 0.6f);
    buttonResume.name = @"buttonResume";
    [buttonResume setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:buttonResume z:0];
}

-(void)addButtonRestart {
    CCButton* buttonRestart = [CCButton buttonWithTitle:@"[ Restart ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    //CCButton *buttonRestart = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"restart.png"]];

    buttonRestart.positionType = CCPositionTypeNormalized;
    buttonRestart.position = ccp(0.5, 0.5f);
    buttonRestart.name = @"buttonRestart";
    [buttonRestart setTarget:self selector:@selector(onRestartClicked:)];
    [self addChild:buttonRestart z:0];
}

-(void)addButtonQuit {
    CCButton* buttonQuit = [CCButton buttonWithTitle:@"[ Quit ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    //CCButton *buttonQuit = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"quit.png"]];
    buttonQuit.positionType = CCPositionTypeNormalized;
    buttonQuit.position = ccp(0.5, 0.4f);
    buttonQuit.name = @"buttonQuit";
    [buttonQuit setTarget:self selector:@selector(onQuitClicked:)];
    [self addChild:buttonQuit z:0];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------
-(void)onJumpClicked:(id)sender {
    [self jump];
}


-(void)onPauseClicked:(id)sender {
    // Pause the game
    self.userInteractionEnabled = NO;
    [[CCDirector sharedDirector] pause];
    
    // Remove the pause button
    [[self getChildByName:@"buttonPause" recursively:NO] removeFromParentAndCleanup:YES];
    
    // Add buttons in pause menu
    [self addButtonResume];
    [self addButtonRestart];
    [self addButtonQuit];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    audio.paused = YES;
}

-(void)onResumeClicked:(id)sender {
    // Resume the game and remove the buttons
    self.userInteractionEnabled = YES;
    [self addButtonPause];
    [[self getChildByName:@"buttonResume" recursively:NO] removeFromParentAndCleanup:YES];
    [[self getChildByName:@"buttonRestart" recursively:NO] removeFromParentAndCleanup:YES];
    [[self getChildByName:@"buttonQuit" recursively:NO] removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] resume];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    audio.paused = NO;
}

-(void)onRestartClicked:(id)sender {
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio stopEverything];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    [[CCDirector sharedDirector] resume];
}

-(void)onQuitClicked:(id)sender {
    // Go to intro scene
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    [[CCDirector sharedDirector] resume];
}

-(void)onSoundClicked:(id)sender {
    if ([[OALSimpleAudio sharedInstance] muted]) {
        // This will unmute the sound
        [[OALSimpleAudio sharedInstance] setMuted:0];
    }
    else {
        //This will mute the sound
        [[OALSimpleAudio sharedInstance] setMuted:1];
    }
    [self removeChildByName:@"buttonSound" cleanup:YES];
    [self addButtonSoundControl];
}

-(void)onNormalShieldClicked:(id)sender
{
    if (_isShieldOn || _goldenShieldLevel > 0 || _isBoostOn) {
        return;
    }
    
    if (_coinProgressBar.percentage >= 100.0/3.0) {
        _coinProgressBar.percentage -= 100.0/3.0;
        _numOfCoins -= 50;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        [self getShield];
    }
    
    [[self getChildByName:@"btnNormalShield" recursively:NO] removeFromParent];
}

-(void)onGoldenShieldClicked:(id)sender
{
    if (_isShieldOn || _goldenShieldLevel > 0 || _isBoostOn) {
        return;
    }
    
    _coinProgressBar.percentage = 100.0f;
    _isCoinProgressFull = NO;
    _numOfCoins -= 150;
    [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
    
    _goldenShieldLevel = 3;
    [self getGoldenShield];
    
    [[self getChildByName:@"btnGoldenShield" recursively:NO] removeFromParent];
}

-(void)onProgressBarClicked:(id)sender {
    if (_isShieldOn || _goldenShieldLevel > 0 || _isBoostOn) {
        return;
    }
    if (_coinProgressBar.percentage >= 100.0) {
        _coinProgressBar.percentage = 0;
        _isCoinProgressFull = NO;
        _numOfCoins -= 150;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        _goldenShieldLevel = 3;
        [self getGoldenShield];
    }
    else if (_coinProgressBar.percentage >= 100.0/3.0) {
        _coinProgressBar.percentage -= 100.0/3.0;
        _numOfCoins -= 50;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        [self getShield];
    }
}

-(void)onFinishClicked:(id)sender
{
    //[self removeChildByName:@"LayerLottery" cleanup:YES];
    [self gameOver];
}

// -----------------------------------------------------------------------
#pragma mark - Special effects
// -----------------------------------------------------------------------
-(void)boost {
    _isBoostOn = YES;
    _isInvulnerable = YES;
    _boostTime = 0;
    _speedBeforeBoost = _scrollSpeed;
    _scrollSpeed = 50;
    ;
    CGFloat x = _robot.position.x;
    CGFloat y = _robot.position.y;
    
    [_robot removeFromParentAndCleanup:YES];
    [self addRobotBoost:x andNb:y];
    
    //[self getBoostShield];
}

-(void)magnet {
    _isMagnetOn = YES;
    _magnetTime = 0;
}

-(void)jump
{
    if(_isBoostOn)
        return;
    if (!_isGameOver) {
        
        touches++;
        if  (touches==2)
        {
            _robot.physicsBody.velocity=ccp(0.0f, 0.0f);
            [_robot.physicsBody applyForce:ccp(0,15.0f)];
            return;
        }
        if (touches==3) {
            CGFloat px = _robot.position.x;
            CGFloat py = _robot.position.y;
            
            [_robot removeFromParentAndCleanup:YES];
            _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
            _robot.position = ccp(px, py);
            _robot.physicsBody.collisionGroup = @"robotGroup";
            _robot.physicsBody.collisionType = @"robotCollision";
            
            [_physicsWorld addChild:_robot z:1];
            [self schedule:@selector(applyForceWhenTouched) interval:1.0f/10.0f];
            return;
        }
        if(touches>=3)
            return;
        
        //        CGFloat x = self.contentSize.width/4;
        //        CGFloat y = _robot.position.y;
        //        if(!_isBoostOn){
        //            [_robot removeFromParentAndCleanup:YES];
        //            [self addRobotJump:x andNb:y];
        //        }else{
        //            [_robot removeFromParentAndCleanup:YES];
        //
        //            [self addRobotBoost:x andNb:y];
        //        }
        //
        //        if(_scrollSpeed < 6) {
        //            [_robot.physicsBody applyImpulse:ccp(0,0.05f)];
        //        }
        //        else {
        //            [_robot.physicsBody applyImpulse:ccp(0,0.1f)];
        //        }
        [_robot.physicsBody applyForce:ccp(0,14.0f)];
        _robot.physicsBody.velocity=CGPointZero;
        
    }
    else {
        self.userInteractionEnabled = NO;
    }

}

// -----------------------------------------------------------------------
#pragma mark - Random number generators
// -----------------------------------------------------------------------
-(int)random:(int)minimum withArg2:(int)maximum {
    int range = maximum - minimum;
    int height;
    switch (arc4random()%14) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            height = minimum;
            break;
        case 5:
        case 6:
            height = range/5+minimum;
            break;
        case 7:
        case 8:
            height = 2*range/5+minimum;
            break;
        case 9:
        case 10:
            height = 3*range/5+minimum;
            break;
        case 11:
        case 12:
        case 13:
            height = 4*range/5+minimum;
            break;
            
        default:
            break;
    }
    //return (arc4random() % range) + minimum;
    if(height>maximum)
        height = maximum;

    return height;
}

-(int)randomTen {
    return (arc4random() % 10) + 1;
}

-(void)tick {
    
    [self generateItem];
    
    if (_isGameOver) {
        _scrollSpeed = _scrollSpeed - 0.1f;
        if (_scrollSpeed <= 0) {
            _scrollSpeed = 0;
            [self gameOver];
        }
    }
    
    // _time = 10 means 1 second
    if (!_isPortalOn) {
        _time++;
    }
    
    // Set distance function
    [self calculateDistacne];
    
    if (_isInvulnerable) {
        _robot.physicsBody.collisionType = @"superRobotCollision";
    }
    else {
        _robot.physicsBody.collisionType = @"robotCollision";
    }
    /*
    if( _coinProgressBar.percentage >= 33.4 && ![self getChildByName:@"btnNormalShield" recursively:NO] )
    {
        [self addButtonNormalShield];
    }
    if( _isCoinProgressFull && ![self getChildByName:@"btnGoldenShield" recursively:NO])
    {
        [self addButtonGoldenShield];
    }
    */
    
    if (_isBoostOn) {
        _boostTime++;
        // Boost effect last for 8 seconds
        if (_boostTime == 80) {
            _robot.scale = 1.0;
            _isBoostOn = NO;
            touches=0;
            _scrollSpeed = _speedBeforeBoost-0.3f;
            
            CGFloat x = _robot.position.x;
            CGFloat y = _robot.position.y;
            [_robot removeFromParentAndCleanup:YES];
            [self addRobotBackToRun:x andNb:y];
            
//            CCAction *fadeIn = [CCActionFadeIn actionWithDuration:0.5f];
//            CCAction *fadeOut = [CCActionFadeOut actionWithDuration:0.5f];
//            CCAction *fadeOutBlock = [CCActionCallBlock actionWithBlock:^{
//                _isInvulnerable = NO;
//            }];
//            [_robot runAction:[CCActionSequence actionWithArray:@[fadeIn, fadeOut, fadeIn, fadeOut, fadeIn, fadeOutBlock]]];
              [self performSelector:@selector(disableInvulnerable) withObject:nil];
        }
        _robot.physicsBody.friction = 0.0f;

        
        _robot.physicsBody.collisionType = @"robotCollision";
        
    }
}

-(void)disableInvulnerable {
    _isInvulnerable = NO;
    //_robot.opacity = 1.0f;
}

-(void)calculateDistacne {
    if (_background._background1.position.x <= 0)
        _distance = 100 * (_sceneCounter - _background._background1.position.x/_background._background1.contentSize.width);
    else
        _distance = 100 * (_sceneCounter - _background._background2.position.x/_background._background2.contentSize.width);
    
    [(CCLabelTTF*)[self getChildByName:@"labelDistance" recursively:NO] setString:[NSString stringWithFormat:@"Metres: %d M", _distance]];
}

-(void)applyForceWhenTouched {
            [_robot.physicsBody applyForce:ccp(0,4.0f)];
}


// -----------------------------------------------------------------------
#pragma mark - Scroll the ground and background
// -----------------------------------------------------------------------
-(void)backgroundScroll : (float)delta {
    for (float i = 0.0f; i<delta; i+=.1f) {
        _background._background1.position = ccp(_background._background1.position.x - .1, _background._background1.position.y);
        _background._background2.position = ccp(_background._background2.position.x - .1, _background._background2.position.y);
        //_background._ground.position = ccp(_background._ground.position.x - .1, _groundInitialY);
    }
    
    if (_background._background1.position.x <= -_background._background1.contentSize.width+1) {
        
        _background._background1.position = ccp(_background._background2.position.x + [_background._background2 boundingBox].size.width - 1, _background._background1.position.y );
        
        [_background._background1 removeAllChildrenWithCleanup:YES];

        if (_sceneCounter==_record/100)
        {
            [self addRecordSign:_background._background1];
        }
        _sceneCounter++;

        
        /*CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bg1" fontName:@"Verdana-Bold" fontSize:15];
        label.positionType = CCPositionTypeNormalized;
        label.position = ccp(0.5f, 0.5f);
        [_background._background1 addChild:label];*/

        [self generateStaticObstacles:_background._background1];
        [self generateRandomGround:_background._background1];
        
    }
    else if (_background._background2.position.x <= -_background._background2.contentSize.width+1) {
        
        _background._background2.position = ccp(_background._background1.position.x + [_background._background1 boundingBox].size.width - 1, _background._background2.position.y );
        
        [_background._background2 removeAllChildrenWithCleanup:YES];
        
        
        if (_sceneCounter==_record/100)
        {
            [self addRecordSign:_background._background2];
        }
        _sceneCounter++;
        /*
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Bg2" fontName:@"Verdana-Bold" fontSize:15];
        label2.positionType = CCPositionTypeNormalized;
        label2.position = ccp(0.5f, 0.5f);
        [_background._background2 addChild:label2];
        */
        [self generateStaticObstacles:_background._background2];
        [self generateRandomGround:_background._background2];
    }
}

//Generate random Y ground
-(void)generateRandomGround : (CCSprite*)bg {
    float counter = 0;
    bg.physicsBody.friction=0.0f;
    while (counter < bg.contentSize.width - 1) {
        CCSprite *spr = [Background generateFlyingGround];
        
        int lengthScaleMin = 3;
        int lengthScaleMax = 8;
        int distanceMin = 10;
        int distanceMax = 100;
        
        float randomScale = arc4random() % (lengthScaleMax - lengthScaleMin) + lengthScaleMin;
        float randomDistance = arc4random() % (distanceMax - distanceMin) + distanceMin;
        
        spr.scaleY = 0.5;
        spr.scaleX = randomScale/10.0;
        //CCLOG(@"++++++++++++++%lu",(unsigned long)randomScale);
        int x = counter;
        int minY = bg.contentSize.height * 0.1;
        int maxY = bg.contentSize.height * 0.4;
        int randomY = arc4random()%(maxY-minY)+minY;
        spr.position = ccp(x,randomY);
        counter += [spr boundingBox].size.width + randomDistance;
        if(counter <= bg.contentSize.width - 1) {
            [bg addChild:spr];
        }
        //CCLOG(@"++++++++++++++%lu",(unsigned long)bg.children.count);
    }
    //CCLOG(@"++++++++++++++");
}

//Generate horizental ground
-(void)generateHorizentalGround : (CCSprite*)bg {
    float counter = 0;
    //float groundLength = [[Background generateFlyingGround] boundingBox].size.width;
    while (counter < bg.contentSize.width - 1) {
        CCSprite *spr = [Background generateFlyingGround];
        
        spr.scaleY = 0.5;
        int x = counter;
        spr.position = ccp(x,20);
        [bg addChild:spr];
        counter += [spr boundingBox].size.width;
        //CCLOG(@"++++++++++++++%lu",(unsigned long)bg.children.count);
    }
    //CCLOG(@"++++++++++++++");
}

-(void)addRecordSign : (CCSprite*)bg {
    float recordPosX = [_userDefault integerForKey:@"record"]%100/100.0f * _background._background1.contentSize.width + self.contentSize.width/4;
    
    CCSprite *spr = [CCSprite spriteWithImageNamed:@"Record_Flag.png"];
    spr.anchorPoint = CGPointZero;
    spr.position = ccp(recordPosX, 5);
    spr.scale = 0.7;
    spr.opacity = 0.7;
    
    CCLabelTTF* labelRecord = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d M", _distance] fontName:@"Verdana-Bold" fontSize:12.0f];
    labelRecord.anchorPoint = ccp(0,0);
    labelRecord.position = ccp(spr.position.x + 15 ,spr.position.y + 5);
    labelRecord.rotation = -45;
    labelRecord.name = @"labelDistance";
    
    [bg addChild:spr];
    [bg addChild:labelRecord];
}
// -----------------------------------------------------------------------
#pragma mark - Add static obstacles
// -----------------------------------------------------------------------
-(void)generateStaticObstacles : (CCSprite*)bg {
    //float pb_num = arc4random()%100/100.0f;
    
//    [self generateThreeObstacles:bg];
//    return;

    //if (pb_num < 0.05f) {
        [self generateOneObstacle:bg];
   // }
    //else if (pb_num < 0.45) {
     //   [self generateTwoObstacles:bg];
    //}
    //else if (pb_num < 0.90f) {
    //    [self generateThreeObstacles:bg];
   // }
    //else {
        [self generateRiskAndRewards:bg];
    //}
}

-(CCSprite*)generateRandomSprite {
    CCSprite* spr;
    float pb_object = arc4random()%100/100.0f;
    
    if (pb_object <= 0.3f) {
        if (pb_object <= 0.03f) {
            spr = [Coin initCoinGroup:COIN_SHAPE_LINE];
        }
        else if (pb_object <= 0.10f) {
            spr = [Coin initCoinGroup:COIN_SHAPE_RECT];
        }
        else if (pb_object <= 0.17f) {
            spr = [Coin initCoinGroup:COIN_SHAPE_DIAMOND];
        }
        else if (pb_object <= 0.22f) {
            spr = [Coin initCoinGroup:COIN_SHAPE_HEART];
        }
        else if (pb_object <= 0.26f) {
            spr = [Coin initCoinGroup:COIN_SHAPE_USC];
        }
        else {
            spr = [Coin initCoinGroup:COIN_SHAPE_Z];
        }
        spr.name = @"coinGroup";
        spr.anchorPoint = ccp(0, 0);
    }
    //else if (pb_object <= 0.4f) {
        spr = [Enemies laserHorizontalInit];
    //}
    //else if (pb_object <= 0.70f) {
     //   spr = [Enemies laserVerticalInit];
    //}
    //else if (pb_object <= 0.78f) {
     //   spr = [Enemies laserDiagonalInit:0];
    //}
   // else if (pb_object <= 0.85f) {
     //   spr = [Enemies laserDiagonalInit:1];
   // }
   // else {
      //  spr = [Enemies laserRotatingInit];
   // }
    
    return spr;
}

-(int)generateRandomY:(CCSprite*)spr {
    int maxY, minY;
    if ([spr.name isEqualToString:@"laserRotating"]) {
        maxY = self.contentSize.height - spr.contentSize.height*.5*spr.scaleY;
        //maxY = _background._background1.contentSize.height - spr.contentSize.height*.5*spr.scaleY;
        minY = spr.contentSize.height*.5*spr.scaleY;
    }
    else if ([spr.name isEqualToString:@"laserHorizontal"]) {
        maxY = self.contentSize.height - spr.contentSize.height - 30;
        //maxY = _background._background1.contentSize.height - spr.contentSize.height - 30;
        minY = 30;
    }
    else if ([spr.name isEqualToString:@"threeStars"]) {
        maxY = self.contentSize.height - _robot.contentSize.height*2 - spr.contentSize.height;
        //maxY = _background._background1.contentSize.height - _robot.contentSize.height*2 - spr.contentSize.height;
        minY = _robot.contentSize.height*2;
    }
    else {
        maxY = self.contentSize.height - spr.contentSize.height;
        //maxY = _background._background1.contentSize.height - spr.contentSize.height;
        minY = 0;
    }
    maxY -= _background._topBackground.contentSize.height;
    minY += _groundInitialY + _background._ground.contentSize.height;
    
    int randomY = arc4random()%(maxY-minY)+minY;
    return randomY;
}

-(int)findPrevX : (CCSprite*)bg {
    int maxPrevX = 0;
    for (CCSprite *temp in bg.children) {
        int tempX = temp.position.x;
        if ([temp.name isEqualToString:@"laserRotating"]) {
            tempX += temp.contentSize.height/2;
        }
        else if ([temp.name isEqualToString:@"laserDiagonalLeft"]) {
            tempX = tempX;
        }
        else if ([temp.name isEqualToString:@"portalIn"]) {
            tempX += temp.contentSize.width/2;
        }
        else {
            tempX += temp.contentSize.width;
        }
        if (tempX >= maxPrevX) {
            maxPrevX = tempX;
        }
    }
    return maxPrevX;
}
/*
-(void)addPortal : (CCSprite*)bg : (CCSprite*)spr {
    float pb_portal = arc4random()%100/100.0f;
    if ([spr.name isEqualToString:@"coinGroup"] || spr.position.x < 0) {
        return;
    }
    for (CCSprite *temp in bg.children) {
        if ([temp.name isEqualToString:@"portalIn"]) {
            return;
        }
    }
    
    if (pb_portal < 0.1f) {
        CCSprite *portal = [Rewards portalInInit];
        int portalX, portalY;
        if ([spr.name isEqualToString:@"laserRotating"]) {
            portalX = spr.position.x + spr.contentSize.height * spr.scaleY / 2 + 40;
        }
        else {
            portalX = spr.position.x + spr.contentSize.width + 70;
        }
        portalY = spr.position.y + portal.contentSize.height/2;
        if (portalX > bg.contentSize.width - 70 || portalY < portal.contentSize.height / 2 || portalY > bg.contentSize.height - portal.contentSize.height / 2) {
            return;
        }
        portal.position = ccp(portalX, portalY);
        [bg addChild:portal];
    }
}
*/
-(void)generateOneObstacle : (CCSprite*)bg {
    CCSprite *spr = [self generateRandomSprite];
    
    int minX = bg.contentSize.width * 0.25;
    int maxX = bg.contentSize.width * 0.75 - spr.contentSize.width - 70;
    int randomX = arc4random()%(maxX-minX)+minX;
    
    int randomY = [self generateRandomY:spr];
    
    spr.position = ccp(randomX, randomY);
    //[self addPortal:bg :spr];
    [bg addChild:spr];
}

-(void)generateTwoObstacles : (CCSprite*)bg {
    CCSprite *spr0 = [self generateRandomSprite];
    CCSprite *spr1 = [self generateRandomSprite];
    while ([spr0.name isEqualToString:spr1.name]) {
        spr1 = [self generateRandomSprite];
    }
    // First sprite
    int minX = 50;
    int maxX = bg.contentSize.width/2 - spr0.contentSize.width;
    if ([spr0.name isEqualToString:@"laserRotating"]) {
        minX += spr0.contentSize.height/2;
    }
    if ([spr0.name isEqualToString:@"laserDiagonalLeft"]) {
        minX += spr0.contentSize.width;
    }
    int randomX;
    if (minX < maxX) {
        randomX = arc4random()%(maxX-minX)+minX;
        spr0.position = ccp(randomX, [self generateRandomY:spr0]);
        //[self addPortal:bg :spr0];
        [bg addChild:spr0];
    }
    // Second sprite
    minX = [self findPrevX:bg] + 100;
    maxX = bg.contentSize.width - spr1.contentSize.width - 50;
    if ([spr1.name isEqualToString:@"laserRotating"]) {
        minX += spr1.contentSize.height/2;
        maxX -= spr1.contentSize.height/2;
    }
    if ([spr1.name isEqualToString:@"laserDiagonalLeft"]) {
        minX += spr1.contentSize.width;
        maxX += spr1.contentSize.width;
    }
    if (minX < maxX) {
        randomX = arc4random()%(maxX-minX)+minX;
        spr1.position = ccp(randomX, [self generateRandomY:spr1]);
        //[self addPortal:bg :spr1];
        [bg addChild:spr1];
    }
}

-(void)generateThreeObstacles : (CCSprite*)bg {
    CCSprite *spr0 = [self generateRandomSprite];
    CCSprite *spr1 = [self generateRandomSprite];
    while ([spr0.name isEqualToString:spr1.name]) {
        spr1 = [self generateRandomSprite];
    }
    CCSprite *spr2 = [self generateRandomSprite];
    while ([spr1.name isEqualToString:spr2.name]) {
        spr2 = [self generateRandomSprite];
    }
    //NSLog(@"spr0, spr1, spr2:%@, %@, %@", spr0.name, spr1.name, spr2.name);
    
    // First sprite
    int minX = 40;
    int maxX = bg.contentSize.width*3/8 - spr0.contentSize.width;
    if ([spr0.name isEqualToString:@"laserRotating"]) {
        minX += spr0.contentSize.height/2;
    }
    if ([spr0.name isEqualToString:@"laserDiagonalLeft"]) {
        minX += spr0.contentSize.width;
    }
    int randomX;
    if (minX < maxX) {
        randomX = arc4random()%(maxX-minX)+minX;
        spr0.position = ccp(randomX, [self generateRandomY:spr0]);
        //[self addPortal:bg :spr0];
        [bg addChild:spr0];
    }
    
    // Second sprite
    minX = [self findPrevX:bg] + 70;
    maxX = bg.contentSize.width*5/8 - spr1.contentSize.width;
    if ([spr1.name isEqualToString:@"laserRotating"]) {
        minX += spr1.contentSize.height/2;
        maxX -= spr1.contentSize.height/2;
    }
    if ([spr1.name isEqualToString:@"laserDiagonalLeft"]) {
        minX += spr1.contentSize.width;
        maxX += spr1.contentSize.width;
    }
    
    if (minX < maxX) {
        randomX = arc4random()%(maxX-minX)+minX;
        spr1.position = ccp(randomX, [self generateRandomY:spr1]);
        //[self addPortal:bg :spr1];
        [bg addChild:spr1];
    }
    
    // Third sprite
    minX = [self findPrevX:bg] + 70;
    maxX = bg.contentSize.width - spr2.contentSize.width - 40;
    if ([spr2.name isEqualToString:@"laserRotating"]) {
        minX += spr2.contentSize.height/2;
        maxX -= spr2.contentSize.height/2;
    }
    if ([spr2.name isEqualToString:@"laserDiagonalLeft"]) {
        minX += spr2.contentSize.width;
        maxX += spr2.contentSize.width;
    }
    
    if (minX < maxX) {
        randomX = arc4random()%(maxX-minX)+minX;
        spr2.position = ccp(randomX, [self generateRandomY:spr2]);
       // [self addPortal:bg :spr2];
        [bg addChild:spr2];
    }
    
}

-(void)generateRiskAndRewards : (CCSprite*)bg {
    CCSprite *spr;
    //if (arc4random()%2 == 1) {
        spr = [Rewards threeStarsInit];
    //}
    //else {
        //spr = [Rewards threeStarsReverseInit];
    //}
    //spr = [Rewards threeStarsReverseInit];
    int minX = bg.contentSize.width*.2;
    int maxX = bg.contentSize.width*.8 - spr.contentSize.width;
    int randomX = arc4random()%(maxX-minX) + minX;
    spr.position = ccp(randomX, [self generateRandomY:spr]);
    [bg addChild:spr];
}

-(void)coinDetection {
    if(_isPortalOn) {
        return;
    }
    
    for (int i = 0; i < _background._background1.children.count; i++) {
        CCSprite *tempNode = _background._background1.children[i];
        if ([tempNode.name isEqualToString:@"coinGroup"]) {
            for (int j = 0; j < tempNode.children.count; j++) {
                CCSprite *sprite = tempNode.children[j];
                float distance = ccpDistance([tempNode convertToNodeSpace:_robot.position], sprite.position);
                if (distance <= 30) {
                    [self coinRemove:sprite];
                }
            }
        }
    }
    for (int i = 0; i < _background._background2.children.count; i++) {
        CCSprite *tempNode = _background._background2.children[i];
        if ([tempNode.name isEqualToString:@"coinGroup"]) {
            for (int j = 0; j < tempNode.children.count; j++) {
                CCSprite *sprite = tempNode.children[j];
                float distance = ccpDistance([tempNode convertToNodeSpace:_robot.position], sprite.position);
                if (distance <= 30) {
                    [self coinRemove:sprite];
                }
            }
        }
    }
}

/*
-(void)addButtonNormalShield
{
    CCSpriteFrame *frameForBtn = [CCSpriteFrame frameWithImageNamed:@"normalShieldIcon.png"];
    CCButton *btnShield = [CCButton buttonWithTitle:nil spriteFrame:frameForBtn];

    btnShield.positionType = CCPositionTypeNormalized;
    btnShield.position = ccp(0.1f, 0.55f);
    btnShield.name = @"btnNormalShield";
    [btnShield setTarget:self selector:@selector(onNormalShieldClicked:)];
    [self addChild:btnShield z:9];
}

-(void)addButtonGoldenShield
{
    CCSpriteFrame *frameForBtn = [CCSpriteFrame frameWithImageNamed:@"goldenShieldIcon.png"];
    CCButton *btnShield = [CCButton buttonWithTitle:nil spriteFrame:frameForBtn];

    btnShield.positionType = CCPositionTypeNormalized;
    btnShield.position = ccp(0.1f, 0.85f);
    btnShield.name = @"btnGoldenShield";
    [btnShield setTarget:self selector:@selector(onGoldenShieldClicked:)];
    [self addChild:btnShield z:9];
}
*/
// -----------------------------------------------------------------------

-(void)dealloc {
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------
-(void)onEnter {
    // always call super onEnter first
    [super onEnter];
    
    [[CCDirector sharedDirector] setAnimationInterval:1.0f/60.0f];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playBg:@"background_music.mp3" loop:YES];
    
    if(_isPortalOn) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        _numOfCoins = (int)[userDefaults integerForKey:@"numOfCoins"];
        _isShieldOn = [userDefaults boolForKey:@"isShieldOn"];
        _isCoinProgressFull = [userDefaults boolForKey:@"isCoinProgressFull"];
        _goldenShieldLevel = (int)[userDefaults integerForKey:@"goldenShieldLevel"];
        _coinProgressBar.percentage = (float)[userDefaults integerForKey:@"coinProgressPercentage"];
        
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        CCAction *fadeOutBlock = [CCActionCallBlock actionWithBlock:^{
            _isInvulnerable = YES;
            for (CCNode* object in _background._background1.children) {
                CCAction *actionFadeOut = [CCActionFadeOut actionWithDuration:1.0f];
                CCAction *actionRemove = [CCActionRemove action];
                [object runAction:[CCActionSequence actionWithArray:@[actionFadeOut, actionRemove]]];
            }
            for (CCNode* object in _background._background2.children) {
                CCAction *actionFadeOut = [CCActionFadeOut actionWithDuration:1.0f];
                CCAction *actionRemove = [CCActionRemove action];
                [object runAction:[CCActionSequence actionWithArray:@[actionFadeOut, actionRemove]]];
            }
            //CCAction *comeOut = [CCActionFadeIn actionWithDuration:1.0f];
            //[_robot runAction:comeOut];
            
            CCSprite *portalOut = [Rewards portalOutInit];
            portalOut.position = ccp(self.contentSize.width/5 - _robot.contentSize.width/2 - portalOut.contentSize.width / 2, _groundInitialY + _background._ground.contentSize.height + _robot.contentSize.height / 2);
            portalOut.opacity = 0.5;
            [_physicsWorld addChild:portalOut];
            [_robot removeFromParentAndCleanup:YES];
            [self addRobotAfterPortal];
            
            CCAction *actionDelay = [CCActionDelay actionWithDuration:1.0f];
            CCAction *portalFadeOut = [CCActionFadeOut actionWithDuration:1.0f];
            [portalOut runAction:[CCActionSequence actionWithArray:@[actionDelay, portalFadeOut]]];
            
        }];
        
        CCAction *actionDelay = [CCActionDelay actionWithDuration:2.0f];
        
        CCAction *backToOriginalSpeed = [CCActionCallBlock actionWithBlock:^{
            _scrollSpeed = _speedBeforeBoost;
            _isPortalOn = NO;
            _isInvulnerable = NO;
        }];
        
        [self runAction:[CCActionSequence actionWithArray:@[fadeOutBlock, actionDelay, backToOriginalSpeed]]];
    }
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

-(void)onExit {
    // always call super onExit last
    [super onExit];
}
@end
