//
//  BRMenuOrderGroupsController.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderGroupsController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "NSBundle+BRMenu.h"

@implementation BRMenuOrderGroupsController {
	BRMenuOrder *order;
	NSDictionary *groupKeyMapping;
	NSArray *sections;
}

@synthesize order;
@synthesize groupKeyMapping;

- (id)init {
	return [self initWithOrder:nil];
}

- (id)initWithOrder:(BRMenuOrder *)theOrder {
	return [self initWithOrder:theOrder groupKeyMapping:nil];
}

- (id)initWithOrder:(BRMenuOrder *)theOrder groupKeyMapping:(NSDictionary *)theGroupKeyMapping {
	if ( (self = [super init]) ) {
		order = theOrder;
		groupKeyMapping = theGroupKeyMapping;
		[self generateSectionsForOrder:theOrder];
	}
	return self;
}

- (void)setGroupKeyMapping:(NSDictionary *)mapping {
	if ( groupKeyMapping != mapping ) {
		groupKeyMapping = mapping;
		[self refresh];
	}
}

- (void)generateSectionsForOrder:(BRMenuOrder *)theOrder {
	sections = [theOrder orderedGroups:self.groupKeyMapping];
}

- (void)refresh {
	[self generateSectionsForOrder:order];
}

- (NSInteger)numberOfSections {
	return sections.count;
}

- (NSString *)titleForSection:(NSInteger)section {
	BRMenuOrderItem *orderItem = [sections[section] firstObject];
	NSString *key = [orderItem orderGroupKey:self.groupKeyMapping];
	NSString *title = ([key isEqualToString:BRMenuOrderItemDefaultGroupKey]
					   ? [NSBundle localizedBRMenuString:@"menu.order.group.default.title"]
					   : [orderItem.item rootMenuItemGroup].title);
	if ( title == nil ) {
		// not in a group; use the item's title directly
		title = orderItem.item.title;
	}
	return title;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return [sections[section] count];
}

- (BRMenuOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger index = [indexPath indexAtPosition:1];
	return sections[section][index];
}

- (NSIndexPath *)indexPathForMenuItemObject:(BRMenuOrderItem *)orderItem {
	NSUInteger section = 0;
	NSUInteger index = NSNotFound;
	for ( NSArray *row in sections ) {
		index = [row indexOfObject:orderItem];
		if ( index != NSNotFound ) {
			break;
		}
		section++;
	}
	if ( index == NSNotFound ) {
		section = NSNotFound;
	}
	NSUInteger indexArr[] = {section, index};
	return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}

@end
