//
//  ImageTools.m
//  Translator
//
//   4/22/16.
//  Copyright © 2016 Dev. 
//

#import "ImageTools.h"

@implementation ImageTools

//MARK: favImageTools
//makes all the stuff for favVC
+ (UIImage *) setMask:(UIImage *) mask forTheFlag:(UIImage *) flag
{
    UIImage *maskedFlag = [ImageTools maskImage:flag withMask:mask];
    UIImage *malevichSquare = [ImageTools makeMalevichwithSize:flag.size];
    UIImage *maskForMalevich = [ImageTools imageWithImage:mask convertToSize:CGSizeMake(mask.size.width+5, mask.size.height+5)];
    UIImage *maskedMalevich = [ImageTools maskImage:malevichSquare withMask:maskForMalevich];
    UIImage *finalImage = [ImageTools drawImage:maskedFlag inImage:maskedMalevich atPoint:CGPointMake(0, 0)];
    return finalImage;
}

//set's a mask over the image //white -  transparent; black - the image
+ (UIImage *) maskImage:(UIImage *) image withMask:(UIImage *) maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    return maskedImage;
}

//draws a image over another Image at a specific point
+ (UIImage *) drawImage:(UIImage *) fgImage inImage:(UIImage *) bgImage atPoint:(CGPoint) point
{
    //adding flag over the black part
    UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake(point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *theNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theNewImage;
}

//creates a black square on specific size
+ (UIImage *) makeMalevichwithSize:(CGSize) size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage * malevichSquare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return malevichSquare;
}

//converts image to given size
+ (UIImage *) imageWithImage:(UIImage *) image convertToSize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end

