//
//  BaseList.m
//
//  Created by thanhvu on 1/17/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "BaseList.h"

@implementation BaseList

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    
    return self;
}

// get all items
- (NSArray *)items {
    return _items;
}

// get item at index
- (id)itemAtIndex:(NSInteger) index {
    if (!_items || index >= [_items count]) {
        return nil;
    }
    
    return [_items objectAtIndex:index];
}

// count
- (NSInteger) count {
    if (!_items) {
        return 0;
    }
    return [_items count];
}

// remove

// remove item
- (BOOL)removeObjectAtIndex:(NSInteger)index {
    if (_items && [_items count] > index) {
        [_items removeObjectAtIndex:index];
        return YES;
    }
    
    return NO;
}

- (BOOL)insertObject:(id)object atIndex:(NSInteger)index {
    if (index <= [_items count]) {
        [_items insertObject:object atIndex:index];
        return YES;
    }
    return NO;
}

- (BOOL)addObject:(id)object {
    if (_items && object) {
        [_items addObject:object];
        
        return YES;
    }
    return NO;
}

- (NSArray *)findItemsByEqualValue:(NSInteger)value withKeys:(NSArray *)keys type:(OperatorType)type {
    NSMutableArray *parr = [NSMutableArray array];
    
    for (int i = 0; i < [keys count]; i++) {
        [parr addObject:[NSPredicate predicateWithFormat:@"(%K == %ld)", keys[i], value]];
    }
    
    NSPredicate *compoundpred = nil;
    if (type == OperatorType_Or) {
        compoundpred = [NSCompoundPredicate orPredicateWithSubpredicates:parr];
    } else if (type == OperatorType_And) {
        compoundpred = [NSCompoundPredicate andPredicateWithSubpredicates:parr];
    } else {
        compoundpred = nil;
    }
    
    if (compoundpred) {
        return [self.items filteredArrayUsingPredicate:compoundpred];
    } else {
        return self.items;
    }
}

// filtered
- (NSArray *)findItemsByValue:(NSString *)value withKeys:(NSArray *)keys type:(OperatorType)type {
    
    NSMutableArray *parr = [NSMutableArray array];
    
    for (int i = 0; i < [keys count]; i++) {
        [parr addObject:[NSPredicate predicateWithFormat:@"(%K BEGINSWITH[c] %@) OR (%K CONTAINS[c] %@)", keys[i], value,
                         keys[i], [NSString stringWithFormat:@" %@", value]]];
    }

    NSPredicate *compoundpred = nil;
    if (type == OperatorType_Or) {
        compoundpred = [NSCompoundPredicate orPredicateWithSubpredicates:parr];
    } else if (type == OperatorType_And) {
        compoundpred = [NSCompoundPredicate andPredicateWithSubpredicates:parr];
    } else {
        compoundpred = nil;
    }
    
    if (compoundpred) {
        return [self.items filteredArrayUsingPredicate:compoundpred];
    } else {
        return self.items;
    }
}

- (id)subList:(int)startIndex length: (int)length {
    if (_items && [_items count] > 0 && [_items count] > startIndex) {
        NSInteger endIndex = startIndex + length;
        if (endIndex > [_items count]) {
            endIndex = [_items count];
        }
        
        BaseList *list = [BaseList new];
        list.items = [NSMutableArray arrayWithArray:[_items subarrayWithRange:NSMakeRange(startIndex, endIndex)]];
        return list;
    }
    
    return nil;
}

- (void)orderField:(NSString *)name ascending:(BOOL)asc {
    
//    NSString *tmp = [AppUtils convertVietNam:name];
//    
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:tmp
//                                                                 ascending:asc];
//    
//    NSArray *items = [_items sortedArrayUsingDescriptors:@[descriptor]];
//    self.items = [NSMutableArray arrayWithArray:items];
}

- (void)append:(BaseList *)list {
    if ([list isKindOfClass: [self class]]) {
        if (!_items) {
            _items = [NSMutableArray array];
        }
        
        [_items addObjectsFromArray:list.items];
    }
}

- (NSInteger)indexOfObject:(id)anObject {
    NSInteger idx = [_items indexOfObject:anObject];
    
/*
    if (idx && idx > 0) {
        return idx;
    } else {
        return -1;
    }
*/
    return idx;
}
@end
