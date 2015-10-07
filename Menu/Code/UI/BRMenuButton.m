//
//  BRMenuButton.m
//  Menu
//
//  Created by Matt on 1/10/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuButton.h"

#import <BRLocalize/Core.h>
#import <BRStyle/BRUIStylishHost.h>
#import <Masonry/Masonry.h>
#import "UIControl+BRMenu.h"
#import "UIView+BRUIStyle.h"

static const CGFloat kNormalHeight = 32.0f;
static const CGFloat kCompactHeight = 26.0f;
static const CGFloat kTextMargins = 10.0f;
static const CGFloat kTextVerticalMargins = 4.0f;
static const CGFloat kBadgeTextMargins = 5.0f;
static const CGFloat kBadgeMinWidth = 24.0f;
static const CGFloat kMinWidth = 48.0f;

@interface BRMenuButton () <BRUIStylishHost>

@end

@implementation BRMenuButton {
	MASConstraint *badgeWidthConstraint;
	UILabel *badgeLabel;

}

@dynamic destructive;
@dynamic uiStyle;
@synthesize badgeText, title, inverse;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		self.opaque = NO;
		self.title = @"";
		self.backgroundColor = [UIColor clearColor];
		self.adjustsImageWhenDisabled = NO;
		self.adjustsImageWhenHighlighted = NO;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithTitle:@""];
}

- (id)initWithTitle:(NSString *)text {
	if ( (self = [super initWithFrame:CGRectZero]) ) {
		self.title = text;
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.adjustsImageWhenDisabled = NO;
		self.adjustsImageWhenHighlighted = NO;
	}
	return self;
}

- (void)localizeWithAppStrings:(NSDictionary *)strings {
	self.title = [self.title localizedStringWithAppStrings:strings];
	self.badgeText = [self.badgeText localizedStringWithAppStrings:strings];
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	self.titleLabel.font = self.uiStyle.fonts.actionFont;
	[self refreshTitleColor:style];
	badgeLabel.font = self.titleLabel.font;
	[self refreshBadgeColor:style];
	[self invalidateIntrinsicContentSize];
	[self setNeedsDisplay];
}

- (void)refreshTitleColor:(BRUIStyle *)style {
	// the disabled/selected states are not respected by UIButton, so we have to set the Normal state always
	BRUIStyleControlStateColorSettings *controlSettings = (inverse
														   ? self.uiStyle.colors.inverseControlSettings
														   : self.uiStyle.colors.controlSettings);
	BRUIStyleControlColorSettings *controlColors = (self.enabled == NO
													? controlSettings.disabledColorSettings
													: self.destructive
													? controlSettings.dangerousColorSettings
													: self.selected
													? controlSettings.selectedColorSettings
													: self.highlighted
													? controlSettings.highlightedColorSettings
													: controlSettings.normalColorSettings
													);
	[self setTitleColor:controlColors.actionColor forState:UIControlStateNormal];
}

- (void)refreshBadgeColor:(BRUIStyle *)style {
	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	BRUIStyleControlColorSettings *controlColors = (self.enabled == NO
													? controlSettings.disabledColorSettings
													: self.destructive
													? controlSettings.dangerousColorSettings
													: controlSettings.selectedColorSettings);
	badgeLabel.textColor = controlColors.actionColor;
}

- (void)controlStateDidChange:(UIControlState)state {
	[self refreshTitleColor:self.uiStyle];
	[self refreshBadgeColor:self.uiStyle];
	[self setNeedsDisplay];
}

- (void)setTitle:(NSString *)text {
	if ( title != text ) {
		title = text;
		[self setTitle:text forState:UIControlStateNormal];
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
}

- (void)setInverse:(BOOL)value {
	if ( value != inverse ) {
		inverse = value;
		[self refreshTitleColor:self.uiStyle];
		[self refreshBadgeColor:self.uiStyle];
		[self setNeedsDisplay];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self refreshTitleColor:self.uiStyle];
		[self refreshBadgeColor:self.uiStyle];
		[self setNeedsDisplay];
	}
}

- (void)setEnabled:(BOOL)enabled {
	BOOL old = self.enabled;
	[super setEnabled:enabled];
	if ( old != enabled ) {
		[self refreshTitleColor:self.uiStyle];
		[self refreshBadgeColor:self.uiStyle];
		[self setNeedsDisplay];
	}
}

- (void)setSelected:(BOOL)enabled {
	BOOL old = self.selected;
	[super setSelected:enabled];
	if ( old != enabled ) {
		[self refreshTitleColor:self.uiStyle];
		[self refreshBadgeColor:self.uiStyle];
		[self setNeedsDisplay];
	}
}

