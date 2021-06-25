//
//  LocalStored.h
//  LaucherGame
//
//  Created by Ngo  Hien on 18/06/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef LocalStored_h
#define LocalStored_h

UIKIT_EXTERN NSString *const AccessToken;

@interface LocalStored : NSObject
+ (NSString *)accessToken;
+ (void)setAccessToken:(NSString *)accessToken;
@end

#endif /* LocalStored_h */
