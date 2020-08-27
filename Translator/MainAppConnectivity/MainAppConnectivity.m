//
//  MainAppConnectivity.m
//  Cloudify
//
//    on 08/12/15.
//  Copyright © 2015. 
//

#import "MainAppConnectivity.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "TranslationManager.h"
#import "SpeechManagerSeetings.h"
#import "NuanceWebApiRequestDemon.h"
#import "LanguageSelectDemon.h"
#import "NSData+GZIP.h"
#import "ExtAudioConverter.h"

typedef NS_ENUM(NSInteger, SESSION_REASON)
{
    GET_TRANSLATE,
    SYNC_WATCH_WITH_PHONE_LANG,
    SYNC_PHONE_WITH_WATCH_LANG
};

@interface MainAppConnectivity() <WCSessionDelegate>

@end

@implementation MainAppConnectivity

#pragma mark - Initializations
+ (id) sharedConnection
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void) activateWatchSession
{
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (BOOL) sessionIsReachable
{
    WCSession *session = [WCSession defaultSession];
    return session.isReachable;
}

- (NSData *) convertMP4DataToWAV:(NSData *) mp4Data
{
    NSString *sourceFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempAudio.mp4"];
    [mp4Data writeToFile:sourceFilePath atomically:YES];
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.wav"];
    
    ExtAudioConverter *converter = [[ExtAudioConverter alloc] init];
    converter.inputFile =  sourceFilePath;
    converter.outputFile = outputFilePath;
    converter.outputSampleRate = 8000;
    converter.outputNumberChannels = 1;
    converter.outputBitDepth = BitDepth_16;
    converter.outputFormatID = kAudioFormatLinearPCM;
    converter.outputFileType = kAudioFileWAVEType;
    [converter convert];
    
    NSData *resultData = [NSData dataWithContentsOfFile:outputFilePath];
    return resultData;
}

#pragma mark - WCSessionDelegate Methods
- (void) session:(WCSession *) session didReceiveMessage:(NSDictionary<NSString *,id> *) userInfo replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull)) replyHandler
{
    NSDictionary *foo = userInfo;
    if ([userInfo[@"reason"] isEqualToNumber:@(GET_TRANSLATE)])
    {
        NSString *bar = [[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:foo[@"langFrom"]];
        
        [NuanceWebApiRequestDemon summon].fromLang = foo[@"langFrom"];
        [NuanceWebApiRequestDemon summon].tolang = foo[@"langTo"];
        
        NSData *zippedData = foo[@"data"];
        NSData *uncompressedData = zippedData;
        
        if ([zippedData isGzippedData])
        {
            uncompressedData = [zippedData gunzippedData];
        }
        
        NSData *wavData = [self convertMP4DataToWAV:uncompressedData];
        [NuanceWebApiRequestDemon sendTextRecognitionRequestForLanguage:bar withData:wavData withCompletionBlock:^(id  _Nonnull receivedObject) {
            
            NSString *foo;
            @try
            {
                foo = [[NSString alloc] initWithData:receivedObject encoding:NSUTF8StringEncoding]; //resposne comes in UTF8 bites, if it's not a error message, duh O_o
            }
            @catch (NSException *exception)
            {
                NSLog(@"well we got the error %@, %@",exception, [exception userInfo]);
                replyHandler(@{@"error":[NSKeyedArchiver archivedDataWithRootObject:receivedObject]});
                return;
            }
            @finally
            {
                NSLog(@"guess empty here");
            }
            
            NSMutableArray * bar = [[foo componentsSeparatedByString:@"\n"] mutableCopy]; //separating result into array
            [bar removeObject:@""]; //it summons an empty string, and don't like it, so...
            
            [[TranslationManager sharedManager] formRequestForLanguage:@[[NuanceWebApiRequestDemon summon].fromLang,[NuanceWebApiRequestDemon summon].tolang]
                                                  text:[bar objectAtIndex:0]
                                              onSucces:^(NSDictionary *result) {
                                                  NSError *error;
                                                  replyHandler(@{@"langFrom" : [NuanceWebApiRequestDemon summon].fromLang,
                                                                 @"langTo" : [NuanceWebApiRequestDemon summon].tolang,
                                                                 @"initText" : [bar objectAtIndex:0],
                                                                 @"transText" : result[@"text"][0]
                                                                 });
                                                  if (error)
                                                  {
                                                      NSLog(@"well something went wrong while updating applicationContext : %@, %@", error, [error userInfo]);
                                                  }
                                              }
                                               onError:^(NSError *error) {
                                                   NSLog(@"well, could not translate from watch cause : %@, %@",error, [error userInfo]);
                                               }];
        }];
    }
    else if([userInfo[@"reason"] isEqualToNumber:@(SYNC_WATCH_WITH_PHONE_LANG)])
    {
        replyHandler(@{@"source": [[LanguageSelectDemon summon] getCurrentSourceLanguage], @"destination": [[LanguageSelectDemon summon] getCurrentDestinationlanguage]});
    }
    else
    {
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:userInfo[@"source"]];
        [[LanguageSelectDemon summon] setCurrentDestinationlanguage:userInfo[@"destination"]];
        replyHandler(@{});
    }
}

- (void) session:(WCSession *) session didReceiveFile:(WCSessionFile *) file
{
    [[WCSession defaultSession] sendMessage:@{@"status" : @"FILE RECEIVED 2"} replyHandler:nil errorHandler:nil];
}

@end
