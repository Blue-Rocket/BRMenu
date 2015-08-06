//
//  BRMenuOrderingFlowController.m
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingFlowController.h"

#import "BRMenu.h"
#import "BRMenuConstants.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "NSBundle+BRMenu.h"

@implementation BRMenuOrderingFlowController {
	BRMenu *menu;
	BRMenuItem *item;
	BRMenuOrderItem *orderItem;
	BRMenuItemGroup *itemGroup;
	BRMenuOrder *temporaryOrder;
	NSArray *steps;
	NSUInteger flowStep;
}

@synthesize menu, item, orderItem;
@synthesize itemGroup, temporaryOrder;

- (id)initWithMenu:(BRMenu *)theMenu {
	return [self initWithMenu:theMenu item:nil];
}

- (id)initWithMenu:(BRMenu *)theMenu item:(BRMenuItem *)theItem {
	if ( (self = [super init]) ) {
		menu = theMenu;
		item = theItem;
		if ( theItem ) {
			orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:theItem];
		}
		[self setupFlow];
	}
	return self;
}

- (id)initWithMenu:(BRMenu *)theMenu group:(BRMenuItemGroup *)theGroup {
	if ( (self = [super init]) ) {
		menu = theMenu;
		itemGroup = theGroup;
	}
	return self;
}

- (id)initWithFlow:(BRMenuOrderingFlowController *)flow step:(NSUInteger)step {
	if ( (self = [super init]) ) {
		menu = flow.menu;
		item = flow.item;
		orderItem = flow->orderItem;
		itemGroup = flow.itemGroup;
		temporaryOrder = flow->temporaryOrder;
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

- (NSUInteger)stepCount {
	return steps.count;
}

- (BOOL)isFinalStep {
	if ( item == nil ) {
		return NO;
	}
	return !(flowStep + 1 < self.stepCount);
}

- (BOOL)hasMenuItemWithoutComponents {
	if ( item != nil ) {
		return (item.componentGroups.count < 1);
	}
	__block BOOL result = NO;
	[itemGroup enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
		if ( menuItem.componentGroups.count < 1 ) {
			result = YES;
			*stop = YES;
		}
	}];
	return result;
}

- (BOOL)canAddItemToOrder:(NSError * __autoreleasing *)error {
	return [self canGotoNextStep:error];
}

- (BOOL)canGotoNextStep:(NSError * __autoreleasing *)error {
	for ( BRMenuItemComponentGroup *group in [self menuItemComponentGroupsForStep:flowStep] ) {
		if ( group.requiredCount < 1 ) {
			continue;
		}
		unsigned int count = 0;
		BOOL leftFilled = NO;
		BOOL rightFilled = NO;
		BRMenuOrderItemComponent *absenceComponent = nil;
		for ( BRMenuItemComponent *component in group.components ) {
			BRMenuOrderItemComponent *orderComponent = [orderItem componentForMenuItemComponent:component];
			if ( orderComponent != nil ) {
				count++;
				leftFilled = (leftFilled || orderComponent.leftPlacement);
				rightFilled = (rightFilled || orderComponent.rightPlacement);
				if ( component.absenceOfComponent ) {
					absenceComponent = orderComponent;
				}
			}
		}
		if ( absenceComponent != nil ) {
			for ( BRMenuItemComponent *component in absenceComponent.component.group.components ) {
				BRMenuOrderItemComponent *orderComponent = [orderItem componentForMenuItemComponent:component];
				if ( orderComponent != nil && orderComponent != absenceComponent ) {
					NSString *msg = nil;
					if ( absenceComponent.placement == BRMenuOrderItemComponentPlacementWhole && orderComponent.placement == BRMenuOrderItemComponentPlacementWhole ) {
						// "no" X overlaps with some X on whole
						msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.overlap.message"],
							   absenceComponent.component.title, component.title];
					} else if ( absenceComponent.leftPlacement && orderComponent.leftPlacement ) {
						// "no" X overlaps with some X on left
						msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.overlapSide.message"],
							   absenceComponent.component.title, component.title, [NSBundle localizedBRMenuString:@"menu.placement.left"]];
					} else if ( absenceComponent.rightPlacement && orderComponent.rightPlacement ) {
						// "no" X overlaps with some X on right
						msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.overlapSide.message"],
							   absenceComponent.component.title, component.title, [NSBundle localizedBRMenuString:@"menu.placement.right"]];
					}
					if ( msg ) {
						if ( error ) {
							*error = [NSError errorWithDomain:BRMenuErrorDomain code:BRMenuOrderingFlowErrorComponentOverlap
													userInfo:@{NSLocalizedDescriptionKey : msg}];
						}
						return NO;
					}
				}
			}
		}
		if ( count < group.requiredCount ) {
			// alert the user
			NSString *msg;
			if ( group.multiSelect == YES ) {
				msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.requiredCount.message"],
					   [NSString stringWithFormat:@"%u", group.requiredCount], [group.title lowercaseString],
					   NSLocalizedString((group.requiredCount == 1 ? @"item" : @"items"), @"item")];
			} else {
				msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.required.message"],
					   [group.title lowercaseString]];
			}
			if ( error ) {
				*error = [NSError errorWithDomain:BRMenuErrorDomain code:BRMenuOrderingFlowErrorComponentOverlap
										 userInfo:@{NSLocalizedDescriptionKey : msg}];
			}
			return NO;
		} else if ( !(leftFilled && rightFilled) ) {
			NSString *msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.componentGroup.requiredPlacement.message"],
							 [group.title lowercaseString],
							 (leftFilled ? [NSBundle localizedBRMenuString:@"right"] : [NSBundle localizedBRMenuString:@"left"])];
			if ( error ) {
				*error = [NSError errorWithDomain:BRMenuErrorDomain code:BRMenuOrderingFlowErrorComponentOverlap
										 userInfo:@{NSLocalizedDescriptionKey : msg}];
			}
			return NO;
		}
	}
	return YES;
}

