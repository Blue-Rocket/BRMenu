//
//  BRMenuItemComponentCell.m
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponentCell.h"

#import <BRStyle/Core.h>
#import <Masonry/Masonry.h>
#import "BRMenuItemComponent.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuOrderItemComponent.h"

// TODO: actual component configuration button classes should be configurable
#import "BRMenuLeftRightPlacementButton.h"
#import "BRMenuLightHeavyQuantityButton.h"


@implementation BRMenuItemComponentCell {
	MASConstraint *titleTrailing;
	MASConstraint *titleBottom;
	MASConstraint *descBottom;
	MASConstraint *descTopMargin;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self.hideDescription = YES;
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	return self;
}


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

static const CGFloat kAccessoryMargin = 22;
static const CGFloat kToggleButtonWidth = 44;
static const CGFloat kToggleButtonMargin = 2;
static const CGFloat kDescTopMargin = 4;

- (void)setupSubviews {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.accessoryType = UITableViewCellAccessoryNone;
	
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
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

	// description: left, left aligned, expands vertically and horizontally
	l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.desc = l;
	[self.contentView addSubview:l];
	
	[self.placementButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(kToggleButtonWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		if ( !self.quantityButton ) {
			make.trailing.equalTo(self.mas_trailingMargin).with.offset(-kAccessoryMargin); // to cell, so we don't shift with checkmark
		}
	}];
	[self.quantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
		if ( self.placementButton ) {
			make.leading.equalTo(self.placementButton.mas_trailing).with.offset(kToggleButtonMargin);
		}
		make.trailing.equalTo(self.mas_trailingMargin).with.offset(-kAccessoryMargin); // to cell, so we don't shift with checkmark
		make.width.equalTo(@(kToggleButtonWidth));
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
	}];
}

- (void)updateConstraints {
	BRMenuItemComponent *component = (BRMenuItemComponent *)self.item;
	const BOOL hasDescription = (!self.hideDescription && [component.desc length] > 0);
	if ( self.title.constraints.count < 1 ) {
		[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView.mas_topMargin);
			make.leading.equalTo(self.contentView.mas_leadingMargin);
			titleTrailing = make.trailing.equalTo(self.mas_trailingMargin).with.offset(-kAccessoryMargin); // to cell, so we don't shift with checkmark
			titleBottom = make.bottom.equalTo(self.contentView.mas_bottomMargin);
		}];
	}
	if ( self.desc.constraints.count < 1 ) {
		[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
			descTopMargin = make.top.equalTo(self.title.mas_bottom).with.offset(kDescTopMargin);
			make.left.equalTo(self.title);
			make.right.equalTo(self.title);
			descBottom = make.bottom.equalTo(self.contentView.mas_bottomMargin).priorityHigh(); // have to do High here so we can uninstall, reset
		}];
		[descBottom uninstall];
		descBottom.priority(MASLayoutPriorityRequired);
	}

	CGFloat titleOffset = -kAccessoryMargin;
	if ( component.askPlacement ) {
		titleOffset -= kToggleButtonWidth;
	}
	if ( component.askQuantity ) {
		titleOffset -= kToggleButtonWidth;
		if ( component.askPlacement ) {
			titleOffset -= kToggleButtonMargin;
		}
	}
	if ( component.askPlacement || component.askQuantity ) {
		titleOffset -= 4;
	}
	titleTrailing.offset(titleOffset);
	descTopMargin.offset(hasDescription ? kDescTopMargin : 0);
	if ( hasDescription ) {
		// let the desc bottom constrain the cell height
		[titleBottom uninstall];
		[descBottom install];
	} else {
		// no desc, so let the title constrain the cell height which makes the title centered vertically
		[descBottom uninstall];
		[titleBottom install];
	}
	[super updateConstraints];
}

- (void)refreshStyle:(BRUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.fonts.listFont;
	self.title.textColor = (self.selected ? style.colors.primaryColor : style.colors.textColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	self.title.textColor = (selected ? self.uiStyle.colors.primaryColor : self.uiStyle.colors.textColor);
	[self.placementButton setSelected:selected animated:animated];
	[self.quantityButton setSelected:selected animated:animated];
	
	self.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
}

@end
