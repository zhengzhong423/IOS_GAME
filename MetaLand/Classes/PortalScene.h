//
//  PortalScene.h
//  MetaLand
//
//  Created by 崔 乘瑜 on 7/9/14.
//  Copyright 2014 崔 乘瑜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface PortalScene : CCScene <CCPhysicsCollisionDelegate>

+ (PortalScene *)scene;
- (id)init;

@end
