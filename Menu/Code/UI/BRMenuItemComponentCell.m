//
//  BRMenuItemComponentCell.m
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponentCell.h"

#import <Masonry/Masonry.h>
#import "BRMenuItemComponent.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuOrderItemComponent.h"
#import "UIView+BRMenuUIStyle.h"

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

- (void)configureForOrderItemComponent:(BRMenuOrderItemComponent *)orderComponent {
	self.placementButton.placement = (orderComponent != nil ? orderComponent.placement : BRMenuOrderItemComponentPlacementWhole);
	self.quantityButton.quantity = (orderComponent != nil ? orderComponent.quantity : BRMenuOrderItemComponentQuantityNormal);
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
	
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 0;
	l.textAlignment = NSTextAlignmentLeft;
	l.lineBreakMode = NSLineBreakByWordWrapping;
	l.preferredMaxLayoutWidth = 260; // this needs to be set to SOMETHING in order for that auto-height layout to work
	[l setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
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

	[self.placementButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.width.equalTo(@44);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
	}];
	[self.quantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.leading.equalTo(self.placementButton.mas_trailing).with.offset(2);
		make.trailing.equalTo(self.contentView.mas_trailingMargin);
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

- (void)refreshStyle:(BRMenuUIStyle *)style {
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
