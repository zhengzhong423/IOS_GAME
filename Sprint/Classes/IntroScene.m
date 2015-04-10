//
//  IntroScene.m
//  MetaLand
//
//  Copyright MetaLand Team 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"


// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //    OALSimpleAudio* audio = [OALSimpleAudio sharedInstance];
    //    [audio playBg:@"main_menu_music.mp3" loop:YES];
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];
    
    //add game intro background
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"main_bg.png"];
    bg.name=@"bg";
    bg.anchorPoint = CGPointZero;
    bg.position = ccp(0, 0);
    [self addChild:bg];
    
    /*
     // Hello world
     CCLabelTTF *label = [CCLabelTTF labelWithString:@"Metaland" fontName:@"Chalkduster" fontSize:36.0f];
     label.positionType = CCPositionTypeNormalized;
     label.color = [CCColor redColor];
     label.position = ccp(0.5f, 0.5f); // Middle of screen
     [self addChild:label];
     */
    
    //CCButton *startButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    CCButton *startButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"start.png"]];
    startButton.name=@"start_button";
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.5f, 0.2f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];
    
    /*
     CCButton *settingsButton = [CCButton buttonWithTitle:@"[ Settings ]" fontName:@"Verdana-Bold" fontSize:18.0f];
     settingsButton.positionType = CCPositionTypeNormalized;
     settingsButton.position = ccp(0.25f, 0.35f);
     [settingsButton setTarget:self selector:@selector(onSettingsClicked:)];
     [self addChild:settingsButton];
     
     CCButton *storeButton = [CCButton buttonWithTitle:@"[ Store ]" fontName:@"Verdana-Bold" fontSize:18.0f];
     storeButton.positionType = CCPositionTypeNormalized;
     storeButton.position = ccp(0.75f, 0.35f);
     [storeButton setTarget:self selector:@selector(onStoreClicked:)];
     [self addChild:storeButton];
     */
    
    // done
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onStartClicked:(id)sender
{
    /*
     [[CCDirector sharedDirector] replaceScene:[GameScene scene]
     withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
     */
    
    [self removeChildByName:@"bg"];
    [self removeChildByName:@"start_button"];
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"main_bg_copy.png"];
    bg.anchorPoint = CGPointZero;
    bg.position = ccp(0, 0);
    [self addChild:bg];
    
    
    for(int i=1;i<=3;i++){
        CCButton *startButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"start.png"]];
        startButton.positionType = CCPositionTypeNormalized;
        startButton.position = ccp(0.5f, 0.2*i);
        [startButton setTarget:self selector:@selector(onLevelsClicked:)];
        [self addChild:startButton];
    }
    
    
    
    
    //    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

- (void)onLevelsClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
    //    if(level==1){
    //
    //    }else if(level==2){
    //
    //    }else{
    //
    //    }
}

- (void)onSettingsClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SettingsScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

- (void)onStoreClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] pushScene:[StoreScene scene]
                            withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}
// -----------------------------------------------------------------------
@end
