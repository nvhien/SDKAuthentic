//
//  UIStoryboard+Extension.m

//
//  Created by thanhvu on 4/4/17.
//

#import "UIStoryboard+Extension.h"

@implementation UIStoryboard (Extension)
+ (id)viewController:(NSString *)identifier storyBoard:(NSString *)storyBoard {
    UIStoryboard *_storyboard = [UIStoryboard storyboardWithName:storyBoard
                                                          bundle: nil];
    
    return [_storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
