//
//  ImageTools.h
//  Translator
//
//   4/22/16.
//  Copyright © 2016 Dev. 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTools : NSObject

+ (UIImage *) setMask:(UIImage *) mask forTheFlag:(UIImage *) flag;
+ (UIImage *) maskImage:(UIImage *) image withMask:(UIImage *) maskImage;
+ (UIImage *) drawImage:(UIImage *) fgImage inImage:(UIImage *) bgImage atPoint:(CGPoint) point;
+ (UIImage *) makeMalevichwithSize:(CGSize) size;
+ (UIImage *) imageWithImage:(UIImage *) image convertToSize:(CGSize) size;

@end
