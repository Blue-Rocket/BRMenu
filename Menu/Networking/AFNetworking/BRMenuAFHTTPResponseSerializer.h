//
//  BRMenu.h
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <AFNetworking/AFURLResponseSerialization.h>

#import "BRMenuDataMapper.h"

/**
 Serialize JSON HTTP responses into BRMenu domain object instances, by way of a @c BRMenuDataMapper.
 */
@interface BRMenuAFHTTPResponseSerializer : AFJSONResponseSerializer

/**
 A key path to apply to the source object to specify the location of the root of the JSON to map.
 */
@property (nonatomic, copy) NSString *rootKeyPath;

/**
 The @c BRMenuDataMapper to handle the mapping of the respone JSON into a BRMenu domain object.
 If not configured the raw JSON response object will be returned as a Foundation object, for 
 example a @c NSDictionary, @c NSArray, etc.
 */
@property (nonatomic, strong) id<BRMenuDataMapper> dataMapper;

@end
