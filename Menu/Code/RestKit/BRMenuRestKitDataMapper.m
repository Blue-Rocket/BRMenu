//
//  BRMenuRestKitDataMapper.m
//  Menu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuRestKitDataMapper.h"

#import <RestKit/ObjectMapping.h>
#import <RestKit/ObjectMapping/RKObjectMappingOperationDataSource.h>
#import "BRMenuMappingRestKitPostProcessor.h"

@implementation BRMenuRestKitDataMapper {
	RKObjectMapping *mapping;
}

- (id)init {
	return [self initWithObjectMapping:nil];
}

- (instancetype)initWithObjectMapping:(RKObjectMapping *)theMapping {
	if ( (self = [super init]) ) {
		mapping = theMapping;
	}
	return self;
}

- (id<RKMappingOperationDataSource>)dataSourceForMappingOperation:(RKMappingOperation *)mappingOperation {
	static RKObjectMappingOperationDataSource *dataSource;
	if ( !dataSource ) {
		dataSource = [RKObjectMappingOperationDataSource new];
	}
	return dataSource;
}

- (id)performMappingWithSourceObject:(id)sourceObject error:(NSError *__autoreleasing *)error {
	RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:sourceObject
																		  destinationObject:nil
																					mapping:mapping];
	id<RKMappingOperationDataSource> dataSource = [self dataSourceForMappingOperation:mappingOperation];
	mappingOperation.dataSource = dataSource;
	[mappingOperation start];
	if ( mappingOperation.error ) {
		if ( error ) {
			*error = mappingOperation.error;
		}
	}
	return mappingOperation.destinationObject;
}

@end
