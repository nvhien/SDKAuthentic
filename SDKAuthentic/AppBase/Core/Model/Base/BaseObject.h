//
//  BaseObject.h
//
//  Created by thanhvu on 1/16/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Utilities.h"

@protocol BaseObject <NSObject>

@required
+ (id _Nullable)parseObject:(id _Nullable)obj;

@end
