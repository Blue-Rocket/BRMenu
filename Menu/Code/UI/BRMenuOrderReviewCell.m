//
//  BRMenuOrderReviewCell.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderReviewCell.h"

#import <Masonry/Masonry.h>
#import "BRMenuBarButtonItemView.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuFlipToggleButton.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrderItem.h"
#import "BRMenuPlusMinusButton.h"
#import "NSBundle+BRMenu.h"
#import "NSNumberFormatter+BRMenu.h"

#define Deg2Rad(degrees) (degrees * M_PI / 180.0)

static const CGFloat kPlusMinusWidth = 40;
static void * kOrderItemQuantityContext = &kOrderItemQuantityContext;

@implementation BRMenuOrderReviewCell {
	BRMenuOrderItem *orderItem;
}

@synthesize orderItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) ) {
		self.accessoryType = UITableViewCellAccessoryNone;
	}
	return self;
}

- (void)dealloc {
	[self setOrderItem:nil]; // clear KVO
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( context == kOrderItemQuantityContext ) {
		[self refreshQuantity];
		[self refreshPrice];
	} else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - Accessors

- (void)setOrderItem:(BRMenuOrderItem *)theOrderItem {
	if ( theOrderItem == orderItem ) {
		return;
	}
	if ( orderItem && [orderItem isProxy] == NO ) {
		[orderItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(quantity)) context:kOrderItemQuantityContext];
	}
	orderItem = theOrderItem;
	if ( theOrderItem && [theOrderItem isProxy] == NO ) {
		[theOrderItem addObserver:self forKeyPath:NSStringFromSelector(@selector(quantity)) options:0 context:kOrderItemQuantityContext];
	}
	self.item = orderItem.item;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	// we force this to None; superclass tries to adjust this
	if ( self.accessoryType != UITableViewCellAccessoryNone ) {
		[super setAccessoryType:UITableViewCellAccessoryNone];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self leaveDeleteState:NO];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];

	// slide the minus button in from the left
	[self.minusButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(editing ? 0 : -kPlusMinusWidth);
	}];
	
	// slide the plus button in from the right
	[self.plusButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.contentView).with.offset(editing ? 0 : kPlusMinusWidth);
	}];
	
	// tighten up spacing between minus button and title
	[self.title mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.minusButton.mas_right).with.offset(editing ? 5 : self.separatorInset.left + 1);
	}];
	
	// tighten up spacing between plus button and price
	[self.price mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.plusButton.mas_left).with.offset(editing ? -5 : -10);
	}];
	
	if ( [self.title respondsToSelector:@selector(setDisableAutoAdjustMaxLayoutWidth:)] ) {
		((BRMenuFitToWidthLabel *)self.title).disableAutoAdjustMaxLayoutWidth = editing;
	}
	self.title.lineBreakMode = (editing ? NSLineBreakByTruncatingTail : NSLineBreakByWordWrapping);

	if ( [self.desc respondsToSelector:@selector(setDisableAutoAdjustMaxLayoutWidth:)] ) {
		((BRMenuFitToWidthLabel *)self.desc).disableAutoAdjustMaxLayoutWidth = editing;
	}
	self.desc.lineBreakMode = (editing ? NSLineBreakByTruncatingTail : NSLineBreakByWordWrapping);
	
	[self setNeedsLayout];

	if ( editing == NO && self.deleteState ) {
		[self leaveDeleteState:animated];
	}

	if ( animated ) {
		[UIView animateWithDuration:0.3 animations:^{
			[self layoutIfNeeded];
		}];
	}
}

- (BOOL)isDeleteState {
	return (self.minusButton.selected == YES);
}

- (void)leaveDeleteState:(BOOL)animated {
	if ( !self.deleteState ) {
		return;
	}
	[self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView.mas_right);
	}];
	[self setNeedsLayout];
	
	void (^actions)(void) = ^{
		self.minusButton.selected = NO;
		self.minusButton.transform = CGAffineTransformIdentity;
		self.price.alpha = 1;
		self.quantity.alpha = 1;
		self.plusButton.alpha = 1;
		self.deleteButton.alpha = 0;
	};
	
	if ( animated ) {
		[UIView animateWithDuration:0.3 animations:^{
			actions();
			[self layoutIfNeeded];
		}];
	} else {
		actions();
	}
}

- (void)enterDeleteState:(BOOL)animated {
	if ( self.deleteState ) {
		return;
	}
	CGFloat buttonWidth = [self.deleteButton intrinsicContentSize].width;
	[self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView.mas_right).with.offset(-buttonWidth - 10);
	}];
	[self setNeedsLayout];
	
	void (^actions)(void) = ^{
		self.minusButton.selected = YES;
		self.minusButton.transform = CGAffineTransformMakeRotation(Deg2Rad(-90));
		self.price.alpha = 0;
		self.quantity.alpha = 0;
		self.plusButton.alpha = 0;
		self.deleteButton.alpha = 1;
	};

	if ( animated ) {
		[UIView animateWithDuration:0.3 animations:^{
			actions();
			[self layoutIfNeeded];
		}];
	} else {
		actions();
	}
}

#pragma mark - Layout

- (void)refreshForItem:(id<BRMenuItemObject>)item {
	[super refreshForItem:item];
	[self refreshDescription];
	[self refreshQuantity];
	[self refreshPrice];
}

- (void)refreshDescription {
	if ( [orderItem.components count] > 0 ) {
		NSMutableString *buf = [NSMutableString stringWithCapacity:64];
		for ( BRMenuOrderItemComponent *orderComponent in orderItem.components ) {
			if ( [buf length] > 0 ) {
				[buf appendString:@", "];
			}
			[buf appendString:orderComponent.component.title];
		}
		self.desc.text = buf;
	} else {
		self.desc.text = self.item.desc;
	}
}

- (void)refreshQuantity {
	self.quantity.text = (orderItem.quantity > 1
						  ? [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.order.review.quantity.title"], orderItem.quantity]
						  : nil);
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
	self.desc.font = style.listCaptionFont;
	self.desc.textColor = style.captionColor;
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
	
	// delete confirmation: right
	BRMenuBarButtonItemView *d = [[BRMenuBarButtonItemView alloc] initWithTitle:[NSBundle localizedBRMenuString:@"menu.action.delete"]];
	d.destructive = YES;
	self.deleteButton = d;
	[self.contentView addSubview:d];
	
	const UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
	
	[self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(kPlusMinusWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.left.equalTo(self.contentView).with.offset(-kPlusMinusWidth);
	}];
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.left.equalTo(self.minusButton.mas_right).with.offset(self.separatorInset.left + 1);
	}];
	[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
		make.baseline.equalTo(self.title);
		make.right.equalTo(self.plusButton.mas_left).with.offset(-10);
	}];
	[self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(kPlusMinusWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.right.equalTo(self.contentView).with.offset(kPlusMinusWidth);
	}];
	[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.left.equalTo(self.title);
		make.right.equalTo(self.title);
		make.bottom.equalTo(@(-padding.bottom));
	}];
	[self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView.mas_right);
		make.centerY.equalTo(self.contentView);
		make.height.equalTo(@32);
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
