//
//  BRMenuItemObjectCell.m
//  Menu
//
//  Created by Matt on 4/4/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemObjectCell.h"

#import <Masonry/Masonry.h>
#import "BRMenu.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuItemObject.h"
#import "BRMenuUIStylishHost.h"
#import "NSNumberFormatter+BRMenu.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuItemObjectCell () <BRMenuUIStylishHost>
@end

@implementation BRMenuItemObjectCell {
	id<BRMenuItemObject> item;
}

@dynamic uiStyle;
@synthesize item;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self refreshStyle:self.uiStyle];
	}
	return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) ) {
		[self setupSubviews];
		[self refreshStyle:self.uiStyle];
	}
	return self;
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
	
	// description: left, left aligned, expands vertically and horizontally
	l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	l.numberOfLines = 0;
	l.textAlignment = NSTextAlignmentLeft;
	l.lineBreakMode = NSLineBreakByWordWrapping;
	l.preferredMaxLayoutWidth = 260;
	[l setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.desc = l;
	[self.contentView addSubview:l];
	
	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
	[self.title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.left.equalTo(@(padding.left));
	}];
	[self.price mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.title.mas_trailing).with.offset(10);
		make.right.equalTo(@(-padding.right));
		make.baseline.equalTo(self.title);
	}];
	[self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.title.mas_bottom).with.offset(2);
		make.left.equalTo(self.title);
		make.right.equalTo(self.title);
		make.bottom.equalTo(@(-padding.bottom));
	}];
}

- (void)refreshStyle:(BRMenuUIStyle *)style {
	self.title.font = self.uiStyle.headlineFont;
	self.title.textColor = self.uiStyle.appPrimaryColor;
	self.price.font = self.uiStyle.listSecondaryFont;
	self.price.textColor = self.uiStyle.appPrimaryColor;
	self.desc.font = self.uiStyle.listCaptionFont;
	self.desc.textColor = self.uiStyle.secondaryColor;
	[self invalidateIntrinsicContentSize];
}

- (void)setItem:(id<BRMenuItemObject>)theItem {
	if ( theItem != item ) {
		item = theItem;
		[self refresh];
	}
}

- (void)uiStyleDidChange:(BRMenuUIStyle *)style {
	[self refreshStyle:style];
}

- (void)refresh {
	self.title.text = item.title;
	self.desc.text = item.desc;
	
	NSString *price = nil;
	if ( item.price != nil ) {
		price = [[NSNumberFormatter standardBRMenuPriceFormatter] stringFromNumber:item.price];
	}
	self.price.text = price;
	[self setNeedsLayout];
}

@end