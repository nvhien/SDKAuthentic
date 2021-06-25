//
//  User.h
//
//  Updated by thanhvu on 4/5/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "ApiResponseObject.h"

@interface User : ApiResponseObject

@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *cgUuid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *cmndNumber;
@property (nonatomic, strong) NSString *cmndCreateDate;
@property (nonatomic, strong) NSString *cmndCreatePlace;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *deviceInfo;

@end
