//
//  BRMenuItemObjectCell.m
//  MenuKit
//
//  Created by Matt on 4/4/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemObjectCell.h"

#import <Masonry/Masonry.h>
#import "BRMenu.h"
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuGroupObject.h"
#import "BRMenuItemObject.h"
#import <BRStyle/Core.h>
#import "NSNumberFormatter+BRMenu.h"

@interface BRMenuItemObjectCell () <BRUIStylishHost>
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
	l.textAlignment = NSTextAlignmentLeft;
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
	l.textAlignment = NSTextAlignmentLeft;
	self.desc = l;
	[self.contentView addSubview:l];
	
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
}

- (void)refreshStyle:(BRUIStyle *)style {
	self.title.font = style.fonts.headlineFont;
	self.title.textColor = style.colors.primaryColor;
	self.price.font = style.fonts.listSecondaryFont;
	self.price.textColor = style.colors.primaryColor;
	self.desc.font = style.fonts.listCaptionFont;
	self.desc.textColor = style.colors.secondaryColor;
	self.backgroundColor = style.colors.backgroundColor;
	[self invalidateIntrinsicContentSize];
	[self setNeedsLayout];
}

- (void)setItem:(id<BRMenuItemObject>)theItem {
	if ( theItem != item ) {
		item = theItem;
		[self refreshForItem:theItem];
	}
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self refreshStyle:style];
}

- (void)refreshForItem:(id<BRMenuItemObject>)theItem {
	self.title.text = theItem.title;
	self.desc.text = theItem.desc;
	self.accessoryType = (theItem.hasComponents || [theItem conformsToProtocol:@protocol(BRMenuGroupObject)]
						  ? UITableViewCellAccessoryDisclosureIndicator
						  : UITableViewCellAccessoryNone);
	
	NSString *price = nil;
	if ( theItem.price != nil ) {
		price = [[NSNumberFormatter standardBRMenuPriceFormatter] stringFromNumber:theItem.price];
	}
	self.price.text = price;
	[self invalidateIntrinsicContentSize];
	[self setNeedsLayout];
}

@end
