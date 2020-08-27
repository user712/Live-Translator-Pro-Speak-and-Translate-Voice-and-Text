//
//  UIImage+Tint.m
//  CustomKeyboards
//
//    on 26/08/14.
//  Copyright (c) 2014 . 
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *) color
{
    return [self imageWithTintColor:color fraction:0.0];
}

- (UIImage *) imageWithTintColor:(UIColor *) color fraction:(CGFloat) fraction
{
    if (color)
    {
        UIImage *image;
        
        if ([UIScreen instancesRespondToSelector:@selector(scale)])
        {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f);
        }
        else
        {
            UIGraphicsBeginImageContext([self size]);
        }

        CGRect rect = CGRectZero;
        rect.size = [self size];
        
        [color set];
        UIRectFill(rect);
        
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        if (fraction > 0.0)
        {
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return self;
}

@end
