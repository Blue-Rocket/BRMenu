//
//  BRMenuJSON.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
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
