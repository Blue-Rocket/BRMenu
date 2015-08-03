//
//  BRMenuItemCellWithoutComponents.m
//  MenuKit
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemCellWithoutComponents.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuItem.h"
#import "BRMenuOrderItem.h"
#import "BRMenuStepper.h"

static const CGFloat kPriceTopMargin = 0;
static const CGFloat kDescTopMargin = 4;

@implementation BRMenuItemCellWithoutComponents {
	MASConstraint *titleBottom;
	MASConstraint *descBottom;
	MASConstraint *priceTopMargin;
	MASConstraint *descTopMargin;
}

- (BRMenuItem *)menuItem {
	return (BRMenuItem *)self.item;
}

- (void)setMenUItem:(BRMenuItem *)menuItem {
	self.item = menuItem;
}

- (void)setupSubviews {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.accessoryType = UITableViewCellAccessoryNone;
	
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	//l.preferredMaxLayoutWidth = 180;
	self.title = l;
	[self.contentView addSubview:l];
	
	// stepper: right, center Y aligned
	BRMenuStepper *s = [[BRMenuStepper alloc] initWithFrame:CGRectZero];
	[s setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[s setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.stepper = s;
	[self.contentView addSubview:s];
	
	// price: beneath title
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 1;
	l.textAlignment = NSTextAlignmentLeft;
	l.lineBreakMode = NSLineBreakByClipping;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.price = l;
	[self.contentView addSubview:l];
	
	// description: left, left aligned, expands vertically and horizontally
	l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	//l.preferredMaxLayoutWidth = 180;
	self.desc = l;
	[self.contentView addSubview:l];
	
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight
																 relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0
																multiplier:1 constant:44]];
}

- (void)refreshForItem:(id<BRMenuItemObject>)item {
	[super refreshForItem:item];
	[self setNeedsUpdateConstraints];
}


- (void)configureForOrderItem:(BRMenuOrderItem *)orderItem {
	self.stepper.value = orderItem.quantity;
}

- (void)refreshStyle:(BRMenuUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.listFont;
	self.title.textColor = (self.selected ? self.uiStyle.appPrimaryColor : self.uiStyle.textColor);
}

- (void)updateConstraints {
	id<BRMenuItemObject> item = self.item;
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
	if ( self.title.constraints.count < 1 ) {
		[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(@(padding.top));
			make.left.equalTo(self.contentView.mas_leftMargin);
			titleBottom = make.bottom.equalTo(@(-padding.bottom));
		}];
	}
	if ( self.stepper.constraints.count < 1 ) {
		// give stepper minimum of 44 height, so cells with only a single line title aren't too short
		[self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.title.mas_right).with.offset(10);
			make.right.equalTo(self.contentView.mas_rightMargin);
			make.height.equalTo(@44);
			make.centerY.equalTo(self.contentView);
		}];
	}
	if ( self.price.constraints.count < 1 ) {
		[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
			priceTopMargin = make.top.equalTo(self.title.mas_bottom).with.offset(kPriceTopMargin);
			make.left.equalTo(self.contentView.mas_leftMargin);
		}];
	}
	if ( self.desc.constraints.count < 1 ) {
		[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
			descTopMargin = make.top.equalTo(self.price.mas_bottom).with.offset(kDescTopMargin);
			make.left.equalTo(self.title);
			make.right.equalTo(self.title);
			descBottom = make.bottom.equalTo(@(-padding.bottom)).priorityHigh(); // have to do High here so we can uninstall, reset
		}];
		[descBottom uninstall];
		descBottom.priority(MASLayoutPriorityRequired);
	}
	priceTopMargin.offset(item.price ? kPriceTopMargin : 0);
	descTopMargin.offset(item.desc ? kDescTopMargin : 0);
	if ( item.price || item.desc ) {
		// let the price/desc bottom constrain the cell height
		[titleBottom uninstall];
		[descBottom install];
	} else {
		// no price or desc, so let the title constrain the cell height which makes the title centered vertically
		[descBottom uninstall];
		[titleBottom install];
	}
	[super updateConstraints];
}

@end
