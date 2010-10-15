//
//  AddAccountWindow.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AddAccountWindow : NSWindowController {
	NSTextField *username;
}

@property (assign) IBOutlet NSTextField* username;

- (IBAction)done: (id)sender;

@end
