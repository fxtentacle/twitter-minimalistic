//
//  NewTweetWindow.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NewTweetWindow : NSWindowController {
	NSTextField *tweet;
	NSTextField *count;
	NSButton* button;
}

@property (assign) IBOutlet NSTextField* tweet;
@property (assign) IBOutlet NSTextField* count;
@property (assign) IBOutlet NSButton* button;

-(void) controlTextDidChange:(NSNotification *)aNotification;
- (IBAction)done: (id)sender;

@end
