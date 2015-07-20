//
//  BRMenuOrderItemAttributes.h
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface BRMenuOrderItemAttributes : NSObject

@property (nonatomic, getter = isTakeAway) BOOL takeAway; // YES == take away, NO == dine in

- (id)initWithTakeAway:(BOOL)takeAway;

@end
