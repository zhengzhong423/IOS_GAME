//
//  StoreScene.m
//  MetaLand
//
//  Created by Chengyu Cui on 6/5/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "StoreScene.h"
#import "ClipNode.h"
#import "GameItemClass/Item.h"
#import "ItemManager.h"

#define SHOW_ITEM_EQUIPMENT 0
#define SHOW_ITEM_UTILITY 1

#define MENU_ITEM_EQUIPMENT 0
#define MENU_ITEM_UTILITY 1
#define MENU_ITEM_OTHERS 2

@implementation StoreScene
{
    ClipNode* _scrollViewBg;
    CCScrollView* _scrollView;
    
    //Use to accomplish auto-alignment of items
    float _xPosOfScrollViewBgInPoint;
    float _leftFlag;
    float _rightFlag;
    
    //Use to decide whether the scrollview is moving
    CGPoint _lastScrollPos;
    CGPoint _currentScrollPos;
    
    //The label showing infomation of items
    CCLabelTTF* _labelDescription;
    int _labelFlag;
    
    CCButton *_menuItemEquip, *_menuItemUtility, *_menuItem3;
}

+ (StoreScene*)scene {
    return [[self alloc] init];
}

- (id)init {
    
    self = [super init];
    if(!self)
        return nil;

    self.userInteractionEnabled = YES;
    
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    
    
    CCSpriteFrame *item1 = [CCSpriteFrame frameWithImageNamed:@"store_menu_pic_1.png"];
    _menuItemEquip = [CCButton buttonWithTitle:nil spriteFrame:item1];
    _menuItemEquip.selected = YES;
    [_menuItemEquip setTarget:self selector:@selector(onEquipButtonClicked)];
    
    CCSpriteFrame *item2 = [CCSpriteFrame frameWithImageNamed:@"store_menu_pic_2.png"];
    //CCButton* menuItem2 = [CCButton buttonWithTitle:nil spriteFrame:item2];
    _menuItemUtility = [CCButton buttonWithTitle:nil spriteFrame:item2 highlightedSpriteFrame:item1 disabledSpriteFrame:nil];
    [_menuItemUtility setTarget:self selector:@selector(onUtilityButtonClicked)];
    
    CCSpriteFrame *item3 = [CCSpriteFrame frameWithImageNamed:@"store_menu_pic_3.png"];
    _menuItem3 = [CCButton buttonWithTitle:nil spriteFrame:item3];
    
    CCLayoutBox* layoutBox = [[CCLayoutBox alloc] init];
    layoutBox.anchorPoint = ccp(0.0f,0.5f);
    layoutBox.position = ccp(0.0f, screenSize.height/2);
    layoutBox.spacing = 10.0f;
    layoutBox.direction = CCLayoutBoxDirectionVertical;
    [layoutBox layout];
    
    [layoutBox addChild:_menuItem3];
    [layoutBox addChild:_menuItemUtility];
    [layoutBox addChild:_menuItemEquip];
    
    [self addChild:layoutBox];
    
    CCSpriteFrame *btnBackImg = [CCSpriteFrame frameWithImageNamed:@"Icon-Small-50.png"];
    CCButton* btnBack = [CCButton buttonWithTitle:@"BACK" spriteFrame:(btnBackImg)];
    btnBack.anchorPoint = ccp(1.0f, 1.0f);
    btnBack.position = ccp(screenSize.width, screenSize.height);
    [btnBack setTarget:self selector:@selector(onBackClicked)];
    [self addChild:btnBack];
    
    _scrollViewBg = [ClipNode node];
    _scrollViewBg.contentSize = CGSizeMake(300, 100);
    _scrollViewBg.positionType = CCPositionTypeNormalized;
    _scrollViewBg.position = ccp(0.35f, 0.6f);
    _scrollViewBg.userInteractionEnabled = YES;
    [self addChild:_scrollViewBg];
    
    _xPosOfScrollViewBgInPoint = [_scrollViewBg convertToWorldSpace:CGPointZero].x + [_scrollViewBg contentSizeInPoints].width*0.5;
    CCSprite* sprTemp = [CCSprite spriteWithImageNamed:@"s2_1.png"];
    _leftFlag = _xPosOfScrollViewBgInPoint - [sprTemp contentSizeInPoints].width;
    _rightFlag = _xPosOfScrollViewBgInPoint + [sprTemp contentSizeInPoints].width;

    
    _scrollView = [[CCScrollView alloc] initWithContentNode:[self createScrollContent:SHOW_ITEM_EQUIPMENT]];
    //scrollView.flipYCoordinates = NO;
    //_scrollView.pagingEnabled = YES;
    _scrollView.verticalScrollEnabled = NO;
    _scrollView.contentSizeType = CCSizeTypeNormalized;
    _scrollView.contentSize = CGSizeMake(1.0f, 1.0f);
    [_scrollViewBg addChild:_scrollView];
    
    _labelFlag = SHOW_ITEM_EQUIPMENT;
    
    _currentScrollPos = _scrollView.scrollPosition;
    _lastScrollPos = _scrollView.scrollPosition;
    
    _labelDescription = [CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:20];
    _labelDescription.contentSize = CGSizeMake(200, 100);
    _labelDescription.positionType = CCPositionTypeNormalized;
    _labelDescription.position = CGPointMake(0.65f, 0.3f);
    [self addChild:_labelDescription];
    
    
    [self schedule:@selector(updateItem:) interval:0.03f];
    [self schedule:@selector(updateLabel) interval:0.1f];
    
    return self;
}

