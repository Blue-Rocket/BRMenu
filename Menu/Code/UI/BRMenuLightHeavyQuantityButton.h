//
//  BRMenuLightHeavyQuantityButton.h
//  MenuKit
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFilledToggleButton.h"

#import "BRMenuOrderItemComponent.h"

IB_DESIGNABLE
@interface BRMenuLightHeavyQuantityButton : BRMenuFilledToggleButton

@property (nonatomic) BRMenuOrderItemComponentQuantity quantity;

- (void)setQuantity:(BRMenuOrderItemComponentQuantity)value animated:(const BOOL)animated;

@end
