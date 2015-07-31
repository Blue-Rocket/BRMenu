//
//  BRMenuMappingRestKitPostProcessor.h
//  Menu
//
//  Created by Matt on 17/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <RestKit/ObjectMapping.h>

@class BRMenu;

/**
 Helper class to post-process objects after RestKit mapping has been performed.
 
 This class conforms to @c RKMapperOperationDelegate and as such can be configured
 to perform post processing tasks automatically by configuring an instance of this
 class as the mapping delegate.
 */
@interface BRMenuMappingRestKitPostProcessor : NSObject <RKMapperOperationDelegate>

@end
