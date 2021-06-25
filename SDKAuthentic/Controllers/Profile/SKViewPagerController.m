//
//  SKViewPagerController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 04/06/2021.
//

#import "SKViewPagerController.h"
#import "SecureViewController.h"
#import "ProfileDetailViewController.h"
#import "ChangeEmailViewController.h"
#import "ChangePasswordViewController.h"
#import "AccountManagerViewController.h"
#import "DatePickerPopup.h"
#import "KDViewPager.h"
#import "Macro.h"
#import "Auth.h"
#import "ZLUtilities.h"
#import "Session.h"
#import "APIClient.h"
#import "IAPShare.h"
#import <StoreKit/StoreKit.h>

@interface SKViewPagerController () <KDViewPagerDatasource, KDViewPagerDelegate, MenuViewDelegate>

@property (nonatomic, strong) KDViewPager *pager;
@property (nonatomic, assign) NSUInteger count;

- (void) requestProducts;

@end

@implementation SKViewPagerController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pager = [[KDViewPager alloc] initWithController:self inView:_contentView];
    _pager.datasource = self;
    _pager.delegate = self;
    
    [_menuView layoutIfNeeded];
    _menuView.delegate = self;
    [_menuView setTypes:MenuViewType_Profile, MenuViewType_Secure, nil];
    
    [_menuView setSelectedType:MenuViewType_Profile];
    
    [self performSelector:@selector(reload) withObject:nil afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopUpdateEmailPopup:) name:@"ShowChangeEmailPopup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopUpdatePasswordPopup:) name:@"ShowChangePasswordPopup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDatePicker:) name:@"ShowDatePickerPopup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissProfile:) name:@"DismissProfile" object:nil];
    
    [self requestProducts];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[APIClient shared] getUserInfo:^(User *user, BOOL success) {
        if (success) {
            User *user = [[Session shared] user];
            if (user && user.account) {
                self.userNameLabel.text = user.account;
            }
        }
    }];
}

- (void)requestProducts {
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response) {
        NSLog(@"Product Request Success");
    }];
}


-(void)setCount:(NSUInteger)count {
    _count = count;
}

-(void)reload {
    self.count = 2;
    [_pager reload];
}

