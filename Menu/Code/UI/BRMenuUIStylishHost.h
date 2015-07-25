//
//  BRMenuUIStylishHost.h
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuUIStyle;

@protocol BRMenuUIStylishHost <NSObject>

@optional

/**
 Sent to the receiver if the BRMenuUIStyle object associated with the receiver has changed.
 */
- (void)uiStyleDidChange:(BRMenuUIStyle *)style;

@end
