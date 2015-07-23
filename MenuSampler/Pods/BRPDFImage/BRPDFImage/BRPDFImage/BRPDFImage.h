//
//  BRPDFImage.h
//  BRPDFImage
//
//  Created by Matt on 12/4/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@interface BRPDFImage : UIImage

// init with page 1 and a clear background color and no tint color
- (id)initWithURL:(NSURL *)url renderSize:(CGSize)size;

// init with page 1 and a clear background color
- (id)initWithURL:(NSURL *)url renderSize:(CGSize)size tintColor:(UIColor *)tintColor;

// init with page 1 and a clear background color and no tint color aspect-constrained to the given size
- (id)initWithURL:(NSURL *)url maximumSize:(CGSize)size;

// init with page 1 and a clear background color aspect-constrained to the given size
- (id)initWithURL:(NSURL *)url maximumSize:(CGSize)size tintColor:(UIColor *)tintColor;

// init with a specific size
- (id)initWithURL:(NSURL *)url
	   pageNumber:(size_t)pageNumber
	   renderSize:(CGSize)size
  backgroundColor:(UIColor *)backgroundColor
		tintColor:(UIColor *)tintColor
	tintBlendMode:(CGBlendMode)tintBlendMode;

// init with an aspect-constrained maximum size
- (id)initWithURL:(NSURL *)url
	   pageNumber:(size_t)pageNumber
	  maximumSize:(CGSize)size
  backgroundColor:(UIColor *)backgroundColor
		tintColor:(UIColor *)tintColor
	tintBlendMode:(CGBlendMode)tintBlendMode;

@end
