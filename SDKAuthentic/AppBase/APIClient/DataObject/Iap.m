//
//  Iap.m
//  SkywaySDK
//
//  Created by Ngo  Hien on 21/06/2021.
//

#import "Iap.h"

@implementation Iap
+ (id)parseObject:(id)obj {
    if (!obj || [NSNull null] == obj) {
        return nil;
    }
    Iap *iap = [Iap new];
    
    iap.producrId                     = [obj stringValueKey:API_PARAM_ID];
    iap.code                         = [obj stringValueKey:API_PARAM_CODE];
    iap.name                         = [obj stringValueKey:API_PARAM_NAME];
    return iap;
}
@end
