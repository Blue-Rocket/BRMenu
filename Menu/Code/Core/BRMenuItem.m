//
//  BRMenuItem.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
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

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [self init]) ) {
		self.itemId = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(itemId))];
		self.key = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(key))];
		self.extendsKey = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(extendsKey))];
		self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
		self.desc = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(desc))];
		self.tags = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(tags))];
		self.askQuantity = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isAskQuantity))];
		self.askTakeaway = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isAskTakeaway))];
		self.needsReview = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isNeedsReview))];
		self.price = [aDecoder decodeObjectOfClass:[NSDecimalNumber class] forKey:NSStringFromSelector(@selector(price))];
		self.componentGroups = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemComponentGroup class], nil] forKey:NSStringFromSelector(@selector(componentGroups))];
		self.group = [aDecoder decodeObjectOfClass:[BRMenuItemGroup class] forKey:NSStringFromSelector(@selector(group))];
		self.menu = [aDecoder decodeObjectOfClass:[BRMenu class] forKey:NSStringFromSelector(@selector(menu))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:self.itemId forKey:NSStringFromSelector(@selector(itemId))];
	[aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
	[aCoder encodeObject:self.extendsKey forKey:NSStringFromSelector(@selector(extendsKey))];
	[aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
	[aCoder encodeObject:self.desc forKey:NSStringFromSelector(@selector(desc))];
	[aCoder encodeInt:self.tags forKey:NSStringFromSelector(@selector(tags))];
	[aCoder encodeBool:self.askQuantity forKey:NSStringFromSelector(@selector(isAskQuantity))];
	[aCoder encodeBool:self.askTakeaway forKey:NSStringFromSelector(@selector(isAskTakeaway))];
	[aCoder encodeBool:self.needsReview forKey:NSStringFromSelector(@selector(isNeedsReview))];
	[aCoder encodeObject:self.price forKey:NSStringFromSelector(@selector(price))];
	[aCoder encodeObject:self.componentGroups forKey:NSStringFromSelector(@selector(componentGroups))];
	[aCoder encodeObject:self.group forKey:NSStringFromSelector(@selector(group))];
	[aCoder encodeObject:self.menu forKey:NSStringFromSelector(@selector(menu))];
}

#pragma mark -

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
	return ([object isKindOfClass:[BRMenuItem class]]
			&& self.itemId == [(BRMenuItem *)object itemId]
			&& [self.menu isEqual:[(BRMenuItem *)object menu]]);
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

- (BOOL)hasComponents {
	return (self.componentGroups.count > 0);
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
