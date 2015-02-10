//
//  ScrollingNode.h
//  MetaLand
//
//  Created by Weiwei Zheng on 6/6/14.
//  Copyright (c) 2014 Weiwei Zheng. All rights reserved.
//
#import "Spritekit/SKSpriteNode.h"


@interface SKScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float) width;
- (void) update:(NSTimeInterval)currentTime;


@end
