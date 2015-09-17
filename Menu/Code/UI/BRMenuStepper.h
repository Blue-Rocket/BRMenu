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

@interface BRMenuStepper : UIControl <BRUIStylish>

@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger minimumValue;
@property (nonatomic) NSInteger maximumValue;
@property (nonatomic) NSInteger stepValue;

@end
