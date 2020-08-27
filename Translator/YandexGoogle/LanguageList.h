//
//  LanguageList.h
//  Translator
//
//   tmp on 10/29/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>

@interface LanguageList : NSObject

typedef NS_ENUM(NSInteger, LANGUAGES_LIST)
{
    Detect = 0,
    Afrikaans,
    Albanian,
    Arabic,
    Armenian,
    Azerbaijan,
    Basque,
    Belarusian,
    Bosnian,
    Bulgarian,
    Catalan,
    Chinese,
    Croatian,
    Czech,
    Danish,
    Dutch,
    English,
    Estonian,
    Finish,
    French,
    Galician,
    Georgian,
    German,
    Greek,
    Haitian_Creole,
    Hungarian,
    Icelandic,
    Indonesian,
    Irish,
    Italian,
    Japanese,
    Kazakh,
    Korean,
    Kyrgyz,
    Latin,
    Latvian,
    Lithuanian,
    Macedonian,
    Malagasy,
    Malay,
    Maltese,
    Mongolian,
    Norwegian,
    Persian,
    Polish,
    Portuguese,
    Romanian,
    Russian,
    Serbian,
    Slovakian,
    Slovenian,
    Spanish,
    Swahili,
    Swedish,
    Tagalog,
    Tajik,
    Tatar,
    Thai,
    Turkish,
    Ukrainian,
    Uzbek,
    Vietnamese,
    Welsh,
    Yiddish
};

typedef NS_ENUM(NSInteger, LANGUAGES_LIST_GOOGLE)
{
    GGDetect = 0,
    GGAfrikaans,
    GGAlbanian,
    GGArabic,
    GGArmenian,
    GGAzerbaijani,
    GGBasque,
    GGBengali,
    GGBosnian,
    GGBelarusian,
    GGBulgarian,
    GGCatalan,
    GGCebuano,
    GGChichewa,
    GGChinese_Siplified,
    GGChinese_Traditional,
    GGCroatian,
    GGCorsican,
    GGCzech,
    GGDanish,
    GGDutch,
    GGEnglish,
    GGEsperanto,
    GGEstonian,
    GGFilipino,
    GGFinnish,
    GGFrench,
    GGGalician,
    GGGeorgian,
    GGGerman,
    GGGreek,
    GGGujarati,
    GGHaitian_Creole,
    GGHausa,
    GGHebrew,
    GGHindi,
    GGHmong,
    GGHungarian,
    GGIcelandic,
    GGIgbo,
    GGIndonesian,
    GGIrish,
    GGItalian,
    GGJapanese,
    GGJavanese,
    GGKannada,
    GGKazakh,
    GGKhmer,
    GGKorean,
    GGKurdish_Kurmanji,
    GGKyrgyz,
    GGLao,
    GGLatin,
    GGLatvian,
    GGLithuanian,
    GGLuxembourgish,
    GGMacedonian,
    GGMalagasy,
    GGMalay,
    GGMalayalam,
    GGMaltese,
    GGMaori,
    GGMarathi,
    GGMongolian,
    GGMyanmar_Burmese,
    GGNepali,
    GGNorwegian,
    GGPashto,
    GGPersian,
    GGPolish,
    GGPortuguese,
    GGPunjabi,
    GGRomanian,
    GGRussian,
    GGSamoan,
    GGScots_Gaelic,
    GGSerbian,
    GGSesotho,
    GGSindhi,
    GGSinhala,
    GGShona,
    GGSlovak,
    GGSlovenian,
    GGSomali,
    GGSpanish,
    GGSundanese,
    GGSwahili,
    GGSwedish,
    GGTajik,
    GGTamil,
    GGTelugu,
    GGThai,
    GGTurkish,
    GGUkrainian,
    GGUrdu,
    GGUzbek,
    GGVietnamese,
    GGWelsh,
    GGYiddish,
    GGYoruba,
    GGZulu,
    GGCount
};

+ (NSString *) getLanguage:(NSUInteger) langIndex;
+ (NSString *) getLanguagePair:(NSUInteger) langIndex andTheSecond:(NSUInteger) secondIndex;
+ (NSString *) enumToString:(NSInteger) langEnumItem;
+ (NSUInteger) indexOfItem:(NSString *) item;
+ (NSUInteger) numberOfLanguages;

@end


//got no flags for ya guys :-/

//Basque	eu
//Welsh	cy
//Haitian (Creole)	ht
//Galician	gl
//Catalan	ca
//Latin	la
//Malagasy	mg
//Swahili	sw
//Tagalog	tl
//Tatar	tt

