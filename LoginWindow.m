//
//  LoginWindow.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "LoginWindow.h"


@implementation LoginWindow

@synthesize pinCode;
@synthesize username;

- (void)awakeFromNib 
{
}

- (IBAction)enteredPin: (id)sender {
	[NSApp stopModal];
}


@end
