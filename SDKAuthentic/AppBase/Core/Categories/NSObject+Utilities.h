//
//  NSObject+Utilities.h
//
//  Created by thanhvu on 4/12/17.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utilities)

- (NSDictionary * _Nonnull)dictionaryRepresentation;

- (NSString * _Nullable)stringValueKey:(NSString * _Nonnull)key;

- (NSInteger)intValueKey:(NSString * _Nonnull)key;

- (BOOL)boolValueKey:(NSString *_Nonnull)key;

- (id _Nullable)objectValueKey:(NSString *_Nonnull)key;

@end
