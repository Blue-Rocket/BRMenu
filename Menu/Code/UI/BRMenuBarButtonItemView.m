//
//  BRMenuBarButtonItemView.m
//  MenuKit
//
//  Created by Matt on 4/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuBarButtonItemView.h"

#import <BRLocalize/Core.h>
#import <BRStyle/BRUIStylishHost.h>
#import "UIControl+BRMenu.h"
#import "UIView+BRUIStyle.h"

static const CGFloat kNormalHeight = 32.0f;
static const CGFloat kCompactHeight = 26.0f;
static const CGFloat kTextMargins = 10.0f;
static const CGFloat kBadgeTextMargins = 5.0f;
static const CGFloat kBadgeMinWidth = 24.0f;
static const CGFloat kMinWidth = 48.0f;

@interface BRMenuBarButtonItemView () <BRUIStylishHost>
@end

@implementation BRMenuBarButtonItemView {
	NSString *title;
	NSString *badgeText;
	BOOL inverse;
}

@dynamic destructive;
@dynamic uiStyle;
@synthesize badgeText, title, inverse;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		self.opaque = NO;
		self.title = @"";
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithTitle:@""];
}

- (id)initWithTitle:(NSString *)text {
	if ( (self = [super initWithFrame:CGRectZero]) ) {
		self.title = text;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	}
	return self;
}

- (void)localizeWithAppStrings:(NSDictionary *)strings {
	self.title = [self.title localizedStringWithAppStrings:strings];
	self.badgeText = [self.badgeText localizedStringWithAppStrings:strings];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
	CGSize textSize = [title sizeWithFont:self.uiStyle.fonts.actionFont
						constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
							lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat width = ceilf(textSize.width) + 2 * kTextMargins;
	width += [self badgeFrameWidth];
	width = MAX(kMinWidth, width);
	if ( (int)width % 2 == 1 ) {
		width += 1;
	}
	return CGSizeMake(width, (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact
							  ? kCompactHeight : kNormalHeight));
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];
	if ( self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ) {
		UIView *barView = nil;
		// if we're in a nav bar or tool bar, size ourselves according to our vertical size class
		if ( (barView = [self nearestAncestorViewOfType:[UINavigationBar class]]) != nil || (barView = [self nearestAncestorViewOfType:[UIToolbar class]]) != nil ) {
			CGSize s = [self intrinsicContentSize];
			CGRect b = self.bounds;
			b.origin.y = 0;
			b.size.height = s.height;
			self.bounds = b;
			[self setNeedsDisplay];
		}
	}
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self invalidateIntrinsicContentSize];
	[self setNeedsDisplay];
}

- (void)controlStateDidChange:(UIControlState)state {
	[self setNeedsDisplay];
}

