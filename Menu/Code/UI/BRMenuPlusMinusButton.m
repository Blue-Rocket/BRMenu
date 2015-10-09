//
//  BRMenuPlusMinusButton.m
//  MenuKit
//
//  Created by Matt on 4/17/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuPlusMinusButton.h"

#import <BRStyle/Core.h>

static const CGFloat kMinButtonLength = 28;

@interface BRMenuPlusMinusButton () <BRUIStylishHost>
@end

@implementation BRMenuPlusMinusButton {
	CGSize buttonSize;
}

@dynamic dangerous;
@dynamic uiStyle;
@synthesize buttonSize;

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
	buttonSize = CGSizeMake(kMinButtonLength, kMinButtonLength);
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

- (void)setEnabled:(BOOL)enabled {
	BOOL old = self.enabled;
	[super setEnabled:enabled];
	if ( old != enabled ) {
		[self setNeedsDisplay];
	}
}

- (void)setButtonSize:(CGSize)size {
	if ( size.width < kMinButtonLength ) {
		size.width = kMinButtonLength;
	}
	if ( size.height < kMinButtonLength ) {
		size.height = kMinButtonLength;
	}
	if ( !CGSizeEqualToSize(size, buttonSize) ) {
		buttonSize = size;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
}

#pragma mark - UI changes

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self setNeedsDisplay];
}

- (void)controlStateDidChange:(UIControlState)state {
	[self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGSize)intrinsicContentSize {
	return CGSizeMake(buttonSize.width + 2, buttonSize.height + 2);
}

- (void)drawRect:(CGRect)rect {
	CGSize size = self.buttonSize;
	CGRect drawFrame = CGRectMake(0, 0, size.width, size.height);
	drawFrame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(drawFrame) / 2;
	drawFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(drawFrame) / 2;
	[self drawPlusMinusWithFrame:drawFrame pressed:self.highlighted plus:self.plus];
}

- (void)drawPlusMinusWithFrame:(CGRect)frame pressed:(BOOL)pressed plus:(BOOL)plus
{
	//// Style settings
	
	BRUIStyleControlSettings *controlSettings = [self uiStyleForState:self.state].controls;

	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* labelColor = controlSettings.actionColor;
	UIColor* strokeColor = controlSettings.borderColor;
	UIColor* fillColor = controlSettings.fillColor;
	UIColor* pressedShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* glossColor = controlSettings.glossColor;
	
	//// Shadow Declarations
	NSShadow* depressedShadow = [[NSShadow alloc] init];
	[depressedShadow setShadowColor: pressedShadowColor];
	[depressedShadow setShadowOffset: CGSizeMake(0.1, 2.1)];
	[depressedShadow setShadowBlurRadius: 2];
	NSShadow* glossShadow = [[NSShadow alloc] init];
	[glossShadow setShadowColor: glossColor];
	[glossShadow setShadowOffset: CGSizeMake(0.1, 1.1)];
	[glossShadow setShadowBlurRadius: 0];
	
	//// Variable Declarations
	BOOL notPressed = !pressed;
	
	if (pressed)
	{
		//// Border Pressed Drawing
		UIBezierPath* borderPressedPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 4];
		[fillColor setFill];
		[borderPressedPath fill];
		
		////// Border Pressed Inner Shadow
		CGContextSaveGState(context);
		UIRectClip(borderPressedPath.bounds);
		CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
		
		CGContextSetAlpha(context, CGColorGetAlpha([depressedShadow.shadowColor CGColor]));
		CGContextBeginTransparencyLayer(context, NULL);
		{
			UIColor* opaqueShadow = [depressedShadow.shadowColor colorWithAlphaComponent: 1];
			CGContextSetShadowWithColor(context, depressedShadow.shadowOffset, depressedShadow.shadowBlurRadius, [opaqueShadow CGColor]);
			CGContextSetBlendMode(context, kCGBlendModeSourceOut);
			CGContextBeginTransparencyLayer(context, NULL);
			
			[opaqueShadow setFill];
			[borderPressedPath fill];
			
			CGContextEndTransparencyLayer(context);
		}
		CGContextEndTransparencyLayer(context);
		CGContextRestoreGState(context);
		
		[strokeColor setStroke];
		borderPressedPath.lineWidth = 1;
		[borderPressedPath stroke];
	}
	
	
	if (notPressed)
	{
		//// Border Drawing
		UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 4];
		[fillColor setFill];
		[borderPath fill];
		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, glossShadow.shadowOffset, glossShadow.shadowBlurRadius, [glossShadow.shadowColor CGColor]);
		[strokeColor setStroke];
		borderPath.lineWidth = 1;
		[borderPath stroke];
		CGContextRestoreGState(context);
	}
	
	
	if (plus)
	{
		//// Plus V Drawing
		UIBezierPath* plusVPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 2) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 12) * 0.50000 + 0.5), 2, 12)];
		[labelColor setFill];
		[plusVPath fill];
	}
	
	
	//// Plus H Drawing
	UIBezierPath* plusHPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 12) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 2) * 0.50000 + 0.5), 12, 2)];
	[labelColor setFill];
	[plusHPath fill];
}

@end
