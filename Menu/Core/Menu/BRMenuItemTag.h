//
//  BRMenuItemTag.h
//  BRMenu
//
//  A "tag" applied to a BRMenuItem, e.g. Vegetarian.
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRMenuItemTag : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@end
