//
//  BRMenuProvider.h
//  BRMenu
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BRMenu.h"

@protocol BRMenuProvider <NSObject>

- (BRMenu *)menu;
- (BRMenu *)menuForVersion:(UInt16)version;

@end
