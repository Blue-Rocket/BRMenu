//
//  BRMenuStepperStepper.m
//  MenuKit
//
//  Created by Matt on 4/12/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuStepper.h"

#import <BRStyle/Core.h>

@interface BRMenuStepper () <BRUIStylishHost>
@end

const CGSize BRMenuStepperPadding = {8.0, 4.0};

static const CGFloat kNaturalWidth = 80.0;
static const CGFloat kNaturalHeight = 28.0;
static const CGFloat kBadgeWidth = 28.0;

@interface BRMenuStepperMinusButton : UIControl
@property (weak) BRMenuStepper *stepper;
@end

@interface BRMenuStepperPlusButton : UIControl
@property (weak) BRMenuStepper *stepper;
@end

@implementation BRMenuStepper {
	__weak UILabel *badgeLabel;
	__weak BRMenuStepperMinusButton *minusButton;
	__weak BRMenuStepperPlusButton *plusButton;
}

@dynamic uiStyle;

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
		[self initializeStepper];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeStepper];
	}
	return self;
}

- (void)initializeStepper {
	UILabel *l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.backgroundColor = [UIColor clearColor];
	l.textAlignment = NSTextAlignmentCenter;
	l.adjustsFontSizeToFitWidth = YES;
	l.lineBreakMode = NSLineBreakByClipping;
	[self addSubview:l];
	badgeLabel = l;
	
	BRMenuStepperMinusButton *minus = [[BRMenuStepperMinusButton alloc] initWithFrame:CGRectZero];
	minus.opaque = NO;
	minus.stepper = self;
	[minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:minus];
	minusButton = minus;
	
	BRMenuStepperPlusButton *plus = [[BRMenuStepperPlusButton alloc] initWithFrame:CGRectZero];
	plus.opaque = NO;
	plus.stepper = self;
	[plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:plus];
	plusButton = plus;
	
	[self updateStyle:self.uiStyle];
	
	self.opaque = NO;
	self.value = 0;
	self.minimumValue = 0;
	self.maximumValue = 32;
	self.stepValue = 1;
	
	self.contentMode = UIViewContentModeRedraw;
}

- (void)updateStyle:(BRUIStyle *)style {
	badgeLabel.font = [style.fonts.actionFont fontWithUIStyleCSSFontWeight:500] ;
	badgeLabel.font = [badgeLabel.font fontWithSize:badgeLabel.font.pointSize + 2.0];
	badgeLabel.textColor = (self.value > 0 ? self.uiStyle.colors.primaryColor :
							self.uiStyle.colors.controlSettings.disabledColorSettings.actionColor);
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self updateStyle:style];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(kNaturalWidth + 2 * BRMenuStepperPadding.width, kNaturalHeight + 2 * BRMenuStepperPadding.height);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect bounds = self.bounds;

	CGRect frame = CGRectMake(CGRectGetMidX(self.bounds) - (kNaturalWidth / 2.0), CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, kNaturalWidth, kNaturalHeight);

	//// Subframes
	CGRect minusFrame = CGRectMake(CGRectGetMinX(frame) - BRMenuStepperPadding.width, 0, 25 + BRMenuStepperPadding.width * 2.0, bounds.size.height);
	CGRect plusFrame = CGRectMake(CGRectGetMaxX(frame) - 25 - BRMenuStepperPadding.width, 0, 25 + BRMenuStepperPadding.width * 2.0, bounds.size.height);
	minusButton.frame = minusFrame;
	plusButton.frame = plusFrame;

	// vertically center the capHeight of the number text: this only works for fonts where numbers DO NOT have descenders (i.e. "old style")
	CGRect badgeFrame = CGRectIntegral(CGRectMake(CGRectGetMidX(bounds) - (kBadgeWidth / 2.0),
												  CGRectGetMidY(bounds) - (badgeLabel.font.ascender - badgeLabel.font.capHeight) - (badgeLabel.font.capHeight / 2.0),
												  kBadgeWidth,
												  badgeLabel.font.lineHeight));
	badgeLabel.frame = badgeFrame;
}

- (void)setValue:(NSInteger)newValue {
	[self setValue:newValue actions:NO];
}

- (void)setValue:(NSInteger)newValue actions:(const BOOL)actions {
	NSInteger old = _value;
	_value = newValue;
	badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)_value];
	if ( old != newValue ) {
		badgeLabel.textColor = (newValue > 0 ? self.uiStyle.colors.primaryColor :
								self.uiStyle.colors.controlSettings.disabledColorSettings.actionColor);
		if ( actions ) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
		
		// enable the opposite button if we moved off the edge cases
		if ( old == _minimumValue ) {
			[minusButton setNeedsDisplay];
		} else if ( old == _maximumValue ) {
			[plusButton setNeedsDisplay];
		}
	}
}

