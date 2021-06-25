//
//  APIClient.m

//
//  Created by Toan Nguyen on 1/13/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "APIClient.h"
#import "AFHTTPSessionManager.h"
#import "ApiKey.h"
#import "Macro.h"
#import "ZLUtilities.h"
#import "Session.h"
#import "LocalStored.h"
#import "IapList.h"

@interface APIClient(){
    AFHTTPSessionManager *_manager;
    NSString *_host;
}

@property (nonatomic, assign, readonly) NSInteger contentId;

+ (void)logError:(NSError *)error;

- (NSString *)apiBaseUrl;

@end


@implementation APIClient

+ (void)logError:(NSError *)error {
    DLog(@"ERROR:%@", error);
}

#pragma mark - Initialize
+ (instancetype)shared {
    static APIClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setApiHost:(NSString *)host {
    _host = host;
    if (_host) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: [self apiBaseUrl]]];
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_manager.requestSerializer setTimeoutInterval:20.0];
    }
}

- (NSString *)apiBaseUrl {
    return [NSString stringWithFormat:@"https://%@/", _host];//nvhien
//    return [NSString stringWithFormat:@"http://%@/", _host];
}

#pragma mark - Content Id
- (void)setContentId:(NSInteger)contentId {
    _contentId = contentId;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)updateAuthorizationHeader:(NSString *)token {
    DLog(@"--- TOKEN : %@ ---", token);
    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

- (void)cancelAllRequest {
    if (_manager) {
        [_manager.operationQueue cancelAllOperations];
    }
}

#pragma mark - Register
- (void)registerAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void (^)(User *, ApiStatus *, NSError *))completion {
    [_manager POST:API_REQUEST_REGISTER parameters:@{
                API_PARAM_GAME_ID : @(gameId),
                API_PARAM_USER_NAME : userName,
                API_PARAM_PASSWORD : password
                } headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                completion(nil, status, nil);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil, nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, nil, error);
        }
    }];
}

#pragma mark - Login

- (void)loginWithAccount:(NSString *)userName password:(NSString *)password gameId:(NSInteger)gameId completion:(void (^)(User *, ApiStatus *, NSError *))completion {
//    DLog(@"UDID : ", [[UIDevice currentDevice] adver]);
    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", UDID);
    [_manager POST:API_REQUEST_LOGIN_SKW
        parameters:@{
                API_PARAM_GAME_ID : @(gameId),
                API_PARAM_USER_NAME : userName,
                API_PARAM_PASSWORD : password,
                API_PARAM_APP_KEY : @"xxxxx",
                API_PARAM_DEVICE_INFO : UDID
                }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            User *user = [User parseObject:responseObject[API_PARAM_DATA]];
            if (status.code == ApiCodeSuccess) {
                [Session shared].user = user;
                [Session shared].sessionToken = user.accessToken;
                [LocalStored setAccessToken:user.accessToken];
                [self updateAuthorizationHeader:[[Session shared] authHeaderField]];
                completion(user, status, nil);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil, nil, nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, nil, error);
        }
    }];
}

- (void)loginWithGuest:(NSString *)guestId gameId:(NSInteger)gameId completion:(void (^)(User *, ApiStatus *, NSError *))completion {
    [_manager POST:API_REQUEST_LOGIN_GUEST
        parameters:@{
                API_PARAM_GAME_ID : @(gameId),
                API_PARAM_GUEST_ID : UDID,
                API_PARAM_APP_KEY : @"xxx",
                API_PARAM_DEVICE_INFO : UDID
                }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            User *user = [User parseObject:responseObject[API_PARAM_DATA]];
            if (status.code == ApiCodeSuccess) {
                [Session shared].user = user;
                [Session shared].sessionToken = user.accessToken;
                [LocalStored setAccessToken:user.accessToken];
                [self updateAuthorizationHeader:[[Session shared] authHeaderField]];
                completion(user, status, nil);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil, nil, nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, nil, error);
        }
    }];
}

