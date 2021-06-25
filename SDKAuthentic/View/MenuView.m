//
//  MenuView.m
//  LaucherGame
//
//  Created by Ngo  Hien on 04/06/2021.
//

#import "MenuView.h"
#import "Macro.h"

@implementation MenuButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    MenuButton *button = [super buttonWithType:buttonType];
    {
        // default
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
    }
    return button;
}
@end

@interface MenuView() <MenuViewDataSource>{
    MenuButton *selectedButton;
    float paddingLeft_;
    float paddingRight_;
    float buttonWidth_;
}

@property (nonatomic, assign) MenuViewType selectedType;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, nonnull, strong) NSMutableArray *buttonArrays;

@property (nonatomic, assign) MenuAlignment alignment;

- (NSString *)p_titleWithType:(MenuViewType)type;

- (void)p_setSelectedMenuButton:(MenuButton *)button;

@end

@implementation MenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    paddingLeft_ = 0.0f;
    paddingRight_ = 0.0f;
    
    _indicatorView = [[UIView alloc] init];
    [self addSubview:_indicatorView];
    
    if ([self respondsToSelector:@selector(menuView:indicatorView:)]) {
        [self menuView:self indicatorView:_indicatorView];
    }
    
    if ([self respondsToSelector:@selector(alignment)]) {
        _alignment = [self alignment];
    }
    _alignment = MenuAlignmentCenter;
}

+ (id)menuWithTypes:(MenuViewType)firstType, ... {
    MenuView *menuView = [MenuView new];
    
    [menuView setTypes:firstType, nil];
    
    return menuView;
}

- (NSString *)p_titleWithType:(MenuViewType)type {
    switch (type) {
        case MenuViewType_Profile:
            return @"THÔNG TIN";
            break;
        case MenuViewType_Secure:
            return @"BẢO MẬT";
            break;
        default:
            return nil;
            break;
    }
}

- (void)p_setSelectedMenuButton:(MenuButton *)button {
    if (selectedButton) {
        selectedButton.selected = NO;
    }
    
    selectedButton = button;
    selectedButton.selected = YES;
    
    _selectedType = button.type;
    
    [self setButtonFontSelectedType:button.type];
    
    if (_delegate && [_delegate respondsToSelector:@selector(menuView:willSelectedType:)]) {
        [_delegate menuView:self willSelectedType:_selectedType];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _indicatorView.frame;
        f.origin.x = CGRectGetMinX(button.frame);
        f.size.width = CGRectGetWidth(button.frame);
        _indicatorView.frame = f;
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(menuView:didSelectedType:)]) {
            [_delegate menuView:self didSelectedType:_selectedType];
        }
    }];
}

- (void)setTypes:(MenuViewType)firstType, ... {
    NSMutableArray *_typesArray = [NSMutableArray array];
    MenuViewType type;
    va_list argumentList;
    
    [_typesArray addObject:@(firstType)];
    
    va_start(argumentList, firstType);
    while ((type = va_arg(argumentList, MenuViewType))) {
        [_typesArray addObject:@(type)];
    }
    
    va_end(argumentList);
    
    NSInteger count = [_typesArray count];
    
    buttonWidth_ = (CGRectGetWidth(self.frame) - 24.0)/count;
    float buttonHeight_ = self.frame.size.height - 2;
    
    _indicatorView.frame = CGRectMake(paddingLeft_, buttonHeight_, buttonWidth_, 2);
    _indicatorView.backgroundColor = RGBA(29, 178, 81, 1.0);
    
    _buttonArrays = [NSMutableArray array];
    
    // init
    float positionX = 0.0;
    for (int i = 0; i < count; i++) {
        
        MenuViewType type = [[_typesArray objectAtIndex:i] intValue];
        
        MenuButton *button = [MenuButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self p_titleWithType:type] forState:UIControlStateNormal];
        [button setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [button setTitleColor:RGBA(29, 178, 81, 1.0) forState:UIControlStateSelected];
        // set properties
        button.index = i;
        button.type = type;
        
        CGRect frame;
        
        switch (_alignment) {
            case MenuAlignmentLeft: {
                [button sizeToFit];
                frame.size = CGSizeMake(CGRectGetWidth(button.bounds) , buttonHeight_);
                frame.origin = CGPointMake(positionX + paddingLeft_, 0);
                
                positionX = CGRectGetMaxX(frame);
            }
                break;
            case MenuAlignmentCenter: {
                [button sizeToFit];
                frame = CGRectMake(i * buttonWidth_ + paddingLeft_, 0, buttonWidth_, buttonHeight_);
                
                positionX = CGRectGetMaxX(frame);
            }
                break;
            default:
                break;
        }
        // frame
        button.frame = frame;
//        button.backgroundColor = i%2==0?[UIColor redColor]:[UIColor greenColor];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelected:)]];
        [self addSubview:button];
        
        [_buttonArrays addObject:button];
    }
}

- (void)setSelectedType:(MenuViewType)type {
    for (MenuButton *button in _buttonArrays) {
        if (button.type == type) {
            [self p_setSelectedMenuButton:button];
            break;
        }
    }
}

- (void)setButtonFontSelectedType:(MenuViewType)type {
    for (MenuButton *button in _buttonArrays) {
//        if (button.type == type) {
//            [button.titleLabel setFont:[UIFont fontWithName:APPLICATION_FONT_MEDIUM size:16]];
//        }
//        else{
//            [button.titleLabel setFont:[UIFont fontWithName:APPLICATION_FONT_MEDIUM size:16]];
//        }
    }
}

- (void)onSelected:(UITapGestureRecognizer *)gesture {
    if (_untouched) {
        return;
    }
    UIView *view = gesture.view;
    if ([view isKindOfClass:[MenuButton class]] && view != selectedButton) {
        [self p_setSelectedMenuButton:(MenuButton *)view];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
