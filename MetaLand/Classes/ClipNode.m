//
//  ClipNode.m
//  MetaLand
//
//  Created by Chengyu Cui on 6/9/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "ClipNode.h"

@implementation ClipNode

- (void)visit
{
    glEnable(GL_SCISSOR_TEST);
    CGPoint worldPosition = [self convertToWorldSpace:CGPointZero];
    const CGFloat s = [[CCDirector sharedDirector] contentScaleFactor];
    glScissor((0) + (worldPosition.x*s), (0) + (worldPosition.y*s),(self.contentSizeInPoints.width*s), (self.contentSizeInPoints.height*s));
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super touchBegan:touch withEvent:event];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super touchCancelled:touch withEvent:event];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super touchEnded:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super touchMoved:touch withEvent:event];
}

@end