//To set content of scrollview
- (CCNode*)createScrollContent : (int)itemTypeFlag
{
    //CCDirector* director = [CCDirector sharedDirector];
    
    CCNode* node = [CCNode node];
    NSUInteger numOfItems;
    
    node.contentSizeType = CCSizeTypeNormalized;
    
    switch (itemTypeFlag) {
        case SHOW_ITEM_EQUIPMENT:
            numOfItems = [((ItemManager*)[ItemManager sharedManager])._equipment count];
            node.contentSize = CGSizeMake(numOfItems/3.0f, 1.0f);
            
            for( int i=0; i<numOfItems; i++ )
            {
                CCSprite* spr = [[((ItemManager*)[ItemManager sharedManager])._equipment objectAtIndex:i] _itemImg];
                spr.positionType = CCPositionTypeNormalized;
                spr.position = ccp((i+0.5f)/numOfItems, 0.5f);
                [node addChild:spr];
            }
            _labelFlag = SHOW_ITEM_EQUIPMENT;
            break;
        
        case SHOW_ITEM_UTILITY:
            numOfItems = [((ItemManager*)[ItemManager sharedManager])._utilities count];
            node.contentSize = CGSizeMake(numOfItems/3.0f, 1.0f);
            
            for( int i=0; i<numOfItems; i++ )
            {
                CCSprite* spr = [[((ItemManager*)[ItemManager sharedManager])._utilities objectAtIndex:i] _itemImg];
                spr.positionType = CCPositionTypeNormalized;
                spr.position = ccp((i+0.5f)/numOfItems, 0.5f);
                [node addChild:spr];
            }
            _labelFlag = SHOW_ITEM_UTILITY;
            break;
            
        default:
            break;
    }
    
    return node;
}

- (void)updateItem:(CCTime)delta
{
    
    for (NSObject* obj in [_scrollView.contentNode children])
    {
        [self animateItem:(CCSprite*)obj];
    }
    
}

//Accomplish the auto-scale of item images
- (void)animateItem : (CCSprite*)spr
{

    CGPoint leftCornerOfSpr = [spr convertToWorldSpace:CGPointZero];
    float xPosOfSpr = leftCornerOfSpr.x + spr.scale * spr.contentSizeInPoints.width * 0.5;
    
    //To avoid unnecessary compuations of Items that currently not shown in the scrollview
    if( xPosOfSpr<_xPosOfScrollViewBgInPoint-[_scrollViewBg contentSizeInPoints].width*0.5 || xPosOfSpr>_xPosOfScrollViewBgInPoint+[_scrollViewBg contentSizeInPoints].width*0.5 )
    {
        return;
    }
    
    
    if( xPosOfSpr>=_leftFlag && xPosOfSpr<_xPosOfScrollViewBgInPoint)
    {
        spr.scale = 0.005f * xPosOfSpr - 0.44f;
        spr.opacity = 0.005f * xPosOfSpr - 0.59f;
    }
    else if( xPosOfSpr>=_xPosOfScrollViewBgInPoint && xPosOfSpr<_rightFlag)
    {
        spr.scale = -0.005f * xPosOfSpr + 3.04f;
        spr.opacity = -0.005f * xPosOfSpr + 2.59f;
    }
    else
    {
        spr.scale = 1.0f;
        spr.opacity = 0.7f;
    }
    
    //NSLog(@"Position: %f, %f, %f", _leftFlag, _xPosOfScrollViewBgInPoint, _rightFlag);
    
}

