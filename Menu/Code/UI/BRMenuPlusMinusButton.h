//
//  BRMenuPlusMinusButton.h
//  Menu
//
//  Created by Matt on 4/17/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

IB_DESIGNABLE
@interface BRMenuPlusMinusButton : UIControl <BRMenuUIStylish>

@property (nonatomic, getter = isPlus) IBInspectable BOOL plus;

@end
