//
//  BaseViewController.h
//  music.application
//
//  Created by thanhvu on 8/14/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLUtilities.h"
#import "AppUtils.h"
#import "Constants.h"

@interface BaseViewController : UIViewController

// hide keyboard
- (void)hideKeyboard;

- (void)showLoading:(BOOL)loading;

@end
