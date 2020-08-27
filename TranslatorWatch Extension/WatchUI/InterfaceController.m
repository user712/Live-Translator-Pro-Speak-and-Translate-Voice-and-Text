//
//  InterfaceController.m
//  TranslatorWatch Extension
//
//   12/4/15.
//  Copyright © 2015 Dev. 
//

#import "InterfaceController.h"
#import "WatchAppConnectivity.h"
#import "NSData+GZIP.h"

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *translateButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *switchLanguagesButton;

@end

@implementation InterfaceController

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneDataFetchStartedNotification:) name:PHONE_DATA_FETCH_STARTED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneDataReceivedNotification:) name:PHONE_DATA_RECEIVED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneDataFetchFailNotification:) name:PHONE_DATA_FETCH_FAIL_NOTIFICATION object:nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) phoneDataFetchStartedNotification:(NSNotification *) notification
{
    [self activityIndicatorStart];
}

- (void) phoneDataReceivedNotification:(NSNotification *) notification
{
    [self activityIndicatorStop];
}

- (void) phoneDataFetchFailNotification:(NSNotification *) notification
{
    [self activityIndicatorStop];
}

- (void) awakeWithContext:(id)context
{
    [super awakeWithContext:context];
}

- (void) willActivate
{
    [super willActivate];
    [self addObservers];
    
    [_translateFromTop setBackgroundImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentSourceLanguage]]];
    [_translateFromBottom setBackgroundImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]]];
    [_translateButton setBackgroundImage:[UIImage imageNamed:@"mic"]];
    [_switchLanguagesButton setBackgroundImage:[UIImage imageNamed:@"switchIcon"]];
    [_translateFromTop setTitle:@""];
    [_translateFromBottom setTitle:@""];
}

- (void) didDeactivate
{
    [self removeObservers];
    [super didDeactivate];
}

- (void) sendTranslationRequestForLanguageSet:(NSString *) langFrom and:(NSString *) langTo
{
    NSURL *urlOut = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_CONECTIVITY_ID];
    urlOut = [urlOut URLByAppendingPathComponent:@"myfile.mp4"];
    
    [self presentAudioRecorderControllerWithOutputURL:urlOut preset:WKAudioRecorderPresetNarrowBandSpeech
                                              options:@{
                                                        WKAudioRecorderControllerOptionsActionTitleKey:@"Translate",
                                                        WKAudioRecorderControllerOptionsAutorecordKey:[NSNumber numberWithBool:YES],
                                                        WKAudioRecorderControllerOptionsMaximumDurationKey:[NSNumber numberWithDouble:15]
                                                        }
                                           completion:^(BOOL didSave, NSError * _Nullable error) {
                                               
                                               if (error)
                                               {
                                                   NSLog(@"Recording error: %@", error.localizedDescription);
                                               }
                                               
                                               if (didSave)
                                               {
                                                   NSData *dataFromFile = [[NSData alloc] initWithContentsOfURL:urlOut];
                                                   NSData *compressedData = [dataFromFile gzippedDataWithCompressionLevel:1.0];
                                                   
                                                   if ([[WCSession defaultSession] isReachable])
                                                   {
                                                       [[WatchAppConnectivity sharedConnection] sendTranslationDataToPhone:@{@"reason" : @(GET_TRANSLATE),
                                                                                                                             @"file" : urlOut.absoluteString,
                                                                                                                             @"langFrom" : langFrom,
                                                                                                                             @"langTo" : langTo,
                                                                                                                             @"data" : compressedData}
                                                                                                              replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                                                                                                  
                                                                                                                  [self activityIndicatorStop];
                                                                                                                  
                                                                                                                  if (replyMessage[@"error"])
                                                                                                                  {
                                                                                                                      NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:replyMessage[@"error"]]);
                                                                                                                      [self presentControllerWithName:@"ErrorController" context:nil];
                                                                                                                  }
                                                                                                                  else
                                                                                                                  {
                                                                                                                      [[HistoryDemon summon] addItem:replyMessage];
                                                                                                                      [self presentControllerWithName:@"TranslationTableView" context:nil];
                                                                                                                  }
                                                                                                                  
                                                                                                              } errorHandler:^(NSError * _Nonnull error) {
                                                                                                                  
                                                                                                                  [self activityIndicatorStop];
                                                                                                              }];
                                                       [self activityIndicatorStart];
                                                   }
                                               }
                                           }];
}

- (IBAction) topButtonPressed
{
    [self presentControllerWithName:@"tempInterfaceController" context:@"top"];
}

- (IBAction) botButtonPressed
{
    [self presentControllerWithName:@"tempInterfaceController" context:@"bot"];
}

- (IBAction) switchLanguages
{
    NSString *currentSourceLanguage = [[LanguageSelectDemon summon] getCurrentSourceLanguage];
    NSString *currendDestinationLanguage = [[LanguageSelectDemon summon] getCurrentDestinationlanguage];
    
    [[LanguageSelectDemon summon] setAndSaveSourceLanguage:currendDestinationLanguage];
    [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:currentSourceLanguage];
    
    [_translateFromTop setBackgroundImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentSourceLanguage]]];
    [_translateFromBottom setBackgroundImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]]];
}

- (IBAction) translate
{
    [self sendTranslationRequestForLanguageSet:[[LanguageSelectDemon summon] getCurrentSourceLanguage] and:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]];
}

- (void) activityIndicatorStart
{
    [_translateFromTop setHidden:YES];
    [_translateFromBottom setHidden:YES];
    [_switchLanguagesButton setHidden:YES];
    [_translateButton setHidden:YES];
    [_interfaceImage setHidden:NO];
    [_interfaceImage setImageNamed:@"activity"];
    [_interfaceImage startAnimatingWithImagesInRange:NSMakeRange(0, 171) duration:2.0 repeatCount:0];
}

- (void) activityIndicatorStop
{
    [_interfaceImage stopAnimating];
    [_interfaceImage setHidden:YES];
    [_translateFromBottom setHidden:NO];
    [_translateFromTop setHidden:NO];
    [_switchLanguagesButton setHidden:NO];
    [_translateButton setHidden:NO];
}

@end

