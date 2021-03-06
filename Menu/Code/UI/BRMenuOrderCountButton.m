//
//  BRMenuOrderCountBarButtonItemView.m
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderCountButton.h"

#import "BRMenuOrder.h"
#import "NSBundle+BRMenu.h"

static void * kOrderItemsContext = &kOrderItemsContext;

@implementation BRMenuOrderCountButton {
	BRMenuOrder *order;
}


@synthesize order;

- (id)init {
	return [self initWithTitle:[NSBundle localizedBRMenuString:@"menu.action.view.order"]];
}

- (void)dealloc {
	[self setOrder:nil]; // clear KVO
}

- (id)initWithTitle:(NSString *)text {
	if ( (self = [super initWithTitle:text]) ) {
		self.badgeText = @"0";
	}
	return self;
}

- (void)setOrder:(BRMenuOrder *)theOrder {
	if ( theOrder == order ) {
		return;
	}
	if ( order ) {
		[order removeObserver:self forKeyPath:@"orderItemCount" context:kOrderItemsContext];
	}
	order = theOrder;
	if ( theOrder ) {
		[theOrder addObserver:self forKeyPath:@"orderItemCount" options:0 context:kOrderItemsContext];
	}
	[self refreshOrderCount:theOrder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( context == kOrderItemsContext ) {
		[self refreshOrderCount:self.order];
	} else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)refreshOrderCount:(BRMenuOrder *)theOrder {
	self.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)[theOrder orderItemCount]];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	BRMenuOrderCountButton *buttonCopy = [super copyWithZone:zone];
	buttonCopy.order = self.order;
	return buttonCopy;
}

@end
