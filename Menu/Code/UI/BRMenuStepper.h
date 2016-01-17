//
//  BRMenuStepper.h
//  MenuKit
//
//  Created by Matt on 4/12/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

/** A padding applied to the internal drawing of the control, so can be aligned to content if desired. */
extern const CGSize BRMenuStepperPadding;

/** The default maximum value. */
extern const NSInteger BRMenuStepperDefaultMaximumValue;

/**
 A button control that renders minus and plus icons and allows stepping a value up or down, like UIStepper.
 */
@interface BRMenuStepper : UIControl <BRUIStylish>

/** A width and height to visual render the plus and minus buttons within. */
@property (nonatomic, assign) IBInspectable CGSize stepButtonSize UI_APPEARANCE_SELECTOR;

/** The value to display. */
@property (nonatomic) NSInteger value;

/** The minimum allowed value. */
@property (nonatomic) NSInteger minimumValue;

/** The maximum allowed value. */
@property (nonatomic) NSInteger maximumValue;

/** The increment/decrement amount. */
@property (nonatomic) NSInteger stepValue;

@end
