//
//  SAUtility.m

//
//  Created by thanhvu on 11/25/15.
//  Copyright © 2015 Zilack. All rights reserved.
//

#import "AppUtils.h"
#import "Session.h"

#pragma mark - Defination

#pragma mark - AppUtils

@implementation AppUtils

+ (UIView *)loadFromNibNamed:(NSString *)nibNamed {
    return [[[NSBundle mainBundle] loadNibNamed:nibNamed owner:self options:nil] objectAtIndex:0];
}

+ (BOOL)validateEmail:(NSString *)email {
     NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePassword:(NSString *)password {
    return [password length] >= 6 && [password length] <= 30;
}

+ (BOOL)validAPICode:(id) responseObject {
    BOOL success = YES;
    id tmp = [responseObject valueForKey:@"error"];
    
    NSNumber * isNumber = (NSNumber *)tmp;
    if ([tmp isKindOfClass:[NSArray class]]) {
        success = NO;
    } else {
        if (!isNumber || [isNumber boolValue] == YES) {
            success = NO;
        }
    }
    return success;
}

+ (NSString *)maskEmail:(NSString *)email {
    if ([self validateEmail:email]) {
        NSRange range = [email rangeOfString:@"@"];
        NSRange newRange = NSMakeRange(3, range.location-3);
        NSString *replace = [@"" stringByPaddingToLength:newRange.length withString:@"*" startingAtIndex:0];
        NSString * maskedEmail = [email stringByReplacingCharactersInRange:newRange withString:replace];
        return  maskedEmail;
    }
    else {return @"";}
}

+ (NSString *)formatDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (date != nil) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        return [dateFormatter stringFromDate:date];
    }
    return @"";
}

+ (NSBundle *)getSdkBundle {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* path = [resourcePath
    stringByAppendingPathComponent:@"SkywayBundle.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if (bundle != nil) {
        return bundle;
    }
    return nil;
}

#pragma mark - Convert VietNam
+ (NSString *)convertVietNam:(NSString *)text {
    NSArray *arrCodau = @[@"á",@"à",@"ả",@"ã",@"ạ",
    @"ă",@"ắ",@"ằ",@"ẳ",@"ẵ",@"ặ",
    @"â",@"ấ",@"ầ",@"ẩ",@"ẫ",@"ậ",@"đ",
    @"é",@"è",@"ẻ",@"ẽ",@"ẹ",
    @"ê",@"ế",@"ề",@"ể",@"ễ",@"ệ",
    @"í",@"ì",@"ỉ",@"ĩ",@"ị",
    @"ó",@"ò",@"ỏ",@"õ",@"ọ",
    @"ô",@"ố",@"ồ",@"ổ",@"ỗ",@"ộ",
    @"ơ",@"ớ",@"ờ",@"ở",@"ỡ",@"ợ",
    @"ú",@"ù",@"ủ",@"ũ",@"ụ",
    @"ư",@"ứ",@"ừ",@"ử",@"ữ",@"ự",
    @"ý",@"ỳ",@"ỷ",@"ỹ",@"ỵ",
    @"Á",@"À",@"Ả",@"Ã",@"Ạ",
    @"Ă",@"Ắ",@"Ằ",@"Ẳ",@"Ẵ",@"Ặ",
    @"Â",@"Ấ",@"Ầ",@"Ẩ",@"Ẫ",@"Ậ",@"Đ",
    @"É",@"È",@"Ẻ",@"Ẽ",@"Ẹ",
    @"Ê",@"Ế",@"Ề",@"Ể",@"Ễ",@"Ệ",
    @"Í",@"Ì",@"Ỉ",@"Ĩ",@"Ị",
    @"Ó",@"Ò",@"Ỏ",@"Õ",@"Ọ",
    @"Ô",@"Ố",@"Ồ",@"Ổ",@"Ỗ",@"Ộ",
    @"Ơ",@"Ớ",@"Ờ",@"Ở",@"Ỡ",@"Ợ",
    @"Ú",@"Ù",@"Ủ",@"Ũ",@"Ụ",
    @"Ư",@"Ứ",@"Ừ",@"Ử",@"Ữ",@"Ự",
    @"Ý",@"Ỳ",@"Ỷ",@"Ỹ",@"Ỵ"];
    
    NSArray *arrKhongdau = @[@"a",@"a",@"a",@"a",@"a",
         @"a",@"a",@"a",@"a",@"a",@"a",
         @"a",@"a",@"a",@"a",@"a",@"a",@"d",
         @"e",@"e",@"e",@"e",@"e",
         @"e",@"e",@"e",@"e",@"e",@"e",
         @"i",@"i",@"i",@"i",@"i",
         @"o",@"o",@"o",@"o",@"o",
         @"o",@"o",@"o",@"o",@"o",@"o",
         @"o",@"o",@"o",@"o",@"o",@"o",
         @"u",@"u",@"u",@"u",@"u",
         @"u",@"u",@"u",@"u",@"u",@"u",
         @"y",@"y",@"y",@"y",@"y",
         @"A",@"A",@"A",@"A",@"A",
         @"A",@"A",@"A",@"A",@"A",@"A",
         @"A",@"A",@"A",@"A",@"A",@"A",@"D",
         @"E",@"E",@"E",@"E",@"E",
         @"E",@"E",@"E",@"E",@"E",@"E",
         @"I",@"I",@"I",@"I",@"I",
         @"O",@"O",@"O",@"O",@"O",
         @"O",@"O",@"O",@"O",@"O",@"O",
         @"O",@"O",@"O",@"O",@"O",@"O",
         @"U",@"U",@"U",@"U",@"U",
         @"U",@"U",@"U",@"U",@"U",@"U",
         @"Y",@"Y",@"Y",@"Y",@"Y"
    ];
    NSString *output = text;
    for (int j = 0; j < [arrCodau count]; j++) {
        output = [output stringByReplacingOccurrencesOfString:arrCodau[j] withString:arrKhongdau[j]];
    }
    return output;
}

@end
