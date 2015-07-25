//
//  MenuItemComponentHeaderView.m
//  FastOrder
//
//  Created by Matt on 4/11/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import "BRMenuGroupTableHeaderView.h"

#import <Masonry/Masonry.h>
#import "BRMenuGroupHeaderView.h"
#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuGroupTableHeaderView () <BRMenuUIStylishHost>
@end

@implementation BRMenuGroupTableHeaderView {
	BRMenuGroupTableHeaderView *headerView;
}

@dynamic uiStyle;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithReuseIdentifier:reuseIdentifier]) ) {
		[self initializeStandardTableHeaderViewDefaults];
	}
	return self;
}

- (void)initializeStandardTableHeaderViewDefaults {
	UIView *container = self.contentView;
	container.frame = CGRectMake(0, 0, 320, 50); // this eliminates a bunch of constraint warnings as container starts as CGRectZero
	headerView = [[BRMenuGroupHeaderView alloc] initWithFrame:container.bounds];
	[container addSubview:headerView];

	[headerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(container);
	}];
	
	self.backgroundView = [[UIView alloc] initWithFrame:container.bounds];
	self.backgroundView.backgroundColor = self.uiStyle.appBodyColor;
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

- (CGSize)intrinsicContentSize {
	return [headerView intrinsicContentSize];
}

@end
