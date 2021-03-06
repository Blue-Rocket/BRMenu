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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper;
@property (strong, nonatomic) IBOutlet BRMenuStepper *stepper2;
@property (strong, nonatomic) IBOutlet BRMenuButton *cartButton;
@property (strong, nonatomic) IBOutlet BRMenuButton *dangerousButton;
@property (strong, nonatomic) IBOutlet BRMenuButton *inverseDisabledButton;
@property (strong, nonatomic) IBOutlet BRMenuPlusMinusButton *disabledPlus;
@property (strong, nonatomic) IBOutlet BRMenuPlusMinusButton *selectedPlus;
@property (strong, nonatomic) IBOutlet BRMenuPlusMinusButton *dangerousPlus;

@end

@implementation ButtonsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	BRMutableUIStyle *mStyle = [[BRUIStyle defaultStyle] mutableCopy];
	mStyle.fonts.actionFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
	mStyle.colors.primaryColor = [BRUIStyle colorWithRGBInteger:0x60ae2b];
	self.stepper2.uiStyle = mStyle;
	
	self.dangerousButton.dangerous = YES;
	self.disabledPlus.enabled = NO;
	self.selectedPlus.selected = YES;
	self.dangerousPlus.dangerous = YES;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	UIEdgeInsets insets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
	self.scrollView.contentInset = insets;
	insets = self.scrollView.scrollIndicatorInsets;
	insets.top = self.topLayoutGuide.length;
	self.scrollView.scrollIndicatorInsets = insets;
}

- (IBAction)stepperDidChange:(BRMenuStepper *)sender {
	log4Info(@"Stepper %@ changed value to %@", sender, @(sender.value));
	NSUInteger itemCount = self.stepper.value + self.stepper2.value;
	self.cartButton.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)itemCount];
}

@end
