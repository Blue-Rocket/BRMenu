//
//  ButtonsViewController.m
//  MenuSampler
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "ButtonsViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <MenuKit/UI/UI.h>

@interface ButtonsViewController ()
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper;
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper2;
@property (strong, nonatomic) IBOutlet BRMenuBarButtonItemView *cartButton;

@end

@implementation ButtonsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	BRMenuMutableUIStyle *mStyle = [[BRMenuUIStyle defaultStyle] mutableCopy];
	mStyle.uiFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
	mStyle.uiBoldFont = [UIFont fontWithName:@"Zapfino" size:12];
	mStyle.appPrimaryColor = [BRMenuUIStyle colorWithRGBHexInteger:0x60ae2b];
	mStyle.controlSelectedColor =  mStyle.appPrimaryColor;
	self.stepper2.uiStyle = mStyle;
}

- (IBAction)stepperDidChange:(BRMenuStepper *)sender {
	log4Info(@"Stepper %@ changed value to %@", sender, @(sender.value));
	NSUInteger itemCount = self.stepper.value + self.stepper2.value;
	self.cartButton.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)itemCount];
}

@end
