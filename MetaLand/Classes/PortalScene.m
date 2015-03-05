//
//  PortalScene.m
//  MetaLand
//
//  Created by 崔 乘瑜 on 7/9/14.
//  Copyright 2014 崔 乘瑜. All rights reserved.
//

#import "PortalScene.h"

#import "Robot.h"
#import "Coin.h"
#import "PortalSceneBackground.h"
#import "Enemies.h"

@implementation PortalScene {
    PortalSceneBackground *_background;
    CCPhysicsNode *_physicsWorldTop;
    CCPhysicsNode *_physicsWorldBot;
    CCSprite *_robot;
    CCSprite *_shadow;
    
    int _time;
    float _scrollSpeed;
    int _numOfCoins;
    BOOL _isDoubleOn;
    BOOL _isShieldOn;
    BOOL _isCoinProgressFull;
    int _goldenShieldLevel;
    BOOL _isOnGround;
    
    CCProgressNode *_coinProgressBar;
    CCButton *_buttonCoinProgressBar;
}

+ (PortalScene*)scene {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (!self) return(nil);
    
    [self schedule:@selector(tick) interval:0.1];
    
    self.userInteractionEnabled = YES;
    
    _time = 0;
    _scrollSpeed = 3;
    _numOfCoins = 0;
    _isDoubleOn = NO;
    _isOnGround = YES;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _numOfCoins = (int)[userDefault integerForKey:@"numOfCoins"];
    _isCoinProgressFull = [userDefault boolForKey:@"isCoinProgressFull"];
    _isShieldOn = [userDefault boolForKey:@"isShieldOn"];
    _goldenShieldLevel = (int)[userDefault integerForKey:@"goldenShieldLevel"];
    
    [self createPhysicsWorld];
    _background = [PortalSceneBackground node];
    
    [self addCoinGroup:_background._background1];
    [self generateRandomObstacle:_background._background2];
    [self addCoinGroup:_background._background2];
    
    [_physicsWorldTop addChild:_background._bgTop];
    [_physicsWorldBot addChild:_background._bgBot];
    
    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
    _robot.position  = ccp(self.contentSize.width/4, _background._middleSeperator1.position.y + _background._middleSeperator1.contentSize.height + _robot.contentSize.height/2);
    _robot.physicsBody.collisionType = @"robotCollision";
    
    [_physicsWorldTop addChild:_robot];
    
    _shadow = [Robot createCharacter:CHARACTER_SHADOW_RUN];
    _shadow.position = ccp(_robot.position.x, _robot.position.y - _background._middleSeperator1.contentSize.height - _background._middleSeperator2.contentSize.height - _shadow.contentSize.height/2 - _robot.contentSize.height/2 );
    _shadow.physicsBody.collisionType = @"shadowCollision";

    
    [_physicsWorldBot addChild:_shadow];
    
    if(_isShieldOn) {
        [self robotGetShield];
        [self shadowGetShield];
    }
    else if (_goldenShieldLevel > 0) {
        [self robotGetGoldenShield];
        [self shadowGetGoldenShield];
    }
    
    CCLabelTTF *labelTimeLeft = [CCLabelTTF labelWithString:@"START!" fontName:@"Verdana-Bold" fontSize:28];
    labelTimeLeft.positionType = CCPositionTypeNormalized;
    labelTimeLeft.position = ccp(0.5f, 0.8f);
    labelTimeLeft.name = @"labelTimeLeft";
    labelTimeLeft.opacity = 0.6f;
    [self addChild:labelTimeLeft z:9];
    
    /*
    CCButton *buttonQuit = [CCButton buttonWithTitle:@"Quit"];
    buttonQuit.anchorPoint = ccp(1, 1);
    buttonQuit.positionType = CCPositionTypeNormalized;
    buttonQuit.position = ccp(1, 1);
    [buttonQuit setTarget:self selector:@selector(onQuitClicked:)];
    [self addChild:buttonQuit z:9];
     */
    
    CCLabelTTF *labelCoin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins] fontName:@"Verdana-Bold" fontSize:15.0f];
    labelCoin.anchorPoint = ccp(0, 1);
    labelCoin.position = ccp(0, self.contentSize.height);
    labelCoin.name = @"labelCoin";
    [self addChild:labelCoin z:9];
    
    [self addCoinProgressBar];
    _coinProgressBar.percentage = (float)[userDefault integerForKey:@"coinProgressPercentage"];
    
    return self;
}

