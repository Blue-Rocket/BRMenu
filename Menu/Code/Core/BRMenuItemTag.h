//
//  BRMenuItemTag.h
//  MenuKit
//
//  A "tag" applied to a BRMenuItem, e.g. Vegetarian.
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface BRMenuItemTag : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@end
