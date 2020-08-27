//
//  KeysManager.m
//  Translator
//
//   1/12/18.
//  
//

#import "KeysManager.h"

NSString * const apiKeyYandexDefault = @"_KEY_";
NSString * const apiKeyGoogleDefault = @"_KEY_";
NSString * const appIdWatchNuanceDefault = @"_KEY_";
NSString * const appKeyWatchNuanceDefault = @"_KEY_";
NSString * const appIdNuanceDefault = @"_KEY_";

@implementation KeysManager

#pragma mark - Initializations
+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self defaultInits];
    }
    return self;
}

- (void) defaultInits
{
    self.apiKeyYandex = apiKeyYandexDefault;
    self.apiKeyGoogle = apiKeyGoogleDefault;
    self.appIdNuance = appIdNuanceDefault;
    self.appIdWatchNuance = appIdWatchNuanceDefault;
    self.appKeyWatchNuance = appKeyWatchNuanceDefault;
}

@end
