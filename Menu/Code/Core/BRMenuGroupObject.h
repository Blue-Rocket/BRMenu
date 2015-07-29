//
//  BRMenuGroupObject.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

/**
 Protocol for objects that are containers for menu items and other groups.
 */
@protocol BRMenuGroupObject <NSObject>

/** The menu items in this group. */
@property (nonatomic, copy, readonly) NSArray *items; // BRMenuItem

/** The nested groups in this group. */
@property (nonatomic, copy, readonly) NSArray *groups; // BRMenuGroupObject

@end
