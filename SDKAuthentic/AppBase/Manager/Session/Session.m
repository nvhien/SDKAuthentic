//
//  Session.m

//
//  Created by Toan Nguyen on 3/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "Session.h"

@interface Session()
@end

@implementation Session

+ (instancetype)shared {
    static Session *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        shared.appId = -1;
        shared.forgotType = SendOtp;
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setContentId:(NSInteger)contentId {
    _appContentId = contentId;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
}

- (void)setAppId:(NSInteger)appid {
    _appId = appid;
}

- (void)setAppStoreUrl:(NSString *)url {
    _storeUrl = url;
}

- (NSString *)authHeaderField {
    if (_sessionToken) {
        return [NSString stringWithFormat:@"Bearer %@",_sessionToken];
    }
    return nil;
}

- (BOOL)signedIn {
    return self.user != nil && self.sessionToken != nil;
}

- (void)setSessionToken:(NSString *)sessionToken {
    _sessionToken = sessionToken;
}

- (void)close {
    _sessionToken = nil;
    _user = nil;
    /*
    _appContentId = -1;
    _appId = -1;
    
    _storeCollection = nil;
     */
}

@end
