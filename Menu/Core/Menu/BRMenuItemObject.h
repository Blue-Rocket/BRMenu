//
//  BRMenuItemObject.h
//  BRMenu
//
//  Protocol for an object that is a menu item, i.e. has these common properties.
/// This allows code to work with BRMenuItem and BRMenuItemGroup instances in a common way.
//
//  Created by Matt on 4/11/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRMenuItemObject <NSObject>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDecimalNumber *price;

@end
