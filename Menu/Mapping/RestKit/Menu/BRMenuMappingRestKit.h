//
//  BRMenuJSON.h
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import <RestKit/ObjectMapping.h>

@interface BRMenuMappingRestKit : NSObject

+ (RKObjectMapping *)menuMapping;
+ (RKObjectMapping *)menuItemMapping;
+ (RKObjectMapping *)menuItemComponentMapping;
+ (RKObjectMapping *)menuItemComponentGroupMapping;
+ (RKObjectMapping *)menuItemGroupMapping;
+ (RKObjectMapping *)menuItemTagMapping;

+ (RKObjectMapping *)menuMetadataMapping;

@end
