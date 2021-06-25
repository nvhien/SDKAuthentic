//
//  User.h
//
//  Updated by thanhvu on 4/5/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "ApiResponseObject.h"

@interface ApiStatus : ApiResponseObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;


@end
