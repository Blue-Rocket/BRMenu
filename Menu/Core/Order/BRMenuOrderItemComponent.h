//
//  BRMenuOrderItemComponent.h
//  BRMenu
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

typedef enum {
	APOrderItemComponentPlacementWhole	= 0,
	APOrderItemComponentPlacementLeft	= 1,
	APOrderItemComponentPlacementRight	= 2,
} APOrderItemComponentPlacement;

typedef enum {
	APOrderItemComponentQuantityNormal	= 0,
	APOrderItemComponentQuantityLight	= 1,
	APOrderItemComponentQuantityHeavy	= 2,
} APOrderItemComponentQuantity;

@class BRMenuItemComponent;

@interface BRMenuOrderItemComponent : NSObject

@property (nonatomic, strong) BRMenuItemComponent *component;
@property (nonatomic) APOrderItemComponentPlacement placement;
@property (nonatomic) APOrderItemComponentQuantity quantity;
@property (nonatomic, readonly, getter = isLeftPlacement) BOOL leftPlacement;
@property (nonatomic, readonly, getter = isRightPlacement) BOOL rightPlacement;

// init with a component with Whole placement and Normal quantity
- (id)initWithComponent:(BRMenuItemComponent *)menuComponent;

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent
			  placement:(APOrderItemComponentPlacement)placement
			   quantity:(APOrderItemComponentQuantity)quantity;

@end
