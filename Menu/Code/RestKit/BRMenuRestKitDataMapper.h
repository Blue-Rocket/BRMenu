//
//  BRMenuRestKitDataMapper.h
//  MenuKit
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuDataMapper.h"

@class RKObjectMapping;

@interface BRMenuRestKitDataMapper : NSObject <BRMenuDataMapper>

/**
 Initialize with a RestKit mapping configuration.
 
 @param mapping The mapping to use.
 */
- (instancetype)initWithObjectMapping:(RKObjectMapping *)mapping;

@end
