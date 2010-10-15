//
//  TwitterMinimalisticAppDelegate.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwitterMinimalisticAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow* window;
	NSMenu *statusMenu;
    NSStatusItem * statusItem;
	
	NSMenuItem *newTweetMenuItem;	
	NSMenuItem *logOutMenuItem;	

	NSMutableArray* users;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSMenuItem *newTweetMenuItem;
@property (assign) IBOutlet NSMenuItem *logOutMenuItem;

- (void) removeUser: (id)user;
- (void) updateUserBasedStuff;
- (IBAction) addAccount: (id)sender;

@end
