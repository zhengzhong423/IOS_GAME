//
//  Item.m
//  MetaLand
//
//  Created by 崔 乘瑜 on 6/12/14.
//  Copyright 2014 MetaLand Team. All rights reserved.
//

#import "Item.h"

////////////////////////////////////////////////////////
/////////  Base class for all items in the game  ///////
////////////////////////////////////////////////////////
@implementation Item

@synthesize _price;
@synthesize _description;
@synthesize _itemImg;

- (id)init
{
    if([super init])
    {
        _price = 0;
        _description = @"";
    }
    
    return self;
}

@end

////////////////////////////////////////////////////////
//////////////   Class for utilities   /////////////////
////////////////////////////////////////////////////////
@implementation Utility

@synthesize _quantity;

- (id)init
{
    if([super init])
    {
        _quantity = 0;
    }
    
    return self;
}

@end

////////////////////////////////////////////////////////
/////////////    Class for equipment   /////////////////
////////////////////////////////////////////////////////
@implementation Equipment

@synthesize _isPossessed;

- (id)init
{
    if([super init])
    {
        _isPossessed = NO;
    }
    
    return self;
}
@end
