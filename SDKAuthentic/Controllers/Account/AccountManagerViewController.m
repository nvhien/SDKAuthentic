//
//  AccountManagerViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "AccountManagerViewController.h"
#import "SigninCollectionViewCell.h"
#import "SignupCollectionViewCell.h"
#import "ForgotPassCollectionViewCell.h"
#import "SKViewPagerController.h"
#import "MainViewController.h"
#import "UIStoryboard+Extension.h"
#import "ZLUtilities.h"
#import "AppUtils.h"
#import "Auth.h"
#import "APIClient.h"
#import "Constants.h"
#import "LocalStored.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>


@interface AccountManagerViewController ()<UITextFieldDelegate, UICollectionViewDataSource, SigninCollectionViewCellDelegate, SignupCollectionViewCellDelegate, ForgotPassCollectionViewCellDelegate, GIDSignInDelegate> {
    AccountScreenState state;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


- (void)p_updateState:(AccountScreenState) aState;

@end

@implementation AccountManagerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (FRAMEWORK_ENABLE) {
        NSBundle *bundle = [AppUtils getSdkBundle];
        if (bundle != nil) {
            self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background" inBundle:bundle compatibleWithTraitCollection:nil]];
        }
    }
    else{
        self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    }
    UICollectionViewFlowLayout *currentLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    currentLayout.minimumLineSpacing = 0;
    currentLayout.minimumInteritemSpacing = 0;
    CGFloat edge = 0;
    currentLayout.sectionInset = UIEdgeInsetsMake(edge, edge, edge, edge);
    [currentLayout invalidateLayout];
    if (FRAMEWORK_ENABLE) {
        NSBundle *bundle = [AppUtils getSdkBundle];
        if (bundle != nil) {
            [_collectionView registerNib:[UINib nibWithNibName:@"SigninCollectionViewCell" bundle:bundle]
                    forCellWithReuseIdentifier:@"signin_cell"];
            [_collectionView registerNib:[UINib nibWithNibName:@"SignupCollectionViewCell" bundle:bundle]
                    forCellWithReuseIdentifier:@"signup_cell"];
            [_collectionView registerNib:[UINib nibWithNibName:@"ForgotPassCollectionViewCell" bundle:bundle]
                    forCellWithReuseIdentifier:@"forgot_pass_cell"];
        }
    }
    else{
        [_collectionView registerNib:[UINib nibWithNibName:@"SigninCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"signin_cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SignupCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"signup_cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"ForgotPassCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"forgot_pass_cell"];
    }
    [self appVerifyState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)appVerifyState {
    NSString * accessToken = [LocalStored accessToken];
    if (accessToken != nil) {
        [self showLoading:YES];
        __weak typeof(self) weakSelf = self;
        [[APIClient shared] verifyToken:accessToken completion:^(User *user, BOOL success) {
            [self showLoading:NO];
            [self p_updateState:AccountScreenStateSignin];
            if (success) {
                if (FRAMEWORK_ENABLE) {
                    NSBundle *bundle = [AppUtils getSdkBundle];
                    if (bundle != nil) {
                        weakSelf.completedCallback(SIGNED_IN, accessToken);
                        /*
                        MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:bundle];
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [weakSelf presentViewController:vc animated:true completion:nil];
                         */
                    }
                }
                else{
                    weakSelf.completedCallback(SIGNED_IN, accessToken);
                    MainViewController *vc = [[MainViewController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:vc animated:true completion:nil];
                }
            }
        }];
    }
    else{
        [self p_updateState:AccountScreenStateSignin];
    }
}

- (void)p_updateState:(AccountScreenState) aState {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == aState) {
            return;
        }
        state = aState;
        [weakSelf.collectionView reloadData];
        [UIView animateWithDuration:0.4 delay:0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                         } completion:^(BOOL finished) {
                         }];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (state == AccountScreenStateUnknow) {
        return 0;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (state) {
        case AccountScreenStateSignin: {
            SigninCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signin_cell" forIndexPath:indexPath];
//            [cell refresh];
            cell.delegate = self;
            return cell;
        }
            break;
        case AccountScreenStateSignup: {
            SignupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signup_cell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
        case AccountScreenStateForgotPassword: {
            ForgotPassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"forgot_pass_cell" forIndexPath:indexPath];
            [cell refresh];
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            break;
        
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signin_cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float w = CGRectGetWidth(self.collectionView.frame);
    float h = CGRectGetHeight(self.collectionView.frame);
    return CGSizeMake(w, h);
}

#pragma mark - SigninCollectionCellDelegate
-(void) signinCollectionCell:(SigninCollectionViewCell *)cell actionWithType:(ActionTypeSignin)type secretName:(NSString *)email secretPassword:(NSString *)password {
    switch (type) {
        case SigninFacebook:{
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                } else if (result.isCancelled) {
                } else {
                    NSString *facebookToken = [FBSDKAccessToken currentAccessToken].tokenString;
                    [self showLoading:YES];
                    __weak typeof(self) weakSelf = self;
                    [[APIClient shared] loginWithFacebookToken:1 appKey:@"xxx" code:facebookToken fcmKey:@"" completion:^(User *user, ApiStatus *status, NSError *error) {
                        [weakSelf showLoading:NO];
                        if (status != nil && user != nil){
                            if (FRAMEWORK_ENABLE) {
                                NSBundle *bundle = [AppUtils getSdkBundle];
                                if (bundle != nil) {
                                    if (weakSelf.completedCallback) {
                                        weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                                    }
                                }
                            }
                            else{
                                weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                                MainViewController *vc = [[MainViewController alloc] init];
                                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                [weakSelf presentViewController:vc animated:true completion:nil];
                            }
                        }
                    }];
                }
            }];
            break;
        }
        case SigninGoogle:{
//            [ZLUtilities showToast:FEATURE_NOT_READY];
            [GIDSignIn sharedInstance].presentingViewController = self;
            [GIDSignIn sharedInstance].delegate = self;
            [[GIDSignIn sharedInstance] signIn];
            break;
        }
        case Signup:
            [self p_updateState:AccountScreenStateSignup];
            [_collectionView reloadData];
            break;
        case ForgotPass:
            [self p_updateState:AccountScreenStateForgotPassword];
            [_collectionView reloadData];
            break;
        case SigninGuest:
        {
            [self hideKeyboard];
        
            [self showLoading:YES];
            __weak typeof(self) weakSelf = self;

            [[APIClient shared] loginWithGuest:@"" gameId:1 completion:^(User *user, ApiStatus *status, NSError *error) {
                [weakSelf showLoading:NO];
                if (status != nil && user != nil){
                    if (FRAMEWORK_ENABLE) {
                        NSBundle *bundle = [AppUtils getSdkBundle];
                        if (bundle != nil) {
                            if (weakSelf.completedCallback) {
                                weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                            }
                            /*
                            MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:bundle];
                            vc.modalPresentationStyle = UIModalPresentationFullScreen;
                            [weakSelf presentViewController:vc animated:true completion:nil];
                             */
                        }
                    }
                    else{
                        weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                        MainViewController *vc = [[MainViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [weakSelf presentViewController:vc animated:true completion:nil];
                    }
                }
            }];
            break;
        }
        default: break;
    }
}

- (void)signinCollectionCell:(SigninCollectionViewCell *)cell userName:(NSString *)userName password:(NSString *)password {
    [self hideKeyboard];
    if ([userName length] == 0) {
        [ZLUtilities showToast:USERNAME_EMPTY];
        return;
    }
    
    if ([password length] == 0) {
        [ZLUtilities showToast:PASSWORD_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:password]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] loginWithAccount:userName password:password gameId:1 completion:^(User *user, ApiStatus *status, NSError *error) {
        if (status != nil && user != nil){
            [cell resetData];
            if (FRAMEWORK_ENABLE) {
                NSBundle *bundle = [AppUtils getSdkBundle];
                if (bundle != nil) {
                    if (weakSelf.completedCallback) {
                        weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                    }
                    /*
                    MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:bundle];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:vc animated:true completion:nil];
                     */
                }
            }
            else{
                if (weakSelf.completedCallback) {
                    weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                }
                MainViewController *vc = [[MainViewController alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf presentViewController:vc animated:true completion:nil];
            }
        }
    }];
}

#pragma mark - SignupCollectionCellDelegate
- (void)signupCollectionCell:(SignupCollectionViewCell *)cell actionWithType:(ActionTypeSignup)type secretName:(NSString *)email secretPassword:(NSString *)password {
    switch (type) {
        case BackToSignin:
            [self p_updateState:AccountScreenStateSignin];
            [_collectionView reloadData];
            break;
        default: break;
    }
}

- (void)signupCollectionCell:(SignupCollectionViewCell *)cell registerName:(NSString *)name password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm {
    [self hideKeyboard];
    if ([name length] == 0) {
        [ZLUtilities showToast:USERNAME_EMPTY];
        return;
    }
    
    NSCharacterSet *alphanumSet = [NSCharacterSet alphanumericCharacterSet];
    if (![[name stringByTrimmingCharactersInSet:alphanumSet] isEqualToString:@""]) {
        [ZLUtilities showToast:USERNAME_INVALID];
        return;
    }
    
    if ([password length] == 0) {
        [ZLUtilities showToast:PASSWORD_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:password]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if ([passwordConfirm length] == 0) {
        [ZLUtilities showToast:PASSWORD_CONFIRM_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:passwordConfirm]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if (![password isEqualToString: passwordConfirm]) {
        [ZLUtilities showToast:PASSWORD_NOT_MATCHING];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] registerAccount:name password:password gameId:1 completion:^(User *user, ApiStatus *status, NSError *error) {
        [weakSelf showLoading:NO];
        if (status != nil && status.code == ApiCodeSuccess){
            [cell resetData];
            [ZLUtilities showToast:SIGN_UP_SUCCESS];
            [Session shared].user = user;
            [weakSelf p_updateState:AccountScreenStateSignin];
            [weakSelf.collectionView reloadData];
        }
        else{
            [Session shared].user = nil;
        }
    }];
}

#pragma mark - ForgotPassCollectionCellDelegate
- (void)forgotPassCollectionCell:(ForgotPassCollectionViewCell *)cell actionWithType:(ActionTypeForgot)type otp:(NSString *)otp {
    switch (type) {
        case Back:
            [Session shared].forgotType = SendOtp;
            [self p_updateState:AccountScreenStateSignin];
            [_collectionView reloadData];
            break;
        default: break;
    }
}

- (void)confirmOtp:(ForgotPassCollectionViewCell *)cell otp:(NSString *)otp {
    [self hideKeyboard];
    if ([otp length] == 0) {
        [ZLUtilities showToast:OTP_EMPTY];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] verifyOtpPassword:otp otpSession:_otpSession completion:^(BOOL success) {
        [weakSelf showLoading:NO];
        if (success) {
            [cell resetData];
            [Session shared].forgotType = ResetPassword;
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (void)sendOtp:(ForgotPassCollectionViewCell *)cell email:(NSString *)email {
    [self hideKeyboard];
    if ([email length] == 0) {
        [ZLUtilities showToast:USERNAME_OR_EMAIL_EMPTY];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] forgotPassword:email completion:^(NSString *otpSession, BOOL success) {
        [weakSelf showLoading:NO];
        if (success) {
            weakSelf.otpSession = otpSession;
            [Session shared].forgotType = ConfirmOtp;
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (void)resetPassword:(ForgotPassCollectionViewCell *)cell newPass:(NSString *)newPass newPassConfirm:(NSString *)newPassConfirm {
    [self hideKeyboard];
    if ([newPass length] == 0) {
        [ZLUtilities showToast:PASSWORD_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:newPass]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if ([newPassConfirm length] == 0) {
        [ZLUtilities showToast:PASSWORD_CONFIRM_EMPTY];
        return;
    }
    
    if (![AppUtils validatePassword:newPassConfirm]) {
        [ZLUtilities showToast:PASSWORD_INVALID];
        return;
    }
    
    if (![newPass isEqualToString: newPassConfirm]) {
        [ZLUtilities showToast:PASSWORD_NOT_MATCHING];
        return;
    }
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;
    [[APIClient shared] resetPassword:newPass otpSession:_otpSession completion:^(BOOL success) {
        [weakSelf showLoading:NO];
        if (success) {
            [Session shared].forgotType = SendOtp;
            [weakSelf p_updateState:AccountScreenStateSignin];
            [weakSelf.collectionView reloadData];
        }
    }];
}

#pragma mark - Signin Google Delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
//        FIRAuthCredential *credential =
//        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
//                                         accessToken:authentication.accessToken];
        [self showLoading:YES];
        __weak typeof(self) weakSelf = self;
        [[APIClient shared] loginWithGoogle:1 appKey:@"xxx" code:authentication.accessToken fcmKey:@"" completion:^(User *user, ApiStatus *status, NSError *error) {
            [weakSelf showLoading:NO];
            if (status != nil && user != nil){
                if (FRAMEWORK_ENABLE) {
                    NSBundle *bundle = [AppUtils getSdkBundle];
                    if (bundle != nil) {
                        if (weakSelf.completedCallback) {
                            weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                        }
                    }
                }
                else{
                    weakSelf.completedCallback(SIGNED_IN, user.accessToken);
                    MainViewController *vc = [[MainViewController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:vc animated:true completion:nil];
                }
            }
        }];
    
      } else {
          NSLog(@"Signin Google Error : %@", error.description);
      }
}

@end
