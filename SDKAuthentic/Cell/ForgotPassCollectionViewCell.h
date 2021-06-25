//
//  ForgotPassCollectionViewCell.h
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import <UIKit/UIKit.h>
#import "OTPTextField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ActionTypeForgot) {
    ConfirmOtp,
    ResetPassword,
    SendOtp,
    Back
};

@class ForgotPassCollectionViewCell;
@protocol ForgotPassCollectionViewCellDelegate <NSObject>

@optional
- (void)forgotPassCollectionCell:(ForgotPassCollectionViewCell *)cell actionWithType:(ActionTypeForgot)type otp:(NSString *)otp;
- (void)sendOtp:(ForgotPassCollectionViewCell *)cell email:(NSString *)email;
- (void)confirmOtp:(ForgotPassCollectionViewCell *)cell  otp:(NSString *)otp ;
- (void)resetPassword:(ForgotPassCollectionViewCell *)cell  newPass:(NSString *)newPass  newPassConfirm:(NSString *)newPassConfirm;
@end

@interface ForgotPassCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet OTPTextField *otpTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *passConfirmTextField;

@property (weak, nonatomic) IBOutlet UILabel *resendOtpLabel;

@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIView *passConfirmView;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *sendOtpButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) ActionTypeForgot type;
@property (weak, nonatomic) id<ForgotPassCollectionViewCellDelegate> delegate;

- (void) refresh;
- (void) resetData;
@end

NS_ASSUME_NONNULL_END
