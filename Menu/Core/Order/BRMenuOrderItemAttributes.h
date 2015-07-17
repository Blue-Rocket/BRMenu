//
//  BRMenuOrderItemAttributes.h
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRMenuOrderItemAttributes : NSObject

@property (nonatomic, getter = isTakeAway) BOOL takeAway; // YES == take away, NO == dine in

- (id)initWithTakeAway:(BOOL)takeAway;

@end
