//
//  ChangePasswordViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 25/05/2021.
//

#import "ChangePasswordViewController.h"
#import "ZLUtilities.h"
#import "Constants.h"
#import "APIClient.h"
#import "AppUtils.h"
#import "Session.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupUI];
}

- (void)p_setupUI {
    switch (_type) {
        case AddPassword:
            [_oldPasswordView setHidden:YES];
            [_titleView1 setHidden:YES];
            [_titleView2 setHidden:YES];
            [_titleView3 setHidden:YES];
            break;
        case UpdatePassword:
            [_oldPasswordView setHidden:NO];
            [_titleView1 setHidden:NO];
            [_titleView2 setHidden:NO];
            [_titleView3 setHidden:NO];
            break;
        default:
            break;
    }
}

- (IBAction)showPasswordButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    if (button.tag == 0) {
        [_oldPasswordTextField setSecureTextEntry:!_oldPasswordTextField.secureTextEntry];
    }
    else if (button.tag == 1) {
        [_passwordTextField setSecureTextEntry:!_passwordTextField.secureTextEntry];
    }
    else{
        [_passwordConfirmTextField setSecureTextEntry:!_passwordConfirmTextField.secureTextEntry];
    }
}

- (IBAction)updatePasswordButtonSelected:(id)sender {
    [self hideKeyboard];
    if (_type == UpdatePassword) {
        if ([_oldPasswordTextField.text length] == 0) {
            [ZLUtilities showToast:OLD_PASSWORD_EMPTY];
            return;
        }
        if (![AppUtils validatePassword:_oldPasswordTextField.text]) {
            [ZLUtilities showToast:PASSWORD_INVALID];
            return;
        }
    }
    
    if ([_passwordTextField.text length] == 0) {
        [ZLUtilities showToast:PASSWORD_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:_passwordTextField.text]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if ([_passwordConfirmTextField.text length] == 0) {
        [ZLUtilities showToast:PASSWORD_CONFIRM_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:_passwordConfirmTextField.text]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString: _passwordConfirmTextField.text]) {
        [ZLUtilities showToast:PASSWORD_NOT_MATCHING];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    switch (_type) {
        case AddPassword:
        {
            [[APIClient shared] addPassword:_passwordTextField.text completion:^(BOOL success) {
                [weakSelf showLoading:NO];
                if (success) {
                    [[Session shared] user].password = weakSelf.passwordTextField.text;
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateProfile"
                                                                        object:nil userInfo:nil];
                }
            }];
            break;
        }
        case UpdatePassword:
        {
            [[APIClient shared] changePassword:_oldPasswordTextField.text newPassword:_passwordTextField.text completion:^(BOOL success) {
                [weakSelf showLoading:NO];
                if (success) {
                    [[Session shared] user].password = weakSelf.passwordTextField.text;
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateProfile"
                                                                        object:nil userInfo:nil];
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (IBAction)cancelButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self hideKeyboard];
}

@end
