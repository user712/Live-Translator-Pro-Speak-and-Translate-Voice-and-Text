//
//  RemoteSettingsManager.h
//
//   23/12/15.
//  Copyright © 2015 dev. 
//

#import <Foundation/Foundation.h>

typedef void (^RemoteSettingsRequestCompletionBlock)(NSError *error);

@interface RemoteSettingsManager : NSObject

+ (id) sharedManager;
- (void) loadRemoteSettingsWithCompletion:(RemoteSettingsRequestCompletionBlock) completionBlock;

@end
