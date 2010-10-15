//
//  TwitterMinimalisticAppDelegate.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "TwitterMinimalisticAppDelegate.h"
#import "TwitterForOneUser.h"
#import "SSKeychain.h"
#import "AddAccountWindow.h"


#define STORE_USERS @"twitter-minimalistic-users" 


@implementation TwitterMinimalisticAppDelegate

@synthesize window;
@synthesize statusMenu;
@synthesize newTweetMenuItem;
@synthesize logOutMenuItem;

-(void)awakeFromNib{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setMenu:statusMenu];
	[statusItem setTitle:@"TwiMin"];
	[statusItem setHighlightMode:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// init growl
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	//init users
	NSString* usersStr = [SSGenericKeychainItem passwordForUsername:@"users" serviceName:STORE_USERS];
	if(usersStr == nil) usersStr = @"";
	NSArray* usersNames = [usersStr componentsSeparatedByString: @"/"];
	
	//connect users
	users = [[NSMutableArray alloc] init];
	for(NSString *cur in usersNames) {
		if([cur length] < 3) continue;
		TwitterForOneUser* twitA = [[TwitterForOneUser alloc] initializeForUsername:cur andApp:self];
		[users addObject:twitA];
	}

	[self updateUserBasedStuff];
}

- (void) updateUserBasedStuff {
	NSMutableArray* usersNames = [[NSMutableArray alloc] init];
	for(TwitterForOneUser *cur in users)
		[usersNames addObject: [cur username]];
	NSString* usersStr = [usersNames componentsJoinedByString: @"/"];
	[SSGenericKeychainItem setPassword:usersStr forUsername:@"users" serviceName:STORE_USERS];
	
	if( [users count] == 0 ) {
		[newTweetMenuItem setSubmenu:nil];
		[logOutMenuItem setSubmenu:nil];
		return;
	}
	
	NSMenu *newTweetMenu = [[NSMenu alloc] initWithTitle: [newTweetMenuItem title]];
	for(TwitterForOneUser *cur in users) {
		NSMenuItem* item = [newTweetMenu addItemWithTitle:[cur username] action: @selector (newTweet:) keyEquivalent: @"" ];
		[item setTarget: cur];
	}
	[newTweetMenuItem setSubmenu:newTweetMenu];

	NSMenu *logOutMenu = [[NSMenu alloc] initWithTitle: [logOutMenuItem title]];
	for(TwitterForOneUser *cur in users) {
		NSMenuItem* item = [logOutMenu addItemWithTitle:[cur username] action: @selector (logOut:) keyEquivalent: @"" ];
		[item setTarget: cur];
	}
	[logOutMenuItem setSubmenu:logOutMenu];
}

- (void) removeUser: (id)user {
	[users removeObject: user];
	[self updateUserBasedStuff];	
}

- (IBAction) addAccount: (id)sender {
	AddAccountWindow* addAcc = [[AddAccountWindow alloc] initWithWindowNibName: @"AddAccountWindow"];
	NSWindow* wnd = [addAcc window];
	
	[NSApp runModalForWindow: wnd];	
	[NSApp endSheet: wnd];
	[wnd orderOut: self];
	
	TwitterForOneUser* twitA = [[TwitterForOneUser alloc] initializeForUsername:[[addAcc username] stringValue] andApp:self];
	[users addObject:twitA];	
	
	[addAcc autorelease];
	
	[self updateUserBasedStuff];	
}

@end
