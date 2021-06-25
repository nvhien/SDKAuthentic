//
//  ZLTextField.h

//
//  Created by thanhvu on 3/16/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZLTextFieldStatus) {
    ZLTextFieldError,
    ZLTextFieldNormal,
    ZLTextFieldDisable
};

@interface ZLTextField : UITextField

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, strong) IBInspectable UIColor *holderColor;
@property (nonatomic, strong) IBInspectable UIImage *image;

@property (nonatomic, assign) ZLTextFieldStatus status;
-(void) setLeftPadding:(int) paddingValue;

-(void) setRightPadding:(int) paddingValue;

@end