//Update the content of label
- (void)updateLabel
{
    switch (_labelFlag) {
        case SHOW_ITEM_EQUIPMENT:
            for (Equipment* equip in ((ItemManager*)[ItemManager sharedManager])._equipment) {
                if (equip._itemImg.scale > 1.2f) {
                    [_labelDescription setString:equip._description];
                    break;
                }
            }
            break;
            
        case SHOW_ITEM_UTILITY:
            for (Utility* utility in ((ItemManager*)[ItemManager sharedManager])._utilities) {
                if (utility._itemImg.scale > 1.2f) {
                    [_labelDescription setString:utility._description];
                    break;
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //[super touchBegan:touch withEvent:event];
    //NSLog(@"Touch!!!");
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"Touch Ended!");
    /*
    CGPoint currentScrollPos = _scrollView.scrollPosition;

    int scrollPosOffset = (int)currentScrollPos.x%100;
    //int scrollDestination = (int)currentScrollPos.x/100;
    if( scrollPosOffset>=50 )
    {
        float scrollPosDelta = (100.0-scrollPosOffset)/1000.0f;
        for( int i=1; i<1000; i++ )
        {
            _scrollView.scrollPosition = ccp(_scrollView.scrollPosition.x+scrollPosDelta, 0);
        }
    }
    else
    {
        float scrollPosDelta = -scrollPosOffset/1000.0f;
        for( int i=1; i<1000; i++ )
        {
            _scrollView.scrollPosition = ccp(_scrollView.scrollPosition.x+scrollPosDelta, 0);
        }
    }
     */

}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"Touch Cancelled!");
    
    [self scheduleOnce:@selector(denoteLastScrollPos) delay:0.9f];
    [self scheduleOnce:@selector(denoteCurrentScrollPos) delay:0.95f];

    
    [self scheduleOnce:@selector(alignItems) delay:1.0f];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"Touch Moved!");
}


//Automatically align the items
- (void)alignItems
{
    _scrollView.userInteractionEnabled = NO;
    
    CGPoint currentScrollPos = _scrollView.scrollPosition;
    
    int scrollPosOffset = (int)currentScrollPos.x%100;
    float offsetDegree = scrollPosOffset * 1000.0f;
    
    if( scrollPosOffset>=50 )
    {
        float scrollPosDelta = (100.0-scrollPosOffset)/offsetDegree;
        for( int i=1; i<offsetDegree; i++ )
        {
            _scrollView.scrollPosition = ccp(_scrollView.scrollPosition.x+scrollPosDelta, 0);
        }
    }
    else
    {
        float scrollPosDelta = -scrollPosOffset/offsetDegree;
        for( int i=1; i<offsetDegree; i++ )
        {
            _scrollView.scrollPosition = ccp(_scrollView.scrollPosition.x+scrollPosDelta, 0);
        }
    }
    _scrollView.userInteractionEnabled = YES;

}

- (void)denoteLastScrollPos
{
    _lastScrollPos = _scrollView.scrollPosition;
}

- (void)denoteCurrentScrollPos
{
    _currentScrollPos = _scrollView.scrollPosition;
}

//Callback func of Back button
- (void)onBackClicked
{
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

//Callback func of Equipment button
- (void)onEquipButtonClicked
{
    if(_menuItemEquip.selected)
    {
        return;
    }
    
    _menuItemEquip.selected = YES;
    _menuItemUtility.selected = NO;
    _menuItem3.selected = NO;
    
    _scrollView.contentNode = [self createScrollContent:SHOW_ITEM_EQUIPMENT];
}

//Callback func of Utility button
- (void)onUtilityButtonClicked
{
    if(_menuItemUtility.selected)
    {
        return;
    }
    
    _menuItemUtility.selected = YES;
    _menuItemEquip.selected = NO;
    _menuItem3.selected = NO;
    
    _scrollView.contentNode = [self createScrollContent:SHOW_ITEM_UTILITY];
}

//This function hasn't been used in this version
//But it may be used later
- (void)onMenuItemClicked : (int)whichItem
{
    switch (whichItem) {
        case MENU_ITEM_EQUIPMENT:
            if(_menuItemEquip.selected)
            {
                return;
            }
            
            _menuItemEquip.selected = YES;
            _menuItemUtility.selected = NO;
            _menuItem3.selected = NO;
            
            _scrollView.contentNode = [self createScrollContent:SHOW_ITEM_EQUIPMENT];
            break;
            
        case MENU_ITEM_UTILITY:
            if(_menuItemUtility.selected)
            {
                return;
            }
            
            _menuItemUtility.selected = YES;
            _menuItemEquip.selected = NO;
            _menuItem3.selected = NO;
            
            _scrollView.contentNode = [self createScrollContent:SHOW_ITEM_UTILITY];
            break;
            
        case MENU_ITEM_OTHERS:
            break;
            
        default:
            break;
    }
}


@end
