//
//  BRMenuOrderItemComponentDetailsView.h
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenuOrderItemComponent;

@interface BRMenuOrderItemComponentDetailsView : UIView <BRMenuUIStylish>

/** The order item component to display. */
@property (nonatomic, strong) BRMenuOrderItemComponent *orderItemComponent;

@end