-(void)createPhysicsWorld {
    //Create physics-world
    _physicsWorldTop = [CCPhysicsNode node];
    _physicsWorldTop.gravity = ccp(0, -500);
    _physicsWorldTop.debugDraw = NO;
    _physicsWorldTop.collisionDelegate = self;
    [self addChild:_physicsWorldTop z:1];
    
    _physicsWorldBot = [CCPhysicsNode node];
    _physicsWorldBot.gravity = ccp(0, 500);
    _physicsWorldBot.debugDraw = NO;
    _physicsWorldBot.collisionDelegate = self;
    [self addChild:_physicsWorldBot z:1];
}

- (void)update:(CCTime)delta {
    if (_coinProgressBar.percentage >= 100.0/3.0) {
        _buttonCoinProgressBar.enabled = YES;
    }
    
    _scrollSpeed += 0.001;
    
    [self backgroundScroll:_scrollSpeed];
    [self generateRandomMissile];
    [self coinDetection];
    
    NSLog(@"!!!%@",_robot.physicsBody.collisionType);
}

-(void)coinDetection {
    for (int i = 0; i < _background._background1.children.count; i++) {
        CCSprite *tempNode = _background._background1.children[i];
        if ([tempNode.name isEqualToString:@"coinGroup"]) {
            for (int j = 0; j < tempNode.children.count; j++) {
                CCSprite *sprite = tempNode.children[j];
                float distance = ccpDistance([tempNode convertToNodeSpace:_shadow.position], sprite.position);
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
                float distance = ccpDistance([tempNode convertToNodeSpace:_shadow.position], sprite.position);
                if (distance <= 30) {
                    [self coinRemove:sprite];
                }
            }
        }
    }
}

- (void)tick {
    _time++;
    
    if(!(_time%10) && _time )
    {
        [(CCLabelTTF*)[self getChildByName:@"labelTimeLeft" recursively:NO] setString:[NSString stringWithFormat:@"%d", 30-_time/10]];
    }
    
    if(_time==300)
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:_numOfCoins forKey:@"numOfCoins"];
        [userDefaults setBool:_isShieldOn forKey:@"isShieldOn"];
        [userDefaults setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
        [userDefaults setInteger:_goldenShieldLevel forKey:@"goldenShieldLevel"];
        [userDefaults setFloat:_coinProgressBar.percentage forKey:@"coinProgressPercentage"];
        
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
    
    if( _coinProgressBar.percentage >= 33.4 && ![self getChildByName:@"btnNormalShield" recursively:NO] )
    {
        [self addButtonNormalShield];
    }
    if( _isCoinProgressFull && ![self getChildByName:@"btnGoldenShield" recursively:NO])
    {
        [self addButtonGoldenShield];
    }
    
}

- (void)backgroundScroll : (float)delta {
    for( float i = 0.0f; i<delta; i+=.1f ) {
        _background._background1.position = ccp(_background._background1.position.x - .1, _background._background1.position.y);
        _background._background2.position = ccp(_background._background2.position.x - .1, _background._background2.position.y);
    }
    
    if ( _background._background1.position.x <= -_background._background1.contentSize.width ) {
        _background._background1.position = ccp(_background._background2.position.x + [_background._background2 boundingBox].size.width - 1, _background._background1.position.y );
        
        [_background._background1 removeAllChildren];
        
        [self generateRandomObstacle:_background._background1];
        [self addCoinGroup:_background._background1];
    }
    else if ( _background._background2.position.x <= -_background._background2.contentSize.width ) {
        _background._background2.position = ccp(_background._background1.position.x + [_background._background1 boundingBox].size.width - 1, _background._background2.position.y );
        
        [_background._background2 removeAllChildren];
        
        [self generateRandomObstacle:_background._background2];
        [self addCoinGroup:_background._background2];
    }
}

-(void)generateRandomObstacle : (CCSprite*)bg {
    float pb_willGenerateObstacle;
    CCSprite *spr;
    
    int maxY, minY, randomY;
    
    for ( int i=0; i<3; i++ ){
        pb_willGenerateObstacle = arc4random()%100/100.0f;
        
        if( pb_willGenerateObstacle <= 0 )
            return;
        
        spr = [Enemies gearInit];
        
        maxY = self.contentSize.height - _background._topBackground.contentSize.height - spr.contentSize.height * 0.5f;
        minY = self.contentSize.height * 0.5f + _background._middleSeperator1.contentSize.height + spr.contentSize.height * 0.5f;
        randomY = [self random:minY withArg2:maxY];
        
        spr.position = ccp(bg.contentSize.width * (0.2f + i * 0.3f), randomY);
        
        //spr.positionType = CCPositionTypeNormalized;
        //spr.position = ccp(0.2f+ i*0.3f, 0.7f);
        
        [bg addChild:spr z:9];
    }
}


