//
//  BRMenuItemObject.h
//  MenuKit
//
//  Created by Matt on 4/11/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

/**
 Protocol for an object that is a menu item, i.e. has these common properties.
 This allows code to work with BRMenuItem and BRMenuItemGroup instances in a common way.
*/
@protocol BRMenuItemObject <NSObject>

@required

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *desc;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, readonly) NSDecimalNumber *price;

/** Flag that indicates if this object contains components or not. */
@property (nonatomic, readonly) BOOL hasComponents;

@end
