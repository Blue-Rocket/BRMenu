//
//  BRMenuItemComopnentGroup.h
//  MenuKit
//
//  A grouping of BRMenuItemComponent objects, e.g. Dough group with
//  Traditional, Whole Wheat, and Multigrain components.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuItemComponent;

@interface BRMenuItemComponentGroup : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, getter = isMultiSelect) BOOL multiSelect;
@property (nonatomic, copy) NSArray *components; // BRMenuItemComponent
@property (nonatomic, copy) NSArray *componentGroups; // BRMenuItemComponentGroup
@property (nonatomic) unsigned int requiredCount;

@property (nonatomic, copy) NSString *key; // unique key assigned by data
@property (nonatomic, copy) NSString *extendsKey; // key of some other BRMenuItemComponentGroup this item extends

@property (nonatomic, weak) BRMenuItemComponentGroup *parentGroup; // parent group

- (BRMenuItemComponent *)menuItemComponentForId:(const UInt8)componentId;

// all unique BRMenuItemComponent objects within this group
- (NSArray *)allComponents;

@end
