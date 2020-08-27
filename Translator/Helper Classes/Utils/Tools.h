//
//  Tools.h
//  Translator
//
//   tmp on 10/28/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>

#define errorSign NSLog(@"\u274C");

@interface Tools : NSObject

+ (NSMutableArray *) moveOnTopRecetObjectAtIndex:(NSInteger) index fromArray:(NSMutableArray *) array;
+ (BOOL) coorectIndex:(NSInteger) index forArray:(id) array;
+ (id) min:(id) item1 and:(id) item2;
+ (BOOL) getBoolValueFromString:(NSString *) inString;
+ (void) setAndSyncNsuserDefaultsObject:(id) obj forKey:(NSString *) key;
+ (BOOL) smartSearchIn:(NSString *) inString the:(NSString *) string;
+ (NSString *) bundleAndVersionString;
+ (NSString *) applicationNameAndVersion;
+ (NSString *) deviceModel;
+ (NSString *) systemVersion;

#ifdef I_AM_IN_THE_MAIN_APP
+ (void) showToastWithMessage:(NSString *) toastMessage withDuration:(NSTimeInterval) duration;
#endif

@end
