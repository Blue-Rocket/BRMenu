//
//  BRMenuFilledToggleButton.h
//  Menu
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRMenuUIStyle;

IB_DESIGNABLE
@interface BRMenuFilledToggleButton : UIControl

@property (nonatomic, strong) IBOutlet BRMenuUIStyle *uiStyle;

@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable CGFloat diameter;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat aspectRatio;
@property (nonatomic) IBInspectable NSTimeInterval animationDuration;

- (void)animateToNextMode;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

@interface BRMenuFilledToggleButton (ImplementationSupport)

/**
 Update the state based on becoming selected. This method is called from the setSelected:animated: method.
 
 @param aniamted YES if should animate any state changes.
 */
- (void)didBecomeSelectedWithAnimation:(BOOL)animated;

/**
 Lay out the given fill layer for the appropriate state. This method is called from the layoutSubviews method.
 
 @param fill A layer that represents the fill for this button.
 @param shape A layer that represents the shape for this button.
 */
- (void)layoutFillLayer:(CALayer *)fill inShapeLayer:(CALayer *)shape;

@end