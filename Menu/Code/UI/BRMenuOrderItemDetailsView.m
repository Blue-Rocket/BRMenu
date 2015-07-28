//
//  BRMenuOrderItemDetailsView.m
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderItemDetailsView.h"

#import <Masonry/Masonry.h>
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuOrderItemPlacementDetailsView.h"
#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuOrderItemDetailsView () <BRMenuUIStylishHost>
@end

@implementation BRMenuOrderItemDetailsView {
	BRMenuOrderItem *orderItem;
	BOOL showTakeAway;
	BRMenuOrderItemPlacementDetailsView *whole;
	BRMenuOrderItemPlacementDetailsView *left;
	BRMenuOrderItemPlacementDetailsView *right;
}

@dynamic uiStyle;
@synthesize orderItem;
@synthesize showTakeAway;

- (void)setOrderItem:(BRMenuOrderItem *)item {
	if ( orderItem == item ) {
		return;
	}
	orderItem = item;
	
	// set up 3 placement views: whole, left, right, assuming those placements used
	__block BOOL haveWholePlacement = NO;
	__block BOOL haveLeftPlacement = NO;
	__block BOOL haveRightPlacement = NO;
	[item.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		BRMenuOrderItemComponent *orderComponent = obj;
		switch ( orderComponent.placement ) {
			case BRMenuOrderItemComponentPlacementLeft:
				haveLeftPlacement = YES;
				break;
				
			case BRMenuOrderItemComponentPlacementRight:
				haveRightPlacement = YES;
				break;
				
			default:
				haveWholePlacement = YES;
				break;
		}
		if ( haveWholePlacement && haveLeftPlacement && haveRightPlacement ) {
			*stop = YES;
		}
	}];
	[whole removeFromSuperview];
	[left removeFromSuperview];
	[right removeFromSuperview];
	if ( haveWholePlacement ) {
		whole = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		[self addSubview:whole];
	}
	if ( haveLeftPlacement ) {
		left = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		[self addSubview:left];
	}
	if ( haveRightPlacement ) {
		right = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		[self addSubview:right];
	}
	[self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
	[whole mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.mas_leadingMargin);
		make.trailing.equalTo(self.mas_trailingMargin);
		make.top.equalTo(self.mas_topMargin);
		if ( !(left || right) ) {
			make.bottom.equalTo(self.mas_bottomMargin);
		}
	}];
	[left mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(whole ? whole.mas_bottom : self.mas_top).with.offset(10);
		make.left.equalTo(self.mas_leftMargin);
		if ( right ) {
			make.right.equalTo(self.mas_centerX).with.offset(-5);
		} else {
			make.right.equalTo(self.mas_rightMargin);
		}
		make.bottom.equalTo(self.mas_bottomMargin);
	}];
	[right mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(whole ? whole.mas_bottom : self.mas_top).with.offset(10);
		if ( left ) {
			make.left.equalTo(self.mas_centerX).with.offset(5);
		} else {
			make.left.equalTo(self.mas_leftMargin);
		}
		make.right.equalTo(self.mas_rightMargin);
		make.bottom.equalTo(self.mas_bottomMargin);
	}];
	[super updateConstraints];
}

@end
