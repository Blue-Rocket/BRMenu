//
//  BRMenuStepper.h
//  Menu
//
//  Created by Matt on 4/12/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRMenuUIStyle;

@interface BRMenuStepper : UIControl

@property (nonatomic, strong) BRMenuUIStyle *uiStyle;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger minimumValue;
@property (nonatomic) NSInteger maximumValue;
@property (nonatomic) NSInteger stepValue;

@end
