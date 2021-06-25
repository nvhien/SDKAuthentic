//
//  Iap.h
//  SkywaySDK
//
//  Created by Ngo  Hien on 21/06/2021.
//

#import "ApiResponseObject.h"

@interface Iap : ApiResponseObject

@property (nonatomic, strong) NSString *producrId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@end
