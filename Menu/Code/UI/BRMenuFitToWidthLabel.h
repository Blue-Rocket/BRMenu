//
//  BRMenuFitToWidthLabel.h
//  MenuKit
//
//  Created by Matt on 12/2/14.
//  Copyright (c) 2014 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@interface BRMenuFitToWidthLabel : UILabel

/** Flag to disable the automatic adjustment of @c preferredMaxLayoutWidth. */
@property (nonatomic, assign, getter=isDisableAutoAdjustMaxLayoutWidth) BOOL disableAutoAdjustMaxLayoutWidth;

@end
