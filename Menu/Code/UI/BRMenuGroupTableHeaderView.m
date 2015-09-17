//
//  MenuItemComponentHeaderView.m
//  FastOrder
//
//  Created by Matt on 4/11/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuGroupTableHeaderView.h"

#import <Masonry/Masonry.h>
#import "BRMenuGroupHeaderView.h"
#import <BRStyle/BRUIStylishHost.h>
#import "UIView+BRUIStyle.h"

@interface BRMenuGroupTableHeaderView () <BRUIStylishHost>
@end

@implementation BRMenuGroupTableHeaderView {
	BRMenuGroupHeaderView *headerView;
}

@dynamic uiStyle;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithReuseIdentifier:reuseIdentifier]) ) {
		[self initializeStandardTableHeaderViewDefaults];
		
		// without the following margin settings, when compiling on iOS 9 SDK the margins are different on iOS 8
		self.preservesSuperviewLayoutMargins = YES;
		self.contentView.preservesSuperviewLayoutMargins = YES;
	}
	return self;
}

- (void)initializeStandardTableHeaderViewDefaults {
	UIView *container = self.contentView;
	container.frame = CGRectMake(0, 0, 320, 50); // this eliminates a bunch of constraint warnings as container starts as CGRectZero
	headerView = [[BRMenuGroupHeaderView alloc] initWithFrame:container.bounds];
	[container addSubview:headerView];

	[headerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(container);
		make.leading.equalTo(container.mas_leadingMargin);
		make.trailing.equalTo(container);
		make.bottom.equalTo(container);
	}];
	[headerView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@10);
		make.leading.equalTo(headerView);
	}];
	[headerView.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(headerView.titleLabel.mas_trailing).with.offset(10);
		make.trailing.equalTo(container.mas_trailingMargin);
		make.baseline.equalTo(headerView.titleLabel);
	}];
	
	self.backgroundView = [[UIView alloc] initWithFrame:container.bounds];
	self.backgroundView.backgroundColor = self.uiStyle.colors.backgroundColor;
}

- (NSDecimalNumber *)price {
	return headerView.price;
}

- (void)setPrice:(NSDecimalNumber *)aPrice {
	headerView.price = aPrice;
}

- (NSString *)title {
	return headerView.title;
}

- (void)setTitle:(NSString *)text {
	headerView.title = text;
}
/*
- (CGSize)intrinsicContentSize {
	return [headerView intrinsicContentSize];
}
*/
@end
