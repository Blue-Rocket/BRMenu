//
//  BRMenuItemCell.m
//  Menu
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
	
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.left.equalTo(self.contentView.mas_leftMargin);
	}];
	[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.title.mas_trailing).with.offset(10);
		make.right.equalTo(self.contentView.mas_rightMargin);
		make.baseline.equalTo(self.title);
	}];
	[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.left.equalTo(self.title);
		make.right.equalTo(self.title);
		make.bottom.equalTo(@(-padding.bottom));
	}];
	[tagGridView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.right.equalTo(self.contentView.mas_rightMargin);
	}];
	
	[self setNeedsUpdateConstraints];
}

- (void)refreshStyle:(BRMenuUIStyle *)style {
	[super refreshStyle:style];
	self.title.font = style.listFont;
	self.title.textColor = (self.selected ? self.uiStyle.appPrimaryColor : self.uiStyle.textColor);
}

@end