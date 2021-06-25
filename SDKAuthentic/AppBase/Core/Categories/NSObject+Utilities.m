//
//  NSObject+Utilities.m
//
//  Created by thanhvu on 4/12/17.
//

#import "NSObject+Utilities.h"
#import <objc/runtime.h>

@implementation NSObject (Utilities)

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}

- (NSString *)stringValueKey:(NSString *)key {
    id tmp = [self objectValueKey:key];
    return tmp;
}

- (NSInteger)intValueKey:(NSString *)key {
    id tmp = [self objectValueKey:key];
    if (tmp) {
        return [tmp intValue];
    }
    return 0;
}

- (BOOL)boolValueKey:(NSString *_Nonnull)key {
    id tmp = [self objectValueKey:key];
    if (tmp) {
        return [tmp boolValue];
    }
    return NO;
}

- (id)objectValueKey:(NSString *_Nonnull)key {
    id value = [self valueForKey:key];    
    if (value && value != [NSNull null]) {
        return value;
    }
    return nil;
}

@end
