//
//  BRMenuOrderingFlowController.m
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingFlowController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponentGroup.h"

@implementation BRMenuOrderingFlowController {
	BRMenu *menu;
	id<BRMenuItemObject> item;
	NSArray *steps;
	NSUInteger flowStep;
}

@synthesize menu, item;

- (id)initWithMenu:(BRMenu *)theMenu {
	return [self initWithMenu:theMenu item:nil];
}

- (id)initWithMenu:(BRMenu *)theMenu item:(id<BRMenuItemObject>)theItem {
	if ( (self = [super init]) ) {
		menu = theMenu;
		item = theItem;
		[self setupFlow];
	}
	return self;
}

- (id)initWithFlow:(BRMenuOrderingFlowController *)flow step:(NSUInteger)step {
	if ( (self = [super init]) ) {
		menu = flow.menu;
		item = flow.item;
		steps = flow->steps;
		flowStep = step;
	}
	return self;
}

- (void)setupFlow {
	if ( item ) {
		NSMutableArray *theSteps = [NSMutableArray arrayWithCapacity:3];
		[self setupFlowForMenuItem:item steps:theSteps];
		steps = [theSteps copy];
		flowStep = 0;
	} else {
		[self setupFlowForMenu];
	}
}

- (void)setupFlowForMenu {
	flowStep = NSNotFound;
}

- (void)setupFlowForMenuItem:(BRMenuItem *)menuItem steps:(NSMutableArray *)theSteps {
	if ( menuItem.extendsKey != nil ) {
		BRMenuItem *parent = [menu menuItemForKey:menuItem.extendsKey];
		if ( parent != nil ) {
			[self setupFlowForMenuItem:parent steps:theSteps];
		}
	}
	if ( [menuItem.componentGroups count] > 0 ) {
		[self setupFlowForMenuItem:menuItem steps:theSteps componentGroups:menuItem.componentGroups];
	}
}

- (void)setupFlowForMenuItem:(BRMenuItem *)menuItem steps:(NSMutableArray *)theSteps componentGroups:(NSArray *)componentGroups {
	// look for nested groups, while combining adjacent groups without nesting into single step
	NSMutableArray *currentStepGroups = [NSMutableArray arrayWithCapacity:[componentGroups count]];
	for ( BRMenuItemComponentGroup *group in componentGroups ) {
		if ( group.componentGroups != nil ) {
			if ( [currentStepGroups count] > 0 ) {
				[self addStep:theSteps];
				[self addMenuItemComponentGroups:currentStepGroups steps:theSteps];
				[currentStepGroups removeAllObjects];
			}
			// found a group with nested groups... add as new step
			[self setupFlowForMenuItem:menuItem steps:theSteps componentGroups:group.componentGroups];
		} else {
			[currentStepGroups addObject:group];
		}
	}
	if ( [currentStepGroups count] > 0 ) {
		[self addStep:theSteps];
		[self addMenuItemComponentGroups:currentStepGroups steps:theSteps];
	}
}

- (void)addStep:(NSMutableArray *)theSteps {
	[theSteps addObject:[NSMutableArray arrayWithCapacity:3]];
}

- (void)addMenuItemComponentGroups:(NSArray *)groups steps:(NSMutableArray *)theSteps {
	[(NSMutableArray *)[theSteps lastObject] addObjectsFromArray:groups];
}

- (NSArray *)menuItemComponentGroupsForStep:(NSUInteger)step {
	return [steps objectAtIndex:step];
}

#pragma mark - Public API

- (NSInteger)numberOfSections {
	if ( item == nil ) {
		return 1;
	}
	return [self menuItemComponentGroupsForStep:flowStep].count;
}

- (NSString *)titleForSection:(NSInteger)section {
	if ( item == nil ) {
		return nil;
	}
	BRMenuItemComponentGroup *componentGroup = [self menuItemComponentGroupsForStep:flowStep][section];
	return componentGroup.title;
}

- (NSDecimalNumber *)priceForSection:(NSInteger)section {
	return nil;
	// TODO: implement
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	if ( item == nil ) {
		return (menu.items.count + menu.groups.count);
	}
	BRMenuItemComponentGroup *componentGroup = [self menuItemComponentGroupsForStep:flowStep][section];
	return componentGroup.components.count;
}

- (id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> result = nil;
	if ( item == nil ) {
		NSUInteger index = [indexPath indexAtPosition:1];
		if ( index != NSNotFound ) {
			if ( index < [menu.items count] ) {
				result = [menu.items objectAtIndex:index];
			} else {
				index -= [menu.items count];
				result = [menu.groups objectAtIndex:index];
			}
		}
	} else {
		NSUInteger section = [indexPath indexAtPosition:0];
		NSUInteger index = [indexPath indexAtPosition:1];
		BRMenuItemComponentGroup *componentGroup = [self menuItemComponentGroupsForStep:flowStep][section];
		result = componentGroup.components[index];
	}
	return result;
}

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section {
	// like what UIKit does, but we have only Foundation imported
	NSUInteger indexArr[] = {section, row};
	return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}

- (NSIndexPath *)indexPathForMenuItemObject:(id<BRMenuItemObject>)itemObject {
	NSIndexPath *result = nil;
	if ( item == nil ) {
		NSUInteger idx = [menu.items indexOfObjectIdenticalTo:itemObject];
		if ( idx == NSNotFound ) {
			idx = [menu.groups indexOfObjectIdenticalTo:itemObject];
			if ( idx != NSNotFound ) {
				idx += menu.items.count;
			}
		}
		result = [BRMenuOrderingFlowController indexPathForRow:idx inSection:1];
	} else {
		// TODO
	}
	return result;
}

- (instancetype)flowControllerForItemAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> item = [self menuItemObjectAtIndexPath:indexPath];
	BRMenuOrderingFlowController *result = nil;
	if ( item ) {
		result = [[[self class] alloc] initWithMenu:menu item:item];
	}
	return result;
}

@end