- (void)verifyToken:(NSString *)token completion:(void (^)(User *, BOOL))completion {
    [Session shared].sessionToken = token;
    [self updateAuthorizationHeader:[[Session shared] authHeaderField]];
    [_manager POST:API_REQUEST_VERIFY_SESSION
        parameters:@{}
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            User *user = [User parseObject:responseObject[API_PARAM_DATA]];
            if (status.code == ApiCodeSuccess) {
                completion(user, YES);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil, NO);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

#pragma mark - User
- (void)getUserInfo:(void (^)(User *, BOOL))completion {
    [_manager GET:API_REQUEST_INFO
        parameters:@{}
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            User *user = [User parseObject:responseObject[API_PARAM_DATA]];
            if (status.code == ApiCodeSuccess) {
                [Session shared].user = user;
                completion(user, YES);
            }
            else{
                [Session shared].user = nil;
                [ZLUtilities showToast:status.message];
                completion(nil, NO);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

- (void)updateUserInfo:(User *)user completion:(void (^)(User *, BOOL))completion {
    [_manager POST:API_REQUEST_UPDATE_PROFILE
        parameters:@{
            API_PARAM_FULLNAME : user.fullName,
            API_PARAM_BIRTHDAY : user.birthday,
            API_PARAM_CMND_NUMBER : user.cmndNumber,
            API_PARAM_DEVICE_INFO : UDID,
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                [ZLUtilities showToast:status.message];
                completion(user, YES);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil, NO);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

- (void)sendOtpEmail:(NSString *)email completion:(void (^)(NSString *))completion {
    [_manager GET:[NSString stringWithFormat:API_REQUEST_SEND_OPT, email]
        parameters:@{}
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * otpSession = [responseObject valueForKey:API_PARAM_DATA];
                DLog(@"OTP Session : %@", otpSession);
                completion(otpSession);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil);
        }
    }];
}

- (void)resendOtp:(NSString *)otpSession completion:(void (^)(NSString *))completion {
    [_manager POST:API_REQUEST_RESEND_OTP
        parameters:@{
            API_PARAM_OTP_SESSION : otpSession,
            API_PARAM_DEVICE_INFO : UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * otpSession = [responseObject valueForKey:API_PARAM_DATA];
                DLog(@"OTP Session : %@", otpSession);
                completion(otpSession);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil);
        }
    }];
}

- (void)verifyOtp:(NSString *)otp otpSession:(NSString *)otpSession completion:(void (^)(NSString *, BOOL))completion {
    [_manager POST:API_REQUEST_VERIFY_OTP
        parameters:@{
            API_PARAM_OTP : otp,
            API_PARAM_OTP_SESSION : otpSession,
            API_PARAM_DEVICE_INFO : UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * otpSession = [responseObject valueForKey:API_PARAM_DATA];
                completion(otpSession, YES);
            }
            else{
                completion(nil, NO);
                [ZLUtilities showToast:status.message];
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

- (void)sendOldOtp:(NSString *)email completion:(void (^)(NSString *))completion {
    [_manager POST:API_REQUEST_SEND_OLD_OTP
        parameters:@{
            API_PARAM_EMAIL: email
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * otpSession = [responseObject valueForKey:API_PARAM_DATA];
                DLog(@"OTP Session : %@", otpSession);
                completion(otpSession);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil);
        }
    }];
}

- (void)sendNewOtp:(NSString *)email completion:(void (^)(NSString *))completion {
    [_manager POST:API_REQUEST_SEND_NEW_OTP
        parameters:@{
            API_PARAM_EMAIL: email
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * otpSession = [responseObject valueForKey:API_PARAM_DATA];
                DLog(@"OTP Session : %@", otpSession);
                completion(otpSession);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(nil);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil);
        }
    }];
}

#pragma mark - Password APi
- (void)addPassword:(NSString *)password completion:(void (^)(BOOL))completion {
    [_manager POST:API_REQUEST_ADD_PASSWORD
        parameters:@{
            API_PARAM_PASSWORD: password,
            API_PARAM_DEVICE_INFO: UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                [ZLUtilities showToast:status.message];
                completion(YES);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(NO);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(NO);
        }
    }];
}

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void (^)(BOOL))completion {
    NSLog(@"Old password : %@   %@", oldPassword, newPassword);
    [_manager POST:API_REQUEST_CHANGE_PASS
        parameters:@{
            API_PARAM_OLD_PASSWORD: oldPassword,
            API_PARAM_NEW_PASSWORD: newPassword
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                [ZLUtilities showToast:status.message];
                completion(YES);
            }
            else{
                [ZLUtilities showToast:status.message];
                completion(NO);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(NO);
        }
    }];
}

