
//
//  TranslationSourceDemon.m
//  Translator
//
//   2/18/16.
//  Copyright © 2016 Dev. 
//

#import "TranslationSourceDemon.h"

@implementation TranslationSourceDemon

static TranslationSourceDemon *m_TranslationSourceDemon;

+ (TranslationSourceDemon *) summom
{
    if (!m_TranslationSourceDemon)
    {
        m_TranslationSourceDemon = [[TranslationSourceDemon alloc] init];
        [m_TranslationSourceDemon getState];
    }
    return m_TranslationSourceDemon;
}

- (void) getState
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", nil];
    
    [manager GET:@"http://nordicnations.net/api/translate/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([foo[@"service"] isEqualToString:@"yandex"])
        {
            self.source = @(YANDEX);
        }
        else
        {
            self.source = @(GOOGLE);
        }
        
        [self saveState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fetch settings error : %@ , %@",error, [error userInfo]);
        self.source = @(GOOGLE);
    }];
}

- (void) saveState
{
    [[NSUserDefaults standardUserDefaults] setObject:self.source forKey:@"TranslationSource"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) useGoogleAPI
{
    return [self.source isEqual:@(GOOGLE)];
}

@end
