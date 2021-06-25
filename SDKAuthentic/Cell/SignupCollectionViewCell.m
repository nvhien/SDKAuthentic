//
//  SignupCollectionViewCell.m
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "SignupCollectionViewCell.h"

@implementation SignupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)resetData {
    _usernameTextField.text = @"";
    _passwordTextField.text = @"";
    _passwordConfirmTextField.text = @"";
}

- (IBAction)backButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signupCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signupCollectionCell:self actionWithType:BackToSignin secretName:_usernameTextField.text secretPassword:_passwordTextField.text];
    }
}

- (IBAction)signupFacebookButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signupCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signupCollectionCell:self actionWithType:SignupFacebook secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signupGoogleButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signupCollectionCell:actionWithType:secretName:secretPassword:)]) {
        [_delegate signupCollectionCell:self actionWithType:SignupGoogle secretName:@"" secretPassword:@""];
    }
}

- (IBAction)signupButtonSelected:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(signupCollectionCell:registerName:password:passwordConfirm:)]) {
        [_delegate signupCollectionCell:self registerName:_usernameTextField.text password:_passwordTextField.text passwordConfirm:_passwordConfirmTextField.text];
    }
}

- (IBAction)showPasswordButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    [_passwordTextField setSecureTextEntry:!_passwordTextField.secureTextEntry];
}

- (IBAction)showPasswordConfirmButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    [_passwordConfirmTextField setSecureTextEntry:!_passwordConfirmTextField.secureTextEntry];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.contentView endEditing:YES];
}

@end
