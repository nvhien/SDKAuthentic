//
//  Auth.m
//  music.application
//
//  Created by thanhvu on 4/24/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import "Auth.h"
#import "ApiClient.h"
#import "ZLUtilities.h"

NSString *const kAuthEvent_LoginFailure                     = @"AuthLoginFailure";
NSString *const kAuthEvent_LoginSuccess                     = @"AuthLoginSuccess";
NSString *const kAuthEvent_UserSessionChanged               = @"AuthUserSessionChanged";

@interface Auth()
@property (nonatomic, assign) AuthState state;
@property (nonatomic, assign) RegisterDeviceState deviceState;
@end

@implementation Auth

#pragma mark - Initialize

+ (instancetype)shared {
    static Auth *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = AuthStateNone;
    }
    return self;
}

#pragma mark - AuthEvent by Name
- (NSString *)p_authEventByType:(AuthEvent) event {
    NSString *eventName = nil;
    switch (event) {
        case AuthEventLoginFailure:
            eventName = kAuthEvent_LoginFailure;
            break;
        case AuthEventLoginSuccess:
            eventName = kAuthEvent_LoginSuccess;
            break;
        case AuthEventUserSessionChanged:
            eventName = kAuthEvent_UserSessionChanged;
            break;
        default:
            break;
    }
    return eventName;
}

- (void)registerDeviceTokenCompletion:(void(^)(BOOL success))completion {
}

#pragma mark - Registration
- (void)registerAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void (^)(User *, ApiStatus *, NSError *))completion {
    [[APIClient shared] registerAccount:userName password:password gameId:gameId
                             completion:^(User *user, ApiStatus *status, NSError *error) {
        completion(user, status, error);
    }];
}

#pragma mark - Login
- (void)loginWithAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void (^)(BOOL))completion {
    if (_state == AuthStateLoging) {
        return;
    }
    _state = AuthStateLoging;
    [[APIClient shared] loginWithAccount:userName password:password gameId:gameId completion:^(User *user, ApiStatus *status, NSError *error) {
        self.state = AuthStateNone;
        if (error) {
            [Session shared].user = nil;
            if (completion) {
                completion(NO);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAuthEvent_LoginFailure object:nil];
        }
        else{
            if (status.code == ApiCodeSuccess) {
                [Session shared].user = user;
                [Session shared].sessionToken = user.accessToken;
                [[APIClient shared] updateAuthorizationHeader:[[Session shared] authHeaderField]];
                if (completion) {
                    completion(YES);
                }
            }
            else{
                [ZLUtilities showToast:status.message];
                if (completion) {
                    completion(NO);
                }
            }
        }
        
    }];
}

- (void)loginWithGuest:(NSString *)guestId gameId:(NSInteger)gameId completion:(void (^)(BOOL))completion {
    if (_state == AuthStateLoging) {
        return;
    }
    _state = AuthStateLoging;
    [[APIClient shared] loginWithGuest:guestId gameId:gameId completion:^(User *user, ApiStatus *status, NSError *error) {
        self.state = AuthStateNone;
        if (error) {
            [Session shared].user = nil;
            if (completion) {
                completion(NO);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAuthEvent_LoginFailure object:nil];
        }
        else{
            if (status.code == ApiCodeSuccess) {
                [Session shared].user = user;
                [Session shared].sessionToken = user.accessToken;
                [[APIClient shared] updateAuthorizationHeader:[[Session shared] authHeaderField]];
                if (completion) {
                    completion(YES);
                }
            }
            else{
                [ZLUtilities showToast:status.message];
                if (completion) {
                    completion(NO);
                }
            }
        }
        
    }];
}

- (void)loginWithFacebookToken:(NSString *)token {
    [[APIClient shared] loginWithFacebookToken:token appId:[Session shared].appId completion:nil];
}

- (void)loginWithFacebookToken:(NSString *)token completion:(void (^)(BOOL))completion {
    
}

- (void)refreshTokenWithCompletion:(void(^)(BOOL success))completion {
}

#pragma mark - User
- (void)getUserInfo:(void (^)(BOOL))completion {
    [[APIClient shared] getUserInfo:^(User *user, BOOL success) {
        if (success) {
            [Session shared].user = user;
            if (completion) {
                completion(YES);
            }
        }
        else{
            if (completion) {
                completion(NO);
            }
        }
    }];
}

#pragma mark - Logout
- (void)logout:(void (^)(ApiStatus *, BOOL))completion {
    [[APIClient shared] logout:^(ApiStatus *status, BOOL success) {
        completion(status, success);
    }];
}

//- (void)logout {
////    [[Session shared] close];
////
////    [[APIClient shared] updateAuthorizationHeader:[[Session shared] authHeaderField]];
////
////    [self sessionChanged];
//
//    [[APIClient shared] logout:^(ApiStatus *status, BOOL success) {
//        (status, success);
//    }];
//}

- (void)sessionChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthEvent_UserSessionChanged object:nil];
}

- (void)addObserver:(NSObject *)observer selector:(SEL)selector forEvent:(AuthEvent)event {
    NSString *authEventName = [self p_authEventByType:event];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:authEventName object:nil];
}

- (void)postAuthEvent:(AuthEvent)authEvent {
    NSString *eventName = [self p_authEventByType:authEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:nil];
}

- (void)saveUser:(User *)user token:(NSString *)token {
}

@end
