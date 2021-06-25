//
//  User.m
//
//  Created by Toan Nguyen on 3/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "ApiStatus.h"

@implementation ApiStatus
+ (id)parseObject:(id)obj {
    if (!obj || [NSNull null] == obj) {
        return nil;
    }
    
    ApiStatus *status = [ApiStatus new];
    status.code             = [obj intValueKey:API_PARAM_CODE];
    status.message           = [obj stringValueKey:API_PARAM_MESSAGE];
    return status;
}
@end