-(void)generateRandomMissile {
    float willMissileBeGenerated = arc4random()%1000000/1000000.0f;
    
    if(willMissileBeGenerated>=0.003) {
        return;
    }
    
    CCSprite *missile = [Enemies missileInit:MISSILE_NORMAL];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    
    
    // Set random missile position
    int maxY = self.contentSize.height - missile.contentSize.height - _background._topBackground.contentSize.height;
    int minY = self.contentSize.height/2 + _background._middleSeperator1.contentSize.height;
    int randomY = [self random:minY withArg2:maxY];
    
    
    [audio playEffect:@"warning.wav"];
    
    CCSprite* warningLine = [CCSprite spriteWithImageNamed:@"flashline.png"];
    
    CCSprite* warning = [CCSprite spriteWithImageNamed:@"warning.png"];
    warningLine.anchorPoint = ccp(0,0);
    warningLine.position = ccp(0,randomY+10);
    warning.anchorPoint = ccp(0, 0);
    warning.position = ccp(self.contentSize.width - warning.contentSize.width, randomY);
    CCAction* actionFadeOut = [CCActionFadeOut actionWithDuration:.4f];
    CCAction* actionFadeIn = [CCActionFadeIn actionWithDuration:.4f];
    CCActionCallBlock* callBlock = [CCActionCallBlock actionWithBlock:^{
        //warning.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"warning_missile_normal_2.png"];
        [self performSelector:@selector(changeWarning:) withObject:warning];
    }];
    
    
    CCAction *warningDelay = [CCActionDelay actionWithDuration:.5f];
    CCAction *warningRemove = [CCActionRemove action];
    [warning runAction:[CCActionSequence actionWithArray:@[actionFadeOut, actionFadeIn, actionFadeOut, callBlock, actionFadeIn, warningDelay, warningRemove]]];
    [warningLine runAction:[CCActionSequence actionWithArray:@[actionFadeOut,actionFadeIn,actionFadeOut,actionFadeIn,warningDelay,warningRemove]]];
    
    missile.position = ccp(self.contentSize.width + warning.contentSize.width + missile.contentSize.width, warning.position.y);
    
    // Set missile move action with random speed
    CCAction *actionMove = [CCActionMoveBy actionWithDuration:1.5 position:ccp(-_background._background1.contentSize.width-2*missile.contentSize.width,0)];
    
    CCAction *actionRemove = [CCActionRemove action];
    CCAction *actionDelay = [CCActionDelay actionWithDuration:2];
    CCActionCallBlock *actionAfterMoving = [CCActionCallBlock actionWithBlock:^{
        [missile removeFromParent];
    }];
    [missile runAction:[CCActionSequence actionWithArray:@[actionDelay, actionMove, actionRemove, actionAfterMoving]]];
    
    
    // Add missile to the physics world
    [_physicsWorldTop addChild:missile z:1];
    [self addChild:warning z:2];
    [self addChild:warningLine z:2];
    
}

//Add different effects to character
-(void)addRobotJump:(CGFloat) px andNb:(CGFloat) py{
    
    _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
    _robot.position = ccp(px, py);
    _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorldTop addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self robotGetShield];
    }
    else if (_goldenShieldLevel) {
        [self robotGetGoldenShield];
    }
}

-(void)addShadowJump:(CGFloat) px andNb: (CGFloat) py{
    _shadow = [Robot createCharacter:CHARACTER_SHADOW_FLY];
    _shadow.position = ccp(px, py);
    _shadow.physicsBody.collisionType = @"shadowCollision";
    [_physicsWorldBot addChild:_shadow z:1];
    
    if (_isShieldOn) {
        [self shadowGetShield];
    }
    else if (_goldenShieldLevel) {
        [self shadowGetGoldenShield];
    }
}

-(void)addRobotBackToRun:(CGFloat) px andNb:(CGFloat) py{
    
    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
    _robot.position = ccp(px, py);
    _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorldTop addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self robotGetShield];
    }
    else if (_goldenShieldLevel) {
        [self robotGetGoldenShield];
    }
}

