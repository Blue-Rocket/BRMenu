//
//  BRMenuGroupHeaderView.m
//  Menu
//
//  Created by Matt on 5/23/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuGroupHeaderView.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuUIStylishHost.h"
#import "NSNumberFormatter+BRMenu.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuGroupHeaderView () <BRMenuUIStylishHost>
@end

@implementation BRMenuGroupHeaderView {
	NSString *title;
	NSDecimalNumber *price;
	UILabel *titleLabel;
	UILabel *priceLabel;
	UIView *ruleView;
}

@dynamic uiStyle;
@synthesize titleLabel, priceLabel;

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		[self setupSubviews];
	}
	return self;
}

- (void)setupSubviews {
	self.autoresizesSubviews = NO;
	self.backgroundColor = [UIColor clearColor];

	// rule: bottom
	ruleView = [[UIView alloc] initWithFrame:CGRectZero];
	ruleView.backgroundColor = self.uiStyle.appPrimaryColor;
	[self addSubview:ruleView];

	// title: left
	UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
	[l setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	l.numberOfLines = 0;
	l.lineBreakMode = NSLineBreakByWordWrapping;
	l.preferredMaxLayoutWidth = 260;
	l.font = self.uiStyle.headlineFont;
	l.textColor = self.uiStyle.appPrimaryColor;
	l.backgroundColor = [UIColor clearColor];
	l.shadowColor = [UIColor whiteColor];
	l.shadowOffset = CGSizeMake(0.0, 1.0);
	[self addSubview:l];
	titleLabel = l;

	// price: right
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	l.font = self.uiStyle.listSecondaryFont;
	l.textColor = self.uiStyle.appPrimaryColor;
	l.backgroundColor = [UIColor clearColor];
	l.textAlignment = NSTextAlignmentRight;
	l.numberOfLines = 1;
	l.lineBreakMode = NSLineBreakByClipping;
	priceLabel = l;
	[self addSubview:l];

	UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 2, 10);
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.leading.equalTo(self.mas_leftMargin);
	}];
	[self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.titleLabel.mas_trailing).with.offset(10);
		make.trailing.equalTo(@(-padding.right));
		make.baseline.equalTo(self.titleLabel);
	}];
	[ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.titleLabel.mas_bottom).with.offset(2);
		make.left.equalTo(self.titleLabel);
		make.right.equalTo(self);
		make.height.equalTo(@1);
		make.bottom.equalTo(@(-padding.bottom));
	}];
}

- (NSDecimalNumber *)price {
	return price;
}

- (void)setPrice:(NSDecimalNumber *)aPrice {
	price = aPrice;
	if ( priceLabel == nil ) {
	}
	priceLabel.hidden = (aPrice == nil);
	priceLabel.text = (aPrice == nil ? nil : [[NSNumberFormatter standardBRMenuPriceFormatter] stringFromNumber:aPrice]);
	[self invalidateIntrinsicContentSize];
}

- (NSString *)title {
	return title;
}

- (void)setTitle:(NSString *)text {
	title = text;
	titleLabel.text = text;
	[self setNeedsUpdateConstraints];
	[self invalidateIntrinsicContentSize];
}

- (BOOL)isRuleHidden {
	return ruleView.hidden;
}

- (void)setRuleHidden:(BOOL)value {
	ruleView.hidden = value;
}

@end
