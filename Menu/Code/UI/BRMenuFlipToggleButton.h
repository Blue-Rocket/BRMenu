//
//  BRMenuFlipToggleButton.h
//  MenuKit
//
//  Created by Matt on 4/16/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

/**
 A button type control that flips between two images when tapped.
 */
IB_DESIGNABLE
@interface BRMenuFlipToggleButton : UIControl <BRMenuUIStylish>

/** The name of the image resource to use for the front image. PDF images may be specified. */
@property (nonatomic, copy) IBInspectable NSString *frontImageName;

/** The name of the image resource to use for the back (flipped) image. PDF images may be specified. */
@property (nonatomic, copy) IBInspectable NSString *backImageName;

/** A size to display the configured images at, which can differ from the size of this view. */
@property (nonatomic, assign) IBInspectable CGSize iconSize;

@property (nonatomic, getter = isFlipped) IBInspectable BOOL flipped;

- (id)initWithIconSize:(CGSize)iconSize;

- (void)setFlipped:(BOOL)flipped animated:(BOOL)animated;

@end
