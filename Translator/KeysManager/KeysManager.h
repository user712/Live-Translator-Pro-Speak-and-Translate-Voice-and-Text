//
//  KeysManager.h
//  Translator
//
//   1/12/18.
//  
//

#import <Foundation/Foundation.h>

@interface KeysManager : NSObject

@property (nonatomic, copy) NSString *apiKeyYandex;
@property (nonatomic, copy) NSString *apiKeyGoogle;
@property (nonatomic, copy) NSString *appIdNuance;
@property (nonatomic, copy) NSString *appIdWatchNuance;
@property (nonatomic, copy) NSString *appKeyWatchNuance;

+ (id) sharedManager;

@end
