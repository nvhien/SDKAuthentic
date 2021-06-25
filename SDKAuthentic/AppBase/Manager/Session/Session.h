//
//  Session.h

//
//  Created by Toan Nguyen on 3/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ForgotPassCollectionViewCell.h"


@interface Session : NSObject
+ (instancetype)shared;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString* sessionToken;
@property (nonatomic, assign) ActionTypeForgot forgotType;

@property (nonatomic, strong, readonly) NSString *deviceToken;
@property (nonatomic, assign, readonly) NSInteger appContentId;
@property (nonatomic, assign, readonly) NSInteger appId;
@property (nonatomic, strong, readonly) NSString* storeUrl;
@property (nonatomic, assign) BOOL languageChange;

- (void)setContentId:(NSInteger)contentId;
- (void)setDeviceToken:(NSString *)deviceToken;
- (void)setAppId:(NSInteger)appid;
- (void)setAppStoreUrl:(NSString *)url;

- (void)close;

@property (nonatomic, readonly) BOOL signedIn;
@property (nonatomic, readonly) NSString *authHeaderField;



@end
