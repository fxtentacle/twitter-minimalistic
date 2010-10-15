//
//  AddAccountWindow.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "AddAccountWindow.h"


@implementation AddAccountWindow

@synthesize username;

- (void)awakeFromNib 
{
}

- (IBAction)done: (id)sender {
	[NSApp stopModal];
}


@end
