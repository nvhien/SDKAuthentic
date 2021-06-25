//
//  ChangeEmailViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 26/05/2021.
//

#import "ChangeEmailViewController.h"
#import "ZLUtilities.h"
#import "Constants.h"
#import "APIClient.h"
#import "AppUtils.h"
#import "Session.h"

@interface ChangeEmailViewController () {
    NSTimer *timer;
    int count;
}

- (void)_timerFired:(NSTimer *)timer;
- (void)refresh;

@end

@implementation ChangeEmailViewController

- (void)_timerFired:(NSTimer *)timer {
    count -= 1;
    if (count <= 0) {
        count = 60;
        _resendOtpLabel.text = @"Gửi lại mã OTP";
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
        [_sendOtpButton setEnabled:YES];
        [_sendOtpButton setAlpha:1.0];
    }
    else{
        _resendOtpLabel.text = [NSString stringWithFormat:@"Gửi lại mã sau (%ds)", count];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupUI];
    [self refresh];
    
}

- (void)p_setupUI {
    count = 60;
    [_otpView setHidden:YES];
    _isGetOldOtp = NO;
    _isFirstGetOtp = YES;
    [_updateButton setEnabled:NO];
    [_updateButton setAlpha:0.5];
}

- (void)refresh {
    User *user = [Session shared].user;
    if (user) {
        if (user.email) {
            _emailTextField.text = [AppUtils maskEmail:user.email];
            [_oldEmailView setHidden:NO];
            [_updateButton setTitle:@"Xác nhận" forState:UIControlStateNormal];
            [_updateButton setEnabled:NO];
            if (_type == UpdateEmail) {
                [_emailTextField setEnabled:NO];
            }
        }
        else{
            [_oldEmailView setHidden:YES];
        }
    }
}

- (void)sendOtpEmail {
    [self hideKeyboard];
    if ([_emailTextField.text length] == 0) {
        [ZLUtilities showToast:EMAIL_EMPTY];
        return;
    }
    
    if (![AppUtils validateEmail:_emailTextField.text]) {
        [ZLUtilities showToast:EMAIL_INVALID];
        return;
    }
    
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] sendOtpEmail:_emailTextField.text completion:^(NSString *otp) {
        [self showLoading:NO];
        if (otp != nil) {
            weakSelf.isFirstGetOtp = NO;
            weakSelf.otpSession = otp;
            [weakSelf setupTimer];
            [weakSelf.otpView setHidden:NO];
            [weakSelf.updateButton setEnabled:YES];
            [weakSelf.updateButton setAlpha:1.0];
            [weakSelf.emailTextField setEnabled:NO];
        }
    }];
}

- (void)sendOldOtp {
    User *user = [Session shared].user;
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] sendOldOtp:user.email completion:^(NSString *otp) {
        [self showLoading:NO];
        if (otp != nil) {
            weakSelf.isFirstGetOtp = NO;
            weakSelf.otpSession = otp;
            [weakSelf setupTimer];
            [weakSelf.emailTextField setEnabled:NO];
            [weakSelf.otpView setHidden:NO];
            [weakSelf.updateButton setEnabled:YES];
            [weakSelf.updateButton setAlpha:1.0];
            [weakSelf.sendOtpButton setEnabled:NO];
            [weakSelf.sendOtpButton setAlpha:0.5];
        }
    }];
}

- (void)sendNewOtp {
    [self hideKeyboard];
    if ([_emailTextField.text length] == 0) {
        [ZLUtilities showToast:EMAIL_EMPTY];
        return;
    }
    if (![AppUtils validateEmail:_emailTextField.text]) {
        [ZLUtilities showToast:EMAIL_INVALID];
        return;
    }
    
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] sendNewOtp:_emailTextField.text completion:^(NSString *otp) {
        [self showLoading:NO];
        if (otp != nil) {
            weakSelf.isFirstGetOtp = NO;
            weakSelf.otpSession = otp;
            [weakSelf setupTimer];
            [weakSelf.emailTextField setEnabled:NO];
            [weakSelf.updateButton setEnabled:YES];
            [weakSelf.updateButton setAlpha:1.0];
            [weakSelf.otpView setHidden:NO];
            [weakSelf.sendOtpButton setEnabled:NO];
            [weakSelf.sendOtpButton setAlpha:0.5];
        }
    }];
}

- (void)resendOtp {
    [self hideKeyboard];
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] resendOtp:_otpSession completion:^(NSString *otp) {
        [self showLoading:NO];
        if (otp != nil) {
            weakSelf.otpSession = otp;
            [weakSelf setupTimer];
            [weakSelf.emailTextField setEnabled:NO];
            [weakSelf.updateButton setEnabled:YES];
            [weakSelf.updateButton setAlpha:1.0];
            [weakSelf.otpView setHidden:NO];
            [weakSelf.sendOtpButton setEnabled:NO];
            [weakSelf.sendOtpButton setAlpha:0.5];
        }
    }];
}

- (IBAction)sendOtpButtonSelected:(id)sender {
    switch (_type) {
        case AddEmail:
            if (_isFirstGetOtp) {
                [self sendOtpEmail];
            }
            else{
                [self resendOtp];
            }
            
            break;
        case UpdateEmail:
            if (!_isGetOldOtp) {
                if (_isFirstGetOtp) {
                    [self sendOldOtp];
                }
                else{
                    [self resendOtp];
                }
            }
            else{
                if (_isFirstGetOtp) {
                    [self sendNewOtp];
                }
                else{
                    [self resendOtp];
                }
            }
            break;
        default:
            break;
    }
}

- (void) setupTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerFired:) userInfo:nil repeats:YES];
}

- (IBAction)updateEmailButtonSelected:(id)sender {
    [self hideKeyboard];
    if ([_otpTextField.text length] == 0) {
        [ZLUtilities showToast:OTP_EMPTY];
        return;
    }
    
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] verifyOtp:_otpTextField.text otpSession:_otpSession completion:^(NSString *otpSession, BOOL success) {
        [weakSelf showLoading:NO];
        if (success) {
            switch (weakSelf.type) {
                case AddEmail:
                    [[Session shared] user].email = self.emailTextField.text;
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateProfile"
                                                                        object:nil userInfo:nil];
                    break;
                case UpdateEmail:
                    if (!weakSelf.isGetOldOtp) {
                        weakSelf.isGetOldOtp = YES;
                        [weakSelf.otpView setHidden:YES];
                        [weakSelf.updateButton setEnabled:NO];
                        [weakSelf.updateButton setAlpha:0.5];
                        [weakSelf.emailTextField setEnabled:YES];
                        weakSelf.oleEmailLabel.text = @"Nhập Email mới";
                        weakSelf.otpTextField.text = @"";
                        weakSelf.emailTextField.text = @"";
                        weakSelf.emailTextField.placeholder = @"Nhập Email mới";
                    }
                    else{
                        [[Session shared] user].email = self.emailTextField.text;
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateProfile"
                                                                            object:nil userInfo:nil];
                    }
                    break;
                default:
                    break;
            }
        }
    }];
}

- (IBAction)cancelButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self hideKeyboard];
}

@end
