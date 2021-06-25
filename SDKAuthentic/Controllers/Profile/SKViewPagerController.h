//
//  SKViewPagerController.h
//  LaucherGame
//
//  Created by Ngo  Hien on 04/06/2021.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MenuView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SKViewPagerControllerCallback)(UserAction key);

@interface SKViewPagerController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@property (nonatomic, copy) SKViewPagerControllerCallback completedCallback;

@end

NS_ASSUME_NONNULL_END
