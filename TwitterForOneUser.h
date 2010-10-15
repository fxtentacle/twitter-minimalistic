//
//  TwitterForOneUser.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGTwitterEngine/MGTwitterEngine.h>

@interface TwitterForOneUser : NSObject<MGTwitterEngineDelegate> {
	id myApp;
    MGTwitterEngine *twitterEngine;
	NSString* username;
	OAToken *token;
	NSTimer* updateTimer;
}

@property (readonly, copy) NSString* username;

- (id)initializeForUsername:(NSString*) username andApp: (id) app;
+ (void)removeAuthorizationForUsername:(NSString*) username;

- (void)newTweet: (id)sender;
- (void)logOut: (id)sender;

@end
