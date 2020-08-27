//
//  NuanceWebApiRequest.h
//  Translator
//
//   12/11/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol NuanceWebAPIDelegate <NSObject>

- (void) responseReceived:(id _Nonnull) responseObject;
- (void) errorReceived:(NSError * _Nonnull) error;

@end

@interface NuanceWebApiRequestDemon : NSObject

@property (nonatomic, weak) id  <NuanceWebAPIDelegate> _Nullable delegate;

+ (void) sendTextRecognitionRequestForLanguage:(NSString * _Nonnull) language withData:(NSData * _Nonnull) data  withCompletionBlock:(void (^ _Nonnull)(id _Nonnull receivedObject)) completionHandler;

+ (NuanceWebApiRequestDemon * _Nonnull) summon;
- (NSString * _Nonnull) formPostLenght:(NSData * _Nonnull) postData;
- (NSData * _Nonnull) formPostDataForFilePath:(NSString * _Nonnull) filePath;
- (NSURL * _Nonnull) formRequestURL;

@property (weak, nonatomic) NSString *_Nullable fromLang;
@property (weak, nonatomic) NSString *_Nullable tolang;

@end
