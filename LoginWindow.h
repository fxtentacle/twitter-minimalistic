//
//  LoginWindow.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LoginWindow : NSWindowController {
	NSTextField *pinCode;
	NSString* username;
}

@property (assign) IBOutlet NSTextField *pinCode;
@property (assign) IBOutlet NSString* username;

- (IBAction)enteredPin: (id)sender;


@end
