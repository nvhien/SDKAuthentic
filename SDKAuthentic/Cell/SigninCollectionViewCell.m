//
//  SigninCollectionViewCell.m
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "SigninCollectionViewCell.h"
#import "AppUtils.h"
#import "Constants.h"

@implementation SigninCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSBundle *bundle = [AppUtils getSdkBundle];
    if (FRAMEWORK_ENABLE) {
        if (bundle != nil) {
            NSString *filePath = [bundle pathForResource:@"skw_logo_enabled" ofType:@"png"];
            _logoImageView.image = [UIImage imageWithContentsOfFile:filePath];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image == nil) {
                [ZLUtilities showToast:@"Image skw_logo_enabled nil"];
            }
//            [UIImage imageNamed:@"skw_logo_enabled.png" inBundle:bundle compatibleWithTraitCollection:nil];
        }
    }
    else{
        _logoImageView.image = [UIImage imageNamed:@"skw_logo_enabled"];
    }
}

- (void)resetData {
    _usernameTextField.text = @"";
    _passwordTextField.text = @"";
}

- (IBAction)forgotPasswordButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signinCollectionCell:self actionWithType:ForgotPass secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signinButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:userName:password:)]) {
        [_delegate signinCollectionCell:self userName:_usernameTextField.text password:_passwordTextField.text];
    }
}

- (IBAction)signinFacebookButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signinCollectionCell:self actionWithType:SigninFacebook secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signinGoogleButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signinCollectionCell:self actionWithType:SigninGoogle secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signinGuestButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signinCollectionCell:self actionWithType:SigninGuest secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signupButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signinCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signinCollectionCell:self actionWithType:Signup secretName:@"" secretPassword:@""];
    }
}

- (IBAction)showPinButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    [_passwordTextField setSecureTextEntry:!_passwordTextField.secureTextEntry];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.contentView endEditing:YES];
}

@end
