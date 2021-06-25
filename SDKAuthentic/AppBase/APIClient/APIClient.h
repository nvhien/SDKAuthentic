//
//  APIClient.h

//
//  Created by Toan Nguyen on 1/13/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ApiDataObjects.h"

@interface APIClient : NSObject
#pragma mark - Initialize
+ (instancetype)shared;

- (void)setApiHost:(NSString *)host;

#pragma mark - Content Id
- (void)setContentId:(NSInteger)contentId;

- (NSString *)newsUrl;

- (void)updateAuthorizationHeader:(NSString *)token;

- (void)cancelAllRequest;

#pragma mark - Register
- (void)registerAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void (^)(User *,ApiStatus * , NSError *))completion;

#pragma mark - Login
- (void)loginWithAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void(^)(User *, ApiStatus *, NSError *))completion;

#pragma mark - Login
- (void)loginWithGuest:(NSString *)guestId gameId:(NSInteger)gameId completion:(void(^)(User *, ApiStatus *, NSError *))completion;

- (void)loginWithFacebookToken:(NSString *)token appId:(NSInteger)appId completion:(void(^)(NSString *, User *, NSError *))completion;

- (void)refreshToken:(NSString *)token completion:(void(^)(NSString *))completion;

- (void)verifyToken:(NSString *)token completion:(void(^)(User *, BOOL))completion;

#pragma mark - User
- (void)getUserInfo:(void(^)(User *, BOOL))completion;
- (void)updateUserInfo:(User *)user completion:(void(^)(User *, BOOL))completion;

#pragma mark - Email Api
- (void)changePassword:(NSString *)password newPassword:(NSString *)newPassword passworConfirm:(NSString *)passwordConfirm completion:(void(^)(BOOL, id))completion;

- (void)sendOtpEmail:(NSString *)email completion:(void(^)(NSString *))completion;

- (void)resendOtp:(NSString *)otpSession completion:(void(^)(NSString *))completion;

- (void)verifyOtp:(NSString *)otp otpSession:(NSString *)otpSession completion:(void(^)(NSString *,BOOL))completion;

- (void)sendOldOtp:(NSString *)email completion:(void(^)(NSString *))completion;

- (void)sendNewOtp:(NSString *)email completion:(void(^)(NSString *))completion;

- (void)logout:(void(^)(ApiStatus *, BOOL))completion;

#pragma mark - Password APi
- (void)addPassword:(NSString *)password completion:(void(^)(BOOL))completion;

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void(^)(BOOL))completion;

- (void)forgotPassword:(NSString *)email completion:(void(^)(NSString *, BOOL))completion;

- (void)verifyOtpPassword:(NSString *)otp otpSession:(NSString *)otpSession completion:(void(^)(BOOL))completion;

- (void)resetPassword:(NSString *)newPass otpSession:(NSString *)otpSession completion:(void(^)(BOOL))completion;

#pragma mark - In App purchase APi

- (void)getListIAP:(NSString *)packageName completion:(void(^)(IapList *,BOOL))completion;

- (void)createTransaction:(NSString *)userId serverId:(NSString *)serverId productId:(NSString *)productId gameClientTransId:(NSString *)gameClientTransId completion:(void(^)(NSString *,BOOL))completion;

- (void)updatePaymentStatus:(NSString *)packageName productId:(NSString *)productId purchaseToken:(NSString *)purchaseToken password:(NSString *)password receiptData:(NSString *)receiptData completion:(void(^)(BOOL))completion;

@end
