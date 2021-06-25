//
//  DatePickerPopup.m
//  LaucherGame
//
//  Created by Ngo  Hien on 07/06/2021.
//

#import "DatePickerPopup.h"
#import "Session.h"
#import "User.h"

@interface DatePickerPopup ()

@end

@implementation DatePickerPopup

- (void)viewDidLoad {
    [super viewDidLoad];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 14.0, *)) {
        _datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    } else {
        // Fallback on earlier versions
    }
    User *user = [Session shared].user;
    if (user && user.birthday != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormatter dateFromString:user.birthday];
        _datePicker.date = date;
    }
}

- (IBAction)cancelButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonSelected:(id)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[_datePicker date]]);
    [Session shared].user.birthday = [dateFormatter stringFromDate:[_datePicker date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BirthDaySelected"
                                                        object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
