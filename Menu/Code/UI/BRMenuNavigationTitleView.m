//
//  APNavigationTitleView.m
//  AndFramework
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuNavigationTitleView.h"

#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuNavigationTitleView () <BRMenuUIStylishHost>
@end

@implementation BRMenuNavigationTitleView {
	UILabel *titleLabel;
	NSString *title;
}

@dynamic uiStyle;

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
		[self initializeNavigationTitleViewDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeNavigationTitleViewDefaults];
	}
	return self;
}

- (void)initializeNavigationTitleViewDefaults {
	self.backgroundColor = [UIColor clearColor];
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = self.uiStyle.titleFont;
	titleLabel.textColor = self.uiStyle.inverseAppPrimaryColor;
	titleLabel.shadowColor = self.uiStyle.inverseTextShadowColor;
	titleLabel.shadowOffset = CGSizeMake(0, -1);
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:titleLabel];
}

- (void)uStyleDidChange:(BRMenuUIStyle *)style {
	[self setNeedsDisplay];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)theText {
	title = theText;
	titleLabel.text = title;
	[titleLabel sizeToFit];
}

- (NSString *)title {
	return title;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
	// size to the icon dimensions, plus a 2px padding
	return [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	const CGRect bounds = self.bounds;
	
	// we assume titleLabel has been fit to text size (setTitle: does that), so set width to at most container width
	CGRect titleBounds = titleLabel.bounds;
	titleBounds.size.width = MIN(titleBounds.size.width, bounds.size.width);
	titleLabel.bounds = titleBounds;

	// now center title X in super.super view but if too large, shift to try to display as much title as possible
	const CGRect superframe = self.superview.superview.bounds;
	const CGPoint supercenter = CGPointMake(superframe.size.width * 0.5, bounds.size.height * 0.5);
	titleLabel.center = [self.superview.superview convertPoint:supercenter toView:self];
	
	// if title overlaps container on left, shift to right
	CGRect frame = CGRectIntegral(titleLabel.frame);
	if ( frame.origin.x < 0 ) {
		frame.origin.x = 0;
	}
	// if title overlaps container on right, shift to left
	if ( CGRectGetMaxX(frame) > bounds.size.width ) {
		frame.origin.x -= CGRectGetMaxX(frame) - bounds.size.width;
	}
	// final re-check left, now have to decrease title width if overlaps left
	if ( frame.origin.x < 0 ) {
		// adjust width
		frame.size.width += frame.origin.x;
		frame.origin.x = 0;
	}
	frame.origin.y = ceilf((bounds.size.height - titleLabel.font.lineHeight) * 0.5);
	titleLabel.frame = frame;
}

@end
