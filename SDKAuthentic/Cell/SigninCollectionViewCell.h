//
//  SigninCollectionViewCell.h
//  LaucherGame
//
//  Created by Ngo  Hien on 20/05/2021.
//

#import "CollectionBaseCell.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ActionTypeSignin) {
    SigninFacebook,
    SigninGoogle,
    SigninGuest,
    Signin,
    Signup,
    ForgotPass
};

@class SigninCollectionViewCell;
@protocol SigninCollectionViewCellDelegate <NSObject>

@optional
- (void)signinCollectionCell:(SigninCollectionViewCell *)cell actionWithType:(ActionTypeSignin)type secretName:(NSString *)email secretPassword:(NSString *)password;
- (void)signinCollectionCell:(SigninCollectionViewCell *)cell userName:(NSString *)userName password:(NSString *)password;
@end

@interface SigninCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) id<SigninCollectionViewCellDelegate> delegate;

- (void) resetData;

@end

NS_ASSUME_NONNULL_END
