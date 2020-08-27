//
//  TranslationManager.h
//  Translator
//
//   tmp on 10/29/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LanguageList.h"
#import "TranslationSourceDemon.h"

@interface TranslationManager : NSObject

+ (instancetype) sharedManager;
- (void) formRequestForLanguage:(NSArray *) lang text:(NSString *) txt onSucces:(void(^)(NSDictionary *result)) onSuccesBlock onError:(void(^)(NSError *error)) onErrorBlock;
- (void) formAutodetectForText:(NSString *) txt onSucces:(void(^)(NSDictionary *result)) onSuccesBlock onError:(void (^)(NSError *error)) onErrorBlock;

@end
