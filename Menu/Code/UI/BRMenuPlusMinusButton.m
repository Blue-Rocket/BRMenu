//
//  BRMenuPlusMinusButton.m
//  MenuKit
//
//  Created by Matt on 4/17/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuPlusMinusButton.h"

#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuPlusMinusButton () <BRMenuUIStylishHost>
@end

@implementation BRMenuPlusMinusButton

@dynamic uiStyle;

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		[self initializePlusMinusButtonDefaults];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializePlusMinusButtonDefaults];
	}
	return self;
}

- (void)initializePlusMinusButtonDefaults {
	self.opaque = NO;
	self.contentMode = UIViewContentModeCenter;
	self.plus = YES;
}

#pragma mark - Accessors

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

- (void)setSelected:(BOOL)selected {
	BOOL old = self.selected;
	[super setSelected:selected];
	if ( old != selected ) {
		[self setNeedsDisplay];
	}
}

#pragma mark - Drawing

- (void)drawPlusMinusInFrame:(CGRect)frame color:(UIColor *)labelColor {
	//// Plus V Drawing
	if ( self.plus ) {
		UIBezierPath* plusVPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 2) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 12) * 0.50000 + 0.5), 2, 12)];
		[labelColor setFill];
		[plusVPath fill];
	}
	
	
	//// Plus H Drawing
	UIBezierPath* plusHPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 12) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 2) * 0.50000 + 0.5), 12, 2)];
	[labelColor setFill];
	[plusHPath fill];
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const BOOL selected = self.selected;
	
	//// Color Declarations
	UIColor* strokeColor = (selected ? [self.uiStyle controlSelectedColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (selected ? [self.uiStyle controlSelectedColor] : [self.uiStyle controlTextColor]);
	
	//// Shadow Declarations
	UIColor* shadow = [self.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = CGRectMake(self.bounds.size.width * 0.5 - 14, self.bounds.size.height * 0.5 - 14, 28, 28);
	
	
	//// Rounded Rectangle Drawing
	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 4];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	roundedRectanglePath.lineWidth = 1;
	[roundedRectanglePath stroke];
	CGContextRestoreGState(context);
	
	[self drawPlusMinusInFrame:frame color:labelColor];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const BOOL selected = self.selected;
	
	//// Color Declarations
	UIColor* strokeColor = (selected ? [self.uiStyle controlSelectedColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (selected ? [self.uiStyle controlSelectedColor] : [self.uiStyle controlTextColor]);
	UIColor* insetShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* highlightedFill = [self.uiStyle controlHighlightedColor];
	
	//// Shadow Declarations
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = CGRectMake(self.bounds.size.width * 0.5 - 14, self.bounds.size.height * 0.5 - 14, 28, 28);
	
	
	//// Rounded Rectangle Drawing
	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 4];
	[highlightedFill setFill];
	[roundedRectanglePath fill];
	
	////// Rounded Rectangle Inner Shadow
	CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
	
	UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
	[roundedRectangleNegativePath appendPath: roundedRectanglePath];
	roundedRectangleNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(roundedRectangleBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[roundedRectanglePath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
		[roundedRectangleNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[roundedRectangleNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[strokeColor setStroke];
	roundedRectanglePath.lineWidth = 1;
	[roundedRectanglePath stroke];
	
	
	[self drawPlusMinusInFrame:frame color:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		[self drawHighlighted];
	} else {
		[self drawNormal];
	}
}

@end