-(void)addShadowBackToRun:(CGFloat) px andNb:(CGFloat) py{
    
    _shadow = [Robot createCharacter:CHARACTER_SHADOW_RUN];
    _shadow.position = ccp(px, py);
    _shadow.physicsBody.collisionType = @"shadowCollision";
    [_physicsWorldBot addChild:_shadow z:1];
    
    if (_isShieldOn) {
        [self shadowGetShield];
    }
    else if (_goldenShieldLevel) {
        [self shadowGetGoldenShield];
    }
}

-(void)addRobotdie:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_DIE];
    _robot.position = ccp( px, py );
    [_physicsWorldTop addChild:_robot z:1];
}

-(void)addRobotshoted:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_SHOTED];
    _robot.position = ccp( px, py );
    [_physicsWorldTop addChild:_robot z:1];
}

//Add coin group and coinDetection
- (void)addCoinGroup : (CCSprite*)bg {
    //float pb_willAddCoin;
    CCSprite *spr;
    
    for (int i=0; i<1; i++) {
        //pb_willAddCoin = arc4random()%10000/10000.0f;
        //if(pb_willAddCoin <= 0.3f)
          //  continue;
        
        spr = [Coin generateRandomCoinGroupForPortalScene];
        float maxY = self.contentSize.height * 0.5f - _background._middleSeperator2.contentSize.height*2 - spr.contentSize.height;
        float minY = _background._ground.contentSize.height + spr.contentSize.height * 0.5f;
        float randomY = [self random:minY withArg2:maxY];
        
        spr.position = ccp( bg.contentSize.width * (i+1) * 0.3f, randomY );
        //spr.positionType = CCPositionTypeNormalized;
        //spr.position = ccp(0.5, 0.5);
        
        [bg addChild:spr];
    }
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

-(void)addCoinProgressBar {
    _coinProgressBar = [CCProgressNode progressWithSprite:[CCSprite spriteWithImageNamed:@"progressBar.png"]];
    _coinProgressBar.type = CCProgressNodeTypeBar;
    _coinProgressBar.rotation = 270;
    _coinProgressBar.midpoint = ccp(0, 0);
    _coinProgressBar.barChangeRate = ccp(1, 0);
    _coinProgressBar.positionType = CCPositionTypeNormalized;
    _coinProgressBar.position = ccp(0.05f, 0.64f);
    _coinProgressBar.name = @"coinProgressBar";
    [self addChild:_coinProgressBar z:2];
    
    CCSpriteFrame *progressBarFrame = [CCSpriteFrame frameWithImageNamed:@"progressBarFrame.png"];
    _buttonCoinProgressBar = [CCButton buttonWithTitle:nil spriteFrame:progressBarFrame];
    _buttonCoinProgressBar.position = ccp(0, 0);
    _buttonCoinProgressBar.anchorPoint = ccp(0, 0);
    _buttonCoinProgressBar.name = @"buttonGoldenShield";
    _buttonCoinProgressBar.enabled = NO;
    [_coinProgressBar addChild:_buttonCoinProgressBar z:9];
    [_buttonCoinProgressBar setTarget:self selector:@selector(onProgressBarClicked:)];
}

-(void)robotGetShield {
    _isShieldOn = YES;
    CCSprite* shield = [CCSprite spriteWithImageNamed:@"normalShield.png"];
    shield.positionType = CCPositionTypeNormalized;
    shield.position = ccp(0.5f, 0.5f);
    [_robot addChild:shield];
}

-(void)shadowGetShield {
    _isShieldOn = YES;
    CCSprite *shield = [CCSprite spriteWithImageNamed:@"normalShield.png"];
    shield.positionType = CCPositionTypeNormalized;
    shield.position = ccp(0.5f, 0.5f);
    shield.opacity = 0.5f;
    [_shadow addChild:shield];
}

-(void)robotGetGoldenShield {
    CCSprite *shield = [CCSprite spriteWithImageNamed:@"goldenShield.png"];
    shield.positionType = CCPositionTypeNormalized;
    shield.position = ccp(0.5f, 0.5f);
    shield.name = @"shieldOnRobot";
    if (_goldenShieldLevel == 2) {
        shield.opacity = 0.7f;
    }
    else if (_goldenShieldLevel == 1) {
        shield.opacity = 0.4f;
    }
    [_robot addChild:shield];
}

-(void)shadowGetGoldenShield {
    CCSprite *shadowShield = [CCSprite spriteWithImageNamed:@"goldenShield.png"];
    shadowShield.positionType = CCPositionTypeNormalized;
    shadowShield.position = ccp(0.5f, 0.5f);
    shadowShield.name = @"shieldOnShadow";
    if (_goldenShieldLevel == 3) {
        shadowShield.opacity = 0.5f;
    }
    else if (_goldenShieldLevel == 2) {
        shadowShield.opacity = 0.35f;
    }
    else if (_goldenShieldLevel == 1) {
        shadowShield.opacity = 0.2f;
    }
    [_shadow addChild:shadowShield];
}

-(void)loseShield {
    [self screenShake];
    if (_isShieldOn) {
        _isShieldOn = NO;
    }
    [_robot removeAllChildren];
    [_shadow removeAllChildren];
}

-(void)screenShake {
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.05f position:ccp(-5, 5)];
    CCActionInterval *reverseMovement = [moveBy reverse];
    CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement,moveBy,reverseMovement,moveBy,reverseMovement,moveBy, reverseMovement,moveBy,reverseMovement,moveBy,reverseMovement]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
    [self runAction:bounce];
}


