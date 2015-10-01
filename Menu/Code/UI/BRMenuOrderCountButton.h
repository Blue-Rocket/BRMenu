//
//  BRMenuOrderCountBarButtonItemView.h
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuButton.h"

@class BRMenuOrder;

/**
 Specialized extension of @c BRMenuButton that displays the count of items in an order as the badge text value.
 */
@interface BRMenuOrderCountButton : BRMenuButton

/** The order to display the item count for. */
@property (nonatomic, strong) BRMenuOrder *order;

@end
