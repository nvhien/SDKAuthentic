//
//  ChangePasswordViewController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 25/05/2021.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ChangePasswordScreenState) {
    AddPassword         = 1,
    UpdatePassword      = 2,
};

@interface ChangePasswordViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *oldPasswordView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *passwordConfirmView;
@property (weak, nonatomic) IBOutlet UIView *titleView1;
@property (weak, nonatomic) IBOutlet UIView *titleView2;
@property (weak, nonatomic) IBOutlet UIView *titleView3;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;

@property (nonatomic, strong) NSString *otpSession;
@property (nonatomic, assign) ChangePasswordScreenState type;

@end

NS_ASSUME_NONNULL_END