- (void)changeWarning : (CCSprite*)warning {
    warning.texture = ((CCSprite*)[CCSprite spriteWithImageNamed:@"warning_missile_normal_2.png"]).texture;
}

-(int)random:(int)minimum withArg2:(int)maximum {
    int range = maximum - minimum;
    
    return (arc4random() % range) + minimum;
}

-(void)addRobotFall:(CGFloat) px andNb:(CGFloat) py{
    _robot = [Robot createCharacter:CHARACTER_ROBOT_FALL];
    _robot.position = ccp(px, py);
    _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorldTop addChild:_robot z:1];
    
    if (_isShieldOn) {
        [self robotGetShield];
    }
    else if (_goldenShieldLevel) {
        [self robotGetGoldenShield];
    }
}

-(void)addShadowFall:(CGFloat) px andNb:(CGFloat) py{
    _shadow = [Robot createCharacter:CHARACTER_SHADOW_FALL];
    _shadow.position = ccp(px, py);
    _shadow.physicsBody.collisionType = @"shadowCollision";
    [_physicsWorldBot addChild:_shadow z:1];
    
    if (_isShieldOn) {
        [self shadowGetShield];
    }
    else if (_goldenShieldLevel) {
        [self shadowGetGoldenShield];
    }
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat x = self.contentSize.width/4;
    CGFloat y = _robot.position.y;
    CGFloat y2 = _shadow.position.y;
    
    [_robot removeFromParentAndCleanup:YES];
    [_shadow removeFromParentAndCleanup:YES];
    
    [self addRobotJump:x andNb:y];
    [self addShadowJump:x andNb:y2];
    
    [_robot.physicsBody applyImpulse:ccp(0, 0.05f)];
    [_shadow.physicsBody applyImpulse:ccp(0, -0.05f)];
    [self schedule:@selector(applyForceWhenTouched) interval:1.0f/60.0f];
    
    _isOnGround = NO;
}

-(void)onProgressBarClicked:(id)sender {
    if (_isShieldOn || _goldenShieldLevel > 0) {
        return;
    }
    if (_coinProgressBar.percentage >= 100.0) {
        _coinProgressBar.percentage = 0;
        _isCoinProgressFull = NO;
        _numOfCoins -= 150;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        _goldenShieldLevel = 3;
        [self robotGetGoldenShield];
        [self shadowGetGoldenShield];
    }
    else if (_coinProgressBar.percentage >= 100.0/3.0) {
        _coinProgressBar.percentage -= 100.0/3.0;
        _numOfCoins -= 50;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        [self robotGetShield];
        [self shadowGetShield];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self whenTouchEndedORCancelled];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self whenTouchEndedORCancelled];
}

- (void)whenTouchEndedORCancelled
{
    [self unschedule:@selector(applyForceWhenTouched)];
    
    CGFloat x = self.contentSize.width/4;
    CGFloat y = _robot.position.y;
    CGFloat y2 = _shadow.position.y;
    
    [_robot removeFromParentAndCleanup:YES];
    [_shadow removeFromParentAndCleanup:YES];
    
    [self addRobotFall:x andNb:y];
    [self addShadowFall:x andNb:y2];
}

