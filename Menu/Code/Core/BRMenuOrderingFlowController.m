//
//  BRMenuOrderingFlowController.m
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderingFlowController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponentGroup.h"

@implementation BRMenuOrderingFlowController {
	BRMenu *menu;
	id<BRMenuItemObject> item;
	NSArray *steps;
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

- (void)setupFlow {
	if ( item ) {
		NSMutableArray *theSteps = [NSMutableArray arrayWithCapacity:3];
		[self setupFlowForMenuItem:item steps:theSteps];
		steps = [theSteps copy];
	} else {
		[self setupFlowForMenu];
	}
}

- (void)setupFlowForMenu {

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

#pragma mark - Public API

- (NSInteger)numberOfSections {
	if ( item == nil ) {
		return 1;
	}
	// TODO
	return 0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	if ( item == nil ) {
		return (self.menu.items.count + self.menu.groups.count);
	}
	// TODO
	return 0;
}

- (id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> result = nil;
	if ( item == nil ) {
		NSUInteger index = [indexPath indexAtPosition:1];
		if ( index != NSNotFound ) {
			if ( index < [self.menu.items count] ) {
				result = [self.menu.items objectAtIndex:index];
			} else {
				index -= [self.menu.items count];
				result = [self.menu.groups objectAtIndex:index];
			}
		}
	} else {
		// TODO
	}
	return result;
}

// like what UIKit does
+ (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section {
	NSUInteger indexArr[] = {section, row};
	return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}

- (NSIndexPath *)indexPathForMenuItemObject:(id<BRMenuItemObject>)itemObject {
	NSIndexPath *result = nil;
	if ( item == nil ) {
		NSUInteger idx = [self.menu.items indexOfObjectIdenticalTo:itemObject];
		if ( idx == NSNotFound ) {
			idx = [self.menu.groups indexOfObjectIdenticalTo:itemObject];
			if ( idx != NSNotFound ) {
				idx += self.menu.items.count;
			}
		}
		result = [BRMenuOrderingFlowController indexPathForRow:idx inSection:1];
	} else {
		// TODO
	}
	return result;
}

@end
