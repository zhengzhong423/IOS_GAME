//
//  GameOverScene.m
//  MetaLand
//
//  Created by yuwen lian on 6/12/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "GameScene.h"
#import "IntroScene.h"
#import "Storescene.h"
#import "GameOverScene.h"

@implementation GameOverScene {
    CCButton *_restartButton;
    CCButton *_storeButton;
    CCButton *_menuButton;
    
    CCLabelTTF *_gameOverTextLabel;
    CCLabelTTF *_highestScoreLabel;
    CCLabelTTF *_distanceLabel;
    CCLabelTTF *_totalCoinLabel;
    CCLabelTTF *_totalScoreLabel;
    
    
    NSUserDefaults *_userDefault;
    
    int _score;
    int _numOfCoins;
    int _deltaCoin;
    int _highestScore;
    
    BOOL _isScoreCalculateFinished;
}

+ (GameOverScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    _isScoreCalculateFinished = NO;
    
    _userDefault = [NSUserDefaults standardUserDefaults];

    _score = (int)[_userDefault integerForKey:@"distance"];
    _numOfCoins = (int)[_userDefault integerForKey:@"numOfCoins"];
    //_numOfCoins = 1444;
    _highestScore = (int)[_userDefault integerForKey:@"highestScore"];
    
    if (_numOfCoins>200 )
        _deltaCoin = _numOfCoins/200;
    else
        _deltaCoin = 1;
    
    OALSimpleAudio* audio = [OALSimpleAudio sharedInstance];
    [audio stopBg];
    
    //add game over background
    CCSprite *gameoverbg = [CCSprite spriteWithImageNamed:@"bggameover.png"];
    gameoverbg.anchorPoint = CGPointZero;
    gameoverbg.position = ccp(0, 0);
    [self addChild:gameoverbg];
    
//    CCSprite *chara = [CCSprite spriteWithImageNamed:@"robot_fall.png"];
//    chara.anchorPoint = CGPointZero;
//    chara.position = ccp(100.0f, 135.0f);
//    chara.scale = 2.0;
//    [self addChild:chara z:0];
    
    // Display game over text
    [self displayHighestScore];
    //[self displayGameOverText];
    [self displayGameDistance];
    [self displayTotalCoins];
    [self displayTotalScore];
    [self displayGameOverText];
    // Add buttons
    [self addRestartButton];
    [self addStoreButton];
    [self addMenuButton];
    
    // done
	return self;
}

-(void)update:(CCTime)delta
{
    if(_numOfCoins>_deltaCoin)
    {
        _numOfCoins = _numOfCoins - _deltaCoin;
        _score = _score + 2*_deltaCoin;
        [_totalCoinLabel setString:[NSString stringWithFormat:@"Coin: %i", _numOfCoins]];
        [_totalScoreLabel setString:[NSString stringWithFormat:@"Score: %i", _score]];
    }
    else if(_numOfCoins>0 && _numOfCoins<=_deltaCoin)
    {
        _numOfCoins = _numOfCoins - 1;
        _score = _score + 2;
        [_totalCoinLabel setString:[NSString stringWithFormat:@"Coin: %i", _numOfCoins]];
        [_totalScoreLabel setString:[NSString stringWithFormat:@"Score: %i", _score]];
    }
    else if(_numOfCoins==0)
    {
        _numOfCoins = -1;
        if(_highestScore < _score)
        {
            [_userDefault setInteger:_score forKey:@"highestScore"];
            
            CCAction *fadeOut = [CCActionFadeOut actionWithDuration:0.5f];
            CCAction *fadeIn = [CCActionFadeIn actionWithDuration:0.5f];
            CCAction *changeHighestScore = [CCActionCallBlock actionWithBlock:^{
                _highestScore = _score;
                [_highestScoreLabel setString:[NSString stringWithFormat:@"Highest Score: %i", _score]];
                _highestScoreLabel.color = [CCColor colorWithCcColor3b:ccc3(242, 235, 39)];
            }];
            
            [_highestScoreLabel runAction:[CCActionSequence actionWithArray:@[fadeOut, fadeIn, fadeOut, fadeIn, changeHighestScore]]];
        }
    }
}


