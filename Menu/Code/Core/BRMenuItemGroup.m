//
//  BRMenuItemGroup.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemGroup.h"

#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"

@implementation BRMenuItemGroup

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [self init]) ) {
		self.key = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(key))];
		self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
		self.desc = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(desc))];
		self.price = [aDecoder decodeObjectOfClass:[NSDecimalNumber class] forKey:NSStringFromSelector(@selector(price))];
		self.showItemDelimiters = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isShowItemDelimiters))];
		self.parentGroup = [aDecoder decodeObjectOfClass:[BRMenuItemGroup class] forKey:NSStringFromSelector(@selector(parentGroup))];
		self.items = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItem class], nil] forKey:NSStringFromSelector(@selector(items))];
		self.groups = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemGroup class], nil] forKey:NSStringFromSelector(@selector(groups))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
	[aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
	[aCoder encodeObject:self.desc forKey:NSStringFromSelector(@selector(desc))];
	[aCoder encodeObject:self.price forKey:NSStringFromSelector(@selector(price))];
	[aCoder encodeBool:self.showItemDelimiters forKey:NSStringFromSelector(@selector(isShowItemDelimiters))];
	[aCoder encodeObject:self.parentGroup forKey:NSStringFromSelector(@selector(parentGroup))];
	[aCoder encodeObject:self.items forKey:NSStringFromSelector(@selector(items))];
	[aCoder encodeObject:self.groups forKey:NSStringFromSelector(@selector(groups))];
}

#pragma mark -

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

- (void)enumerateMenuItemGroupsUsingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block {
	if ( block == NULL ) {
		return;
	}
	NSUInteger index = 0;
	for ( BRMenuItemGroup *group in self.groups ) {
		if ( [BRMenuItemGroup enumerateMenuItemGroups:group startingAtIndex:&index usingBlock:block] ) {
			break;
		}
	}
}

+ (BOOL)enumerateMenuItemGroups:(BRMenuItemGroup *)group startingAtIndex:(NSUInteger *)index usingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block {
	BOOL stop = NO;
	block(group, (*index)++, &stop);
	if ( stop ) {
		return stop;
	}
	for ( BRMenuItemGroup *nested in group.groups ) {
		stop = [BRMenuItemGroup enumerateMenuItemGroups:nested startingAtIndex:index usingBlock:block];
		if ( stop ) {
			return stop;
		}
	}
	return stop;
}

- (BRMenuItem *)menuItemForId:(const uint8_t)itemId {
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

- (BRMenuItemComponent *)menuItemComponentForId:(const uint8_t)componentId {
	for ( BRMenuItem *item in self.items ) {
		BRMenuItemComponent *component = [item menuItemComponentForId:(const uint8_t)componentId];
		if ( component != nil ) {
			return component;
		}
	}
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItemComponent *component = [nested menuItemComponentForId:(const uint8_t)componentId];
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
