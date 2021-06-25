//
//  MenuView.h
//  LaucherGame
//
//  Created by Ngo  Hien on 04/06/2021.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, MenuAlignment) {
    MenuAlignmentLeft,
    MenuAlignmentCenter
};

typedef NS_OPTIONS(NSInteger, MenuViewType) {
    MenuViewType_Profile,
    MenuViewType_Secure,
};

@class MenuView;
@protocol MenuViewDelegate <NSObject>

@optional

- (void)menuView:(MenuView *)view willSelectedType:(MenuViewType)type;
- (void)menuView:(MenuView *)view didSelectedType:(MenuViewType)type;

@end

@protocol MenuViewDataSource <NSObject>

@optional
- (void)menuView:(MenuView *)view indicatorView:(UIView *)indicatorView;
- (UIColor *)menuViewItemNormalColor;
- (UIColor *)menuViewItemSelectedColor;
- (MenuAlignment)alignment;
@end

@interface MenuView : UIView
{
}

@property (nonatomic, assign) id<MenuViewDelegate> delegate;

@property (nonatomic, assign, setter=setTouchDisable:) BOOL untouched;

+ (id)menuWithTypes:(MenuViewType)types,...;

- (void)setTypes:(MenuViewType)firstType, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setSelectedType:(MenuViewType)type;

@end

@interface MenuButton : UIButton
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) MenuViewType type;
@end

