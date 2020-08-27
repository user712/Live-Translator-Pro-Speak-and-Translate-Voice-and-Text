//
//  UIImage+Tint.h
//  CustomKeyboards
//
//    on 26/08/14.
//  Copyright (c) 2014 . 
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *) color;
- (UIImage *) imageWithTintColor:(UIColor *) color fraction:(CGFloat) fraction;

@end
