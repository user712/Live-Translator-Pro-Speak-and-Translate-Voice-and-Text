//
//  TranslationSourceDemon.h
//  Translator
//
//   2/18/16.
//  Copyright © 2016 Dev. 
//
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@interface TranslationSourceDemon : NSObject

typedef NS_ENUM(NSInteger, TRANSLATION_SOURCE)
{
    GOOGLE,
    YANDEX,
    DEFAULT
};

@property (nonnull, nonatomic, strong) NSNumber *source;

+ (TranslationSourceDemon *_Nonnull) summom;
- (BOOL) useGoogleAPI;

@end
