//
//  BRMenuProvider.h
//  MenuKit
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenu.h"

@protocol BRMenuProvider <NSObject>

- (BRMenu *)menu;
- (BRMenu *)menuForVersion:(uint16_t)version;

@end
