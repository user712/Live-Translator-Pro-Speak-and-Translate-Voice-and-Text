//
//  SpeechManagerNuance.h
//  Translator
//
//   2/4/16.
//  Copyright © 2016 Dev. 
//

#import <Foundation/Foundation.h>
#import "SpeechKit/SpeechKit.h"
#import "SpeechManagerSeetings.h"
#import "Settings.h"

extern NSString * const SpeechManagerRecordingStartedNotification;
extern NSString * const SpeechManagerRecordingFinishedNotification;
extern NSString * const SpeechManagerRecordingReceivedResultsNotification;

@interface SpeechManagerNuance : NSObject <SpeechKitDelegate, SKVocalizerDelegate, SKRecognizerDelegate>
{
    BOOL isSpeaking;
    SKVocalizer *vocalizer;
    SKRecognizer *voiceSearch;
}

@property (strong, nonatomic) NSString *textToBeSpoken;
@property (strong, nonatomic) NSString *languageOfTheText;
@property (weak, nonatomic) UIButton *theListenButton;
@property (assign, nonatomic) NSInteger transactionState;

+ (SpeechManagerNuance *) summon;
- (BOOL) internetConnectionIsReachable;

//TEXT TO SPEECH:
- (void) speak;
- (void) speakText:(NSString *) text;
- (void) speakText:(NSString *) text withLanguage:(NSString *) lang andSender:(UIButton *) sender;

//SPEECH TO TEXT:
- (void) initSpeechToTextSettings;
- (void) startRecord;

@end