#pragma mark - Show Change Email Popup
- (void)shopUpdateEmailPopup:(NSNotification *)notification {
    User *user = [[Session shared] user];
    if (FRAMEWORK_ENABLE) {
        NSBundle *bundle = [AppUtils getSdkBundle];
        if (bundle != nil) {
            ChangeEmailViewController *vc = [[ChangeEmailViewController alloc] initWithNibName:@"ChangeEmailViewController" bundle:bundle];
            if (user && user.email != nil) {
                vc.type = UpdateEmail;
            } else{
                vc.type = AddEmail;
            }
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else{
        ChangeEmailViewController *vc = [[ChangeEmailViewController alloc] init];
        if (user && user.email != nil) {
            vc.type = UpdateEmail;
        } else{
            vc.type = AddEmail;
        }
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Show Change Password Popup
- (void)shopUpdatePasswordPopup:(NSNotification *)notification {
    User *user = [[Session shared] user];
    if (FRAMEWORK_ENABLE) {
        NSBundle *bundle = [AppUtils getSdkBundle];
        if (bundle != nil) {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:bundle];
            if (user && user.password != nil) {
                vc.type = UpdatePassword;
            } else{
                vc.type = AddPassword;
            }
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else{
        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
        if (user && user.password != nil) {
            vc.type = UpdatePassword;
        } else{
            vc.type = AddPassword;
        }
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dismissProfile:(NSNotification *)notification {
    [Session shared].user.birthday = nil;
    [self closeButtonSelected:nil];
}

#pragma mark - Show Date Picker Popup
- (void)showDatePicker:(NSNotification *)notification {
    
    if (FRAMEWORK_ENABLE) {
        NSBundle *bundle = [AppUtils getSdkBundle];
        if (bundle != nil) {
            DatePickerPopup *vc = [[DatePickerPopup alloc] initWithNibName:@"DatePickerPopup" bundle:bundle];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:true completion:nil];
        }
    }
    else{
        DatePickerPopup *vc = [[DatePickerPopup alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:true completion:nil];
    }
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    [Session shared].user.birthday = [dateFormatter stringFromDate:[sender date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BirthDaySelected"
                                                        object:nil userInfo:nil];
}



- (IBAction)logoutButtonSelected:(id)sender {
    [self hideKeyboard];
    
    [self showLoading:YES];
    __weak typeof(self) weakSelf = self;

    [[APIClient shared] logout:^(ApiStatus *status, BOOL success) {
        [weakSelf showLoading:NO];
        [ZLUtilities showToast:status.message];
        
        if (FRAMEWORK_ENABLE) {
            NSBundle *bundle = [AppUtils getSdkBundle];
            if (bundle != nil) {
                if (weakSelf.completedCallback) {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        weakSelf.completedCallback(LOGOUT);
                    }];
                }
                /*
                AccountManagerViewController *vc = [[AccountManagerViewController alloc] initWithNibName:@"AccountManagerViewController" bundle:bundle];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf presentViewController:vc animated:true completion:nil];
                 */
            }
        }
        else{
            AccountManagerViewController *vc = [[AccountManagerViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:vc animated:true completion:nil];
            
        }
    }];
}

- (void) createTransaction:(NSString *)productId clientTransId:(NSString *)clientTransId {
    [[APIClient shared] createTransaction:@"1" serverId:@"1" productId:productId gameClientTransId:clientTransId completion:^(NSString *transactionId, BOOL success) {
        if (transactionId != nil) {
            SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
            
            NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
            NSLog(@"Title: %@",product.localizedTitle);
            [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
                if(trans.error){
                    NSLog(@"Fail %@",[trans.error localizedDescription]);
                }
                else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                    NSLog(@"Transaction Success => Verify Receipt Data");
            
                    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            
                    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
                    NSString *jsonObjectString = [receipt base64EncodedStringWithOptions:0];
                    
                    [self showLoading: YES];
                    [[APIClient shared] updatePaymentStatus:@"com.skyway.authentic" productId: product.productIdentifier purchaseToken:@"" password:@"" receiptData:jsonObjectString completion:^(BOOL success) {
                        [self showLoading: NO];
                        if (success) {
                            DLog(@"--- Verify Server Success ---");
                        }
                        else{
                            DLog(@"--- Verify Server Failed ---");
                        }
                    }];
            
                    DLog(@"--- Receipt Data STRING : %@ ---", jsonObjectString);
                }
                else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                    NSLog(@"Transaction Cancel or Fail");
                }
            
            }];
        }
    }];
}

- (IBAction)buyGoldButtonSelected:(id)sender {
    
    if ([[IAPShare sharedHelper].iap.products count] > 0) {
        SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
        [self createTransaction:product.productIdentifier clientTransId:@""];
    }
}

- (IBAction)closeButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self hideKeyboard];
}

#pragma mark - datasource
-(UIViewController *)kdViewPager:(KDViewPager *)viewPager controllerAtIndex:(NSUInteger)index cachedController:(UIViewController *)cachedController {
    if (cachedController == nil) {
        if (index == 0) {
            if (FRAMEWORK_ENABLE) {
                NSBundle *bundle = [AppUtils getSdkBundle];
                cachedController = [[ProfileDetailViewController alloc] initWithNibName:@"ProfileDetailViewController" bundle:bundle];
            }
            else{
                cachedController = [[ProfileDetailViewController alloc] init];
            }
        }
        else{
            if (FRAMEWORK_ENABLE) {
                NSBundle *bundle = [AppUtils getSdkBundle];
                cachedController = [[SecureViewController alloc] initWithNibName:@"SecureViewController" bundle:bundle];
            }
            else{
                cachedController = [[SecureViewController alloc] init];
            }
        }
    }
    return cachedController;
}

-(NSUInteger)numberOfPages:(KDViewPager *)viewPager {
    return _count;
}

#pragma mark - delegate
-(void)kdViewpager:(KDViewPager *)viewPager didSelectPage:(NSUInteger)index direction:(UIPageViewControllerNavigationDirection)direction {
    if (index == 0) {
        [_menuView setSelectedType:MenuViewType_Profile];
    }
    else{
        [_menuView setSelectedType:MenuViewType_Secure];
    }
}
-(void)kdViewpager:(KDViewPager *)viewPager willSelectPage:(NSUInteger)index direction:(UIPageViewControllerNavigationDirection)direction {
    NSLog(@"willSelectPage: %lu direction: %lu", index, direction);
}

#pragma mark - MenuView Delegate

- (void)menuView:(MenuView *)view willSelectedType:(MenuViewType)type {
    
}

- (void)menuView:(MenuView *)view didSelectedType:(MenuViewType)type {
    switch (type) {
        case MenuViewType_Profile:
            [_pager setCurrentPage:0 animated:NO];
            break;
        case MenuViewType_Secure:
            [_pager setCurrentPage:1 animated:NO];
            break;
        default:
            break;
    }
}

@end
