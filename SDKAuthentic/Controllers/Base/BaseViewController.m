//
//  BaseViewController.m
//  music.application
//
//  Created by thanhvu on 8/14/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "Macro.h"

@interface BaseViewController ()
@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [SVProgressHUD setForegroundColor:RGB(29, 178, 81)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Utilities
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)showLoading:(BOOL)loading {
    if (loading == YES) {
        [SVProgressHUD show];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

@end
