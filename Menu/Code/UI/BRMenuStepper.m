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
static const CGFloat kBadgeHorizonalPadding = 2;

static const CGFloat kMinimumPlusMinusButtonWidth = 25.0;
static const CGFloat kMinimumBadgeWidth = (kNaturalWidth - kMinimumPlusMinusButtonWidth * 2);

@implementation BRMenuStepper {
	UILabel *badgeLabel;
	BOOL minusHighlighted;
	BOOL plusHighlighted;
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
	l.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:l];
	badgeLabel = l;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	tap.numberOfTapsRequired = 1;
	tap.numberOfTouchesRequired = 1;
	[self addGestureRecognizer:tap];
	
	self.opaque = NO;
	self.value = 0;
	self.minimumValue = 0;
	self.maximumValue = 32;
	self.stepValue = 1;
	
	self.contentMode = UIViewContentModeRedraw;
	
	CGSize stepSize = self.stepButtonSize;
	if ( stepSize.width < kMinimumPlusMinusButtonWidth ) {
		stepSize.width = kMinimumPlusMinusButtonWidth;
	}
	if ( stepSize.height < kNaturalHeight ) {
		stepSize.height = kNaturalHeight;
	}
	if ( !CGSizeEqualToSize(self.stepButtonSize, stepSize) ) {
		self.stepButtonSize = stepSize;
	}

	[self updateStyle:self.uiStyle];
}

- (void)setStepButtonSize:(CGSize)value {
	if ( !CGSizeEqualToSize(value, _stepButtonSize) && !(value.width < kMinimumPlusMinusButtonWidth) && !(value.height < kNaturalHeight) ) {
		_stepButtonSize = value;
		[self invalidateIntrinsicContentSize];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	}
}

- (void)updateStyle:(BRUIStyle *)style {
	badgeLabel.font = [style.fonts.actionFont fontWithUIStyleCSSFontWeight:500] ;
	badgeLabel.font = [badgeLabel.font fontWithSize:badgeLabel.font.pointSize + 2.0];
	[self refreshBadgeColor:style];
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (void)refreshBadgeColor:(BRUIStyle *)style {
	BRUIStyleControlSettings *disabledSettings = [self uiStyleForState:UIControlStateDisabled].controls;
	BRUIStyleControlSettings *selectedSettings = [self uiStyleForState:UIControlStateSelected].controls;
	badgeLabel.textColor = (self.value > 0
							? selectedSettings.actionColor
							: disabledSettings.actionColor);
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self updateStyle:style];
}

- (void)setEnabled:(BOOL)enabled {
	BOOL changed = (self.enabled != enabled);
	[super setEnabled:enabled];
	if ( changed ) {
		[self refreshBadgeColor:self.uiStyle];
		[self setNeedsDisplay];
	}
}

- (void)setValue:(NSInteger)newValue {
	[self setValue:newValue actions:NO];
}

