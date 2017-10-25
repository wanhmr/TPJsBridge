//
//  UIView+TPJsBridge.m
//  Pods-TPJsBridge
//
//  Created by Tpphha on 2017/10/25.
//

#import "UIView+TPJsBridge.h"

@implementation UIView (TPJsBridge)

- (UIViewController *)tp_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = view.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
