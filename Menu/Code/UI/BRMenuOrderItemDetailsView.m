//
//  BRMenuOrderItemDetailsView.m
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItemDetailsView.h"

#import <Masonry/Masonry.h>
#import "BRMenuFilledToggleButton.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuOrderItemPlacementDetailsView.h"
#import <BRStyle/BRUIStylishHost.h>
#import "UIView+BRUIStyle.h"

@interface BRMenuOrderItemDetailsView () <BRUIStylishHost>
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
	const BOOL haveWholePlacement = YES; // always include whole because that's the item title
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
				
			case BRMenuOrderItemComponentPlacementWhole:
				// nothing
				break;
		}
		if ( haveLeftPlacement && haveRightPlacement ) {
			*stop = YES;
		}
	}];
	[whole removeFromSuperview];
	[left removeFromSuperview];
	[right removeFromSuperview];
	if ( haveWholePlacement ) {
		whole = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		whole.translatesAutoresizingMaskIntoConstraints = NO;
		whole.placementToDisplay = BRMenuOrderItemComponentPlacementWhole;
		whole.orderItem = item;
		[self addSubview:whole];
	}
	if ( haveLeftPlacement ) {
		left = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		left.translatesAutoresizingMaskIntoConstraints = NO;
		[left setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[left setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
		[left setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
		left.placementToDisplay = BRMenuOrderItemComponentPlacementLeft;
		left.orderItem = item;
		[self addSubview:left];
	}
	if ( haveRightPlacement ) {
		right = [[BRMenuOrderItemPlacementDetailsView alloc] initWithFrame:CGRectZero];
		right.translatesAutoresizingMaskIntoConstraints = NO;
		[right setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[right setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
		[right setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
		right.placementToDisplay = BRMenuOrderItemComponentPlacementRight;
		right.orderItem = item;
		[self addSubview:right];
	}
	[self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
	[whole mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self);
		make.trailing.equalTo(self);
		make.top.equalTo(self.mas_top);
		if ( !(left || right) ) {
			make.bottom.equalTo(self);
		}
	}];
	const CGFloat kWholePartsMargin = 20;
	const CGFloat kPartsMargin = 10;
	BOOL rightTaller = ([left systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height
						< [right systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
	[left mas_remakeConstraints:^(MASConstraintMaker *make) {
		if ( whole ) {
			make.top.equalTo(whole.mas_bottom).with.offset(kWholePartsMargin);
		} else {
			make.top.equalTo(self);
		}
		make.left.equalTo(self);
		if ( right ) {
			make.right.equalTo(self.mas_centerX).with.offset(-kPartsMargin / 2);
		} else {
			make.right.equalTo(self);
		}
		if ( !rightTaller ) {
			make.bottom.equalTo(self);
		}
	}];
	[right mas_remakeConstraints:^(MASConstraintMaker *make) {
		if ( whole ) {
			make.top.equalTo(whole.mas_bottom).with.offset(kWholePartsMargin);
		} else {
			make.top.equalTo(self);
		}
		if ( left ) {
			make.left.equalTo(self.mas_centerX).with.offset(kPartsMargin / 2);
		} else {
			make.left.equalTo(self);
		}
		make.right.equalTo(self);
		if ( rightTaller ) {
			make.bottom.equalTo(self);
		}
	}];
	[super updateConstraints];
}

@end
