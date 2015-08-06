//
//  BRMenuUIControl.h
//  MenuKit
//
//  Created by Matt on 6/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

/**
 A protocol for controls to conform to to pick up some common traits.
 */
@protocol BRMenuUIControl <NSObject>

/** Manage a destructive state. */
@property (nonatomic, assign, getter=isDestructive) BOOL destructive;

@optional

/**
 Notify the receiver that the control state has changed.
 
 @param state The new state.
 */
- (void)controlStateDidChange:(UIControlState)state;

@end
