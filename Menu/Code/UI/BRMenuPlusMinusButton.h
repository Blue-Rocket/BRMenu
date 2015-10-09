//
//  BRMenuPlusMinusButton.h
//  MenuKit
//
//  Created by Matt on 4/17/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIControl.h"
#import <BRStyle/BRUIStylish.h>

/**
 A simple plus or minus button.
 */
@interface BRMenuPlusMinusButton : UIControl <BRMenuUIControl, BRUIStylish>

/** Manage the BRUIStyleControlStateDangerous state flag. */
@property(nonatomic, getter=isDangerous) IBInspectable BOOL dangerous;

/** If @c YES then render the button as a plus, otherwise as a minus. */
@property (nonatomic, getter = isPlus) IBInspectable BOOL plus;

/** A width and height to visually render the buttons within. */
@property (nonatomic, assign) IBInspectable CGSize buttonSize UI_APPEARANCE_SELECTOR;

@end
