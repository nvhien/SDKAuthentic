//
//  SecureViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 23/05/2021.
//

#import "SecureViewController.h"
#import "ChangePasswordViewController.h"
#import "User.h"
#import "Session.h"
#import "Auth.h"
#import "APIClient.h"

@interface SecureViewController ()

@end

@implementation SecureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"UpdateProfile" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[Session shared] user] == nil) {
        __weak typeof(self) weakSelf = self;
        [[APIClient shared] getUserInfo:^(User *user, BOOL success) {
            if (success) {
                [weakSelf updateData];
            }
        }];
    }
    [self updateData];
}

-(void)updateProfile:(NSNotification *)notification {
    [self updateData];
}

- (void)updateData {
    User *user = [[Session shared] user];
    if (user != nil) {
        if (user.email != nil) {
            NSRange range = [user.email rangeOfString:@"@"];
            NSRange newRange = NSMakeRange(1, range.location-2);
            NSString *replace = [@"" stringByPaddingToLength:newRange.length withString:@"*" startingAtIndex:0];
            NSString * maskedEmail = [user.email stringByReplacingCharactersInRange:newRange withString:replace];
            _emailTextField.text = maskedEmail;
            [_updateEmailButton setTitle:@"THAY ĐỔI" forState:UIControlStateNormal];
        }
        else{
            [_updateEmailButton setTitle:@"CẬP NHẬT" forState:UIControlStateNormal];
        }
        if (user.password != nil) {
            _passwordTextField.text = @"xxxxxxx";
            [_updatePasswordButton setTitle:@"ĐỔI MẬT KHẨU" forState:UIControlStateNormal];
        }
        else{
            [_updatePasswordButton setTitle:@"CẬP NHẬT" forState:UIControlStateNormal];
        }
        if (user.email != nil && user.password != nil) {
            _statusLabel.text = @"Bạn đã cập nhật đầy đủ thông tin";
            NSBundle *bundle = [AppUtils getSdkBundle];
            if (FRAMEWORK_ENABLE) {
                if (bundle != nil) {
                    _statusImageView.image = [UIImage imageNamed:@"ic_success" inBundle:bundle compatibleWithTraitCollection:nil];
                }
            }
            else{
                _statusImageView.image = [UIImage imageNamed:@"ic_success"];
            }
        }
        else{
            _statusLabel.text = @"Vui lòng cập nhật và kích hoạt đầy đủ thông tin để bảo mật tài khoản tốt hơn";
            NSBundle *bundle = [AppUtils getSdkBundle];
            if (FRAMEWORK_ENABLE) {
                if (bundle != nil) {
                    _statusImageView.image = [UIImage imageNamed:@"ic_error" inBundle:bundle compatibleWithTraitCollection:nil];
                }
            }
            else{
                _statusImageView.image = [UIImage imageNamed:@"ic_error"];
            }
        }
    }
}


- (IBAction)updatePasswordButtonSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowChangePasswordPopup"
                                                        object:nil userInfo:nil];
}

- (IBAction)updateEmailButtonSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowChangeEmailPopup"
                                                        object:nil userInfo:nil];
}

@end
