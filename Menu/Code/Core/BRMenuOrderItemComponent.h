//
//  BRMenuOrderItemComponent.h
//  MenuKit
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

typedef enum {
	BRMenuOrderItemComponentPlacementWhole	= 0,
	BRMenuOrderItemComponentPlacementLeft	= 1,
	BRMenuOrderItemComponentPlacementRight	= 2,
} BRMenuOrderItemComponentPlacement;

typedef enum {
	BRMenuOrderItemComponentQuantityNormal	= 0,
	BRMenuOrderItemComponentQuantityLight	= 1,
	BRMenuOrderItemComponentQuantityHeavy	= 2,
} BRMenuOrderItemComponentQuantity;

@class BRMenuItemComponent;

@interface BRMenuOrderItemComponent : NSObject <NSSecureCoding>

@property (nonatomic, strong) BRMenuItemComponent *component;
@property (nonatomic) BRMenuOrderItemComponentPlacement placement;
@property (nonatomic) BRMenuOrderItemComponentQuantity quantity;
@property (nonatomic, readonly, getter = isLeftPlacement) BOOL leftPlacement;
@property (nonatomic, readonly, getter = isRightPlacement) BOOL rightPlacement;

// init with a component with Whole placement and Normal quantity
- (id)initWithComponent:(BRMenuItemComponent *)menuComponent;

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent
			  placement:(BRMenuOrderItemComponentPlacement)placement
			   quantity:(BRMenuOrderItemComponentQuantity)quantity;

@end
