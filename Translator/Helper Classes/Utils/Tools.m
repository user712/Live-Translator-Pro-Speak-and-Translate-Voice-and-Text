//
//  Tools.m
//  Translator
//
//   tmp on 10/28/15.
//  Copyright © 2015 Dev. 
//


/**
 *  contains tolls I can use externaly;
 */

#import "Tools.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/utsname.h>

#ifdef I_AM_IN_THE_MAIN_APP
#import "UIView+Toast.h"
#endif

@implementation Tools

#pragma mark - TOOLS
/**
 * changes the order of elements in an array, bring the element at index tot top but keeps the initial order of other objects
 */
+ (NSMutableArray *) moveOnTopRecetObjectAtIndex:(NSInteger) index fromArray:(NSMutableArray *) array
{
    if (![Tools coorectIndex:index forArray:array])
    {
        return nil;
    }
    
    if (index != 0)
    {
        [array insertObject:[array objectAtIndexedSubscript:index] atIndex:0];
        [array removeObjectAtIndex:index+1];
    }
    return array;
}

#pragma mark - inputTests
+ (BOOL) coorectIndex:(NSInteger) index forArray:(id) array
{
    if (index < 0)
    {
        errorSign
        [NSException raise:@" Invalid index Value" format:@"index Must be >0, %ld is not",(long)index];
        return NO;
    }
    else if (array && !([array count] > 0))
    {
        errorSign
        // this happens when you press on an empty "recent language"
        // [NSException raise:@"Array not initialised or has no objects" format:@""];
        return NO;
    }
    else if (index >= (int)[array count])
    {
        errorSign
        [NSException raise:@"index out of bouds" format:@"index = %ld, arraylen = %ld",(long)index, (long)[array count]];
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (id) min:(id) item1 and:(id) item2
{
    return item1 > item2 ? item2 : item1;
}

+ (BOOL) getBoolValueFromString:(NSString *) inString
{
    return [inString isEqualToString:@"0"]?NO:YES;
}

+ (void) setAndSyncNsuserDefaultsObject:(id) obj forKey:(NSString *) key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) smartSearchIn:(NSString *) inString the:(NSString *) string
{
#ifdef I_AM_IN_THE_MAIN_APP
    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        
        return [inString containsString:string];
        
    }else{
        
        return [inString rangeOfString:string].location != NSNotFound;
    }
#endif
    return NO;
}

+ (NSString *) bundleAndVersionString
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleString = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appVersionString = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleAndVersionString = [appBundleString stringByAppendingString:appVersionString];
    return bundleAndVersionString;
}

+ (NSString *) applicationNameAndVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appNameString = [info objectForKey:/*(NSString *)kCFBundleNameKey*/@"CFBundleDisplayName"];
    NSString *appVersionString = [info objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@ %@",appNameString,appVersionString];
}

