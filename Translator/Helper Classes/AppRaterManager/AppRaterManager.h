//
//  AppRaterManager.h
//  Translator
//
//   1/31/18.
//  
//

#import <Foundation/Foundation.h>

@interface AppRaterManager : NSObject

//MARK: Initializations
+ (id) sharedManager;

//MARK: Rate Methods
- (void) updateAppID:(NSString *) applicationID;
- (void) loadRaterSettings;
- (void) appEnteredForeground;

@end
