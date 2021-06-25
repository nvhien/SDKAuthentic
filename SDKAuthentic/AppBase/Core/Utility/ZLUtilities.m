//
//  ZLUtilities.m
//  music.application
//
//  Created by thanhvu on 5/18/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import "ZLUtilities.h"
#import "UIView+Toast.h"
#import "Macro.h"

#pragma mark - ZLUtilities
@implementation ZLUtilities

+ (NSString *) documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//+ (CGRect)boundingRectForString:(NSString *)msg font:(UIFont *)font width:(float)width {
//    if (!msg) {
//        return CGRectZero;
//    }
//    NSDictionary *attributes = @{NSFontAttributeName: font};
//    
//    return [msg boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
//                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                          attributes:attributes context:nil];
//}

+ (NSString *)numberString:(NSString *)string {
    if (string) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *number = [f numberFromString:string];
    
    if (number != nil) {
        return string;
    }
    return nil;
}

+ (BOOL)isValidEmail:(NSString *_Nullable)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)showToast:(NSString *)message {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
//    style.messageFont = [UIFont fontWithName:APPLICATION_FONT size:14.0];
    style.messageColor = RGB(216, 216, 216);
    style.messageAlignment = NSTextAlignmentCenter;
    
    [UIApplication.sharedApplication.keyWindow makeToast:message duration:3.0 position:CSToastPositionTop style:style];
}

@end
