//
//  SignupCollectionViewCell.h
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ActionTypeSignup) {
    SignupFacebook,
    SignupGoogle,
    SignupAccount,
    BackToSignin
};

@class SignupCollectionViewCell;
@protocol SignupCollectionViewCellDelegate <NSObject>

@optional
- (void)signupCollectionCell:(SignupCollectionViewCell *)cell actionWithType:(ActionTypeSignup)type secretName:(NSString *)email secretPassword:(NSString *)password;
- (void)signupCollectionCell:(SignupCollectionViewCell *)cell registerName:(NSString *)name password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm;
@end

@interface SignupCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *errorUserName;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) id<SignupCollectionViewCellDelegate> delegate;

- (void) resetData;

@end

NS_ASSUME_NONNULL_END
