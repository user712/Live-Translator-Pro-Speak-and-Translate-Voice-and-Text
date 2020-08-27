//
//  NuanceWebApiRequest.m
//  Translator
//
//   12/11/15.
//  Copyright © 2015 Dev. 
//

#import "NuanceWebApiRequestDemon.h"
#import <Crashlytics/Crashlytics.h>
#import "KeysManager.h"

#define URL_FOR_THE_WEB_INTERFACE_NUANCE @"https://dictation.nuancemobility.net/NMDPAsrCmdServlet/dictation"
#define DEVICE_ID_NUANCE @"0000"

@implementation NuanceWebApiRequestDemon

@synthesize delegate;

static NuanceWebApiRequestDemon *demon;

@synthesize fromLang;
@synthesize tolang;

+ (void) initialize
{
    [NuanceWebApiRequestDemon summon];
}

+ (NuanceWebApiRequestDemon *) summon
{
    if (!demon)
    {
        demon = [[NuanceWebApiRequestDemon alloc] init];
    }
    return demon;
}

+ (void) sendTextRecognitionRequestForLanguage:(NSString *) language withData:(NSData *) data  withCompletionBlock:(void (^)(id receivedObject)) completionHandler
{
    NSData *postData = data;
    NSURL *url = [demon formRequestURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:url];
    
    [request setValue:@"audio/x-wav;codec=pcm;bit=16;rate=8000" forHTTPHeaderField:@"Content-Type"];
    [request addValue:language forHTTPHeaderField:@"Content-Language"];
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Dictation" forHTTPHeaderField:@"Accept-Topic"];
    
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30.0];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"application/json", @"text/plain", nil];
    //[manager.responseSerializer setStringEncoding:kCFStringEncodingUTF8]; //DEPRECATED
    
    __block NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error)
        {
            completionHandler(error);
        }
        else
        {
            completionHandler(responseObject);
        }
    }];
    
    [task resume];
}

- (NSData *) formPostDataForFilePath:(NSString *) filePath
{
    
    NSError *error;
    NSData * foo = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] options:NSDataReadingUncached error:&error];
    
    if (error)
    {
        CLS_LOG(@"Unable to load data from file : %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return foo;
}

- (NSString *) formPostLenght:(NSData *)postData
{
    return [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
}

- (NSURL *) formRequestURL
{
    NSString *appID = [[KeysManager sharedManager] appIdWatchNuance];
    NSString *appKey = [[KeysManager sharedManager] appKeyWatchNuance];
    return  [NSURL URLWithString:[NSString stringWithFormat:@"%@?appId=%@&appKey=%@&id=%@", URL_FOR_THE_WEB_INTERFACE_NUANCE, appID, appKey, DEVICE_ID_NUANCE]];
}

@end
