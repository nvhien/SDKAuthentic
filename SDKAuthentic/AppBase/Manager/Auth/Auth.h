//
//  Auth.h
//  music.application
//
//  Created by thanhvu on 4/24/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Session.h"
#import "ApiDataObjects.h"

#define APPLICATION_VERSION                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

typedef NS_ENUM(NSInteger, AuthState) {
    AuthStateNone,
    AuthStateLoging
};

typedef NS_ENUM(NSInteger, RegisterDeviceState) {
    RegisterDeviceStateNone,
    RegisterDeviceStateProcessing,
    RegisterDeviceStateSuccess
};

typedef NS_OPTIONS(NSInteger, AppVerifyState) {
    AppVerifyStateSuccess,
    AppVerifyStateUpdate,
    AppVerifyStateFailure
};

typedef NS_ENUM(NSInteger, AuthEvent) {
    AuthEventLoginFailure,
    AuthEventLoginSuccess,
    AuthEventUserSessionChanged
};

UIKIT_EXTERN NSString *const kAuthEvent_LoginFailure;
UIKIT_EXTERN NSString *const kAuthEvent_LoginSuccess;
UIKIT_EXTERN NSString *const kAuthEvent_UserSessionChanged;

@interface Auth : NSObject

+ (instancetype)shared;

// verify application
- (void)verifyApplication:(void(^)(AppVerifyState state))completion;

// register device token
- (void)registerDeviceTokenCompletion:(void(^)(BOOL success))completion;

#pragma mark - Registration
// register account
- (void)registerAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void(^)(User*, ApiStatus*, NSError *))completion;

#pragma mark - Login Email

// login with email
- (void)loginWithAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void(^)(BOOL success))completion;

// login guest
- (void)loginWithGuest:(NSString *)guestId gameId:(NSInteger)gameId completion:(void(^)(BOOL success))completion;

#pragma mark - Login Facebook
// login with facebook
- (void)loginWithFacebookToken:(NSString *)token;

// login with facebook
- (void)loginWithFacebookToken:(NSString *)token completion:(void(^)(BOOL success))completion;

// refresh token
- (void)refreshTokenWithCompletion:(void(^)(BOOL success))completion;

#pragma mark - User
- (void)getUserInfo:(void(^)(BOOL))completion;

// logout
- (void)logout:(void(^)(ApiStatus*,BOOL success))completion;

// push notification session was changed
- (void)sessionChanged;

// add Observer for receive push event
- (void)addObserver:(NSObject *)observer selector:(SEL)selector forEvent:(AuthEvent)event;

// send push message notification
- (void)postAuthEvent:(AuthEvent)authEvent;

// save user to local stored

- (void)saveUser:(User *)user token:(NSString *)token;

@end
