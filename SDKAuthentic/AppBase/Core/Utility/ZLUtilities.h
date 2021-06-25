//
//  ZLUtilities.h
//  music.application
//
//  Created by thanhvu on 5/18/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLUtilities : NSObject

// document directory
+ (NSString *_Nonnull) documentDirectory;

// rect for string
//+ (CGRect)boundingRectForString:(NSString * _Nonnull)msg font:(UIFont *_Nonnull)font width:(float)width;

// number by string
+ (NSString * _Nullable)numberString:(NSString * _Nullable)string;

// validate email
+ (BOOL)isValidEmail:(NSString *_Nullable)email;

// show toast
+ (void)showToast:(NSString *_Nullable)message;

@end
