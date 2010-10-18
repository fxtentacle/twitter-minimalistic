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
    NSString* userId;
    NSString* userScreenname;
    NSData* userImage;
	OAToken *token;
	NSTimer* updateTimer;
	MGTwitterEngineID lastId;
}

@property (readonly, copy) NSString* username;
@property (readonly, copy) NSString* userId;
@property (readwrite, copy) NSData* userImage;
@property (readwrite, copy) NSString* userScreenname;

- (id)initializeForUsername:(NSString*) username andApp: (id) app;
+ (void)removeAuthorizationForUsername:(NSString*) username;

- (void)newTweet: (id)sender;
- (void)logOut: (id)sender;

@end
