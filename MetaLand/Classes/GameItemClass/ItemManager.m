//
//  ItemManager.m
//  MetaLand
//
//  Created by 崔 乘瑜 on 6/14/14.
//  Copyright 2014 MetaLand Team. All rights reserved.
//

#import "ItemManager.h"
#import "Item.h"

static ItemManager* manager = nil;

@implementation ItemManager

@synthesize _equipment, _utilities;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    @synchronized(self) {
        if(!manager)
        {
            manager = [[ItemManager alloc] init];
        }        
    }
    
    return manager;
}

- (id)init
{
    if( self = [super init] )
    {
        _equipment = [[NSMutableArray alloc] init];
        _utilities = [[NSMutableArray alloc] init];
        
        for (int i=0; i<10; i++ )
        {
            Equipment* tempEquip = [[Equipment alloc] init];
            tempEquip._itemImg = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"s2_%i.png",i+1]];
            tempEquip._description = [NSString stringWithFormat:@"Equipment %i", i+1];
            [_equipment addObject:tempEquip];
            
            Utility* tempUtility = [[Utility alloc] init];
            tempUtility._itemImg  = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"s2_%i.png",i+1]];
            tempUtility._description = [NSString stringWithFormat:@"Utility %i", i+1];
            [_utilities addObject:tempUtility];
        }
    }
    
    return self;
}

@end
