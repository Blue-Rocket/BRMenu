//
//  BRMenuItemComponent.h
//  BRMenu
//
//  A component of a BRMenuItem, e.g. a topping selection.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenuItemComponentGroup;

@interface BRMenuItemComponent : NSObject

@property (nonatomic) UInt8 componentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, getter = isAskQuantity) BOOL askQuantity; // defaults to YES
@property (nonatomic, getter = isAskPlacement) BOOL askPlacement; // defaults to YES
@property (nonatomic, getter = isShowWithFoodInformation) BOOL showWithFoodInformation; // defaults to YES
@property (nonatomic, getter = isAbsenceOfComponent) BOOL absenceOfComponent; // defaults to NO

@property (nonatomic, weak) BRMenuItemComponentGroup *group;

@end
