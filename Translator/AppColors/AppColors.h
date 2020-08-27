//
//  AppColors.h
//  Translator
//
//   2/7/18.
//  
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Color(r,g,b,a) [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]

@interface AppColors : NSObject

+ (UIColor *) appBlueColor;
+ (UIColor *) appLightBlueColor;
+ (UIColor *) appDarkBlueColor;
+ (UIColor *) appGreenColor;
+ (UIColor *) appRedColor;
+ (UIColor *) appPurpleColor;
+ (UIColor *) appGrayColor;
+ (UIColor *) settingsTableBackgroundColor;

@end
