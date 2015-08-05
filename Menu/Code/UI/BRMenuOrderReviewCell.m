//
//  BRMenuOrderReviewCell.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderReviewCell.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuFlipToggleButton.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrderItem.h"
#import "BRMenuPlusMinusButton.h"
#import "NSBundle+BRMenu.h"
#import "NSNumberFormatter+BRMenu.h"

static const CGFloat kPlusMinusWidth = 40;

@implementation BRMenuOrderReviewCell {
	BRMenuOrderItem *orderItem;
	
	MASConstraint *minusLeftConstraint;
	MASConstraint *plusRightConstraint;
	MASConstraint *takeAwayLeftConstraint;
}

@synthesize orderItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) ) {
		self.accessoryType = UITableViewCellAccessoryNone;
	}
	return self;
}

#pragma mark - Accessors

- (void)setOrderItem:(BRMenuOrderItem *)theOrderItem {
	if ( theOrderItem == orderItem ) {
		return;
	}
	orderItem = theOrderItem;
	self.item = orderItem.item;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	// we force this to None; superclass tries to adjust this
	if ( self.accessoryType != UITableViewCellAccessoryNone ) {
		[super setAccessoryType:UITableViewCellAccessoryNone];
	}
}

#pragma mark - Layout

- (void)refreshForItem:(id<BRMenuItemObject>)item {
	[super refreshForItem:item];
	[self refreshQuantity];
	[self refreshPrice];
}

- (void)refreshQuantity {
	self.quantity.text = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.order.review.quantity.title"], orderItem.quantity];
}

- (void)refreshPrice {
	NSString *priceValue = nil;
	NSDecimalNumber *priceNumber;
	if ( orderItem.item.price != nil ) {
		priceNumber = orderItem.item.price;
	} else if ( orderItem.item.group.price != nil ) {
		priceNumber = orderItem.item.group.price;
	}
	if ( priceNumber != nil ) {
		if ( orderItem.item.askTakeaway == NO &&  orderItem.quantity > 1 ) {
			priceNumber = [priceNumber decimalNumberByMultiplyingBy:
						   [NSDecimalNumber decimalNumberWithMantissa:orderItem.quantity exponent:0 isNegative:NO]];
		}
		priceValue = [[NSNumberFormatter standardBRMenuPriceFormatter]  stringFromNumber:priceNumber];
	}
	
	self.price.text = priceValue;
}

- (void)refreshStyle:(BRMenuUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.listFont;
	self.title.textColor = self.uiStyle.textColor;
	self.quantity.font = style.listSecondaryFont;
	self.quantity.textColor = style.appPrimaryColor;
}

- (void)setupSubviews {
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	self.title = l;
	[self.contentView addSubview:l];
	
	// minus button: left
	BRMenuPlusMinusButton *pm = [[BRMenuPlusMinusButton alloc] initWithFrame:CGRectZero];
	pm.plus = NO;
	self.minusButton = pm;
	[self.contentView addSubview:pm];
	
	// plus button: right
	pm = [[BRMenuPlusMinusButton alloc] initWithFrame:CGRectZero];
	pm.plus = YES;
	self.plusButton = pm;
	[self.contentView addSubview:pm];
	
	// price: top right, right aligned
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 1;
	l.textAlignment = NSTextAlignmentRight;
	l.lineBreakMode = NSLineBreakByClipping;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.price = l;
	[self.contentView addSubview:l];
	
	// quantity: top right, right aligned to price
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 1;
	l.textAlignment = NSTextAlignmentRight;
	l.lineBreakMode = NSLineBreakByClipping;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.quantity = l;
	[self.contentView addSubview:l];
	
	// dine-in/take-away flip toggle: same as quantity (takes over that space)
	BRMenuFlipToggleButton *f = [[BRMenuFlipToggleButton alloc] initWithFrame:CGRectZero];
	[f setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[f setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.takeAwayButton = f;
	[self.contentView addSubview:f];
	
	// description: left, left aligned, expands vertically and horizontally
	l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	self.desc = l;
	[self.contentView addSubview:l];
	
	const UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
	
	[self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(kPlusMinusWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		minusLeftConstraint = make.left.equalTo(self.contentView).with.offset(-kPlusMinusWidth);
	}];
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.left.equalTo(self.minusButton.mas_right).with.offset(self.separatorInset.left + 1);
	}];
	[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
		make.baseline.equalTo(self.title);
	}];
	[self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(kPlusMinusWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		plusRightConstraint = make.right.equalTo(self.contentView).with.offset(kPlusMinusWidth);
		make.left.equalTo(self.price.mas_right).with.offset(10);
	}];
	[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.left.equalTo(self.title);
		make.right.equalTo(self.title);
		make.bottom.equalTo(@(-padding.bottom));
	}];
}

- (void)updateConstraints {
	if ( self.orderItem.item.askTakeaway ) {
		self.quantity.hidden = YES;
		[self.quantity mas_remakeConstraints:^(MASConstraintMaker *make) {
			// just remove all constraints
		}];
		self.takeAwayButton.hidden = NO;
		[self.takeAwayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.title);
			make.left.equalTo(self.title.mas_right).with.offset(10);
			make.right.equalTo(self.price.mas_left).with.offset(-10);
		}];
	} else {
		self.quantity.hidden = NO;
		[self.quantity mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.baseline.equalTo(self.title);
			make.left.equalTo(self.title.mas_right).with.offset(10);
			make.right.equalTo(self.price.mas_left).with.offset(-10);
		}];
		self.takeAwayButton.hidden = YES;
		[self.takeAwayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
			// just remove all constraints
		}];
	}
	[super updateConstraints];
}

@end
