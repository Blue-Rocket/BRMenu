//
//  ButtonsViewController.m
//  MenuSampler
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "ButtonsViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <MenuKit/UI.h>

@interface ButtonsViewController ()
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper;
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper2;
@property (strong, nonatomic) IBOutlet BRMenuBarButtonItemView *cartButton;

@end

@implementation ButtonsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	BRMutableUIStyle *mStyle = [[BRUIStyle defaultStyle] mutableCopy];
	mStyle.fonts.actionFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
	mStyle.colors.primaryColor = [BRUIStyle colorWithRGBInteger:0x60ae2b];
	mStyle.colors.controlSettings.selectedColorSettings.actionColor =  mStyle.colors.primaryColor;
	self.stepper2.uiStyle = mStyle;
}

- (IBAction)stepperDidChange:(BRMenuStepper *)sender {
	log4Info(@"Stepper %@ changed value to %@", sender, @(sender.value));
	NSUInteger itemCount = self.stepper.value + self.stepper2.value;
	self.cartButton.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)itemCount];
}

@end
