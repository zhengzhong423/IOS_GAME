//
//  SettingsScene.m
//  MetaLand
//
//  Created by John Rocamora on 6/11/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "SettingsScene.h"

@implementation SettingsScene
+ (SettingsScene*)scene {
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]];
    [self addChild:background];
    

    CCButton *changeButton = [CCButton buttonWithTitle:@"[ Change ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    changeButton.positionType = CCPositionTypeNormalized;
    changeButton.position = ccp(0.5f, 0.5f);
    [changeButton setTarget:self selector:@selector(onChangeClicked:)];
    [self addChild:changeButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onChangeClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}


@end
