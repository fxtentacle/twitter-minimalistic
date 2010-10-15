//
//  TwitterForOneUser.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "TwitterForOneUser.h"
#import "SSKeychain.h"
#import "LoginWindow.h"
#import "TwitterMinimalisticAppDelegate.h"
#import "Growl-WithInstaller/GrowlApplicationBridge.h"

#define STORE_KEY @"twitter-minimalistic-key" 
#define STORE_SECRET @"twitter-minimalistic-key" 

@implementation TwitterForOneUser
@synthesize username;

- (id)initializeForUsername:(NSString*) userNameToSet andApp: (id)app {	
	username = [userNameToSet copy];
	myApp = app;
	
	NSString *consumerKey = nil;
	NSString *consumerSecret = nil;
	
	// this file will set consumerKey and consumerSecret
#include "SecretValues.h"
	
    // Most API calls require a name and password to be set...
    if (!consumerKey || !consumerSecret) {
        NSLog(@"You forgot to specify your key/secret in SecretValues.h, things might not work!");
		NSLog(@"And if things are mysteriously working without the username/password, it's because NSURLConnection is using a session cookie from another connection.");
    }
    
    // Create a TwitterEngine and set our login details.
    twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	[twitterEngine setUsesSecureConnection:NO];
	[twitterEngine setConsumerKey:consumerKey secret:consumerSecret];
	
	// This has been undepreciated for the purposes of dealing with Lists.
	// At present the list API calls require you to specify a user that owns the list.
	[twitterEngine setUsername:username];
	
	NSString* key = [SSGenericKeychainItem passwordForUsername:username serviceName:STORE_KEY];
	NSString* secret = [SSGenericKeychainItem passwordForUsername:username serviceName:STORE_SECRET];
	
	if(key != nil && secret != nil && [key length] > 4 && [secret length] > 4) {
		OAToken* tt = [[OAToken alloc] initWithKey:key secret:secret];
		[self accessTokenReceived: tt forRequest: nil];
	} else {
		[twitterEngine getRequestToken];
	}
	return self;
}

+ (void)removeAuthorizationForUsername:(NSString*) usernameToUse {
	[SSGenericKeychainItem setPassword:@"" forUsername: usernameToUse serviceName: STORE_KEY];
	[SSGenericKeychainItem setPassword:@"" forUsername: usernameToUse serviceName: STORE_SECRET];
}

- (void)newTweet: (id)sender {
	NSLog(@"newTweet for user %@",username);
}

- (void)logOut: (id)sender {
	NSLog(@"logOut for user %@",username);
	[TwitterForOneUser removeAuthorizationForUsername: username];
	[(TwitterMinimalisticAppDelegate*)myApp removeUser: self];
}



- (void)updateStatus:(NSTimer *)theTimer
{
    [twitterEngine getHomeTimelineSinceID:0 startingAtPage:0 count:20];
} 



- (void)dealloc
{
	[updateTimer invalidate];
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
	[login setUsername:username];
	NSWindow* wnd = [login window];
	
	[NSApp runModalForWindow: wnd];	
	[NSApp endSheet: wnd];
	[wnd orderOut: self];
	
	NSString* pinCode = [[login pinCode] stringValue];
	if([pinCode length] < 3) 
		[twitterEngine getRequestToken];
	else
		[twitterEngine getAccessTokenForRequestToken:token pin: pinCode];

	[login autorelease];
}


- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Access token received! %@",aToken);
	
	token = [aToken retain];
	[twitterEngine setAccessToken:token];
	[SSGenericKeychainItem setPassword: [token key] forUsername: username serviceName: STORE_KEY];
	[SSGenericKeychainItem setPassword: [token secret] forUsername: username serviceName: STORE_SECRET];
	
	[GrowlApplicationBridge
	 notifyWithTitle:username
	 description:[NSString stringWithFormat:@"User %@ successfully logged in.", username]
	 notificationName:@"UserLogin"
	 iconData:nil
	 priority:1
	 isSticky:NO
	 clickContext:nil];
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target: self selector:@selector(updateStatus:) userInfo: nil repeats: YES];
	[self updateStatus: updateTimer];
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
	
	for(NSDictionary* status in statuses) {
		/*
		 {
		 contributors = "";
		 coordinates = "";
		 "created_at" = 2010-10-14 21:47:50 +0200;
		 favorited = false;
		 geo = "";
		 id = 27379283219;
		 "in_reply_to_screen_name" = "";
		 "in_reply_to_status_id" = "";
		 "in_reply_to_user_id" = "";
		 place =         {
		 };
		 "retweet_count" = "";
		 retweeted = false;
		 source = web;
		 "source_api_request_type" = 1;
		 text = "Finally reclaimed my beloved nickname :)";
		 truncated = 0;
		 user =         {
		 "contributors_enabled" = false;
		 "created_at" = 2008-09-23 12:00:28 +0200;
		 description = "";
		 "favourites_count" = 0;
		 "follow_request_sent" = false;
		 "followers_count" = 0;
		 following = 0;
		 "friends_count" = 0;
		 "geo_enabled" = false;
		 id = 16418140;
		 lang = en;
		 "listed_count" = 0;
		 location = "";
		 name = fxtentacle;
		 notifications = false;
		 "profile_background_color" = C0DEED;
		 "profile_background_image_url" = "http://s.twimg.com/a/1287010001/images/themes/theme1/bg.png";
		 "profile_background_tile" = false;
		 "profile_image_url" = "http://s.twimg.com/a/1287010001/images/default_profile_4_normal.png";
		 "profile_link_color" = 0084B4;
		 "profile_sidebar_border_color" = C0DEED;
		 "profile_sidebar_fill_color" = DDEEF6;
		 "profile_text_color" = 333333;
		 "profile_use_background_image" = true;
		 protected = 0;
		 "screen_name" = fxtentacle;
		 "show_all_inline_media" = false;
		 "statuses_count" = 2;
		 "time_zone" = "";
		 url = "";
		 "utc_offset" = "";
		 verified = false;
		 };
		 },
		 */
		NSDictionary* user = [status objectForKey:@"user"];
		NSURL *url = [NSURL URLWithString: [user objectForKey:@"profile_image_url"]];
		NSData *userImage = [NSData dataWithContentsOfURL:url];

		[GrowlApplicationBridge
		 notifyWithTitle:[user objectForKey:@"name"]
		 description:[status objectForKey:@"text"]
		 notificationName:@"NewTweetReceived"
		 iconData:userImage
		 priority:0
		 isSticky:NO
		 clickContext:nil];		
	}
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
