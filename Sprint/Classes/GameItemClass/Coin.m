//
//  Coin.m
//  MetaLand
//
//  Created by yuwen lian on 6/12/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "Coin.h"

@implementation Coin


+ (CCSprite*)initCoin
{
    //CCSprite *spr = [Coin spriteWithImageNamed:@"coin.png"];

    
    
    CCSprite *spr;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"coin_1.plist"];
    CCSpriteFrame *initialSpriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin_1-1.png"];
    
    spr = [Coin spriteWithSpriteFrame:initialSpriteFrame];
    
    NSMutableArray *animationFramesRun = [NSMutableArray array];

    if (spr) {
        // ************* RUNNING ANIMATION ********************
        for(int i = 1; i <= 8; ++i) {
            [animationFramesRun addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"coin_1-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRun delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        CCActionRepeatForever *run = [CCActionRepeatForever actionWithAction: [CCActionAnimate actionWithAnimation:running]];
        [spr runAction:run];
    }
    
    
    
    
    
    
    
    
    
    
    spr.name = @"coin";
    
    return spr;
}

+ (CCSprite*)initCoinGroup : (int)type
{
    NSString *fileName;
    switch (type)
    {
        case COIN_SHAPE_LINE:
            fileName = @"coin_1X12.txt";
            break;
            
        case COIN_SHAPE_RECT:
            fileName = @"coin_3X8.txt";
            break;
            
        case COIN_SHAPE_DIAMOND:
            fileName = @"coin_diamond.txt";
            break;
            
        case COIN_SHAPE_HEART:
            fileName = @"coin_heart.txt";
            break;
            
        case COIN_SHAPE_USC:
            fileName = @"coin_USC.txt";
            break;
            
        case COIN_SHAPE_Z:
            fileName = @"coin_z.txt";
            break;
            
        case COIN_SHAPE_LONGLINE:
            fileName = @"coin_long.txt";
            break;
            
        default:
            break;
    }
    
    NSMutableArray *coinArray = [self readCoinFile:fileName];
    
    return [self createCoinGroup:coinArray];
}

+ (CCSprite*)generateRandomCoinGroupForPortalScene
{
    float pb_shape = arc4random()%10000/10000.0f;
    CCSprite *spr;
    
    if (pb_shape <= 0.2f)
        spr = [Coin initCoinGroup:COIN_SHAPE_LINE];
    else if(pb_shape <=0.3f)
        spr = [Coin initCoinGroup:COIN_SHAPE_LONGLINE];
    else if(pb_shape <=0.4f)
        spr = [Coin initCoinGroup:COIN_SHAPE_RECT];
    else if(pb_shape <=0.5f)
        spr = [Coin initCoinGroup:COIN_SHAPE_DIAMOND];
    else if(pb_shape <=0.6f)
        spr = [Coin initCoinGroup:COIN_SHAPE_HEART];
    else if(pb_shape <=0.7f)
        spr = [Coin initCoinGroup:COIN_SHAPE_USC];
    else
        spr = [Coin initCoinGroup:COIN_SHAPE_Z];
    
    return spr;
}

+(NSMutableArray*)readCoinFile:(NSString*) name {
    NSString *root = [[NSBundle mainBundle] resourcePath];
    
    //pull the content from the file into memory
    NSData* data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@", root, @"/", name]];
    //convert the bytes from the file into a string
    NSString* string = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    NSMutableArray *coinArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    int j = 0;
    for (int i = 0; i < string.length; i++) {
        NSString *character = [string substringWithRange:NSMakeRange(i, 1)];
        if (![character isEqualToString:@"\n"]) {
            [tempArray addObject:character];
        }
        else {
            [coinArray addObject:[[NSMutableArray alloc] initWithArray:tempArray]];
            [tempArray removeAllObjects];
            j++;
        }
    }
    [coinArray addObject:[[NSMutableArray alloc] initWithArray:tempArray]];
    [tempArray removeAllObjects];
    return coinArray;
}

+(CCSprite*)createCoinGroup:(NSMutableArray*)coinArray {
    CCSprite *coinGroup = [CCSprite node];
    coinGroup.name =@"coinGroup";
    
    CCSprite *spr;
    NSUInteger rowCount = [coinArray count];
    NSUInteger columnCount = [[coinArray objectAtIndex:0] count];
    
    for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
            if ([coinArray[i][j]  isEqual: @"1"]) {
                spr = [Coin initCoin];
                spr.position = ccp((j + 0.5) * spr.contentSize.width, (rowCount - 0.5 - i) * spr.contentSize.height);
                [coinGroup addChild:spr];
            }
        }
    }
    coinGroup.contentSize = CGSizeMake(columnCount * spr.contentSize.width, rowCount * spr.contentSize.height);
    coinGroup.anchorPoint = ccp(0, 0);
    return coinGroup;
}

@end
