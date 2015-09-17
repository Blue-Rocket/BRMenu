//
//  BRMenuItemCell.m
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemCell.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuItem.h"
#import "BRMenuTagGridView.h"

@implementation BRMenuItemCell {
	BRMenuTagGridView *tagGridView;
}

- (BRMenuItem *)menuItem {
	return (BRMenuItem *)self.item;
}

- (void)setMenUItem:(BRMenuItem *)menuItem {
	self.item = menuItem;
}

- (void)setupSubviews {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// title: top left, left aligned, expands vertically and horizontally
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	self.title = l;
	[self.contentView addSubview:l];
	
	// price: top right, right aligned
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 1;
	l.textAlignment = NSTextAlignmentRight;
	l.lineBreakMode = NSLineBreakByClipping;
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	self.price = l;
	[self.contentView addSubview:l];
	
	// description: left, left aligned, expands vertically and horizontally
	l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.textAlignment = NSTextAlignmentLeft;
	self.desc = l;
	[self.contentView addSubview:l];
	
	// tag grid: center X with price, top with desc
	BRMenuTagGridView *t = [[BRMenuTagGridView alloc] initWithFrame:CGRectZero];
	tagGridView = t;
	[self.contentView addSubview:t];
	
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 0);
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.left.equalTo(self.contentView.mas_leftMargin);
	}];
	[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.title.mas_trailing).with.offset(10);
		make.right.equalTo(@(-padding.right));
		make.baseline.equalTo(self.title);
	}];
	[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.left.equalTo(self.title);
		make.bottom.equalTo(@(-padding.bottom));
		
		// if multiple tag icons are present, they might be wider than the price, so make sure
		// we don't overlap with that by adding two constraints of different priority for the right
		make.right.equalTo(self.title).priorityHigh();
		make.right.lessThanOrEqualTo(tagGridView.mas_left).with.offset(-5);
	}];
	[tagGridView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.right.equalTo(@(-padding.right));
	}];
}

- (void)refreshForItem:(id<BRMenuItemObject>)item {
	[super refreshForItem:item];
	if ( ![item isKindOfClass:[BRMenuItem class]] ) {
		return;
	}
	BRMenuItem *menuItem = (BRMenuItem *)item;
	tagGridView.tags = [menuItem menuItemTags];
}

- (void)refreshStyle:(BRUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.fonts.listFont;
	self.title.textColor = (self.selected ? self.uiStyle.colors.primaryColor : self.uiStyle.colors.textColor);
	self.desc.font = style.fonts.listCaptionFont;
	self.desc.textColor = style.colors.captionColor;
}

@end
