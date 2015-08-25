//
//  BRMenuItemComponentCell.m
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponentCell.h"

#import <Masonry/Masonry.h>
#import "BRMenuItemComponent.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuOrderItemComponent.h"
#import "UIView+BRUIStyle.h"

// TODO: actual component configuration button classes should be configurable
#import "BRMenuLeftRightPlacementButton.h"
#import "BRMenuLightHeavyQuantityButton.h"


@implementation BRMenuItemComponentCell

- (BRMenuItemComponent *)component {
	return (BRMenuItemComponent *)self.item;
}

- (void)setComponent:(BRMenuItemComponent *)component {
	self.item = component;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self configureForOrderItemComponent:nil];
}

- (void)configureForOrderItemComponent:(BRMenuOrderItemComponent *)orderComponent {
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
	if ( self.placementButton ) {
		[buttons addObject:self.placementButton];
	}
	if ( self.quantityButton ) {
		[buttons addObject:self.quantityButton];
	}
	[buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIButton<BRMenuModelPropertyEditor> *button = obj;
		NSString *keyPath = [button propertyEditorKeyPathForModel:[BRMenuOrderItemComponent class]];
		id value = (orderComponent == nil
					? [button propertyEditorDefaultValueForModel:[BRMenuOrderItemComponent class]]
					: [orderComponent valueForKeyPath:keyPath]);
		[button setPropertyEditorValue:value];
	}];
}

- (void)refreshForItem:(id<BRMenuItemObject>)item {
	[super refreshForItem:item];
	if ( ![item isKindOfClass:[BRMenuItemComponent class]] ) {
		return;
	}
	BRMenuItemComponent *component = (BRMenuItemComponent *)item;
	
	BOOL layoutChanged = NO;
	if ( self.placementButton.hidden != !component.askPlacement ) {
		self.placementButton.hidden = !component.askPlacement;
		layoutChanged = YES;
	}
	if ( self.quantityButton.hidden != !component.askQuantity ) {
		self.quantityButton.hidden = !component.askQuantity;
		layoutChanged = YES;
	}
	
	if ( layoutChanged ) {
		[self invalidateIntrinsicContentSize];
		[self setNeedsUpdateConstraints];
	}
	[self setNeedsLayout];
}

- (void)setupSubviews {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.accessoryType = UITableViewCellAccessoryNone;
	
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	self.title = l;
	[self.contentView addSubview:l];
	
	// placement: top right, right aligned
	BRMenuLeftRightPlacementButton *p = [[BRMenuLeftRightPlacementButton alloc] initWithFrame:CGRectZero];
	[p setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.placementButton = p;
	[self.contentView addSubview:p];
	
	// placement: top right, right aligned
	BRMenuLightHeavyQuantityButton *q = [[BRMenuLightHeavyQuantityButton alloc] initWithFrame:CGRectZero];
	[q setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.quantityButton = q;
	[self.contentView addSubview:q];

	const CGFloat kAccessoryMargin = 22;
	[self.placementButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.width.equalTo(@44);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		if ( !self.quantityButton ) {
			make.trailing.equalTo(self.mas_trailingMargin).with.offset(-kAccessoryMargin); // to cell, so we don't shift with checkmark
		}
	}];
	[self.quantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		if ( self.placementButton ) {
			make.leading.equalTo(self.placementButton.mas_trailing).with.offset(2);
		}
		make.trailing.equalTo(self.mas_trailingMargin).with.offset(-kAccessoryMargin); // to cell, so we don't shift with checkmark
		make.width.equalTo(@44);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
	}];
}

- (void)updateConstraints {
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 0);
	BRMenuItemComponent *component = self.item;
	[self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.leading.equalTo(self.contentView.mas_leadingMargin);
		make.trailing.equalTo(component.askPlacement
							  ? self.placementButton.mas_leading
							  : component.askQuantity
							  ? self.quantityButton.mas_leading
							  : self.contentView.mas_trailing).with.offset(-10);
		make.bottom.equalTo(@(-padding.bottom));
	}];
	[super updateConstraints];
}

- (void)refreshStyle:(BRUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.listFont;
	self.title.textColor = (self.selected ? self.uiStyle.appPrimaryColor : self.uiStyle.textColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	self.title.textColor = (selected ? self.uiStyle.appPrimaryColor : self.uiStyle.textColor);
	[self.placementButton setSelected:selected animated:animated];
	[self.quantityButton setSelected:selected animated:animated];
	
	self.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
}

@end
