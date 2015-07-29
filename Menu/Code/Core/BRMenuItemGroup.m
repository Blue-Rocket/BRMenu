//
//  BRMenuItemGroup.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemGroup.h"

#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"

@implementation BRMenuItemGroup

- (BOOL)hasComponents {
	return NO;
}

- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block {
	if ( block == NULL ) {
		return;
	}
	NSUInteger index = 0;
	[BRMenuItemGroup enumerateMenuItemsInGroup:self startingAtIndex:&index usingBlock:block];
}

+ (BOOL)enumerateMenuItemsInGroup:(BRMenuItemGroup *)group startingAtIndex:(NSUInteger *)index usingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block {
	BOOL stop = NO;
	for ( BRMenuItem *item in group.items ) {
		block(item, (*index)++, &stop);
		if ( stop ) {
			return stop;
		}
	}
	for ( BRMenuItemGroup *nested in group.groups ) {
		stop = [BRMenuItemGroup enumerateMenuItemsInGroup:nested startingAtIndex:index usingBlock:block];
		if ( stop ) {
			return stop;
		}
	}
	return stop;
}

- (BRMenuItem *)menuItemForId:(const UInt8)itemId {
	for ( BRMenuItem *item in self.items ) {
		if ( itemId == item.itemId ) {
			return item;
		}
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItem *item = [nested menuItemForId:itemId];
		if ( item != nil ) {
			return item;
		}
	}
	return nil;
}

- (BRMenuItem *)menuItemForKey:(NSString *)key {
	for ( BRMenuItem *item in self.items ) {
		if ( [key isEqualToString:item.key] ) {
			return item;
		}
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItem *item = [nested menuItemForKey:key];
		if ( item != nil ) {
			return item;
		}
	}
	return nil;
}

- (BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key {
	if ( [key isEqualToString:self.key] ) {
		return self;
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItemGroup *group = [nested menuItemGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	return nil;
}

- (BRMenuItemComponent *)menuItemComponentForId:(const UInt8)componentId {
	for ( BRMenuItem *item in self.items ) {
		BRMenuItemComponent *component = [item menuItemComponentForId:(const UInt8)componentId];
		if ( component != nil ) {
			return component;
		}
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItemComponent *component = [nested menuItemComponentForId:(const UInt8)componentId];
		if ( component != nil ) {
			return component;
		}
	}
	return nil;
}

- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key {
	for ( BRMenuItem *item in self.items ) {
		BRMenuItemComponentGroup *group = [item menuItemComponentGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItemComponentGroup *group = [nested menuItemComponentGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	return nil;
}

- (NSArray *)allComponents {
	NSMutableArray *result = [NSMutableArray new];
	for ( BRMenuItem *item in self.items ) {
		[result addObjectsFromArray:[item allComponents]];
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		[result addObjectsFromArray:[nested allComponents]];
	}
	return result;
}

@end
