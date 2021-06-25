//
//  MainViewController.m
//  LaucherGame
//
//  Created by Ngo  Hien on 25/05/2021.
//

#import "MainViewController.h"
#import "UIView+draggable.h"
#import "UIStoryboard+Extension.h"
#import "SKViewPagerController.h"

#define ICON_SIZE 50

@interface MainViewController () {
    NSTimer *timer;
    int count;
}

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *draggableViews;

@property BOOL isDraging;

- (void)_timerFired:(NSTimer *)timer;

@end

@implementation MainViewController

@synthesize isDraging;

- (void)_timerFired:(NSTimer *)timer {
    NSBundle *bundle = [AppUtils getSdkBundle];
    count += 1;
    if (count >= 5) {
        if (FRAMEWORK_ENABLE) {
            if (bundle != nil) {
                _iconImageView.image = [UIImage imageNamed:@"skw_logo_disabled" inBundle:bundle compatibleWithTraitCollection:nil];
            }
        }
        else{
            _iconImageView.image = [UIImage imageNamed:@"skw_logo_disabled"];
        }
    }
    if (count >= 10) {
        [self resetTimer];
        if (FRAMEWORK_ENABLE) {
            if (bundle != nil) {
                _iconImageView.image = [UIImage imageNamed:@"half_2_icon" inBundle:bundle compatibleWithTraitCollection:nil];
            }
        }
        else{
            _iconImageView.image = [UIImage imageNamed:@"half_2_icon"];
        }
    }
    else{
        
    }
}

- (void) setupTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerFired:) userInfo:nil repeats:YES];
}

- (void) resetTimer {
    count = 0;
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    [self.draggableView addGestureRecognizer:singleFingerTap];
    
    [self.draggableViews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        [obj enableDragging];
        [obj.layer setCornerRadius:4];
        obj.cagingArea = CGRectMake(0, 0, self.view.frame.size.width - 20.0, self.view.frame.size.height);
        [obj setDraggingStartedBlock:^(UIView *v) {
            [self resetTimer];
            if (FRAMEWORK_ENABLE) {
                NSBundle *bundle = [AppUtils getSdkBundle];
                if (bundle != nil) {
                    self.iconImageView.image = [UIImage imageNamed:@"skw_logo_enabled" inBundle:bundle compatibleWithTraitCollection:nil];
                }
            }
            else{
                self.iconImageView.image = [UIImage imageNamed:@"skw_logo_enabled"];
            }
        }];
        [obj setDraggingMovedBlock:^(UIView *v) {
            
        }];
        [obj setDraggingEndedBlock:^(UIView *v) {
            if ((v.frame.origin.x +  v.frame.size.width/2 )< self.view.frame.size.width/2) {
                [self.draggableView setFrame:CGRectMake(0, v.frame.origin.y, ICON_SIZE, ICON_SIZE)];
            }
            else{
                [self.draggableView setFrame:CGRectMake(self.view.frame.size.width - ICON_SIZE, v.frame.origin.y, ICON_SIZE, ICON_SIZE)];
            }
        }];
    }];
    
    isDraging = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.draggableView setFrame:CGRectMake(0, 50, ICON_SIZE, ICON_SIZE)];
    count = 0;
    [self setupTimer];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSBundle *bundle = [AppUtils getSdkBundle];
    if (FRAMEWORK_ENABLE) {
        if (bundle != nil) {
            self.iconImageView.image = [UIImage imageNamed:@"skw_logo_enabled" inBundle:bundle compatibleWithTraitCollection:nil];
            SKViewPagerController *vc = [[SKViewPagerController alloc] initWithNibName:@"SKViewPagerController" bundle:bundle];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:true completion:nil];
        }
    }
    else{
        self.iconImageView.image = [UIImage imageNamed:@"skw_logo_enabled"];
        SKViewPagerController *vc = [[SKViewPagerController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:true completion:nil];
    }
}

@end
