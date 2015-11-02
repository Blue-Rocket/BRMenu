//
//  BRMenuOrderItemPlacementDetailsView.m
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItemPlacementDetailsView.h"

#import <Masonry/Masonry.h>
#import "BRMenuFitToWidthLabel.h"
#import "BRMenuLeftRightPlacementButton.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponentDetailsView.h"
#import <BRStyle/BRUIStylishHost.h>
#import "NSBundle+BRMenu.h"
#import "UIView+BRUIStyle.h"

@interface BRMenuOrderItemPlacementDetailsView () <BRUIStylishHost>
@property (nonatomic, strong) UIView *titleRule;
@end

@implementation BRMenuOrderItemPlacementDetailsView {
	BRMenuOrderItem *orderItem;
	BRMenuOrderItemComponentPlacement placementToDisplay;
	NSArray *componentViews;
	BOOL omitEmptyPlaceholderSet;
}

@dynamic uiStyle;
@synthesize orderItem;
@synthesize placementToDisplay;
@synthesize omitEmptyPlaceholder;

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
	if ( !self.titleRule ) {
		UIView *rule = [[UIView alloc] initWithFrame:CGRectZero];
		rule.backgroundColor = self.uiStyle.colors.separatorColor;
		rule.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:rule];
		self.titleRule = rule;
	}
	
	if ( !self.title ) {
		UILabel *l = [[BRMenuFitToWidthLabel alloc] initWithFrame:CGRectZero];
		l.font = self.uiStyle.fonts.headlineFont;
		l.textColor = self.uiStyle.colors.primaryColor;
		self.title = l;
		[self addSubview:l];
	}
	
	if ( !self.placement ) {
		BRMenuLeftRightPlacementButton *placement = [[BRMenuLeftRightPlacementButton alloc] initWithFrame:CGRectZero];
		placement.enabled = NO;
		placement.selected = NO;
		placement.diameter = floorf(self.title.font.capHeight);
		placement.cornerRadius = placement.diameter / 2;

		// to keep this snug to the right, make the content hugging required
		[placement setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
		self.placement = placement;
		[self addSubview:placement];
	}
	
	if ( self.titleRule.constraints.count < 1 ) {
		[self.titleRule mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.height.equalTo(@0.5);
			make.top.equalTo(self.title.mas_baseline).with.offset(2);
		}];
	}
	
	if ( self.placement.constraints.count < 1 ) {
		[self.placement mas_makeConstraints:^(MASConstraintMaker *make) {
			make.trailing.equalTo(self);
			make.bottom.equalTo(self.titleRule.mas_top);
		}];
	}
}

- (void)updateConstraints {
	[self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.leading.equalTo(self);
		make.trailing.equalTo(self.placement.hidden
							  ? self.mas_trailing
							  : self.placement.mas_leading);
	}];
	__block UIView *previousView = self.title;
	[componentViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *componentView = obj;
		[componentView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self);
			make.trailing.equalTo(self);
			make.top.equalTo(previousView.mas_bottom).with.offset(2); // TODO: make configurable?
		}];
		previousView = componentView;
	}];
	[previousView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self);
	}];
	[super updateConstraints];
}

- (void)updateTitleFromModel {
	switch ( placementToDisplay ) {
		case BRMenuOrderItemComponentPlacementLeft:
			self.title.text = [NSBundle localizedBRMenuString:@"menu.ordering.item.details.left.title"];
			break;
			
		case BRMenuOrderItemComponentPlacementRight:
			self.title.text = [NSBundle localizedBRMenuString:@"menu.ordering.item.details.right.title"];
			break;
			
		default:
			self.title.text = self.orderItem.item.title;
			break;
	}
}

- (void)setOmitEmptyPlaceholder:(BOOL)value {
	omitEmptyPlaceholderSet = YES;
	omitEmptyPlaceholder = value;
}

- (BOOL)isOmitEmptyPlaceholder {
	return (omitEmptyPlaceholderSet
			? omitEmptyPlaceholder
			: (placementToDisplay == BRMenuOrderItemComponentPlacementWhole
			   ? NO
			   : YES));
}

- (void)setOrderItem:(BRMenuOrderItem *)item {
	if ( orderItem != item ) {
		orderItem = item;
		[componentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		NSMutableArray *views = [NSMutableArray arrayWithCapacity:5];
		NSArray<BRMenuOrderItemComponent *> *orderComponents = orderItem.components;
		if ( orderComponents.count < 1 && !self.isOmitEmptyPlaceholder ) {
			BRMenuItemComponent *placeholder = [[BRMenuItemComponent alloc] init];
			placeholder.title = [NSBundle localizedBRMenuString:@"menu.ordering.item.details.emptyComponent.title"];
			BRMenuOrderItemComponent *orderPlaceholder = [[BRMenuOrderItemComponent alloc] initWithComponent:placeholder];
			orderComponents = @[orderPlaceholder];
		}
		for ( BRMenuOrderItemComponent *orderComponent in orderComponents ) {
			if ( orderComponent.placement != placementToDisplay ) {
				continue;
			}
			BRMenuOrderItemComponentDetailsView *cv = [[BRMenuOrderItemComponentDetailsView alloc] initWithFrame:CGRectZero];
			cv.translatesAutoresizingMaskIntoConstraints = NO;
			cv.orderItemComponent = orderComponent;
			[views addObject:cv];
			[self addSubview:cv];
		}
		componentViews = [views copy];
		self.placement.hidden = (placementToDisplay == BRMenuOrderItemComponentPlacementWhole);
		[self updateTitleFromModel];
		[self setNeedsUpdateConstraints];
	}
}

- (void)setPlacementToDisplay:(BRMenuOrderItemComponentPlacement)toDisplay {
	if ( placementToDisplay != toDisplay ) {
		placementToDisplay = toDisplay;
		[self.placement setValue:@(toDisplay) forKeyPath:[self.placement propertyEditorKeyPathForModel:[BRMenuOrderItemComponent class]]];
		[self updateTitleFromModel];
		[self setNeedsUpdateConstraints];
	}
}

@end
