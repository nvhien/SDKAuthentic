//
//  BaseList.h
//
//  Created by thanhvu on 1/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OperatorType {
    OperatorType_Or,
    OperatorType_And
} OperatorType;

@interface BaseList : NSObject

@property(nonatomic, strong, getter = items) NSMutableArray *items;
@property(nonatomic, assign, readonly, getter = count) NSInteger count;

// get item at index
- (id)itemAtIndex:(NSInteger) index;

// find items by predicate OR
- (NSArray *)findItemsByValue:(NSString *)value withKeys:(NSArray *)keys type:(OperatorType)type;

- (NSArray *)findItemsByEqualValue:(NSInteger)value withKeys:(NSArray *)keys type:(OperatorType)type;

// remove item
- (BOOL)removeObjectAtIndex:(NSInteger)index;

// insert
- (BOOL)insertObject:(id)object atIndex:(NSInteger)index;

// add
- (BOOL)addObject:(id)object;

// sub array
- (id)subList:(int)startIndex length: (int)length;

// order
- (void)orderField:(NSString *)name ascending:(BOOL)asc;

// append
- (void)append:(BaseList *)list;

// index of object
- (NSInteger)indexOfObject:(id)anObject;

@end
