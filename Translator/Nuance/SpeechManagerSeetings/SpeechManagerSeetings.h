//
//  SpeechManagerSeetings.h
//  Translator
//
//   11/25/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>

#define Nuance_APP_HOST @"frb.nmdp.nuancemobility.net"
#define Nuance_APP_PORT 443

@interface SpeechManagerSeetings : NSObject

typedef NS_ENUM(NSInteger, PARAM_LIST)
{
    Speech_to_Text, //asr
    Text_to_Speech, //tts
    Male_Voice,
    Female_Voice
};

typedef NS_ENUM(NSInteger, TRANSACTION_STATE)
{
    TS_IDLE,
    TS_INITIAL,
    TS_RECORDING,
    TS_PROCESSING,
};

+ (SpeechManagerSeetings *) summon;
- (NSString *) getParam:(NSUInteger) paramIndex forLanguage:(NSString *) lang;

//MARK: ALERTS
- (void) checkVolumeLevel;
- (void) showNoLanguageAvailableForSpeechAlert;
- (void) showNoSpeechInputAlert;

@end
