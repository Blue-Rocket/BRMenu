//
//  BRMenuLightHeavyQuantityButton.h
//  Menu
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import "BRMenuFilledToggleButton.h"

#import "BRMenuOrderItemComponent.h"

IB_DESIGNABLE
@interface BRMenuLightHeavyQuantityButton : BRMenuFilledToggleButton

@property (nonatomic) BRMenuOrderItemComponentQuantity quantity;

- (void)setQuantity:(BRMenuOrderItemComponentQuantity)value animated:(const BOOL)animated;

@end
