//
//  BRMenuUIModelPropertyEditor.h
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuModelPropertyEditor.h"

@protocol BRMenuUIModelPropertyEditor <BRMenuModelPropertyEditor>

/**
 Set the selected state of the editor.
 
 @param selected The selected state.
 @param animated Flag to use animation or not when changing selection state.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
