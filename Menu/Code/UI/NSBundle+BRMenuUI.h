//
//  NSBundle+BRMenuUI.h
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@interface NSBundle (BRMenuUI)

/**
 Get an icon image for a given resource name, size, and tint color.
 
 If the resource is a PDF file, the @c iconSize and @c tintColor arguments are used to size and color the final image.
 
 This method will cache the loaded images as memory permits.
 
 @param resourceName The name of the image resource to use.
 @param iconSize For PDF resources, the size of the image to create.
 @param tintColor For PDF resources, an optional tint color to apply to the image.
 @return An image, or @c nil if the resource cannot be loaded.
 */
+ (UIImage *)iconForBRMenuResource:(NSString *)resourceName size:(CGSize)iconSize color:(UIColor *)tintColor;

@end
