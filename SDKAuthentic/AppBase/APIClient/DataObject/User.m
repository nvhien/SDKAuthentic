//
//  User.m
//
//  Created by Toan Nguyen on 3/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "User.h"
#import "AppUtils.h"

@implementation User
+ (id)parseObject:(id)obj {
    if (!obj || [NSNull null] == obj) {
        return nil;
    }
    User *user = [User new];
    
    user.gameId                     = [obj intValueKey:API_PARAM_GAME_ID];
    user.account                    = [obj stringValueKey:API_PARAM_ACCOUNT];
    user.userName                   = [obj stringValueKey:API_PARAM_USER_NAME];
    user.session                    = [obj stringValueKey:API_PARAM_SESSION];
    user.userId                     = [obj stringValueKey:API_PARAM_ID];
    user.cgUuid                     = [obj stringValueKey:API_PARAM_CGUUID];
    user.accessToken                = [obj stringValueKey:API_PARAM_ACCESS_TOKEN];
    user.deviceId                   = [obj stringValueKey:API_PARAM_DEVICE_ID];
    user.email                      = [obj stringValueKey:API_PARAM_EMAIL];
    user.password                   = [obj stringValueKey:API_PARAM_PASSWORD];
    user.fullName                   = [obj stringValueKey:API_PARAM_FULLNAME];
    user.cmndNumber                 = [obj stringValueKey:API_PARAM_CMND_NUMBER];
    user.cmndCreateDate             = [obj stringValueKey:API_PARAM_CMND_CREATE_DATE];
    user.cmndCreatePlace            = [obj stringValueKey:API_PARAM_CMND_CREATE_PLACE];
    NSString *birthDateString =     [obj stringValueKey:API_PARAM_BIRTHDAY];
    if (birthDateString != nil) {
        user.birthday =             [AppUtils formatDate:birthDateString];
    }
    user.address                    = [obj stringValueKey:API_PARAM_ADDRESS];
    user.deviceInfo                 = [obj stringValueKey:API_PARAM_DEVICE_INFO];
    
    return user;
}
@end
