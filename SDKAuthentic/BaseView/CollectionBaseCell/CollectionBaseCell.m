//
//  CollectionBaseCell.m
//  music.application
//
//  Created by thanhvu on 6/27/17.
//  Copyright © 2017 Zilack. All rights reserved.
//

#import "CollectionBaseCell.h"

@interface CollectionBaseCell()

- (void)p_initializeSubviews;

@end

@implementation CollectionBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_initializeSubviews];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self p_initializeSubviews];
    }
    return self;
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

- (void)p_initializeSubviews {
    NSString *className = NSStringFromClass([self class]);
    
    [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
    
    [self addSubview:self.view];
    NSLog(@"@className : ", className);
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:self.view attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:self.view attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:self.view attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:self.view attribute:NSLayoutAttributeRight]];
}

@end
