//
//  BRMenuItemComponent.h
//  MenuKit
//
//  A component of a BRMenuItem, e.g. a topping selection.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenuItemObject.h"

@class BRMenuItemComponentGroup;

@interface BRMenuItemComponent : NSObject <BRMenuItemObject, NSSecureCoding>

@property (nonatomic) uint8_t componentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, getter = isAskQuantity) BOOL askQuantity; // defaults to YES
@property (nonatomic, getter = isAskPlacement) BOOL askPlacement; // defaults to YES
@property (nonatomic, getter = isShowWithFoodInformation) BOOL showWithFoodInformation; // defaults to YES
@property (nonatomic, getter = isAbsenceOfComponent) BOOL absenceOfComponent; // defaults to NO

@property (nonatomic, weak) BRMenuItemComponentGroup *group;

@end
