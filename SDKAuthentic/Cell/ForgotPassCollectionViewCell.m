//
//  ForgotPassCollectionViewCell.m
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "ForgotPassCollectionViewCell.h"
#import "Session.h"

@interface ForgotPassCollectionViewCell () {
    NSTimer *timer;
    int count;
}

- (void)_timerFired:(NSTimer *)timer;

@end

@implementation ForgotPassCollectionViewCell

- (void)_timerFired:(NSTimer *)timer {
    count -= 1;
    if (count <= 0) {
        count = 60;
        _resendOtpLabel.text = @"Gửi lại mã OTP";
        [self resetTimer];
        [_sendOtpButton setEnabled:YES];
        [_sendOtpButton setAlpha:1.0];
    }
    else{
        _resendOtpLabel.text = [NSString stringWithFormat:@"Gửi lại mã sau (%ds)", count];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    count = 60;
}

- (void)refresh {
    switch ([Session shared].forgotType) {
        case SendOtp:
        {
            [_emailTextField  setEnabled:YES];
            [_emailView setHidden:NO];
            [_otpView setHidden:YES];
            [_passView setHidden:YES];
            [_passConfirmView setHidden:YES];
            [_updateButton setEnabled:NO];
            [_updateButton setAlpha:0.5];
        }
            break;
        case ConfirmOtp:
        {
            [_emailTextField  setEnabled:NO];
            [_otpView setHidden:NO];
            [_passView setHidden:YES];
            [_passConfirmView setHidden:YES];
            [_updateButton setEnabled:YES];
            [_updateButton setAlpha:1.0];
        }
            break;
        case ResetPassword:
        {
            [_emailView setHidden:YES];
            [_otpView setHidden:YES];
            [_passView setHidden:NO];
            [_passConfirmView setHidden:NO];
        }
            break;
        default:
            break;
    }
}

- (void)resetData {
    _emailTextField.text = @"";
    _otpTextField.text = @"";
    _passTextField.text = @"";
    _passConfirmTextField.text = @"";
}

- (void) setupTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerFired:) userInfo:nil repeats:YES];
}

- (void) resetTimer {
    count = 60;
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

- (IBAction)confirmButtonSelected:(id)sender {
    switch ([Session shared].forgotType) {
        case ConfirmOtp:
        {
            [self resetTimer];
            if (_delegate && [_delegate respondsToSelector:@selector(confirmOtp:otp:)]) {
                [_delegate confirmOtp:self otp:_otpTextField.text];
            }
        }
            break;
        case ResetPassword:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(resetPassword:newPass:newPassConfirm:)]) {
                [_delegate resetPassword:self newPass:_passTextField.text newPassConfirm:_passConfirmTextField.text];
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)backButtonSelected:(id)sender {
    [self resetTimer];
    _emailTextField.text = @"";
    _passTextField.text = @"";
    _passConfirmTextField.text = @"";
    _otpTextField.text = @"";
    _resendOtpLabel.text = @"Gửi lại mã OTP";
    if (_delegate && [_delegate respondsToSelector:@selector(forgotPassCollectionCell:actionWithType:otp:)]) {
        [_delegate forgotPassCollectionCell:self actionWithType:Back otp:@""];
    }
}

- (IBAction)sendOTPButtonSelected:(id)sender {
    [self resetTimer];
    [self setupTimer];
    if (_delegate && [_delegate respondsToSelector:@selector(sendOtp:email:)]) {
        [_delegate sendOtp:self email: _emailTextField.text];
    }
}

- (IBAction)showPasswordButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    if (button.tag == 0) {
        [_passTextField setSecureTextEntry:!_passTextField.secureTextEntry];
    }
    else if (button.tag == 1) {
        [_passConfirmTextField setSecureTextEntry:!_passConfirmTextField.secureTextEntry];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.contentView endEditing:YES];
}

@end