- (void)applyForceWhenTouched {
    [_robot.physicsBody applyForce:ccp(0, 1.2f)];
    [_shadow.physicsBody applyForce:ccp(0, -1.2f)];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot missileCollision:(CCNode *)missile {
    
    [missile removeFromParentAndCleanup:YES];
    if (_isShieldOn) {
        [self loseShield];
        return NO;
    }
    else if (_goldenShieldLevel > 0) {
        _goldenShieldLevel--;
        if (_goldenShieldLevel == 2) {
            [_robot getChildByName:@"shieldOnRobot" recursively:NO].opacity = 0.7;
            [_robot getChildByName:@"shieldOnShadow" recursively:NO].opacity = 0.35;
            [self screenShake];
        }
        else if (_goldenShieldLevel == 1) {
            [_robot getChildByName:@"shieldOnRobot" recursively:NO].opacity = 0.3;
            [_robot getChildByName:@"shieldOnShadow" recursively:NO].opacity = 0.15;
            [self screenShake];
        }
        else {
            [self loseShield];
        }
        return NO;
    }
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"Explosion.wav"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_numOfCoins forKey:@"numOfCoins"];
    [userDefaults setBool:_isShieldOn forKey:@"isShieldOn"];
    [userDefaults setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
    [userDefaults setInteger:_goldenShieldLevel forKey:@"goldenShieldLevel"];
    [userDefaults setFloat:_coinProgressBar.percentage forKey:@"coinProgressPercentage"];
    
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot seperator1Collision:(CCNode *)seperator {
    if (_isOnGround) {
        return YES;
    }
    
    _isOnGround = YES;
    CGFloat x = self.contentSize.width/4;
    CGFloat y = _robot.position.y;
    CGFloat y2 = _shadow.position.y;
    
    [_robot removeFromParentAndCleanup:YES];
    [_shadow removeFromParentAndCleanup:YES];
    
    [self addRobotBackToRun:x andNb:y];
    [self addShadowBackToRun:x andNb:y2];
    
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot gearCollision:(CCNode *)gear {
    
    [gear removeFromParentAndCleanup:YES];
    if (_isShieldOn) {
        [self loseShield];
        return NO;
    }
    else if (_goldenShieldLevel > 0) {
        _goldenShieldLevel--;
        if (_goldenShieldLevel == 2) {
            [_robot getChildByName:@"shieldOnRobot" recursively:NO].opacity = 0.7;
            [_robot getChildByName:@"shieldOnShadow" recursively:NO].opacity = 0.35;
            [self screenShake];
        }
        else if (_goldenShieldLevel == 1) {
            [_robot getChildByName:@"shieldOnRobot" recursively:NO].opacity = 0.3;
            [_robot getChildByName:@"shieldOnShadow" recursively:NO].opacity = 0.15;
            [self screenShake];
        }
        else {
            [self loseShield];
        }
        return NO;
    }
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"Explosion.wav"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_numOfCoins forKey:@"numOfCoins"];
    [userDefaults setBool:_isShieldOn forKey:@"isShieldOn"];
    [userDefaults setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
    [userDefaults setInteger:_goldenShieldLevel forKey:@"goldenShieldLevel"];
    [userDefaults setFloat:_coinProgressBar.percentage forKey:@"coinProgressPercentage"];
    
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    return YES;
}

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


-(void)onNormalShieldClicked:(id)sender
{
    if (_isShieldOn || _goldenShieldLevel > 0) {
        return;
    }
    
    if (_coinProgressBar.percentage >= 100.0/3.0) {
        _coinProgressBar.percentage -= 100.0/3.0;
        _numOfCoins -= 50;
        [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
        
        [self robotGetShield];
        [self shadowGetShield];
    }
    
    [[self getChildByName:@"btnNormalShield" recursively:NO] removeFromParent];
}

-(void)onGoldenShieldClicked:(id)sender
{
    if (_isShieldOn || _goldenShieldLevel > 0) {
        return;
    }
    
    _coinProgressBar.percentage = 0;
    _isCoinProgressFull = NO;
    _numOfCoins -= 150;
    [((CCLabelTTF*)[self getChildByName:@"labelCoin" recursively:NO]) setString:[NSString stringWithFormat:@"Coin: %d", _numOfCoins]];
    
    _goldenShieldLevel = 3;
    [self robotGetGoldenShield];
    [self shadowGetGoldenShield];
    
    [[self getChildByName:@"btnGoldenShield" recursively:NO] removeFromParent];
}


- (void)onQuitClicked : (id)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_numOfCoins forKey:@"numOfCoins"];
    [userDefaults setBool:_isShieldOn forKey:@"isShieldOn"];
    [userDefaults setBool:_isCoinProgressFull forKey:@"isCoinProgressFull"];
    [userDefaults setInteger:_goldenShieldLevel forKey:@"goldenShieldLevel"];
    [userDefaults setFloat:_coinProgressBar.percentage forKey:@"coinProgressPercentage"];
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

@end
