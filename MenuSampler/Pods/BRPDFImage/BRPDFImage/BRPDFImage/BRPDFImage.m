//
//  BRPDFImage.m
//  BRPDFImage
//
//  Created by Matt on 12/4/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRPDFImage.h"

#import <CoreGraphics/CoreGraphics.h>

static CGSize BRPdfNaturalSize(CGPDFPageRef page);
static CGSize BRPdfNaturalSize(CGPDFPageRef page);
static CGSize BRAspectSizeToFit(CGSize aSize, CGSize maxSize);
static void BRPdfDrawPage(CGPDFPageRef page, CGRect rect, CGColorRef backgroundColor,
						  CGContextRef context, bool flipped);

@implementation BRPDFImage

- (id)initWithURL:(NSURL *)url renderSize:(CGSize)size {
	return [self initWithURL:url pageNumber:1 renderSize:size backgroundColor:[UIColor clearColor] tintColor:nil tintBlendMode:kCGBlendModeSourceIn];
}

- (id)initWithURL:(NSURL *)url renderSize:(CGSize)size tintColor:(UIColor *)tintColor {
	return [self initWithURL:url pageNumber:1 renderSize:size backgroundColor:[UIColor clearColor] tintColor:tintColor tintBlendMode:kCGBlendModeSourceIn];
}

- (id)initWithURL:(NSURL *)url pageNumber:(size_t)pageNumber renderSize:(CGSize)size  backgroundColor:(UIColor *)backgroundColor
		tintColor:(UIColor *)tintColor tintBlendMode:(CGBlendMode)tintBlendMode {
	CGPDFDocumentRef doc = [self newCGPDFDocumentWithURL:url];
	UIImage *bitmap = nil;
	if ( doc != NULL ) {
		CGPDFPageRef page = CGPDFDocumentGetPage(doc, pageNumber);
		if ( page != NULL ) {
			bitmap = [BRPDFImage bitmapImageWithCGPDFPage:page size:size backgroundColor:backgroundColor
												tintColor:tintColor tintBlendMode:tintBlendMode];
		}
	}
	self = [super initWithCGImage:bitmap.CGImage scale:bitmap.scale orientation:bitmap.imageOrientation];
	CGPDFDocumentRelease(doc);
	return self;
}

- (id)initWithURL:(NSURL *)url maximumSize:(CGSize)size {
	return [self initWithURL:url pageNumber:1 maximumSize:size backgroundColor:[UIColor clearColor] tintColor:nil tintBlendMode:kCGBlendModeSourceIn];
}

- (id)initWithURL:(NSURL *)url maximumSize:(CGSize)size tintColor:(UIColor *)tintColor {
	return [self initWithURL:url pageNumber:1 maximumSize:size backgroundColor:[UIColor clearColor] tintColor:tintColor tintBlendMode:kCGBlendModeSourceIn];
}

- (id)initWithURL:(NSURL *)url pageNumber:(size_t)pageNumber maximumSize:(CGSize)size  backgroundColor:(UIColor *)backgroundColor
		tintColor:(UIColor *)tintColor tintBlendMode:(CGBlendMode)tintBlendMode {
	CGPDFDocumentRef doc = [self newCGPDFDocumentWithURL:url];
	UIImage *bitmap = nil;
	if ( doc != NULL ) {
		CGPDFPageRef page = CGPDFDocumentGetPage(doc, pageNumber);
		CGSize aspectFitSize = BRAspectSizeToFit(BRPdfNaturalSize(page), size);
		if ( page != NULL ) {
			bitmap = [BRPDFImage bitmapImageWithCGPDFPage:page size:aspectFitSize backgroundColor:backgroundColor
												tintColor:tintColor tintBlendMode:tintBlendMode];
		}
	}
	self = [super initWithCGImage:bitmap.CGImage scale:bitmap.scale orientation:bitmap.imageOrientation];
	CGPDFDocumentRelease(doc);
	return self;
}