- (void)setValue:(NSInteger)newValue actions:(const BOOL)actions {
	NSInteger old = _value;
	_value = newValue;
	badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)_value];
	if ( old != newValue ) {
		[self refreshBadgeColor:self.uiStyle];
		if ( actions ) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
		
		// enable the opposite button if we moved off/on the edge cases
		if ( old == _minimumValue || old == _maximumValue || _value == _minimumValue || _value == _maximumValue ) {
			[self setNeedsDisplay];
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

- (void)setMinusHighlighted:(BOOL)value {
	if ( !value == minusHighlighted ) {
		minusHighlighted = value;
		if ( value ) {
			[self setPlusHighlighted:NO];
		}
		[self setNeedsDisplay];
	}
}

- (void)setPlusHighlighted:(BOOL)value {
	if ( !value == plusHighlighted ) {
		plusHighlighted = value;
		if ( value ) {
			[self setMinusHighlighted:NO];
		}
		[self setNeedsDisplay];
	}
}

#pragma mark Touch support

- (IBAction)tap:(UITapGestureRecognizer *)sender {
	CGPoint tapPoint = [sender locationInView:self];
	if ( tapPoint.x < CGRectGetMidX(self.bounds) ) {
		[self minus:sender];
	} else {
		[self plus:sender];
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	if ( touches.count != 1 ) {
		return;
	}
	const CGPoint tapPoint = [[touches anyObject] locationInView:self];
	const CGFloat midX = CGRectGetMidX(self.bounds);
	if ( _value > _minimumValue && tapPoint.x < midX ) {
		[self setMinusHighlighted:YES];
	} else if ( _value < _maximumValue && tapPoint.x > midX ) {
		[self setPlusHighlighted:YES];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if ( minusHighlighted ) {
		[self setMinusHighlighted:NO];
	}
	if ( plusHighlighted ) {
		[self setPlusHighlighted:NO];
	}
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	if ( minusHighlighted ) {
		[self setMinusHighlighted:NO];
	}
	if ( plusHighlighted ) {
		[self setPlusHighlighted:NO];
	}
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSizeWithoutPadding {
	CGFloat badgeWidth = ([badgeLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultHigh].width
						  + (kBadgeHorizonalPadding * 2));
	if ( badgeWidth < kMinimumBadgeWidth ) {
		badgeWidth = kMinimumBadgeWidth;
	}
	return CGSizeMake(self.stepButtonSize.width * 2 + badgeWidth, self.stepButtonSize.height);
}

- (CGSize)intrinsicContentSize {
	CGSize frameSize = [self intrinsicContentSizeWithoutPadding];
	return CGSizeMake(frameSize.width + 2 * BRMenuStepperPadding.width, frameSize.height + 2 * BRMenuStepperPadding.height);
}

- (CGRect)intrinsicContentFrame {
	CGRect bounds = self.bounds;
	CGSize frameSize = [self intrinsicContentSizeWithoutPadding];
	return CGRectMake(CGRectGetMidX(bounds) - (frameSize.width / 2.0), CGRectGetMidY(bounds) - (frameSize.height / 2.0) + 1.0, frameSize.width, frameSize.height);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect frame = [self intrinsicContentFrame];

	// vertically center the capHeight of the number text: this only works for fonts where numbers DO NOT have descenders (i.e. "old style")
	CGRect badgeFrame = CGRectIntegral(CGRectMake(CGRectGetMinX(frame) + self.stepButtonSize.width,
												  CGRectGetMidY(self.bounds) - (badgeLabel.font.ascender - badgeLabel.font.capHeight) - (badgeLabel.font.capHeight / 2.0),
												  CGRectGetWidth(frame) - self.stepButtonSize.width * 2,
												  badgeLabel.font.lineHeight));
	badgeLabel.frame = badgeFrame;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	// TODO: cache drawing into stretchable image
	CGRect frame = [self intrinsicContentFrame];
	[self drawStepperWithFrame:frame plusPressed:plusHighlighted minusPressed:minusHighlighted plusEnabled:(_value < _maximumValue) minusEnabled:(_value > _minimumValue)];
}

- (void)drawStepperWithFrame: (CGRect)frame plusPressed: (BOOL)plusPressed minusPressed: (BOOL)minusPressed plusEnabled: (BOOL)plusEnabled minusEnabled: (BOOL)minusEnabled
{
	//// BRStyle Declarations
	BRUIStyleControlSettings *highlightedSettings = [self uiStyleForState:(self.state | UIControlStateHighlighted)].controls;
	BRUIStyleControlSettings *disabledSettings = [self uiStyleForState:(self.state | UIControlStateDisabled)].controls;
	BRUIStyleControlSettings *controlSettings = [self uiStyleForState:self.state].controls;
	BRUIStyleControlSettings *notHighlightedSettings = [self uiStyleForState:(self.state & ~UIControlStateHighlighted)].controls;

	const CGFloat stepButtonWidth = self.stepButtonSize.width;

	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = controlSettings.borderColor;
	UIColor* labelEnabledColor = controlSettings.actionColor;
	UIColor* labelDisabledColor = disabledSettings.actionColor;
	UIColor *notHighlightedLabelColor = notHighlightedSettings.actionColor;
	UIColor* fillColor = controlSettings.fillColor;
	UIColor* highlightedFillColor = highlightedSettings.fillColor;
	UIColor* glossColor = controlSettings.glossColor;
	UIColor* pressedShadowColor = highlightedSettings.shadowColor;

	//// Shadow Declarations
	NSShadow* glossShadow = [[NSShadow alloc] init];
	[glossShadow setShadowColor: glossColor];
	[glossShadow setShadowOffset: CGSizeMake(0.1, 1.1)];
	[glossShadow setShadowBlurRadius: 0];
	NSShadow* depressedShadow = [[NSShadow alloc] init];
	[depressedShadow setShadowColor: pressedShadowColor];
	[depressedShadow setShadowOffset: CGSizeMake(0.1, 2.1)];
	[depressedShadow setShadowBlurRadius: 2];
	
	//// Variable Declarations
	UIColor* plusColor = !plusEnabled ? labelDisabledColor : plusPressed ? labelEnabledColor : notHighlightedLabelColor;
	UIColor* minusColor = !minusEnabled ? labelDisabledColor : minusPressed ? labelEnabledColor : notHighlightedLabelColor;
	
	
	//// Subframes
	CGRect minusFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), stepButtonWidth, CGRectGetHeight(frame));
	CGRect plusFrame = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - stepButtonWidth, CGRectGetMinY(frame), stepButtonWidth, CGRectGetHeight(frame));
	CGRect plus = CGRectMake(CGRectGetMinX(plusFrame) + floor((CGRectGetWidth(plusFrame) - 12) * 0.46154 + 0.5), CGRectGetMinY(plusFrame) + floor((CGRectGetHeight(plusFrame) - 12) * 0.50000 + 0.5), 12, 12);
	
	
	//// Rounded Rectangle Drawing
	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
	[roundedRectanglePath moveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 6.61, CGRectGetMinY(minusFrame) + 0.5)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 6.61, CGRectGetMinY(plusFrame) + 0.5)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 3.18, CGRectGetMinY(plusFrame) + 0.76) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 4.85, CGRectGetMinY(plusFrame) + 0.5) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 3.97, CGRectGetMinY(plusFrame) + 0.5)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 3.03, CGRectGetMinY(plusFrame) + 0.8)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.8, CGRectGetMinY(plusFrame) + 3.03) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 1.99, CGRectGetMinY(plusFrame) + 1.18) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 1.18, CGRectGetMinY(plusFrame) + 1.99)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMinY(plusFrame) + 6.61) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMinY(plusFrame) + 3.97) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMinY(plusFrame) + 4.85)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMaxY(plusFrame) - 7.61)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.76, CGRectGetMaxY(plusFrame) - 4.18) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMaxY(plusFrame) - 5.85) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMaxY(plusFrame) - 4.97)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.8, CGRectGetMaxY(plusFrame) - 4.03)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 3.03, CGRectGetMaxY(plusFrame) - 1.8) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 1.18, CGRectGetMaxY(plusFrame) - 2.99) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 1.99, CGRectGetMaxY(plusFrame) - 2.18)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 6.61, CGRectGetMaxY(plusFrame) - 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 3.97, CGRectGetMaxY(plusFrame) - 1.5) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 4.85, CGRectGetMaxY(plusFrame) - 1.5)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 6.61, CGRectGetMaxY(minusFrame) - 1.5)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 3.18, CGRectGetMaxY(minusFrame) - 1.76) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 4.85, CGRectGetMaxY(minusFrame) - 1.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 3.97, CGRectGetMaxY(minusFrame) - 1.5)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 3.03, CGRectGetMaxY(minusFrame) - 1.8)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.8, CGRectGetMaxY(minusFrame) - 4.03) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 1.99, CGRectGetMaxY(minusFrame) - 2.18) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 1.18, CGRectGetMaxY(minusFrame) - 2.99)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMaxY(minusFrame) - 7.61) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMaxY(minusFrame) - 4.97) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMaxY(minusFrame) - 5.85)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 6.61)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.76, CGRectGetMinY(minusFrame) + 3.18) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.85) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 3.97)];
	[roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.8, CGRectGetMinY(minusFrame) + 3.03)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 3.03, CGRectGetMinY(minusFrame) + 0.8) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 1.18, CGRectGetMinY(minusFrame) + 1.99) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 1.99, CGRectGetMinY(minusFrame) + 1.18)];
	[roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 6.61, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 3.97, CGRectGetMinY(minusFrame) + 0.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 4.85, CGRectGetMinY(minusFrame) + 0.5)];
	[roundedRectanglePath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, glossShadow.shadowOffset, glossShadow.shadowBlurRadius, [glossShadow.shadowColor CGColor]);
	[strokeColor setStroke];
	roundedRectanglePath.lineWidth = 1;
	[roundedRectanglePath stroke];
	[fillColor setFill];
	[roundedRectanglePath fill];
	CGContextRestoreGState(context);
	
	
	//// Minus rule Drawing
	UIBezierPath* minusRulePath = [UIBezierPath bezierPath];
	[minusRulePath moveToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusRulePath addLineToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMaxY(minusFrame) - 1.5)];
	[minusRulePath addLineToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusRulePath closePath];
	[strokeColor setStroke];
	minusRulePath.lineWidth = 1;
	[minusRulePath stroke];
	
	
	if (plusPressed)
	{
		//// Plus tab Drawing
		UIBezierPath* plusTabPath = [UIBezierPath bezierPath];
		[plusTabPath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMaxY(plusFrame) - 1.5)];
		[plusTabPath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 4.5, CGRectGetMaxY(plusFrame) - 1.5)];
		[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMaxY(plusFrame) - 5.66) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 2.29, CGRectGetMaxY(plusFrame) - 1.5) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMaxY(plusFrame) - 3.36)];
		[plusTabPath addLineToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMinY(plusFrame) + 4.66)];
		[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMaxX(plusFrame) - 4.5, CGRectGetMinY(plusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMaxX(plusFrame) - 0.5, CGRectGetMinY(plusFrame) + 2.36) controlPoint2: CGPointMake(CGRectGetMaxX(plusFrame) - 2.29, CGRectGetMinY(plusFrame) + 0.5)];
		[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
		[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMaxY(plusFrame) - 1.5)];
		[plusTabPath closePath];
		[highlightedFillColor setFill];
		[plusTabPath fill];
		
		////// Plus tab Inner Shadow
		CGContextSaveGState(context);
		UIRectClip(plusTabPath.bounds);
		CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
		
		CGContextSetAlpha(context, CGColorGetAlpha([depressedShadow.shadowColor CGColor]));
		CGContextBeginTransparencyLayer(context, NULL);
		{
			UIColor* opaqueShadow = [depressedShadow.shadowColor colorWithAlphaComponent: 1];
			CGContextSetShadowWithColor(context, depressedShadow.shadowOffset, depressedShadow.shadowBlurRadius, [opaqueShadow CGColor]);
			CGContextSetBlendMode(context, kCGBlendModeSourceOut);
			CGContextBeginTransparencyLayer(context, NULL);
			
			[opaqueShadow setFill];
			[plusTabPath fill];
			
			CGContextEndTransparencyLayer(context);
		}
		CGContextEndTransparencyLayer(context);
		CGContextRestoreGState(context);
		
		[strokeColor setStroke];
		plusTabPath.lineWidth = 1;
		[plusTabPath stroke];
	}
	
	
	//// Plus
	{
		//// Plus V Drawing
		UIBezierPath* plusVPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plus) + 5, CGRectGetMinY(plus), 2, 12)];
		[plusColor setFill];
		[plusVPath fill];
		
		
		//// Plus H Drawing
		UIBezierPath* plusHPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plus), CGRectGetMinY(plus) + 5, 12, 2)];
		[plusColor setFill];
		[plusHPath fill];
	}
	
	
	//// Plus rule Drawing
	UIBezierPath* plusRulePath = [UIBezierPath bezierPath];
	[plusRulePath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusRulePath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMaxY(plusFrame) - 1.5)];
	[plusRulePath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusRulePath closePath];
	[strokeColor setStroke];
	plusRulePath.lineWidth = 1;
	[plusRulePath stroke];
	
	
	if (minusPressed)
	{
		//// Minus tab Drawing
		UIBezierPath* minusTabPath = [UIBezierPath bezierPath];
		[minusTabPath moveToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMaxY(minusFrame) - 1.5)];
		[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMaxY(minusFrame) - 1.5)];
		[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMaxY(minusFrame) - 5.66) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMaxY(minusFrame) - 1.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMaxY(minusFrame) - 3.36)];
		[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.66)];
		[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 2.36) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 0.5)];
		[minusTabPath addLineToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMinY(minusFrame) + 0.5)];
		[minusTabPath addLineToPoint: CGPointMake(CGRectGetMaxX(minusFrame) - 0.5, CGRectGetMaxY(minusFrame) - 1.5)];
		[minusTabPath closePath];
		[highlightedFillColor setFill];
		[minusTabPath fill];
		
		////// Minus tab Inner Shadow
		CGContextSaveGState(context);
		UIRectClip(minusTabPath.bounds);
		CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
		
		CGContextSetAlpha(context, CGColorGetAlpha([depressedShadow.shadowColor CGColor]));
		CGContextBeginTransparencyLayer(context, NULL);
		{
			UIColor* opaqueShadow = [depressedShadow.shadowColor colorWithAlphaComponent: 1];
			CGContextSetShadowWithColor(context, depressedShadow.shadowOffset, depressedShadow.shadowBlurRadius, [opaqueShadow CGColor]);
			CGContextSetBlendMode(context, kCGBlendModeSourceOut);
			CGContextBeginTransparencyLayer(context, NULL);
			
			[opaqueShadow setFill];
			[minusTabPath fill];
			
			CGContextEndTransparencyLayer(context);
		}
		CGContextEndTransparencyLayer(context);
		CGContextRestoreGState(context);
		
		[strokeColor setStroke];
		minusTabPath.lineWidth = 1;
		[minusTabPath stroke];
	}
	
	
	//// Minus Drawing
	UIBezierPath* minusPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(minusFrame) + floor((CGRectGetWidth(minusFrame) - 12) * 0.53846 + 0.5), CGRectGetMinY(minusFrame) + floor((CGRectGetHeight(minusFrame) - 2) * 0.50000 + 0.5), 12, 2)];
	[minusColor setFill];
	[minusPath fill];
}

@end
