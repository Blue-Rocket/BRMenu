//
//  BRMenuModelPropertyEditor.h
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

/**
 Protocol for components that represent editors of a model property, such as a @c UIButton
 that toggles between values of an enumeration.
 */
@protocol BRMenuModelPropertyEditor <NSObject>

/**
 Get a key path for the property managed by this editor.
 
 @param model The class of the model object the receiver is editing.
 @return The key path for the model property, or @c nil if not known.
 */
- (NSString *)propertyEditorKeyPathForModel:(Class)modelClass;

/**
 Get a default value for a given model class.
 
 @param modelClass The class of the model object.
 @return The default value.
 */
- (id)propertyEditorDefaultValueForModel:(Class)modelClass;

/**
 Get the current value of the edited property.
 
 @return The current property value, as far as the editor is concerned.
 */
- (id)propertyEditorValue;

/**
 Set the current value of the edited propery.
 
 @param value The property value to set.
 */
- (void)setPropertyEditorValue:(id)value;

@end
