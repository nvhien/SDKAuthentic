//
//  LocalStored.m
//  LaucherGame
//
//  Created by Ngo  Hien on 18/06/2021.
//

#import "LocalStored.h"

NSString *const AccessToken    = @"AccessToken";

@implementation LocalStored

+ (NSString *)accessToken {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (![userDefault valueForKey:AccessToken]) {
        return nil;
    } else {
        return [userDefault stringForKey:AccessToken];
    }
}

+ (void)setAccessToken:(NSString *)accessToken {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:accessToken forKey:AccessToken];
    
    [userDefault synchronize];
}

@end
