//
//  SpeechManagerNuance.m
//  Translator
//
//   2/4/16.
//  Copyright © 2016 Dev. 
//

#import "SpeechManagerNuance.h"
#import "ErrorMessageGenerator.h"
#import <AVFoundation/AVFoundation.h>
#import "KeysManager.h"
#import "LanguageSelectDemon.h"
#import "AFNetworking.h"

NSString * const SpeechManagerRecordingStartedNotification = @"SpeechManagerRecordingStartedNotification";
NSString * const SpeechManagerRecordingFinishedNotification = @"SpeechManagerRecordingFinishedNotification";
NSString * const SpeechManagerRecordingReceivedResultsNotification = @"SpeechManagerRecordingReceivedResultsNotification";

@implementation SpeechManagerNuance

static SpeechManagerNuance *m_SpeechDemon;

UIButton * homeScreenSender;

+ (SpeechManagerNuance *) summon
{
    if (!m_SpeechDemon)
    {
        m_SpeechDemon = [[SpeechManagerNuance alloc] init];
    }
    return m_SpeechDemon;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self startConnectionMonitoring];
    }
    return self;
}

//MARK: SpeachKit delegates
- (void) initSpeachKit
{
    [SpeechKit setupWithID:[[KeysManager sharedManager] appIdNuance]
                      host:Nuance_APP_HOST
                      port:Nuance_APP_PORT
                    useSSL:NO
                  delegate:self];
}

- (void) speakOrStopAction
{
    if (isSpeaking)
    {
        [vocalizer cancel];
        isSpeaking = NO;
    }
    else
    {
        NSString *foo;
        foo = [[SpeechManagerSeetings summon] getParam:[Settings doIMaleVoice] ? Male_Voice : Female_Voice forLanguage:self.languageOfTheText];
        
        if (foo)
        {
            [[SpeechManagerSeetings summon] checkVolumeLevel];
            
            isSpeaking = YES;
            vocalizer = [[SKVocalizer alloc] initWithVoice:foo delegate:self];
            [vocalizer speakString:self.textToBeSpoken];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[SpeechManagerSeetings summon] showNoLanguageAvailableForSpeechAlert];
            });
            
            [self vocalizer:vocalizer didFinishSpeakingString:@"" withError:nil];
        }
    }
}

- (void) audioSessionReleased
{
    NSLog(@"AudioSession Released");
}

- (void) vocalizer:(SKVocalizer *) vocalizer willBeginSpeakingString:(NSString *) text
{
    isSpeaking = YES;
}

- (void) vocalizer:(SKVocalizer *) vocalizer willSpeakTextAtCharacter:(NSUInteger) index ofString:(NSString *) text
{
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
}

- (void) vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error
{
    [self.theListenButton setUserInteractionEnabled:YES];
    
    NSLog(@"Session id [%@]", [SpeechKit sessionID]);
    isSpeaking = NO;
    if (error != nil)
    {
        NSLog(@"vocalizer error : %@",[error localizedDescription]);
    }
    
    if (homeScreenSender != nil)
    {
        [homeScreenSender setBackgroundImage:[UIImage imageNamed:@"bnt_speaker"] forState:UIControlStateNormal];
        homeScreenSender.tag = 0;
    }
}

//MARK: userCalls
- (void) speak
{
    if (![self internetConnectionIsReachable])
    {
        [ErrorMessageGenerator showNoInternetConnectionMessage];
        return;
    }
    
    [self initSpeachKit];
    [self speakOrStopAction];
}

- (void) speakText:(NSString *) text
{
    self.textToBeSpoken = text;
    [self speak];
}

- (void) speakText:(NSString *) text withLanguage:(NSString *) lang andSender:(UIButton *) sender
{
    if (text == nil)
    {
        return;
    }
   
    if (sender.tag == 1)
    {
        homeScreenSender = sender;
        sender = nil;
    }
    
    self.theListenButton = sender;
    [self.theListenButton setUserInteractionEnabled:NO];
    self.languageOfTheText = lang;
    [self speakText:text];
}

//MARK: Helper Methods
- (void) startConnectionMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
}

- (BOOL) internetConnectionIsReachable
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return manager.reachable;
}

//MARK: SpeachKitDelegates
- (void) initSpeechToTextSettings
{
    [SpeechKit setupWithID:[[KeysManager sharedManager] appIdNuance]
                      host:Nuance_APP_HOST
                      port:Nuance_APP_PORT
                    useSSL:NO
                  delegate:self];
    
    SKEarcon *earconStart = [SKEarcon earconWithName:@"earcon_listening.wav"];
    SKEarcon *earconStop = [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    //SKEarcon *earconCancel = [SKEarcon earconWithName:@"earcon_cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    //[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}

- (void) startRecord
{
    if (self.transactionState == TS_RECORDING)
    {
        [voiceSearch stopRecording];
    }
    else if (self.transactionState == TS_IDLE)
    {
        SKEndOfSpeechDetection detectionType;
        NSString *recorType;
        NSString *langType;
        
        detectionType = SKLongEndOfSpeechDetection;
        recorType = SKDictationRecognizerType;
        langType = [[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:[[LanguageSelectDemon summon] getCurrentSourceLanguage]];

        if (langType)
        {
            self.transactionState = TS_INITIAL;
            voiceSearch = [[SKRecognizer alloc] initWithType:recorType detection:detectionType language:langType delegate:self];
        }
        else
        {
            [[SpeechManagerSeetings summon] showNoSpeechInputAlert];
        }
    }
}

//MARK: SKRecognizerDelegate methods
- (void) recognizerDidBeginRecording:(SKRecognizer *) recognizer
{
    self.transactionState = TS_RECORDING;
    [[NSNotificationCenter defaultCenter] postNotificationName:SpeechManagerRecordingStartedNotification object:nil];
}

- (void) recognizerDidFinishRecording:(SKRecognizer *) recognizer
{
    self.transactionState = TS_PROCESSING;
    [[NSNotificationCenter defaultCenter] postNotificationName:SpeechManagerRecordingFinishedNotification object:nil];
}

- (void) recognizer:(SKRecognizer *) recognizer didFinishWithResults:(SKRecognition *) results
{
    NSLog(@"Session id [%@]", [SpeechKit sessionID]);
    self.transactionState = TS_IDLE;
    voiceSearch = nil;
    if (results.results > 0 && results.firstResult)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SpeechManagerRecordingReceivedResultsNotification object:nil userInfo:@{@"results" : results.results, @"firstResult" : results.firstResult}];
    }
}

- (void) recognizer:(SKRecognizer *) recognizer didFinishWithError:(NSError *) error suggestion:(NSString *) suggestion
{
    NSLog(@"Session id [%@]", [SpeechKit sessionID]);
    self.transactionState = TS_IDLE;
    NSLog(@"and My recognition error is %@", [error localizedDescription]);
    voiceSearch = nil;
}

@end
