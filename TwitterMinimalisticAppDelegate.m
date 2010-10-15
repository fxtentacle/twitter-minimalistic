//
//  TwitterMinimalisticAppDelegate.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "TwitterMinimalisticAppDelegate.h"
#import "LoginWindow.h"

@implementation TwitterMinimalisticAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
    // Put your Twitter username and password here:
    NSString *username = nil;
	
	NSString *consumerKey = nil;
	NSString *consumerSecret = nil;
	
	// this file will set username, consumerKey and consumerSecret
#include "SecretValues.h"
	
    // Most API calls require a name and password to be set...
    if (! username || !consumerKey || !consumerSecret) {
        NSLog(@"You forgot to specify your username/password/key/secret in AppController.m, things might not work!");
		NSLog(@"And if things are mysteriously working without the username/password, it's because NSURLConnection is using a session cookie from another connection.");
    }
    
    // Create a TwitterEngine and set our login details.
    twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	[twitterEngine setUsesSecureConnection:NO];
	[twitterEngine setConsumerKey:consumerKey secret:consumerSecret];
	// This has been undepreciated for the purposes of dealing with Lists.
	// At present the list API calls require you to specify a user that owns the list.
	[twitterEngine setUsername:username];
	
	[twitterEngine getRequestToken];
}




- (void)dealloc
{
    [twitterEngine release];
    [super dealloc];
}


#pragma mark MGTwitterEngineDelegate methods


- (void)requestTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Request token received! %@",aToken);
	token = [aToken retain];
	
	[twitterEngine openAuthorizePageForRequestToken: token];
	
	LoginWindow* login = [[LoginWindow alloc] initWithWindowNibName: @"LoginWindow"];
	NSWindow* wnd = [login window];
	
	[NSApp runModalForWindow: wnd];	
	[NSApp endSheet: wnd];
	[wnd orderOut: self];
	[login autorelease];
}


- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Access token received! %@",aToken);
	
	token = [aToken retain];
}

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
}

- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
}

- (void)imageReceived:(NSImage *)image forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
    
    // Save image to the Desktop.
    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", connectionIdentifier] stringByExpandingTildeInPath];
    [[image TIFFRepresentation] writeToFile:path atomically:NO];
}

- (void)connectionFinished:(NSString *)connectionIdentifier
{
    NSLog(@"Connection finished %@", connectionIdentifier);
}

@end
