//
//  SAUtility.h

//
//  Created by thanhvu on 11/25/15.
//  Copyright © 2015 Zilack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLUtilities.h"

NS_ASSUME_NONNULL_BEGIN
// Setting key
UIKIT_EXTERN NSString *const kLanguage_EN;
UIKIT_EXTERN NSString *const kLanguage_VI;

// Setting key
UIKIT_EXTERN NSString *const kLanguageChangedNotification;
UIKIT_EXTERN NSString *const kMusicTimeOffChangedNotification;

// Setting key
UIKIT_EXTERN NSString *const kSettingMusicQuality;
UIKIT_EXTERN NSString *const kSettingMusicTimeOff;
UIKIT_EXTERN NSString *const kSettingLanguageLocalization;

NS_ASSUME_NONNULL_END

// language options
typedef NS_OPTIONS(NSInteger, Language) {
    LanguageVietnamese,
    LanguageEnglish
};

// music quanlity
typedef NS_OPTIONS(NSInteger, MusicQuality) {
    MusicQuality128,
    MusicQuality320,
    MusicQualityLossless
};

// music quanlity
typedef NS_OPTIONS(NSInteger, ShareType) {
    ShareSong,
    ShareVideo,
    ShareAlbum
};

@interface AppUtils : ZLUtilities

#pragma mark - View from xib
+ (UIView * _Nullable)loadFromNibNamed:(NSString * _Nonnull)nibNamed;

#pragma mark - Validation
+ (BOOL)validateEmail:(NSString *_Nullable)email;
+ (BOOL)validatePassword:(NSString *_Nullable)password;
+ (BOOL)validAPICode:(id _Nullable)response;
+ (NSString *_Nullable)convertVietNam:(NSString *_Nullable)text;
+ (NSString *_Nullable)createShareLink:(NSInteger)id shareType:(ShareType)type;
+ (NSString *_Nullable)maskEmail:(NSString *_Nullable)email;
+ (NSString *_Nullable)formatDate:(NSString *_Nullable)dateString;
+ (NSBundle *_Nullable)getSdkBundle;

@end
