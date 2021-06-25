//
//  ZLView.h

//
//  Created by thanhvu on 1/10/16.
//  Copyright © 2016 Zilack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLView : UIView
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@end
