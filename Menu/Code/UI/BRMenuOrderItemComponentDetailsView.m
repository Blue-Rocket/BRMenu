//
//  BRMenuOrderItemComponentDetailsView.m
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderItemComponentDetailsView.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuItemComponent.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuUIModelPropertyEditor.h"
#import "BRMenuLightHeavyQuantityButton.h"
#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuOrderItemComponentDetailsView () <BRMenuUIStylishHost>
@property (nonatomic, strong) IBOutlet UIControl<BRMenuUIModelPropertyEditor> *quantity;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@end

@implementation BRMenuOrderItemComponentDetailsView {
	BRMenuOrderItemComponent *orderItemComponent;
}

@dynamic uiStyle;
@synthesize orderItemComponent;

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		[self setupSubviews];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self setupSubviews];
	}
	return self;
}

- (void)setupSubviews {
	self.contentInsets = UIEdgeInsetsMake(2, 0, 2, 0);
	
	if ( !self.title ) {
		UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
		l.font = self.uiStyle.secondaryFont;
		l.textColor = self.uiStyle.secondaryColor;
		self.title = l;
		[self addSubview:l];
	}
	
	if ( !self.quantity ) {
		BRMenuLightHeavyQuantityButton *quantity = [[BRMenuLightHeavyQuantityButton alloc] initWithFrame:CGRectZero];
		quantity.enabled = NO;
		quantity.selected = YES;
		self.quantity = quantity;
		[self addSubview:quantity];
	}
	
	UIEdgeInsets padding = self.contentInsets;
	if ( self.quantity.constraints.count < 1 ) {
		[self.quantity mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.trailing.equalTo(@(-padding.right));
			make.width.equalTo(@44);
			make.top.equalTo(self);
			make.bottom.equalTo(self);
		}];
	}
}

- (void)updateConstraints {
	UIEdgeInsets padding = self.contentInsets;
	[self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(padding.top));
		make.leading.equalTo(@(padding.left));
		make.trailing.equalTo(self.quantity.hidden
							  ? self.mas_trailing
							  : self.quantity.mas_leading).with.offset(-padding.right);
		make.bottom.equalTo(@(-padding.bottom));
	}];
	[super updateConstraints];
}

- (void)setOrderItemComponent:(BRMenuOrderItemComponent *)theOrderComponent {
	orderItemComponent = theOrderComponent;
	self.title.text = theOrderComponent.component.title;
	[self.quantity setPropertyEditorValue:@(theOrderComponent.quantity)];
	self.quantity.hidden = (theOrderComponent.component.askQuantity == NO
							|| [[self.quantity propertyEditorDefaultValueForModel:[BRMenuOrderItemComponent class]] isEqual:@(theOrderComponent.quantity)]);
	[self setNeedsUpdateConstraints];
}

@end
