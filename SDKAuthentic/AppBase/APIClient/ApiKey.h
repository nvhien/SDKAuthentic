//
//  ApiKey.h

//
//  Created by thanhvu on 11/26/15.
//  Copyright © 2015 Zilack. All rights reserved.
//

#ifndef ApiKey_h
#define ApiKey_h

#define APPLICATION_BUNDLE_IDENTIFIER    [[NSBundle mainBundle] bundleIdentifier]
#define APPLICATION_API_HOST @"api.launcher.skw.vn/"

#define APPLICATION_PLATFORM_IOS                            @"ios"
#define UDID                                                [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define PURCHASE_TYPE                                       @"APP_STORE"

typedef enum {
    ApiCodeSuccess = 0,
    ApiCodeError = 1
} ApiCode;

typedef NS_OPTIONS(NSInteger, CategoryType) {
    CategoryTypePhoto   = 1,
    CategoryTypeVideo   = 2
};

// API PARAMETERS
#define API_PARAM_DATA                  @"data"
#define API_PARAM_ID                    @"id"
#define API_PARAM_GAME_ID               @"gameId"
#define API_PARAM_CGUUID                @"cgUuid"
#define API_PARAM_GUEST_ID              @"guestId"
#define API_PARAM_ACCOUNT               @"account"
#define API_PARAM_USER_NAME             @"userName"
#define API_PARAM_PASSWORD              @"password"
#define API_PARAM_APP_KEY               @"appKey"
#define API_PARAM_DEVICE_INFO           @"deviceInfo"
#define API_PARAM_DEVICE_ID             @"deviceId"
#define API_PARAM_GUEST_ID              @"guestId"
#define API_PARAM_OLD_PASSWORD          @"oldPassword"
#define API_PARAM_NEW_PASSWORD          @"newPassword"
#define API_PARAM_FULLNAME              @"fullName"
#define API_PARAM_CMND_NUMBER           @"cmndNumber"
#define API_PARAM_CMND_CREATE_DATE      @"cmndCreateDate"
#define API_PARAM_CMND_CREATE_PLACE     @"cmndCreatePlace"
#define API_PARAM_ADDRESS               @"address"
#define API_PARAM_OTP_SESSION           @"otpSession"
#define API_PARAM_SESSION               @"session"
#define API_PARAM_OTP                   @"otp"
#define API_PARAM_NEW_PASS              @"newPass"
#define API_PARAM_CODE                  @"code"
#define API_PARAM_MESSAGE               @"message"
#define API_PARAM_ACCESS_TOKEN          @"accessToken"
#define API_PARAM_AT                    @"at"
#define API_PARAM_REQUEST_ID            @"requestId"
#define API_PARAM_ERROR                 @"error"
#define API_APP_KEY                     @"appKey"
#define API_PARAM_EMAIL                 @"email"
#define API_PARAM_BIRTHDAY              @"birthday"
#define API_PARAM_PAYMENT_CHANNEL       @"paymentChannel"
#define API_PARAM_SERVER_ID             @"serverId"
#define API_PARAM_USER_ID               @"userId"
#define API_PARAM_PRODUCT_ID            @"productId"
#define API_PARAM_GAME_CLIENT_TRANS_ID  @"gameClientTransId"
#define API_PARAM_PACKAGE_NAME          @"packageName"
#define API_PARAM_NAME                  @"name"
#define API_PARAM_PURCHASE_TOKEN        @"purchaseToken"
#define API_PARAM_RECEIPT_DATA          @"receiptData"

// API REQUEST
#define API_REQUEST_LOGIN_SKW                   @"user/login/skw"
#define API_REQUEST_LOGIN_GUEST                 @"user/login/guest"
#define API_REQUEST_USER_LOGOUT                 @"user/logout"
#define API_REQUEST_VERIFY_SESSION              @"user/verifySession"
#define API_REQUEST_REGISTER                    @"user/register"
#define API_REQUEST_INFO                        @"user/info"
#define API_REQUEST_CHANGE_PASS                 @"user/changePass"
#define API_REQUEST_REFRESH_TOKEN               @"user/refreshToken?session=%@"
#define API_REQUEST_UPDATE_PROFILE              @"user/info/update"
#define API_REQUEST_SEND_OPT                    @"user/email/add/sendOtp?email=%@"
#define API_REQUEST_SEND_NEW_OTP                @"user/email/change/sendNewOtp"
#define API_REQUEST_SEND_OLD_OTP                @"user/email/change/sendOldOtp"
#define API_REQUEST_VERIFY_OTP                  @"user/email/verifyOtp"
#define API_REQUEST_RESEND_OTP                  @"user/email/resendOtp"
#define API_REQUEST_ADD_PASSWORD                @"user/addPassword"
#define API_REQUEST_FORGET_PASSWORD             @"user/forgetPassword"
#define API_REQUEST_VERIFY_OTP_PASSWORD         @"user/verifyOtpPassword"
#define API_REQUEST_RESET_PASSWORD              @"user/resetPassword"
#define API_REQUEST_RESEND_OTP_FORGET_PASSWORD  @"user/resendOtpForgetPassword"
#define API_REQUEST_CREATE_TRANSACTION          @"transaction/create"
#define API_REQUEST_UPDATE_PAYMENT_STATUS       @"transaction/updatePaymentStatus"
#define API_REQUEST_GET_LIST_PRODUCT            @"transaction/listProduct"

#endif /* ApiKey_h */
