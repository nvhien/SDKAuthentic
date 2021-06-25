//
//  ProfileDetailViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 23/05/2021.
//

#import "ProfileDetailViewController.h"
#import "ZLUtilities.h"
#import "AppUtils.h"
#import "Constants.h"
#import "Session.h"
#import "User.h"
#import "APIClient.h"
#import "Auth.h"

@interface ProfileDetailViewController () {
}

@end

@implementation ProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBirthDay:) name:@"BirthDaySelected" object:nil];
}

- (void) updateBirthDay:(NSNotification *)notification {
    User *user = [[Session shared] user];
    if (user != nil) {
        if (user.birthday != nil) {
            _birthdayTextField.text = user.birthday;
        }
    }
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

- (void)updateData {
    User *user = [[Session shared] user];
    if (user != nil) {
        if (user.fullName != nil) {
            _fullNameTextField.text = user.fullName;
        }
        if (user.birthday != nil) {
            _birthdayTextField.text = user.birthday;
//            [AppUtils formatDate:user.birthday];
        }
        if (user.cmndNumber != nil) {
            _cmndNumberTextField.text = user.cmndNumber;
        }
    }
}

- (IBAction)showDatePicker:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDatePickerPopup"
                                                        object:nil userInfo:nil];
}

- (IBAction)updateInforButtonSelected:(id)sender {
    [self hideKeyboard];
    
    if ([_fullNameTextField.text length] == 0) {
        [ZLUtilities showToast:FULLNAME_EMPTY];
        return;
    }
    
    if ([_birthdayTextField.text length] == 0) {
        [ZLUtilities showToast:BIRTHDAY_EMPTY];
        return;
    }
    
    if ([_cmndNumberTextField.text length] == 0 || ( [_cmndNumberTextField.text length] != 9 && [_cmndNumberTextField.text length] != 12)) {
        [ZLUtilities showToast:CMND_NUMBER_INVALID];
        return;
    }
    
    User *user = [User new];
    user.fullName = _fullNameTextField.text;
    user.birthday = [NSString stringWithFormat:@"%@ 00:00:00", _birthdayTextField.text];
    user.cmndNumber = _cmndNumberTextField.text;
    
    [self showLoading:YES];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] updateUserInfo:user completion:^(User *u, BOOL success) {
        [weakSelf showLoading:NO];
        if (success) {
            
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideDatePickerPopup"
                                                        object:nil userInfo:nil];
}

- (IBAction)cancelButtonSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissProfile"
                                                        object:nil userInfo:nil];
}

@end