- (NSInteger)numberOfSections {
	if ( itemGroup != nil ) {
		// return 1 section for all items in the group, plus sections for every nested group
		return (itemGroup.items.count > 0 ? 1 : 0) + (itemGroup.groups.count);
	} else if ( item == nil ) {
		return 1;
	}
	return [self menuItemComponentGroupsForStep:flowStep].count;
}

- (NSString *)titleForSection:(NSInteger)section {
	if ( itemGroup != nil ) {
		BRMenuItemGroup *group = nil;
		if ( itemGroup.items.count > 0 ) {
			// first section is items..., which has no title
			if ( section == 0 ) {
				return nil;
			}
			group = itemGroup.groups[section - 1];
		} else {
			group = itemGroup.groups[section];
		}
		return group.title;
	} else if ( item == nil ) {
		return nil;
	}
	BRMenuItemComponentGroup *componentGroup = [self menuItemComponentGroupsForStep:flowStep][section];
	return componentGroup.title;
}

- (NSDecimalNumber *)priceForSection:(NSInteger)section {
	if ( itemGroup != nil ) {
		BRMenuItemGroup *group = nil;
		if ( itemGroup.items.count > 0 ) {
			// first section is items..., which has no price
			if ( section == 0 ) {
				return nil;
			}
			group = itemGroup.groups[section - 1];
		} else {
			group = itemGroup.groups[section];
		}
		return group.price;
	} else if ( item == nil ) {
		return nil;
	}
	return nil;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	if ( itemGroup != nil ) {
		// TODO: rename groups to groups and create protocol for BRMenu and BRMenuItem to conform to
		BRMenuItemGroup *group = nil;
		if ( itemGroup.items.count > 0 ) {
			// first section is items...
			if ( section == 0 ) {
				return itemGroup.items.count;
			}
			group = itemGroup.groups[section - 1];
		} else {
			group = itemGroup.groups[section];
		}
		return (group.items.count + group.groups.count);
	} else if ( item == nil ) {
		return (menu.items.count + menu.groups.count);
	}
	BRMenuItemComponentGroup *componentGroup = [self menuItemComponentGroupsForStep:flowStep][section];
	return componentGroup.components.count;
}

- (id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> result = nil;
	if ( itemGroup != nil ) {
		// TODO: rename groups to groups and create protocol for BRMenu and BRMenuItem to conform to
		NSUInteger section = [indexPath indexAtPosition:0];
		NSUInteger index = [indexPath indexAtPosition:1];
		BRMenuItemGroup *group = nil;
		if ( itemGroup.items.count > 0 ) {
			// first section is items...
			if ( section == 0 ) {
				return itemGroup.items[index];
			}
			group = itemGroup.groups[section - 1];
		} else {
			group = itemGroup.groups[section];
		}
		if ( index < group.items.count ) {
			result = [group.items objectAtIndex:index];
		} else {
			index -= group.items.count;
			result = [group.groups objectAtIndex:index];
		}
	} else if ( item == nil ) {
		NSUInteger index = [indexPath indexAtPosition:1];
		if ( index != NSNotFound ) {
			if ( index < menu.items.count ) {
				result = [menu.items objectAtIndex:index];
			} else {
				index -= menu.items.count;
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
	// TODO: rename groups to groups and create protocol for BRMenu and BRMenuItem to conform to
	if ( itemGroup != nil ) {
		NSUInteger idx = [itemGroup.items indexOfObjectIdenticalTo:itemObject];
		if ( idx == NSNotFound ) {
			idx = [itemGroup.groups indexOfObjectIdenticalTo:itemObject];
			if ( idx != NSNotFound ) {
				idx += itemGroup.items.count;
			}
		}
		result = [BRMenuOrderingFlowController indexPathForRow:idx inSection:1];
	} else if ( item == nil ) {
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

- (NSArray *)indexPathsForSelectedComponents {
	if ( item == nil ) {
		return nil;
	}
	NSUInteger section = 0;
	NSUInteger row;
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	for ( BRMenuItemComponentGroup *group in [self menuItemComponentGroupsForStep:flowStep] ) {
		row = 0;
		for ( BRMenuItemComponent *component in group.components ) {
			if ( [orderItem componentForMenuItemComponent:component] != nil ) {
				NSIndexPath *indexPath = [BRMenuOrderingFlowController indexPathForRow:row inSection:section];
				[indexPaths addObject:indexPath];
			}
			row++;
		}
		section++;
	}
	return [indexPaths copy];
}

- (instancetype)flowControllerForItemAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> itemObj = [self menuItemObjectAtIndexPath:indexPath];
	BRMenuOrderingFlowController *result = nil;
	if ( [itemObj isKindOfClass:[BRMenuItem class]] ) {
		result = [[[self class] alloc] initWithMenu:menu item:(BRMenuItem *)itemObj];
	} else if ( [itemObj isKindOfClass:[BRMenuItemGroup class]] ) {
		result = [[[self class] alloc] initWithMenu:menu group:(BRMenuItemGroup *)itemObj];
	}
	return result;
}

- (instancetype)flowControllerForNextStep {
	return [[[self class] alloc] initWithFlow:self step:(flowStep + 1)];
}


@end
