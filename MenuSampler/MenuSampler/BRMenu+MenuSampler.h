//
//  BRMenu+MenuSampler.h
//  MenuSampler
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <BRMenuKit/Core/BRMenu.h>

@interface BRMenu (MenuSampler)

+ (BRMenu *)sampleMenuForResourceName:(NSString *)menuResourceName;

@end
