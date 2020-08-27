//
//  MainAppConnectivity.h
//  Cloudify
//
//    on 08/12/15.
//  Copyright © 2015. 
//

#import <Foundation/Foundation.h>

@interface MainAppConnectivity : NSObject

+ (id) sharedConnection;
- (void) activateWatchSession;

@end
