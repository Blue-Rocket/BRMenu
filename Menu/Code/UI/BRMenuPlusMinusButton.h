//
//  BRMenuPlusMinusButton.h
//  Menu
//
//  Created by Matt on 4/17/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRMenuUIStyle;

@interface BRMenuPlusMinusButton : UIControl

@property (nonatomic, strong) BRMenuUIStyle *uiStyle;
@property (nonatomic, getter = isPlus) BOOL plus;

@end