+ (UIImage *)bitmapImageWithCGPDFPage:(CGPDFPageRef)page size:(CGSize)renderSize backgroundColor:(UIColor *)backgroundColor
							tintColor:(UIColor *)tintColor tintBlendMode:(const CGBlendMode)blendMode {
	UIGraphicsBeginImageContextWithOptions(renderSize, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
	CGContextSaveGState(context); {
		BRPdfDrawPage(page, frame, backgroundColor.CGColor, context, true);
	} CGContextRestoreGState(context);
	if ( tintColor != nil ) {
		if ( blendMode != kCGBlendModeSourceIn ) {
			CGImageRef maskImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
			CGContextClipToMask(context, frame, maskImage);
		}
		CGContextSetBlendMode(context, blendMode);
		[tintColor setFill];
		CGContextFillRect(context, frame);
	}
	UIImage *bitmap = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return bitmap;
}

- (CGPDFDocumentRef)newCGPDFDocumentWithURL:(NSURL *)url {
	NSError *error;
	NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
	if ( data == nil ) {
		NSLog(@"Error reading PDF %@: %@", url, [error localizedDescription]);
		return NULL;
	}
    
	CGDataProviderRef dp = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	if ( dp == NULL ) {
		NSLog(@"Unable to create CGDataProvider from PDF %@", url);
		return NULL;
	}
	
	CGPDFDocumentRef doc = CGPDFDocumentCreateWithProvider(dp);
	CFRelease(dp);
	if ( doc == NULL ) {
		NSLog(@"Unable to open PDF %@", url);
	}
	return doc;
}

@end

static CGSize BRPdfWorldSize(CGSize worldSize, int pageRotation) {
	if ( (abs(pageRotation) / 90) % 2 == 1 ) {
		CGFloat tmp = worldSize.width;
		worldSize.width = worldSize.height;
		worldSize.height = tmp;
	}
	return worldSize;
}

static CGSize BRPdfNaturalSize(CGPDFPageRef page) {
	if ( page == NULL ) {
		return CGSizeZero;
	}
	CGSize pdfSize = CGPDFPageGetBoxRect(page, kCGPDFCropBox).size;
	int pageRotation = CGPDFPageGetRotationAngle(page); // only allowed to be 0, ±90, ±180, ±270
	return BRPdfWorldSize(pdfSize, pageRotation);
}

static CGSize BRAspectSizeToFit(CGSize aSize, CGSize maxSize) {
	CGFloat scale = 1.0;
	if ( aSize.width > 0.0 && aSize.height > 0.0 ) {
		CGFloat dw = maxSize.width / aSize.width;
		CGFloat dh = maxSize.height / aSize.height;
		scale = dw < dh ? dw : dh;
	}
	return CGSizeMake(MIN(floorf(maxSize.width), ceilf(aSize.width * scale)),
					  MIN(floorf(maxSize.height), ceilf(aSize.height * scale)));
}

static void BRPdfDrawPage(CGPDFPageRef page, CGRect rect, CGColorRef backgroundColor,
						  CGContextRef context, bool flipped) {
	CGSize pdfSize = BRPdfNaturalSize(page);
	CGSize fitSize = BRAspectSizeToFit(pdfSize, rect.size);
	
	// the following scale and translation values compenstate for CGPDFPageGetDrawingTransform which only scales down, not UP
	
	CGFloat dw = rect.size.width / pdfSize.width;
	CGFloat dh = rect.size.height / pdfSize.height;
	CGFloat scale = (dw < dh ? dw : dh);
	
	CGFloat tx = rect.origin.x + (0.0 - (pdfSize.width < rect.size.width ? (((rect.size.width - pdfSize.width) / 2.0) * scale) : 0.0));
	CGFloat ty;
	if ( flipped ) {
		ty = rect.origin.y + (rect.size.height + (pdfSize.height < rect.size.height ? (((rect.size.height - pdfSize.height) / 2.0) * scale) : 0.0));
	} else {
		ty = rect.origin.y - (                   (pdfSize.height < rect.size.height ? (((rect.size.height - pdfSize.height) / 2.0) * scale) : 0.0));
	}
	
	// CGPDFPageGetDrawingTransform will also scale the result,
	// but only down so we only apply scale > 1
	if ( scale < 1.0 ) {
		scale = 1.0;
	}
	
	CGContextSaveGState(context);
	{
		// fill in PDF background with our own background view color, otherwise
		// layer seems to draw black background followed by PDF content
		CGRect pageRect = CGRectIntegral(CGRectMake(rect.origin.x + (rect.size.width - fitSize.width) / 2.0,
													rect.origin.y + (rect.size.height - fitSize.height) / 2.0,
													fitSize.width,
													fitSize.height));
		if ( backgroundColor != NULL ) {
			CGContextSetFillColorWithColor(context, backgroundColor);
			CGContextFillRect(context, pageRect);
		}
		
		// PDFs can draw outside their defined page box, so clip to the box here
		// MSM: commenting out, because clipping slightly edges of PDFs drawn in places like icons, where
		//      we have slight fractional differences in pageRect from rect. Need to investigate a bit more.
		//CGContextClipToRect(context, pageRect);
		
		CGContextTranslateCTM(context, tx, ty);
		CGContextScaleCTM(context, scale, (flipped ? -scale : scale));
		CGAffineTransform pdfXform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, CGRectMake(0, 0, rect.size.width, rect.size.height), 0, false);
		CGContextConcatCTM(context, pdfXform);
		
		CGContextDrawPDFPage(context, page);
	} CGContextRestoreGState(context);
}
