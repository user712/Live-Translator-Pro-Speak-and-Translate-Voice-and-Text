//
//  TranslationHistory.m
//  Translator
//
//   11/4/15.
//  Copyright © 2015 Dev. 
//

#import "TranslationHistory.h"
#import "DatabaseDemon.h"

@implementation TranslationHistory

@synthesize initialText;
@synthesize translateText;
@synthesize sourceLang;
@synthesize destinationLang;
@synthesize faved;
@synthesize stamp;

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        self.initialText = @"initial text VIA the NEW Method";
        self.translateText = @"Translated text VIA the NEW Method";
        self.sourceLang = @"en";
        self.destinationLang = @"ru";
        self.faved = [NSNumber numberWithLong:0];
    }
    else
    {
        [NSException raise:@"self not inited" format:@"TranslationHistory.m row 27"];
    }
    return self;
}

- (id) initWithInitialText:(NSString *) initialTxt translatedText:(NSString *) translatedTxt translationDirection:(NSArray *) translatedDirectionTxt favedState:(NSNumber *) favState andStamp:(NSNumber *) stampl
{
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Translations" inManagedObjectContext:[DatabaseDemon summon].managedObjectContext];
    self.faved  = favState;
    self.initialText = initialTxt;
    self.translateText = translatedTxt;
    self.sourceLang = translatedDirectionTxt[0];
    self.destinationLang = translatedDirectionTxt[1];
    if (stampl)
    {
        self.stamp = stampl;
    }
    else
    {
        self.stamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    }
    
    [[DatabaseDemon summon] save];
    return self;
}

- (id) initWithInitialTextNoSave:(NSString *) initialTxt translatedText:(NSString *) translatedTxt translationDirection:(NSArray *) translatedDirectionTxt favedState:(NSNumber *) favState andStamp:(NSNumber *) stampl
{
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Translations" inManagedObjectContext:[DatabaseDemon summon].managedObjectContext];
    self.faved  = favState;
    self.initialText = initialTxt;
    self.translateText = translatedTxt;
    self.sourceLang = translatedDirectionTxt[0];
    self.destinationLang = translatedDirectionTxt[1];
    if (stampl)
    {
        self.stamp = stampl;
    }
    else
    {
        self.stamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    }
    return self;
}

- (TranslationHistory *) copyFrom:(TranslationHistory *) another
{
    self.initialText = another.initialText;
    self.sourceLang = another.sourceLang;
    self.destinationLang = another.destinationLang;
    self.translateText = another.translateText;
    self.faved = another.faved;
    return self;
}

@end

