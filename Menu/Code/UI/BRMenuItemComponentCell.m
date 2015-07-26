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
#import "UIView+BRMenuUIStyle.h"

// TODO: actual component configuration button classes should be configurable
#import "BRMenuLeftRightPlacementButton.h"
#import "BRMenuLightHeavyQuantityButton.h"


@implementation BRMenuItemComponentCell


- (void)setComponent:(BRMenuItemComponent *)component {
	self.item = component;
}

- (BRMenuItemComponent *)component {
	return (BRMenuItemComponent *)self.item;
}

- (void)setupSubviews {
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
	
	
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 0);
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.leading.equalTo(self.contentView.mas_leadingMargin);
		make.bottom.equalTo(@(-padding.bottom));
	}];
	[self.placementButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.leading.equalTo(self.title.mas_trailing).with.offset(10);
		make.width.equalTo(@32);
		make.height.equalTo(@32);
	}];
	[self.quantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.leading.equalTo(self.placementButton.mas_trailing).with.offset(2);
		make.trailing.equalTo(self.contentView.mas_trailingMargin);
		make.width.equalTo(@32);
		make.height.equalTo(@32);
	}];
}

- (void)refreshStyle:(BRMenuUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.listFont;
}

@end
