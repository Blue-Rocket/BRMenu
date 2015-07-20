//
//  BRMenuMappingPostProcessorTests.m
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuMappingPostProcessor.h"

@interface BRMenuMappingPostProcessorTests : XCTestCase

@end

@implementation BRMenuMappingPostProcessorTests

- (void)testAssignMenuIds {
	BRMenuItem *pizzaItem = [BRMenuItem new];
	pizzaItem.title = @"Pizza";
	//pizzaItem.itemId = 1;
	
	BRMenuItem *pizzaPlusItem = [BRMenuItem new];
	pizzaPlusItem.title = @"Pizza+";
	//pizzaPlusItem.itemId = 2;
	
	BRMenuItemComponent *traditionalDough = [BRMenuItemComponent new];
	//traditionalDough.componentId = 1;
	traditionalDough.title = @"Traditional";
	
	BRMenuItemComponent *wholeWheatDough = [BRMenuItemComponent new];
	//wholeWheatDough.componentId = 2;
	wholeWheatDough.title = @"Whole Wheat";
	
	BRMenuItemComponentGroup *doughGroup = [BRMenuItemComponentGroup new];
	doughGroup.components = @[traditionalDough, wholeWheatDough];
	
	pizzaPlusItem.componentGroups = @[doughGroup];

	BRMenu *menu = [BRMenu new];
	menu.items = @[pizzaItem, pizzaPlusItem];
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	assertThat(@(pizzaItem.itemId), equalTo(@1));
	assertThat(@(pizzaPlusItem.itemId), equalTo(@2));

	assertThat(@(traditionalDough.componentId), equalTo(@1));
	assertThat(@(wholeWheatDough.componentId), equalTo(@2));
}

@end
