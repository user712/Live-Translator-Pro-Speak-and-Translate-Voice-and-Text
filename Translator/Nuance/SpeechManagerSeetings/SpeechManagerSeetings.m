//
//  SpeechManagerSeetings.m
//  Translator
//
//   11/25/15.
//  Copyright © 2015 Dev. 
//

#import "SpeechManagerSeetings.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Tools.h"

//production credentials
const unsigned char SpeechKitApplicationKey[] =
{
    0xa0, 0x19, 0x08, 0x4a, 0x65, 0x30, 0xbb, 0x90,
    0x07, 0x13, 0x89, 0xe6, 0xae, 0x66, 0xa4, 0x95,
    0x16, 0x03, 0x51, 0xf2, 0x34, 0xdb, 0xe9, 0x48,
    0x07, 0x2e, 0x47, 0x23, 0x97, 0x11, 0xca, 0x37,
    0x2b, 0xd3, 0x81, 0x90, 0x03, 0x3d, 0x20, 0x0a,
    0x50, 0xa9, 0xf0, 0xfe, 0x10, 0x95, 0x93, 0x26,
    0x98, 0xe4, 0x18, 0xcd, 0xbf, 0x01, 0x15, 0xc6,
    0x30, 0x5c, 0xe9, 0xc7, 0x6e, 0xb4, 0xfe, 0x99
};

@interface SpeechManagerSeetings()

@property (nonatomic, assign) BOOL noVolumeMessageHasBeenShown;

@end

@implementation SpeechManagerSeetings

static NSArray *paramList;
static SpeechManagerSeetings *m_Nuance_Demon;
static NSDictionary *nuancePramFile;

+ (void) initialize
{
    paramList = [[NSArray alloc] initWithObjects:
                 @"asr", //index for Speech-to-Text
                 @"tts", //index for Text-to-Speech
                 @"male", //the voice
                 @"female", //the voice
                 nil];
    nuancePramFile = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"langs" ofType:@"plist"]];
}

+ (SpeechManagerSeetings *) summon
{
    if (!m_Nuance_Demon)
    {
        m_Nuance_Demon = [[SpeechManagerSeetings alloc] init];
    }
    return m_Nuance_Demon;
}

- (NSString *) getParam:(NSUInteger) paramIndex
{
    return [paramList objectAtIndex:paramIndex];
}

- (NSString *) getParam:(NSUInteger) paramIndex forLanguage:(NSString *) lang
{
    //case for zh
    if ([lang isEqualToString:@"zh-CN"] || [lang isEqualToString:@"zh-TW"])
    {
        lang = @"zh";
    }
    
    NSDictionary *foo = nuancePramFile[lang];
    if (foo)
    {
        if (paramIndex == Male_Voice || paramIndex == Text_to_Speech || paramIndex == Female_Voice)
        {
            if (foo[@"tts"] == [NSNumber numberWithBool:NO])
            {
                return nil;
            }
            else
            {
                if (paramIndex == Male_Voice)
                {
                    return ![foo[@"male"] isEqual:@(0)] ? foo[@"male"] : foo[@"female"];
                }
                else
                {
                    return ![foo[@"female"] isEqual:@(0)] ? foo[@"female"] : foo[@"male"];
                }
            }
        }
        return foo[[m_Nuance_Demon getParam:paramIndex]] == [NSNumber numberWithBool:NO] ? nil : foo[[m_Nuance_Demon getParam:paramIndex]];
    }
    return nil;
}

//MARK: ALERTS
- (void) checkVolumeLevel
{
#ifdef I_AM_IN_THE_MAIN_APP
    if (self.noVolumeMessageHasBeenShown)
    {
        return;
    }
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    
    if (volume == 0)
    {
        [Tools showToastWithMessage:NSLocalizedString(@"soundOFF", nil) withDuration:3];
        self.noVolumeMessageHasBeenShown = YES;
    }
#endif
}

- (void) showNoLanguageAvailableForSpeechAlert
{
#ifdef I_AM_IN_THE_MAIN_APP
    [Tools showToastWithMessage:NSLocalizedString(@"noTTS", nil) withDuration:3];
#endif
}

- (void) showNoSpeechInputAlert
{
#ifdef I_AM_IN_THE_MAIN_APP
    [Tools showToastWithMessage:NSLocalizedString(@"noSpeachInput", nil) withDuration:3];
#endif
}

@end
