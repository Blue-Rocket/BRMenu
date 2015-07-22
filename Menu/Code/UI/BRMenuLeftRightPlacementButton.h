//
//  BRMenuLeftRightPlacementButton.h
//  AndFramework
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuOrderItemComponent.h"

@class BRMenuUIStyle;

IB_DESIGNABLE
@interface BRMenuLeftRightPlacementButton : UIControl

@property (nonatomic, strong) IBOutlet BRMenuUIStyle *uiStyle;

@property (nonatomic) BRMenuOrderItemComponentPlacement placement;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable CGFloat diameter;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat aspectRatio;
@property (nonatomic) IBInspectable NSTimeInterval animationDuration;

- (void)animateToNextPlacementMode;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
