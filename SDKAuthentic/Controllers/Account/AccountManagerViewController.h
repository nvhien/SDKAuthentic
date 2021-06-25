//
//  AccountManagerViewController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AccountManagerViewControllerCallback)(UserAction key, NSString *value);

typedef NS_OPTIONS(NSInteger, AccountScreenState) {
    AccountScreenStateUnknow            = 0,
    AccountScreenStateSignin            = 1,
    AccountScreenStateSignup            = 2,
    AccountScreenStateProfile           = 3,
    AccountScreenStateForgotPassword    = 4,
    
};

@interface AccountManagerViewController : BaseViewController

@property (nonatomic, strong) NSString *otpSession;

@property (nonatomic, copy) AccountManagerViewControllerCallback completedCallback;

@end

NS_ASSUME_NONNULL_END
