//
//  ZLRoundButton.m

//
//  Created by thanhvu on 1/10/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "ZLView.h"
@interface ZLView()
@end

@implementation ZLView

- (void)p_initDefault {
//    self.backgroundColor = [UIColor clearColor];
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_initDefault];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_initDefault];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    self.backgroundColor = [UIColor clearColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect innerRect = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)), _borderWidth/2.0, _borderWidth/2.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:_cornerRadius];
    CGContextAddPath(context, path.CGPath);
    
    [_borderColor setStroke];
    [_fillColor setFill];
    
    path.lineWidth = _borderWidth;
    [path stroke];
    [path fill];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}
@end