- (void)setBadgeText:(NSString *)text {
	if ( badgeText != text ) {
		badgeText = text;
		if ( text && !badgeLabel ) {
			UILabel *l = [[UILabel alloc] initWithFrame:CGRectZero];
			l.textAlignment = NSTextAlignmentCenter;
			[l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
			[self addSubview:l];
			[l mas_makeConstraints:^(MASConstraintMaker *make) {
				make.right.equalTo(self);
				make.centerY.equalTo(self);
				badgeWidthConstraint = make.width.offset(0);
			}];
			badgeLabel = l;
			[self uiStyleDidChange:self.uiStyle];
		}
		badgeLabel.text = text;
		[badgeLabel layoutIfNeeded];
		[self setNeedsUpdateConstraints];
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
}

#pragma mark - Layout

- (void)updateConstraints {
	if ( badgeWidthConstraint ) {
		badgeWidthConstraint.offset(MAX(kBadgeMinWidth, [self badgeFrameWidthForMaxHeight:CGFLOAT_MAX]));
	}
	[super updateConstraints];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
	CGRect result = [super titleRectForContentRect:contentRect];
	// adjust for badge
	CGFloat badgeWidth = [self badgeFrameWidthForMaxHeight:self.bounds.size.height];
	result.origin.x -= badgeWidth / 2;
	return result;
}

- (CGFloat)badgeFrameWidthForMaxHeight:(const CGFloat)maxHeight {
	CGFloat width = 0.0;
	if ( [badgeText length] > 0 ) {
		CGSize badgeTextSize = [badgeText sizeWithFont:self.uiStyle.fonts.actionFont
									 constrainedToSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
										 lineBreakMode:NSLineBreakByWordWrapping];
		
		// if the badge text is only a number, use the (tighter) kBadgeTextMargin, otherwise use the (more generous) kTextMargin
		BOOL hasNonNumeric = [badgeText rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound;
		CGFloat badgeWidth = ceilf(badgeTextSize.width) + 2 * (hasNonNumeric ? kTextMargins : kBadgeTextMargins);
		
		width = MAX(kBadgeMinWidth, badgeWidth);
	}
	return width;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
	UIFont *font = self.uiStyle.fonts.actionFont;
	CGFloat height = MAX(kNormalHeight, font.lineHeight + kTextVerticalMargins * 2);
	CGSize textSize = [title sizeWithFont:self.uiStyle.fonts.actionFont
						constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
							lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat width = ceilf(textSize.width) + 2 * kTextMargins;
	width += [self badgeFrameWidthForMaxHeight:height];
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

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	// TODO: cache drawing into stretchable image
	[self drawBadgeButtonWithButtonRect:self.bounds badgeWidth:badgeLabel.bounds.size.width pressed:self.highlighted];
}

- (void)drawBadgeButtonWithButtonRect: (CGRect)buttonRect badgeWidth: (CGFloat)badgeWidth pressed: (BOOL)pressed
{
	//// BRStyle Declarations
	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	BRUIStyleControlColorSettings *colorSettings = (pressed ? controlSettings.highlightedColorSettings : controlSettings.normalColorSettings);

	BRUIStyleControlColorSettings *controlColors = (self.selected
													? controlSettings.selectedColorSettings
													: self.enabled == NO
													? controlSettings.disabledColorSettings
													: pressed
													? controlSettings.highlightedColorSettings
													: self.destructive
													? controlSettings.dangerousColorSettings
													: controlSettings.normalColorSettings
													);
	
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (self.destructive ? controlSettings.dangerousColorSettings.borderColor : controlColors.borderColor);
	UIColor* separatorColor = [strokeColor colorWithAlphaComponent: 0.8];
	UIColor* pressedSeparatorColor = [separatorColor colorWithAlphaComponent: 0.4];
	UIColor* fillColor = (self.fillColor ? self.fillColor : pressed ? controlSettings.highlightedColorSettings.fillColor : controlColors.fillColor);
	UIColor* strokeShadowColor = colorSettings.glossColor;
	UIColor* pressedShadowColor = controlSettings.highlightedColorSettings.shadowColor;
	
	//// Shadow Declarations
	NSShadow* glossShadow = [[NSShadow alloc] init];
	[glossShadow setShadowColor: strokeShadowColor];
	[glossShadow setShadowOffset: CGSizeMake(0.1, 1.1)];
	[glossShadow setShadowBlurRadius: 0];
	NSShadow* depressedShadow = [[NSShadow alloc] init];
	[depressedShadow setShadowColor: pressedShadowColor];
	[depressedShadow setShadowOffset: CGSizeMake(0.1, 2.1)];
	[depressedShadow setShadowBlurRadius: 2];
	
	//// Variable Declarations
	BOOL showBadge = badgeWidth > 0;
	CGRect badgeRect = CGRectMake(buttonRect.origin.x + buttonRect.size.width - badgeWidth, buttonRect.origin.y, badgeWidth, buttonRect.size.height - 1);
	BOOL notPressed = !pressed;
	UIColor* badgeSeparatorColor = pressed ? pressedSeparatorColor : separatorColor;
	
	//// Frames
	CGRect badgeFrame = CGRectMake(badgeRect.origin.x, badgeRect.origin.y, badgeRect.size.width, badgeRect.size.height);
	CGRect frame = CGRectMake(buttonRect.origin.x, buttonRect.origin.y, buttonRect.size.width, buttonRect.size.height);
	
	
	if (pressed)
	{
		//// Border Pressed Drawing
		UIBezierPath* borderPressedPath = [UIBezierPath bezierPath];
		[borderPressedPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 4.5)];
		[borderPressedPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMaxY(frame) - 1.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 2.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1.84, CGRectGetMaxY(frame) - 1.5)];
		[borderPressedPath addLineToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 3.5, CGRectGetMaxY(badgeFrame) - 0.5)];
		[borderPressedPath addCurveToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMaxY(badgeFrame) - 3.5) controlPoint1: CGPointMake(CGRectGetMaxX(badgeFrame) - 1.84, CGRectGetMaxY(badgeFrame) - 0.5) controlPoint2: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMaxY(badgeFrame) - 1.84)];
		[borderPressedPath addLineToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMinY(badgeFrame) + 4.5)];
		[borderPressedPath addCurveToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 3.5, CGRectGetMinY(badgeFrame) + 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMinY(badgeFrame) + 2.84) controlPoint2: CGPointMake(CGRectGetMaxX(badgeFrame) - 1.84, CGRectGetMinY(badgeFrame) + 1.5)];
		[borderPressedPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 1.5)];
		[borderPressedPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 4.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1.84, CGRectGetMinY(frame) + 1.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 2.84)];
		[borderPressedPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 4.5)];
		[borderPressedPath closePath];
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
		UIBezierPath* borderPath = [UIBezierPath bezierPath];
		[borderPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 4.6)];
		[borderPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMaxY(frame) - 1.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 2.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1.84, CGRectGetMaxY(frame) - 1.5)];
		[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 3.5, CGRectGetMaxY(badgeFrame) - 0.5)];
		[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMaxY(badgeFrame) - 3.6) controlPoint1: CGPointMake(CGRectGetMaxX(badgeFrame) - 1.84, CGRectGetMaxY(badgeFrame) - 0.5) controlPoint2: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMaxY(badgeFrame) - 1.89)];
		[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMinY(badgeFrame) + 4.5)];
		[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(badgeFrame) - 3.5, CGRectGetMinY(badgeFrame) + 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(badgeFrame) - 0.5, CGRectGetMinY(badgeFrame) + 2.79) controlPoint2: CGPointMake(CGRectGetMaxX(badgeFrame) - 1.84, CGRectGetMinY(badgeFrame) + 1.5)];
		[borderPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 1.5)];
		[borderPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 4.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1.84, CGRectGetMinY(frame) + 1.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 2.89)];
		[borderPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame) - 4.6)];
		[borderPath closePath];
		[fillColor setFill];
		[borderPath fill];
		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, glossShadow.shadowOffset, glossShadow.shadowBlurRadius, [glossShadow.shadowColor CGColor]);
		[strokeColor setStroke];
		borderPath.lineWidth = 1;
		[borderPath stroke];
		CGContextRestoreGState(context);
	}
	
	
	if (showBadge)
	{
		//// Separator Drawing
		UIBezierPath* separatorPath = [UIBezierPath bezierPath];
		[separatorPath moveToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMinY(badgeFrame) + 1.5)];
		[separatorPath addLineToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMaxY(badgeFrame) - 0.5)];
		[separatorPath addLineToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMinY(badgeFrame) + 1.5)];
		[separatorPath closePath];
		[badgeSeparatorColor setStroke];
		separatorPath.lineWidth = 1;
		[separatorPath stroke];
	}
}

@end
