//
//  TranslationHistory.h
//  Translator
//
//   11/4/15.
//  Copyright © 2015 Dev. 
//

#import <CoreData/CoreData.h>

@interface TranslationHistory : NSManagedObject

@property (strong, nonatomic) NSString *initialText;
@property (strong, nonatomic) NSString *translateText;
@property (strong, nonatomic) NSString *destinationLang;
@property (strong, nonatomic) NSString *sourceLang;
@property (strong, nonatomic) NSNumber *faved;
@property (strong, nonatomic) NSNumber *stamp;

- (TranslationHistory *) copyFrom:(TranslationHistory *) another;
- (instancetype) init;
- (id) initWithInitialText:(NSString *) initialTxt translatedText:(NSString *) translatedTxt translationDirection:(NSArray *) translatedDirectionTxt favedState:(NSNumber *) favState andStamp:(NSNumber *) stampl;
- (id) initWithInitialTextNoSave:(NSString *) initialTxt translatedText:(NSString *) translatedTxt translationDirection:(NSArray *) translatedDirectionTxt favedState:(NSNumber *) favState andStamp:(NSNumber *) stampl;

@end

