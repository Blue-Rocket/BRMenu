//
//  BRMenuItem.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import "BRMenuItem.h"

#import "BRMenu.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"
#import "BRMenuItemTag.h"

@implementation BRMenuItem {
	int tags;
	NSArray *menuItemTags;
}

@synthesize tags;

- (void)enumerateMenuItemComponentGroupsUsingBlock:(void (^)(BRMenuItemComponentGroup *, NSUInteger, BOOL *))block {
	NSUInteger index = 0;
	for ( BRMenuItemComponentGroup *group in self.componentGroups ) {
		if ( [BRMenuItem enumerateMenuItemComponentGroupsInGroup:group startingAtIndex:&index usingBlock:block] ) {
			return;
		}
	}
}

+ (BOOL)enumerateMenuItemComponentGroupsInGroup:(BRMenuItemComponentGroup *)group startingAtIndex:(NSUInteger *)index usingBlock:(void (^)(BRMenuItemComponentGroup *componentGroup, NSUInteger idx, BOOL *stop))block {
	BOOL stop = NO;
	block(group, (*index)++, &stop);
	if ( stop ) {
		return stop;
	}
	for ( BRMenuItemComponentGroup *nested in group.componentGroups ) {
		stop = [BRMenuItem enumerateMenuItemComponentGroupsInGroup:nested startingAtIndex:index usingBlock:block];
		if ( stop ) {
			return stop;
		}
	}
	return stop;
}

- (BOOL)isEqual:(id)object {
	return ([object isKindOfClass:[BRMenuItem class]] && self.itemId == [(BRMenuItem *)object itemId]);
}

- (NSUInteger)hash {
	return ((NSUInteger)31 + (NSUInteger)_itemId);
}

- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key {
	if ( key == nil ) {
		return nil;
	}
	for ( BRMenuItemComponentGroup *group in self.componentGroups ) {
		if ( [group.key isEqualToString:key] ) {
			return group;
		}
	}
	return nil;
}

- (BRMenuItemComponent *)menuItemComponentForId:(const UInt8)componentId {
	for ( BRMenuItemComponentGroup *group in self.componentGroups ) {
		BRMenuItemComponent *component = [group menuItemComponentForId:componentId];
		if ( component != nil ) {
			return component;
		}
	}
	return nil;
}

- (BRMenuItemGroup *)rootMenuItemGroup {
	BRMenuItemGroup *result = self.group;
	while ( result.parentGroup != nil ) {
		result = result.parentGroup;
	}
	return result;
}

- (NSArray *)allComponents {
	NSMutableArray *result = [NSMutableArray new];
	for ( BRMenuItemComponentGroup *group in self.componentGroups ) {
		[result addObjectsFromArray:[group allComponents]];
	}
	return result;
}

- (NSArray *)menuItemTags {
	if ( menuItemTags == nil && tags > 0 ) {
		NSMutableArray *menuTags = [[NSMutableArray alloc] initWithCapacity:3];
		int i = 0;
		for ( BRMenuItemTag *tag in self.menu.tags ) {
			if ( ((tags >> i) & 0x1) == 1 ) {
				[menuTags addObject:tag];
			}
			i++;
		}
		menuItemTags = [menuTags copy];
	}
	return menuItemTags;
}

@end
