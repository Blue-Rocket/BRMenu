//
//  BRMenuItemComponentCell.h
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemObjectCell.h"

@class BRMenuItemComponent;
@class BRMenuLeftRightPlacementButton;
@class BRMenuLightHeavyQuantityButton;
@class BRMenuOrderItemComponent;

@interface BRMenuItemComponentCell : BRMenuItemObjectCell

@property (nonatomic, strong) BRMenuItemComponent *component;

@property (nonatomic, strong) IBOutlet BRMenuLeftRightPlacementButton *placementButton;
@property (nonatomic, strong) IBOutlet BRMenuLightHeavyQuantityButton *quantityButton;

/**
 Configure the cell for a given order item component.
 
 @param orderCompoent The order component to configure the receiver with.
 */
- (void)configureForOrderItemComponent:(BRMenuOrderItemComponent *)orderComponent;

@end
