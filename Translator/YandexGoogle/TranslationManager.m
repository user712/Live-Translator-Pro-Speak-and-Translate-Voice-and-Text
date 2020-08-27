//
//  TranslationManager.m
//  Translator
//
//   tmp on 10/29/15.
//  Copyright © 2015 Dev. 
//

#import "TranslationManager.h"
#import "KeysManager.h"

@interface TranslationManager()

@property (nonatomic, copy) NSString *requestURLYandex;
@property (nonatomic, copy) NSString *requestDetectURLYandex;
@property (nonatomic, copy) NSString *requestURLGoogle;
@property (nonatomic, copy) NSString *requestDetectURLGoogle;
@property (nonatomic, copy) NSString *notificationObj;

@end

@implementation TranslationManager

//MARK: Initializations
+ (instancetype) sharedManager
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
        [self defaultLoadings];
    }
    return self;
}

- (void) defaultLoadings
{
    self.requestURLYandex = @"https://translate.yandex.net/api/v1.5/tr.json/translate";
    self.requestDetectURLYandex = @"https://translate.yandex.net/api/v1.5/tr.json/detect";
    
    self.requestURLGoogle = @"https://translation.googleapis.com/language/translate/v2";
    self.requestDetectURLGoogle = @"https://translation.googleapis.com/language/translate/v2/detect";
}

//MARK: Requests
- (void) formRequestForLanguage:(NSArray *) lang text:(NSString *) txt onSucces:(void (^)(NSDictionary *)) onSuccesBlock onError:(void (^)(NSError *)) onErrorBlock
{
    if ([lang[0] isEqualToString:lang[1]])
    {
        if (onSuccesBlock)
        {
            onSuccesBlock(@{@"text" : @[txt]});
        }
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"application/json" , nil];

    //Added bundle filters to google console, and in order to make it work, we need to set bundle identifier to http header:
    [manager.requestSerializer setValue:[[NSBundle mainBundle] bundleIdentifier] forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];

    if (![[TranslationSourceDemon summom] useGoogleAPI])  // if not goole use Yandex (:
    {
        [manager GET:self.requestURLYandex parameters:@{@"key" : [[KeysManager sharedManager] apiKeyYandex], @"lang":[NSString stringWithFormat:@"%@-%@", lang[0], lang[1]], @"text":txt} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if (onSuccesBlock)
            {
                onSuccesBlock(foo);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (onErrorBlock)
            {
                onErrorBlock(error);
            }
        }];
    }
    else  //use google :)
    {
        [manager GET:self.requestURLGoogle parameters:@{@"key" : [[KeysManager sharedManager] apiKeyGoogle], @"q" : txt, @"source" : lang[0], @"target" : lang[1]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if (onSuccesBlock)
            {
                onSuccesBlock(@{@"text" : @[[self validateString:foo[@"data"][@"translations"][0][@"translatedText"]]]});
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (onErrorBlock)
            {
                onErrorBlock(error);
            }
        }];
    }
}

- (NSString *) validateString:(NSString *) str
{
    str = [str stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"o"];
    str = [str stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    return str;
}

- (void) formAutodetectForText:(NSString *) txt onSucces:(void (^)(NSDictionary *)) onSuccesBlock onError:(void (^)(NSError *)) onErrorBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"application/json", nil];
    
    if (![[TranslationSourceDemon summom] useGoogleAPI]) // if not goole use Yandex (:
    {
        [manager GET:self.requestDetectURLYandex parameters:@{@"key" : [[KeysManager sharedManager] apiKeyYandex], @"text":txt} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if (onSuccesBlock)
            {
                onSuccesBlock(foo);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (onErrorBlock)
            {
                onErrorBlock(error);
            }
        }];
    }
    else  //use google :)
    {
        [manager GET:self.requestDetectURLGoogle parameters:@{@"key" : [[KeysManager sharedManager] apiKeyGoogle], @"q" : txt} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if (onSuccesBlock)
            {
                onSuccesBlock(@{@"lang" : foo[@"data"][@"detections"][0][0][@"language"]});
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (onErrorBlock)
            {
                onErrorBlock(error);
            }
        }];
    }
}

@end