// -----------------------------------------------------------------------
#pragma mark - Add Buttons
// -----------------------------------------------------------------------
-(void)displayHighestScore {
//    _highestScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highest Score: %i", _highestScore] fontName:@"Verdana-Bold" fontSize:24.0f];
//    _highestScoreLabel.positionType = CCPositionTypeNormalized;
//    _highestScoreLabel.position = ccp(0.6f, 0.8f);
//    _highestScoreLabel.color = [CCColor colorWithCcColor3b:ccc3(130, 22, 22)];
//    [self addChild:_highestScoreLabel];

}

-(void)displayGameOverText {
    _gameOverTextLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Game Over" ] fontName:@"MarkerFelt-Wide" fontSize:45.0f];
    _gameOverTextLabel.positionType = CCPositionTypeNormalized;
    _gameOverTextLabel.position = ccp(0.5f, 0.75f);
    _gameOverTextLabel.color = [CCColor colorWithCcColor3b:ccc3(0x82, 0x16, 0x16)];
    [self addChild:_gameOverTextLabel z:0];
}

-(void)displayGameOver{
    
    
}

-(void)displayGameDistance {
//    _distanceLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Distance: %ld M (MAX %ld M)", (long)[_userDefault integerForKey:@"distance"], (long)[_userDefault integerForKey:@"record"]] fontName:@"Verdana-Bold" fontSize:18.0f];
//    _distanceLabel.positionType = CCPositionTypeNormalized;
//    _distanceLabel.position = ccp(0.6f, 0.65f);
//    _distanceLabel.color = [CCColor colorWithCcColor3b:ccc3(130, 22, 22)];
//    [self addChild:_distanceLabel z:0];
    // Reinitialize the score in database to 0
    //[_userDefault setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"distance"];
    //[_userDefault synchronize];
}

-(void)displayTotalCoins {
    _totalCoinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You Ran: %ld m (Max: %ld m)", (long)[_userDefault integerForKey:@"distance"],(long)[_userDefault integerForKey:@"record"] ] fontName:@"MarkerFelt-Wide" fontSize:20.0f];
    _totalCoinLabel.positionType = CCPositionTypeNormalized;
    _totalCoinLabel.position = ccp(0.5f, 0.50f);
    _totalCoinLabel.color = [CCColor colorWithCcColor3b:ccc3(0x82, 0x16, 0x16)];
    [self addChild:_totalCoinLabel z:0];
}

-(void)displayTotalScore {
    _totalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your Score: %i (Highest: %i)", _score,_highestScore] fontName:@"MarkerFelt-Wide" fontSize:20.0f];
    _totalScoreLabel.positionType = CCPositionTypeNormalized;
    _totalScoreLabel.position = ccp(0.5f, 0.60f);
    _totalScoreLabel.color = [CCColor colorWithCcColor3b:ccc3(0x82, 0x16, 0x16)];
    [self addChild:_totalScoreLabel];
}

// -----------------------------------------------------------------------
#pragma mark - Add Buttons
// -----------------------------------------------------------------------
-(void)addRestartButton {
    _restartButton = [CCButton buttonWithTitle:@"[-- Play Again --]" fontName:@"Verdana-Bold" fontSize:18.0f];
    _restartButton.positionType = CCPositionTypeNormalized;
    _restartButton.position = ccp(0.5, 0.3f);
    [_restartButton setTarget:self selector:@selector(onRestartClicked:)];
    [self addChild:_restartButton z:0];
}

-(void)addStoreButton {
//    _storeButton = [CCButton buttonWithTitle:@"[ Store ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    _storeButton.positionType = CCPositionTypeNormalized;
//    _storeButton.position = ccp(0.5, 0.2f);
//    [_storeButton setTarget:self selector:@selector(onStoreClicked:)];
//    [self addChild:_storeButton z:0];
}

-(void)addMenuButton {
    _menuButton = [CCButton buttonWithTitle:@"[-- Return --]" fontName:@"Verdana-Bold" fontSize:18.0f];
    _menuButton.positionType = CCPositionTypeNormalized;
    _menuButton.position = ccp(0.5, 0.2f);
    [_menuButton setTarget:self selector:@selector(onMenuClicked:)];
    [self addChild:_menuButton z:0];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------
-(void)onRestartClicked:(id)sender {
    // Reflesh the game scene
    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onMenuClicked:(id)sender {
    // Go back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onStoreClicked:(id)sender {
    // Go to store scene
    [[CCDirector sharedDirector] pushScene:[StoreScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}
@end
