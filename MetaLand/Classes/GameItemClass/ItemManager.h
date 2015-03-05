//
//  ItemManager.h
//  MetaLand
//
//  Created by 崔 乘瑜 on 6/14/14.
//  Copyright 2014 MetaLand Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ItemManager : CCNode {
    NSMutableArray* _equipment;
    NSMutableArray* _utilities;
}

@property (nonatomic, retain) NSMutableArray *_equipment, *_utilities;

+ (id)sharedManager;

@end
