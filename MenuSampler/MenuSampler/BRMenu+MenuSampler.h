//
//  BRMenu+MenuSampler.h
//  MenuSampler
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <MenuKit/Core/BRMenu.h>

@interface BRMenu (MenuSampler)

+ (BRMenu *)sampleMenuForResourceName:(NSString *)menuResourceName;

@end
