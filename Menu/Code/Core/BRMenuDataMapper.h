//
//  BRMenuDataMapper.h
//  Menu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@protocol BRMenuDataMapper <NSObject>

/**
 Map a source data object into some domain object.
 
 @param sourceObject The source data, which might be @c NSData, @c NSDictionary, etc.
 @param error An optional output error pointer, or @c nil.
 @return The mapped domain object, or @c nil if an error occurs.
 */
- (id)performMappingWithSourceObject:(id)sourceObject error:(NSError *__autoreleasing *)error;

@end
