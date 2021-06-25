//
//  IapList.m
//  SkywaySDK
//
//  Created by Ngo  Hien on 21/06/2021.
//

#import "IapList.h"
#import "Iap.h"

@implementation IapList

+ (id)parseObject:(id)obj {
    if (obj && [NSNull null] != obj && [obj isKindOfClass:[NSArray class]]) {
        IapList *list = [IapList new];
        for (int i = 0; i < [obj count]; i++) {
            id tmp = [obj objectAtIndex:i];
            Iap *iap = [Iap parseObject:tmp];
            [list insertObject:iap atIndex:0];
        }
        return list;
    }
    return nil;
}

@end
