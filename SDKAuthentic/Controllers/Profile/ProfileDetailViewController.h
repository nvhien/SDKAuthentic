//
//  ProfileDetailViewController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 23/05/2021.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cmndNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;

@end

NS_ASSUME_NONNULL_END