- (IBAction)minus:(id)sender {
	NSInteger offset = 0;
	if ( _value > _minimumValue ) {
		offset = -_stepValue;
	}
	[self setValue:MAX(_minimumValue, _value + offset) actions:YES];
}

- (IBAction)plus:(id)sender {
	NSInteger offset = 0;
	if ( _value < _maximumValue ) {
		offset = _stepValue;
	}
	[self setValue: MIN(_maximumValue, _value + offset) actions:YES];
}

- (void)drawRect:(CGRect)rect {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = self.uiStyle.colors.controlSettings.normalColorSettings.borderColor;
	
	//// Shadow Declarations
	UIColor* shadow = self.uiStyle.colors.controlSettings.normalColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = CGRectMake(CGRectGetMidX(self.bounds) - (kNaturalWidth / 2.0), CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, kNaturalWidth, kNaturalHeight);
	
	//// Subframes
	CGRect boxFrame = CGRectMake(frame.origin.x + 24.5, frame.origin.y + 0.5, frame.size.width - 49, 25);
	
	
	//// Box Drawing
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	CGContextSetLineWidth(context, 1);
	CGContextStrokeRect(context, boxFrame);
	CGContextRestoreGState(context);
	
}

@end

#pragma mark -

@implementation BRMenuStepperMinusButton

- (void)drawLabelInFrame:(CGRect)minusFrame context:(CGContextRef)context textColor:(UIColor *)labelColor {
	[labelColor setFill];

	//// Minus Drawing
	UIBezierPath* minusPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(minusFrame) + 7, CGRectGetMinY(minusFrame) + floor((CGRectGetHeight(minusFrame) - 2) * 0.48000 + 0.5), 12, 2)];
	[minusPath fill];
}