- (void)forgotPassword:(NSString *)email completion:(void (^)(NSString *, BOOL))completion {
    DLog(@"API_PARAM_DEVICE_INFO : %@", UDID);
    [_manager POST:API_REQUEST_FORGET_PASSWORD
        parameters:@{
            API_PARAM_USER_NAME : email,
            API_PARAM_DEVICE_INFO : UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSDictionary * dict = [responseObject valueForKey:API_PARAM_DATA];
//                NSString *otpSession = dict[@"session"];
                NSString *otpSession = dict[@"session"];
                completion(otpSession, YES);
            }
            else{
                completion(nil, NO);
                [ZLUtilities showToast:status.message];
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil,NO);
        }
    }];
}

- (void)verifyOtpPassword:(NSString *)otp otpSession:(NSString *)otpSession completion:(void (^)(BOOL))completion {
    [_manager POST:API_REQUEST_VERIFY_OTP_PASSWORD
        parameters:@{
            API_PARAM_OTP : otp,
            API_PARAM_OTP_SESSION : otpSession,
            API_PARAM_DEVICE_INFO : UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                [ZLUtilities showToast:status.message];
                completion(YES);
            }
            else{
                completion(NO);
                [ZLUtilities showToast:status.message];
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(NO);
        }
    }];
}

- (void)resetPassword:(NSString *)newPass otpSession:(NSString *)otpSession completion:(void (^)(BOOL))completion {
    [_manager POST:API_REQUEST_RESET_PASSWORD
        parameters:@{
            API_PARAM_NEW_PASS : newPass,
            API_PARAM_OTP_SESSION : otpSession,
            API_PARAM_DEVICE_INFO : UDID
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                [ZLUtilities showToast:status.message];
                completion(YES);
            }
            else{
                completion(NO);
                [ZLUtilities showToast:status.message];
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(NO);
        }
    }];
}

#pragma mark - Logout
- (void)logout:(void (^)(ApiStatus *, BOOL))completion {
    [_manager POST:API_REQUEST_USER_LOGOUT
        parameters:@{}
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            [LocalStored setAccessToken:nil];
            completion(status, YES);
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil,YES);
        }
    }];
}

#pragma mark - In App purchase APi
- (void)createTransaction:(NSString *)userId serverId:(NSString *)serverId productId:(NSString *)productId gameClientTransId:(NSString *)gameClientTransId completion:(void (^)(NSString *, BOOL))completion {
    [_manager POST:API_REQUEST_CREATE_TRANSACTION
        parameters:@{
            API_PARAM_PAYMENT_CHANNEL : PURCHASE_TYPE,
            API_PARAM_SERVER_ID : serverId,
            API_PARAM_USER_ID : userId,
            API_PARAM_DEVICE_INFO : UDID,
            API_PARAM_PRODUCT_ID : productId,
            API_PARAM_GAME_CLIENT_TRANS_ID : gameClientTransId
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                NSString * transactionId = [responseObject valueForKey:API_PARAM_DATA];
                completion(transactionId, YES);
                [ZLUtilities showToast:status.message];
            }
            else{
                completion(nil, YES);
                [ZLUtilities showToast:status.message];
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

- (void)updatePaymentStatus:(NSString *)packageName productId:(NSString *)productId purchaseToken:(NSString *)purchaseToken password:(NSString *)password receiptData:(NSString *)receiptData completion:(void (^)(BOOL))completion {
    [_manager GET:API_REQUEST_CREATE_TRANSACTION
        parameters:@{
            API_PARAM_PAYMENT_CHANNEL : PURCHASE_TYPE,
            API_PARAM_PACKAGE_NAME : packageName,
            API_PARAM_PRODUCT_ID : productId,
            API_PARAM_PURCHASE_TOKEN : purchaseToken,
            API_PARAM_PASSWORD : password,
            API_PARAM_RECEIPT_DATA : receiptData
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            completion(YES);
        }
    }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(NO);
        }
        
    }];
}

- (void)getListIAP:(NSString *)packageName completion:(void (^)(IapList *,BOOL))completion {
    [_manager GET:API_REQUEST_GET_LIST_PRODUCT
        parameters:@{
            API_PARAM_PACKAGE_NAME: packageName
        }
        headers:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            ApiStatus *status = [ApiStatus parseObject:responseObject[API_PARAM_ERROR]];
            if (status.code == ApiCodeSuccess) {
                IapList *list = [IapList parseObject:[responseObject valueForKey:API_PARAM_DATA]];
                completion(list, YES);
            }
            else {
                completion(nil, YES);
            }
        }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            [APIClient logError:error];
            completion(nil, NO);
        }
    }];
}

@end