+ (NSString *) deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceOriginalName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *deviceFormattedName = deviceOriginalName;
    
    if ([deviceOriginalName isEqualToString:@"iPhone1,1"])   deviceFormattedName = @"iPhone 2G";                   //iPhone 2G
    else if ([deviceOriginalName isEqualToString:@"iPhone1,2"])   deviceFormattedName = @"iPhone 3G";              //iPhone 3G
    else if ([deviceOriginalName isEqualToString:@"iPhone2,1"])   deviceFormattedName = @"iPhone 3GS";             //iPhone 3GS
    else if ([deviceOriginalName isEqualToString:@"iPhone3,1"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - AT&T
    else if ([deviceOriginalName isEqualToString:@"iPhone3,2"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - Other carrier
    else if ([deviceOriginalName isEqualToString:@"iPhone3,3"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - Other carrier
    else if ([deviceOriginalName isEqualToString:@"iPhone4,1"])   deviceFormattedName = @"iPhone 4S";              //iPhone 4S
    else if ([deviceOriginalName isEqualToString:@"iPhone5,1"])   deviceFormattedName = @"iPhone 5";               //iPhone 5 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,2"])   deviceFormattedName = @"iPhone 5";               //iPhone 5 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,3"])   deviceFormattedName = @"iPhone 5c";              //iPhone 5c (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,4"])   deviceFormattedName = @"iPhone 5c";              //iPhone 5c (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone6,1"])   deviceFormattedName = @"iPhone 5s";              //iPhone 5s (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone6,2"])   deviceFormattedName = @"iPhone 5s";              //iPhone 5s (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone7,1"])   deviceFormattedName = @"iPhone 6 Plus";          //iPhone 6+
    else if ([deviceOriginalName isEqualToString:@"iPhone7,2"])   deviceFormattedName = @"iPhone 6";               //iPhone 6
    else if ([deviceOriginalName isEqualToString:@"iPhone8,1"])   deviceFormattedName = @"iPhone 6S";              //iPhone 6S
    else if ([deviceOriginalName isEqualToString:@"iPhone8,2"])   deviceFormattedName = @"iPhone 6S Plus";         //iPhone 6S+
    else if ([deviceOriginalName isEqualToString:@"iPhone8,4"])   deviceFormattedName = @"iPhone SE";              //iPhone SE
    else if ([deviceOriginalName isEqualToString:@"iPhone9,1"])   deviceFormattedName = @"iPhone 7";               //iPhone 7 (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone9,3"])   deviceFormattedName = @"iPhone 7";               //iPhone 7 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone9,2"])   deviceFormattedName = @"iPhone 7 Plus";          //iPhone 7 Plus (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone9,4"])   deviceFormattedName = @"iPhone 7 Plus";          //iPhone 7 Plus (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,1"])   deviceFormattedName = @"iPhone 8";               //iPhone 8 (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,4"])   deviceFormattedName = @"iPhone 8";               //iPhone 8 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,2"])   deviceFormattedName = @"iPhone 8 Plus";          //iPhone 8 Plus (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,5"])   deviceFormattedName = @"iPhone 8 Plus";          //iPhone 8 Plus (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,3"])   deviceFormattedName = @"iPhone X";               //iPhone X (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone10,6"])   deviceFormattedName = @"iPhone X";               //iPhone X (GSM)
    
    else if ([deviceOriginalName isEqualToString:@"iPod1,1"])     deviceFormattedName = @"iPod Touch 1st Gen";     //iPod Touch 1G
    else if ([deviceOriginalName isEqualToString:@"iPod2,1"])     deviceFormattedName = @"iPod Touch 2nd Gen";     //iPod Touch 2G
    else if ([deviceOriginalName isEqualToString:@"iPod3,1"])     deviceFormattedName = @"iPod Touch 3rd Gen";     //iPod Touch 3G
    else if ([deviceOriginalName isEqualToString:@"iPod4,1"])     deviceFormattedName = @"iPod Touch 4th Gen";     //iPod Touch 4G
    else if ([deviceOriginalName isEqualToString:@"iPod5,1"])     deviceFormattedName = @"iPod Touch 5th Gen";     //iPod Touch 5G
    else if ([deviceOriginalName isEqualToString:@"iPod7,1"])     deviceFormattedName = @"iPod Touch 6th Gen";     //iPod Touch 6G
    
    else if ([deviceOriginalName isEqualToString:@"iPad1,1"])     deviceFormattedName = @"iPad 1";                 //iPad Wifi
    else if ([deviceOriginalName isEqualToString:@"iPad1,2"])     deviceFormattedName = @"iPad 1";                 //iPad 3G
    else if ([deviceOriginalName isEqualToString:@"iPad2,1"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,2"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad2,3"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad2,4"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,5"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,6"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad2,7"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad3,1"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad3,2"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad3,3"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad3,4"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad3,5"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad3,6"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad4,1"])     deviceFormattedName = @"iPad Air";               //iPad Air A1474
    else if ([deviceOriginalName isEqualToString:@"iPad4,2"])     deviceFormattedName = @"iPad Air";               //iPad Air A1475
    else if ([deviceOriginalName isEqualToString:@"iPad4,3"])     deviceFormattedName = @"iPad Air";               //iPad Air A1476
    else if ([deviceOriginalName isEqualToString:@"iPad4,4"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 2 A1489
    else if ([deviceOriginalName isEqualToString:@"iPad4,5"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 2 A1490
    else if ([deviceOriginalName isEqualToString:@"iPad4,6"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 2 A1491
    else if ([deviceOriginalName isEqualToString:@"iPad4,7"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 3 A1599
    else if ([deviceOriginalName isEqualToString:@"iPad4,8"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 3 A1600
    else if ([deviceOriginalName isEqualToString:@"iPad4,9"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 3 A1601
    else if ([deviceOriginalName isEqualToString:@"iPad5,1"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 4 A1538
    else if ([deviceOriginalName isEqualToString:@"iPad5,2"])     deviceFormattedName = @"iPad Mini";              //iPad Mini 4 A1550
    else if ([deviceOriginalName isEqualToString:@"iPad5,3"])     deviceFormattedName = @"iPad Air";               //iPad Air 2 A1566
    else if ([deviceOriginalName isEqualToString:@"iPad5,4"])     deviceFormattedName = @"iPad Air";               //iPad Air 2 A1567
    else if ([deviceOriginalName isEqualToString:@"iPad6,7"])     deviceFormattedName = @"iPad Pro 12.9\"";          //iPad Pro 12.9"
    else if ([deviceOriginalName isEqualToString:@"iPad6,4"])     deviceFormattedName = @"iPad Pro 9.7\"";           //iPad Pro 9.7"
    
    else if ([deviceOriginalName isEqualToString:@"i386"])        deviceFormattedName = @"Simulator";              //Simulator
    else if ([deviceOriginalName isEqualToString:@"x86_64"])      deviceFormattedName = @"Simulator";              //Simulator
    
    return deviceFormattedName;
}

+ (NSString *) systemVersion
{
    #ifdef I_AM_IN_THE_MAIN_APP
    return [NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion];
    #endif
    return @"";
}

#ifdef I_AM_IN_THE_MAIN_APP
+ (void) showToastWithMessage:(NSString *) toastMessage withDuration:(NSTimeInterval) duration
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.backgroundColor = [AppColors appRedColor];
    toastStyle.messageAlignment = NSTextAlignmentCenter;
    [topView makeToast:toastMessage duration:duration position:CSToastPositionCenter style:toastStyle];
}
#endif

@end