- (CGRect)minusFrame {
	return CGRectMake(BRMenuStepperPadding.width, CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, 25, 27);
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	BRUIStyleControlStateColorSettings *controlSettings = self.uiStyle.colors.controlSettings;
	
	//// Color Declarations
	UIColor* strokeColor = controlSettings.normalColorSettings.borderColor;
	UIColor* labelColor = (self.stepper.value <= self.stepper.minimumValue
						   ? controlSettings.disabledColorSettings.actionColor
						   : controlSettings.normalColorSettings.actionColor);
	
	//// Shadow Declarations
	UIColor* shadow = self.uiStyle.colors.controlSettings.normalColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Subframes
	CGRect minusFrame = [self minusFrame];
	
	
	//// Minus tab Drawing
	UIBezierPath* minusTabPath = [UIBezierPath bezierPath];
	[minusTabPath moveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 23.71)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	minusTabPath.lineWidth = 1;
	[minusTabPath stroke];
	CGContextRestoreGState(context);
	
	[self drawLabelInFrame:minusFrame context:context textColor:labelColor];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();

	BRUIStyleControlStateColorSettings *controlSettings = self.uiStyle.colors.controlSettings;

	//// Color Declarations
	UIColor* strokeColor = controlSettings.highlightedColorSettings.borderColor;
	UIColor* labelColor = (self.stepper.value <= self.stepper.minimumValue
						   ? controlSettings.disabledColorSettings.actionColor
						   : controlSettings.highlightedColorSettings.actionColor);
	UIColor* insetShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* highlightedFill = controlSettings.highlightedColorSettings.fillColor;
	
	//// Shadow Declarations
	UIColor* shadow = controlSettings.highlightedColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Subframes
	CGRect minusFrame = [self minusFrame];
	
	
	//// Minus tab Drawing
	UIBezierPath* minusTabPath = [UIBezierPath bezierPath];
	[minusTabPath moveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 23.71)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	minusTabPath.lineWidth = 1;
	[minusTabPath stroke];
	CGContextRestoreGState(context);
	[highlightedFill setFill];
	[minusTabPath fill];
	
	////// Minus tab Inner Shadow
	CGRect minusTabBorderRect = CGRectInset([minusTabPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	minusTabBorderRect = CGRectOffset(minusTabBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	minusTabBorderRect = CGRectInset(CGRectUnion(minusTabBorderRect, [minusTabPath bounds]), -1, -1);
	
	UIBezierPath* minusTabNegativePath = [UIBezierPath bezierPathWithRect: minusTabBorderRect];
	[minusTabNegativePath appendPath: minusTabPath];
	minusTabNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(minusTabBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[minusTabPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(minusTabBorderRect.size.width), 0);
		[minusTabNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[minusTabNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	//[strokeColor setStroke];
	//minusTabPath.lineWidth = 1;
	//[minusTabPath stroke];
	
	
	[self drawLabelInFrame:minusFrame context:context textColor:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( self.stepper.value > self.stepper.minimumValue ) {
			[self drawHighlighted];
		} else {
			[self drawNormal];
		}
	} else {
		[self drawNormal];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

@end

#pragma mark - 

@implementation BRMenuStepperPlusButton

- (void)drawLabelInFrame:(CGRect)plusFrame context:(CGContextRef)context textColor:(UIColor *)labelColor {
	[labelColor setFill];

	//// Plus V Drawing
	UIBezierPath* plusVPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plusFrame) + CGRectGetWidth(plusFrame) - 14, CGRectGetMinY(plusFrame) + floor((CGRectGetHeight(plusFrame) - 12) * 0.46667 + 0.5), 2, 12)];
	[plusVPath fill];
	
	
	//// Plus H Drawing
	UIBezierPath* plusHPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plusFrame) + CGRectGetWidth(plusFrame) - 19, CGRectGetMinY(plusFrame) + floor((CGRectGetHeight(plusFrame) - 2) * 0.48000 + 0.5), 12, 2)];
	[plusHPath fill];
}

- (CGRect)plusFrame {
	return CGRectMake(BRMenuStepperPadding.width, CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, 25, 27);
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	BRUIStyleControlStateColorSettings *controlSettings = self.uiStyle.colors.controlSettings;
	
	//// Color Declarations
	UIColor* strokeColor = controlSettings.normalColorSettings.borderColor;
	UIColor* labelColor = (self.stepper.value >= self.stepper.maximumValue
						   ? controlSettings.disabledColorSettings.actionColor
						   : controlSettings.normalColorSettings.actionColor);
	
	//// Shadow Declarations
	UIColor* shadow = controlSettings.normalColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect plusFrame = [self plusFrame];
	
	
	//// Plus tab Drawing
	UIBezierPath* plusTabPath = [UIBezierPath bezierPath];
	[plusTabPath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 23.71)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 4.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	plusTabPath.lineWidth = 1;
	[plusTabPath stroke];
	CGContextRestoreGState(context);
	
	[self drawLabelInFrame:plusFrame context:context textColor:labelColor];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	BRUIStyleControlStateColorSettings *controlSettings = self.uiStyle.colors.controlSettings;

	//// Color Declarations
	UIColor* strokeColor = controlSettings.highlightedColorSettings.borderColor;
	UIColor* labelColor = (self.stepper.value >= self.stepper.maximumValue
						   ? controlSettings.disabledColorSettings.actionColor
						   : controlSettings.highlightedColorSettings.actionColor);
	UIColor* insetShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* highlightedFill = controlSettings.highlightedColorSettings.fillColor;
	
	//// Shadow Declarations
	UIColor* shadow = controlSettings.highlightedColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect plusFrame = [self plusFrame];
	
	
	//// Plus tab Drawing
	UIBezierPath* plusTabPath = [UIBezierPath bezierPath];
	[plusTabPath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 23.71)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 4.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	plusTabPath.lineWidth = 1;
	[plusTabPath stroke];
	CGContextRestoreGState(context);
	[highlightedFill setFill];
	[plusTabPath fill];
	
	////// Plus tab Inner Shadow
	CGRect plusTabBorderRect = CGRectInset([plusTabPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	plusTabBorderRect = CGRectOffset(plusTabBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	plusTabBorderRect = CGRectInset(CGRectUnion(plusTabBorderRect, [plusTabPath bounds]), -1, -1);
	
	UIBezierPath* plusTabNegativePath = [UIBezierPath bezierPathWithRect: plusTabBorderRect];
	[plusTabNegativePath appendPath: plusTabPath];
	plusTabNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(plusTabBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[plusTabPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(plusTabBorderRect.size.width), 0);
		[plusTabNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[plusTabNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	//[strokeColor setStroke];
	//plusTabPath.lineWidth = 1;
	//[plusTabPath stroke];
	
	[self drawLabelInFrame:plusFrame context:context textColor:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( self.stepper.value < self.stepper.maximumValue ) {
			[self drawHighlighted];
		} else {
			[self drawNormal];
		}
	} else {
		[self drawNormal];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

@end