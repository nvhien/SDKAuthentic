//
//  ZLTextField.m

//
//  Created by thanhvu on 3/16/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import "ZLTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"

@interface ZLTextField() {
    UIColor *_textColor;
    float _padding;
}

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@implementation ZLTextField

- (void)setStatus:(ZLTextFieldStatus)status {
    _status = status;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDefault];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
    }
    
    return self;
}

- (void)initDefault {
    self.backgroundColor = [UIColor clearColor];
    _padding = 0.0f;
    self.edgeInsets = UIEdgeInsetsMake(1, _padding, 1, _padding);
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    _status = ZLTextFieldNormal;
    _textColor = self.textColor;
    if (!_fillColor) {
        _fillColor = [UIColor clearColor];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (void)drawRect:(CGRect)rect {
    [self clearsContextBeforeDrawing];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect innerRect = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)), 1, 1);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:_cornerRadius];
    CGContextAddPath(context, path.CGPath);
    
    UIColor *strokeColor = _borderColor;
    UIColor *fillColor = _fillColor;
    UIColor *txtColor = _textColor;
    NSString *placeHolder = self.placeholder;
    self.placeholder = @"";
    switch (_status) {
        case ZLTextFieldError:
        {
            strokeColor = [UIColor redColor];
            fillColor = _fillColor;
            [self setEnabled:YES];
            txtColor = [UIColor redColor];
        }
            break;
        case ZLTextFieldDisable:
        {
            strokeColor = _borderColor;
            fillColor = RGB(240, 240, 240);
            [self setEnabled:NO];
            txtColor = RGB(150, 150, 150);
        }
            break;
        default:
        {
            strokeColor = _borderColor;
            fillColor = _fillColor;
            [self setEnabled:YES];
            txtColor = _textColor;
        }
            break;
    }
    self.textColor = txtColor;
    [strokeColor setStroke];
    [fillColor setFill];
    
    path.lineWidth = 0;
    [path stroke];
    [path fill];
    
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(innerRect, _borderWidth/2.0, _borderWidth/2.0) cornerRadius:_cornerRadius];
    CGContextAddPath(context, strokePath.CGPath);
    strokePath.lineWidth = _borderWidth;
    [strokePath stroke];
    
    // draw image
    if (_image) {
        CGSize imageSize = _image.size;
        [_image drawInRect:CGRectMake(_padding, (CGRectGetHeight(rect) - imageSize.height)/2, imageSize.width, imageSize.height)];
        self.edgeInsets = UIEdgeInsetsMake(1, 2 * _padding + imageSize.width, 1, _padding);
    }
    // reassign
    self.placeholder = placeHolder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder?placeHolder:@""
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: _holderColor?_holderColor:[UIColor whiteColor]
                                                                              }];
}

-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