- (void)setTitle:(NSString *)text {
	if ( title != text ) {
		title = text;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
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

- (void)setBadgeText:(NSString *)text {
	if ( badgeText != text ) {
		badgeText = text;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const BOOL destructive = self.destructive;
	
	BRUIStyleControlStateColorSettings *controlStateColors = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	BRMutableUIStyleControlColorSettings *controlColors = controlStateColors.highlightedColorSettings;
	
	//// Color Declarations
	UIColor* strokeColor = (destructive ? controlStateColors.dangerousColorSettings.borderColor : controlColors.borderColor);
	UIColor* labelColor = (destructive ? controlStateColors.dangerousColorSettings.actionColor : controlColors.actionColor);
	UIColor* insetShadowColor = controlColors.shadowColor;
	UIColor* highlightedFill = controlColors.fillColor;
	UIColor* fillColor = (self.fillColor ? self.fillColor : controlColors.fillColor);
	
	//// Shadow Declarations
	UIColor* innerShadow = insetShadowColor;
	CGSize innerShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat innerShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = self.bounds;
	
	
	//// Abstracted Attributes
	NSString* textContent = self.title;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	if ( fillColor != nil ) {
		[fillColor setFill];
		[borderPath fill];
	}
	[highlightedFill setFill];
	[borderPath fill];
	
	////// Border Inner Shadow
	CGRect borderBorderRect = CGRectInset([borderPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
	borderBorderRect = CGRectOffset(borderBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
	borderBorderRect = CGRectInset(CGRectUnion(borderBorderRect, [borderPath bounds]), -1, -1);
	
	UIBezierPath* borderNegativePath = [UIBezierPath bezierPathWithRect: borderBorderRect];
	[borderNegativePath appendPath: borderPath];
	borderNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = innerShadowOffset.width + round(borderBorderRect.size.width);
		CGFloat yOffset = innerShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									innerShadowBlurRadius,
									innerShadow.CGColor);
		
		[borderPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderBorderRect.size.width), 0);
		[borderNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[borderNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	
	[self drawLabel:textContent inFrame:frame withFont:self.uiStyle.fonts.actionFont color:labelColor];
}

- (CGFloat)badgeFrameWidth {
	CGFloat width = 0.0;
	if ( [badgeText length] > 0 ) {
		CGSize badgeTextSize = [badgeText sizeWithFont:self.uiStyle.fonts.actionFont
									 constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
										 lineBreakMode:NSLineBreakByWordWrapping];

		// if the badge text is only a number, use the (tighter) kBadgeTextMargin, otherwise use the (more generous) kTextMargin
		BOOL hasNonNumeric = [badgeText rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound;
		CGFloat badgeWidth = ceilf(badgeTextSize.width) + 2 * (hasNonNumeric ? kTextMargins : kBadgeTextMargins);
		
		width = MAX(kBadgeMinWidth, badgeWidth);
	}
	return width;
}

- (void)drawHighlightedWithBadge {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();

	const BOOL destructive = self.destructive;
	
	BRUIStyleControlStateColorSettings *controlStateColors = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	BRMutableUIStyleControlColorSettings *controlColors = controlStateColors.highlightedColorSettings;

	//// Color Declarations
	UIColor* strokeColor = (destructive ? controlStateColors.dangerousColorSettings.borderColor : controlColors.borderColor);
	UIColor* labelColor = (destructive ? controlStateColors.dangerousColorSettings.actionColor : controlColors.actionColor);
	UIColor* insetShadowColor = controlColors.shadowColor;
	UIColor* highlightedFill = controlColors.fillColor;
	UIColor* fillColor = (self.fillColor ? self.fillColor : controlColors.fillColor);

	UIColor* separatorColor = (inverse ? strokeColor  : [strokeColor colorWithAlphaComponent:0.5]);
	UIColor* badgeColor = (inverse
						   ? controlColors.actionColor
						   : self.uiStyle.colors.primaryColor);
	
	//// Shadow Declarations
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	const CGFloat badgeWidth = [self badgeFrameWidth];
	CGRect badgeFrame = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) - badgeWidth), CGRectGetMinY(frame), badgeWidth, CGRectGetHeight(frame));
	CGRect buttonLabelRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - badgeWidth, CGRectGetHeight(frame));
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = self.uiStyle.fonts.actionFont;
	NSString* badgeLabelContent = self.badgeText;
	UIFont* badgeLabelFont = buttonLabelFont;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	if ( fillColor != nil ) {
		[fillColor setFill];
		[borderPath fill];
	}
	[highlightedFill setFill];
	[borderPath fill];
	
	////// Border Inner Shadow
	CGRect borderBorderRect = CGRectInset([borderPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	borderBorderRect = CGRectOffset(borderBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	borderBorderRect = CGRectInset(CGRectUnion(borderBorderRect, [borderPath bounds]), -1, -1);
	
	UIBezierPath* borderNegativePath = [UIBezierPath bezierPathWithRect: borderBorderRect];
	[borderNegativePath appendPath: borderPath];
	borderNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(borderBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[borderPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderBorderRect.size.width), 0);
		[borderNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[borderNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	
	
	//// Button Label Drawing
	[self drawLabel:buttonLabelContent inFrame:buttonLabelRect withFont:buttonLabelFont color:labelColor];
	
	//// Badge Label Drawing
	[self drawLabel:badgeLabelContent inFrame:badgeFrame withFont:badgeLabelFont color:badgeColor];
	
	//// Separator
	[self drawSeparatorWithBadgeFrame:badgeFrame color:separatorColor];
}

- (void)drawSeparatorWithBadgeFrame:(CGRect)badgeFrame color:(UIColor *)separatorColor {
	UIBezierPath* bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMinY(badgeFrame) + 1.5)];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMaxY(badgeFrame) - 1.5)];
	[separatorColor setStroke];
	bezierPath.lineWidth = 1;
	[bezierPath stroke];
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const BOOL destructive = self.destructive;
	
	BRUIStyleControlStateColorSettings *controlStateColors = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);

	BRMutableUIStyleControlColorSettings *controlColors = (self.selected
														   ? controlStateColors.selectedColorSettings
														   : self.enabled == NO
														   ? controlStateColors.disabledColorSettings
														   : destructive
														   ? controlStateColors.dangerousColorSettings
														   : controlStateColors.normalColorSettings);
	
	//// Color Declarations
	UIColor* strokeColor = controlColors.borderColor;
	UIColor* labelColor = controlColors.actionColor;
	UIColor* fillColor = (self.fillColor ? self.fillColor : controlColors.fillColor);
	
	//// Shadow Declarations
	UIColor* shadow = controlColors.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Abstracted Attributes
	NSString* textContent = self.title;
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	CGContextRestoreGState(context);
	if ( fillColor != nil ) {
		[fillColor setFill];
		[borderPath fill];
	}
	
	//// Text Drawing
	[self drawLabel:textContent inFrame:frame withFont:self.uiStyle.fonts.actionFont color:labelColor];
}

- (void)drawLabel:(NSString *)labelContent inFrame:(CGRect)frame withFont:(UIFont *)labelFont color:(UIColor *)labelColor {
	CGRect buttonLabelRect = CGRectIntegral(CGRectMake(CGRectGetMinX(frame) + 2,
													   CGRectGetMidY(frame) - (labelFont.ascender - labelFont.capHeight) - (labelFont.capHeight / 2.0),
													   CGRectGetWidth(frame) - 4,
													   labelFont.lineHeight));
	[labelColor setFill];
	[labelContent drawInRect: buttonLabelRect withFont: labelFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}



- (void)drawNormalWithBadge {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const BOOL destructive = self.destructive;
	const BOOL disabled = !self.enabled;

	BRUIStyleControlStateColorSettings *controlStateColors = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	
	BRMutableUIStyleControlColorSettings *controlColors = (self.selected
														   ? controlStateColors.selectedColorSettings
														   : self.enabled == NO
														   ? controlStateColors.disabledColorSettings
														   : destructive
														   ? controlStateColors.dangerousColorSettings
														   : controlStateColors.normalColorSettings);
	

	//// Color Declarations
	UIColor* strokeColor = controlColors.borderColor;
	UIColor* labelColor = controlColors.actionColor;
	UIColor* fillColor = (self.fillColor ? self.fillColor : controlColors.fillColor);
	UIColor* separatorColor = [strokeColor colorWithAlphaComponent: 0.8];
	UIColor* badgeColor = (disabled || inverse
						   ? controlColors.actionColor
						   : self.uiStyle.colors.primaryColor);
	
	//// Shadow Declarations
	UIColor* shadow = controlStateColors.normalColorSettings.glossColor;
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	const CGFloat badgeWidth = [self badgeFrameWidth];
	CGRect badgeFrame = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) - badgeWidth), CGRectGetMinY(frame), badgeWidth, CGRectGetHeight(frame));
	CGRect buttonLabelRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - badgeWidth, CGRectGetHeight(frame));
	
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = self.uiStyle.fonts.actionFont;
	NSString* badgeLabelContent = self.badgeText;
	UIFont* badgeLabelFont = buttonLabelFont;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	if ( fillColor != nil ) {
		[fillColor setFill];
		[borderPath fill];
	}
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	CGContextRestoreGState(context);
	
	
	//// Button Label Drawing
	[self drawLabel:buttonLabelContent inFrame:buttonLabelRect withFont:buttonLabelFont color:labelColor];
	
	//// Badge Label Drawing
	[self drawLabel:badgeLabelContent inFrame:badgeFrame withFont:badgeLabelFont color:badgeColor];
	
	//// Separator
	[self drawSeparatorWithBadgeFrame:badgeFrame color:separatorColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( [badgeText length] > 0 ) {
			[self drawHighlightedWithBadge];
		} else {
			[self drawHighlighted];
		}
	} else {
		if ( [badgeText length] > 0 ) {
			[self drawNormalWithBadge];
		} else {
			[self drawNormal];
		}
	}
}

@end
