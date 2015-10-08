//
//  BRMenuLeftRightPlacementButton.h
//  AndFramework
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFilledToggleButton.h"

#import "BRMenuOrderItemComponent.h"

@interface BRMenuLeftRightPlacementButton : BRMenuFilledToggleButton

@property (nonatomic) BRMenuOrderItemComponentPlacement placement;

- (void)setPlacement:(BRMenuOrderItemComponentPlacement)value animated:(const BOOL)animated;

@end
