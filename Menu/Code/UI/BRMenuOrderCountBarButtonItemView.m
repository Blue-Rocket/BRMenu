//
//  BRMenuOrderCountBarButtonItemView.m
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderCountBarButtonItemView.h"

#import "BRMenuOrder.h"
#import "NSBundle+BRMenu.h"

static void * kOrderItemsContext = &kOrderItemsContext;

@implementation BRMenuOrderCountBarButtonItemView {
	BRMenuOrder *order;
}

- (id)init {
	return [self initWithTitle:[NSBundle localizedBRMenuString:@"menu.action.view.order"]];
}

- (id)initWithTitle:(NSString *)text {
	if ( (self = [super initWithTitle:text]) ) {
		self.badgeText = @"0";
	}
	return self;
}

@synthesize order;

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
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( context == kOrderItemsContext ) {
		self.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)[self.order orderItemCount]];
	} else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
