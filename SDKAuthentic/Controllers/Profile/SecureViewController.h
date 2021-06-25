//
//  SecureViewController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 23/05/2021.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, SecureViewControllerActionType) {
    updatePassword,
    addEmail
};

@class SecureViewController;
@protocol SecureViewControllerDelegate <NSObject>

@optional
- (void)secureViewController:(SecureViewController *)vc actionWithType:(SecureViewControllerActionType)type ;
@end

@interface SecureViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *updateEmailButton;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) id<SecureViewControllerDelegate> delegate;

- (void)updateData;

@end

NS_ASSUME_NONNULL_END
