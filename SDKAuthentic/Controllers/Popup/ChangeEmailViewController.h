//
//  ChangeEmailViewController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 26/05/2021.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OTPTextField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ChangeEmailScreenState) {
    Unknow            = 0,
    AddEmail          = 1,
    UpdateEmail       = 2,
    
};

@interface ChangeEmailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet OTPTextField *otpTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UIView *oldEmailView;

@property (weak, nonatomic) IBOutlet UILabel *oleEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *resendOtpLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *sendOtpButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSString *otpSession;
@property (nonatomic, assign) ChangeEmailScreenState type;
@property (nonatomic, assign) BOOL isGetOldOtp;
@property (nonatomic, assign) BOOL isFirstGetOtp;

@end

NS_ASSUME_NONNULL_END
