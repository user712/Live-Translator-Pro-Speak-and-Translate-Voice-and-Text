//
//  LanguageList.m
//  Translator
//
//   tmp on 10/29/15.
//  Copyright © 2015 Dev. 
//

#import "LanguageList.h"

@implementation LanguageList

static NSArray *shortcutList;
static NSArray *shortcutListGG;

+ (void) initialize
{
    shortcutList = [NSArray arrayWithObjects:
                    @"ad",
                    @"af",
                    @"sq",
                    @"ar",
                    @"hy",
                    @"az",
                    @"eu",
                    @"be",
                    @"bs",
                    @"bg",
                    @"ca",
                    @"zh",
                    @"hr",
                    @"cs",
                    @"da",
                    @"nl",
                    @"en",
                    @"et",
                    @"fi",
                    @"fr",
                    @"gl",
                    @"ka",
                    @"de",
                    @"el",
                    @"ht",
                    @"hu",
                    @"is",
                    @"id",
                    @"ga",
                    @"it",
                    @"ja",
                    @"kk",
                    @"ko",
                    @"ky",
                    @"la",
                    @"lv",
                    @"lt",
                    @"mk",
                    @"mg",
                    @"ms",
                    @"mt",
                    @"mn",
                    @"no",
                    @"fa",
                    @"pl",
                    @"pt",
                    @"ro",
                    @"ru",
                    @"sr",
                    @"sk",
                    @"sl",
                    @"es",
                    @"sw",
                    @"sv",
                    @"tl",
                    @"tg",
                    @"tt",
                    @"th",
                    @"tr",
                    @"uk",
                    @"uz",
                    @"vi",
                    @"cy",
                    @"he",
                    nil];
    
    shortcutListGG = [NSArray arrayWithObjects:
                      @"ad",
                      @"af",
                      @"sq",
                      @"ar",
                      @"hy",
                      @"az",
                      @"eu",
                      @"bn",
                      @"bs",
                      @"be",
                      @"bg",
                      @"ca",
                      @"ceb",
                      @"ny",
                      @"zh-CN",
                      @"zh-TW",
                      @"hr",
                      @"co",
                      @"cs",
                      @"da",
                      @"nl",
                      @"en",
                      @"eo",
                      @"et",
                      @"tl",
                      @"fi",
                      @"fr",
                      @"gl",
                      @"ka",
                      @"de",
                      @"el",
                      @"gu",
                      @"ht",
                      @"ha",
                      @"iw",
                      @"hi",
                      @"hmn",
                      @"hu",
                      @"is",
                      @"ig",
                      @"id",
                      @"ga",
                      @"it",
                      @"ja",
                      @"jw",
                      @"kn",
                      @"kk",
                      @"km",
                      @"ko",
                      @"ku",
                      @"ky",
                      @"lo",
                      @"la",
                      @"lv",
                      @"lt",
                      @"lb",
                      @"mk",
                      @"mg",
                      @"ms",
                      @"ml",
                      @"mt",
                      @"mi",
                      @"mr",
                      @"mn",
                      @"my",
                      @"ne",
                      @"no",
                      @"ps",
                      @"fa",
                      @"pl",
                      @"pt",
                      @"ma",
                      @"ro",
                      @"ru",
                      @"sm",
                      @"gd",
                      @"sr",
                      @"st",
                      @"sd",
                      @"si",
                      @"sn",
                      @"sk",
                      @"sl",
                      @"so",
                      @"es",
                      @"su",
                      @"sw",
                      @"sv",
                      @"tg",
                      @"ta",
                      @"te",
                      @"th",
                      @"tr",
                      @"uk",
                      @"ur",
                      @"uz",
                      @"vi",
                      @"cy",
                      @"yi",
                      @"yo",
                      @"zu",
                      nil];
    
}

+ (NSString *) getLanguage:(NSUInteger) langIndex
{
    if (!(BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        return [shortcutListGG objectAtIndexedSubscript:langIndex];
    }
    else
    {
        return [shortcutList objectAtIndexedSubscript:langIndex];
    }
}

+ (NSString *) getLanguagePair:(NSUInteger) langIndex andTheSecond:(NSUInteger) secondIndex
{    
    if (!(BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        return [NSString stringWithFormat:@"%@-%@",[shortcutListGG objectAtIndexedSubscript:langIndex],[shortcutListGG objectAtIndexedSubscript:secondIndex]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@-%@",[shortcutList objectAtIndexedSubscript:langIndex],[shortcutList objectAtIndexedSubscript:secondIndex]];
    }
}

+ (NSUInteger) indexOfItem:(NSString *) item
{
    if (!(BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        if ([shortcutListGG indexOfObject:item] >= GGCount)
        {
            if ([item isEqualToString:@"zh"])
            {
                return [shortcutListGG indexOfObject:@"zh-CN"];
            }
            
            NSLog(@"%@, %s", item, __PRETTY_FUNCTION__);
            [NSException raise:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] format:@"wrong item requested?"];
            return 6666;
        }
        else
        {
            return [shortcutListGG indexOfObject:item];
        }
    }
    else
    {
        return [shortcutList indexOfObject:item];
    }
}

+ (NSUInteger) numberOfLanguages
{
    if (!(BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        return GGCount;
    }
    else
    {
        return [shortcutList count];
    }
}

+ (NSString *) enumToString:(NSInteger) langEnumItem
{
    if ((BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        switch (langEnumItem)
        {
            case Albanian: return NSLocalizedString(@"Albanian", nil);
            case English: return NSLocalizedString(@"English",nil);
            case Arabic: return NSLocalizedString(@"Arabic",nil);
            case Armenian: return NSLocalizedString(@"Armenian", nil);
            case Azerbaijan: return NSLocalizedString(@"Azerbaijan", nil);
            case Afrikaans: return NSLocalizedString(@"Afrikaans", nil);
            case Basque: return NSLocalizedString(@"Basque", nil);
            case Belarusian: return NSLocalizedString(@"Belarusian", nil);
            case Bulgarian: return NSLocalizedString(@"Bulgarian", nil);
            case Bosnian: return NSLocalizedString(@"Bosnian", nil);
            case Welsh: return NSLocalizedString(@"Welsh", nil);
            case Vietnamese: return NSLocalizedString(@"Vietnamese", nil);
            case Hungarian: return NSLocalizedString(@"Hungarian", nil);
            case Haitian_Creole: return NSLocalizedString(@"Haitian Creole", nil);
            case Galician: return NSLocalizedString(@"Galician", nil);
            case Dutch: return NSLocalizedString(@"Dutch", nil);
            case Greek: return NSLocalizedString(@"Greek", nil);
            case Georgian: return NSLocalizedString(@"Georgian", nil);
            case Danish: return NSLocalizedString(@"Danish", nil);
            case Yiddish: return NSLocalizedString(@"Yiddish", nil);
            case Indonesian: return NSLocalizedString(@"Indonesian", nil);
            case Irish: return NSLocalizedString(@"Irish", nil);
            case Italian: return NSLocalizedString(@"Italian", nil);
            case Icelandic: return NSLocalizedString(@"Icelandic", nil);
            case Spanish: return NSLocalizedString(@"Spanish", nil);
            case Kazakh: return NSLocalizedString(@"Kazakh", nil);
            case Catalan: return NSLocalizedString(@"Catalan", nil);
            case Kyrgyz: return NSLocalizedString(@"Kyrgyz", nil);
            case Chinese: return NSLocalizedString(@"Chinese", nil);
            case Korean: return NSLocalizedString(@"Korean", nil);
            case Latin: return NSLocalizedString(@"Latin", nil);
            case Latvian: return NSLocalizedString(@"Latvian", nil);
            case Lithuanian: return NSLocalizedString(@"Lithuanian", nil);
            case Malagasy: return NSLocalizedString(@"Malagasy", nil);
            case Malay: return NSLocalizedString(@"Malay", nil);
            case Maltese: return NSLocalizedString(@"Maltese", nil);
            case Macedonian: return NSLocalizedString(@"Macedonian", nil);
            case Mongolian: return NSLocalizedString(@"Mongolian", nil);
            case German: return NSLocalizedString(@"German", nil);
            case Norwegian: return NSLocalizedString(@"Norwegian", nil);
            case Persian: return NSLocalizedString(@"Persian", nil);
            case Polish: return NSLocalizedString(@"Polish", nil);
            case Portuguese: return NSLocalizedString(@"Portuguese", nil);
            case Romanian: return NSLocalizedString(@"Romanian", nil);
            case Russian: return NSLocalizedString(@"Russian", nil);
            case Serbian: return NSLocalizedString(@"Serbian", nil);
            case Slovakian: return NSLocalizedString(@"Slovakian", nil);
            case Slovenian: return NSLocalizedString(@"Slovenian", nil);
            case Swahili: return NSLocalizedString(@"Swahili", nil);
            case Tajik: return NSLocalizedString(@"Tajik", nil);
            case Thai: return NSLocalizedString(@"Thai", nil);
            case Tagalog: return NSLocalizedString(@"Tagalog", nil);
            case Tatar: return NSLocalizedString(@"Tatar", nil);
            case Turkish: return NSLocalizedString(@"Turkish", nil);
            case Uzbek: return NSLocalizedString(@"Uzbek", nil);
            case Ukrainian: return NSLocalizedString(@"Ukrainian", nil);
            case Finish: return NSLocalizedString(@"Finish", nil);
            case French: return NSLocalizedString(@"French", nil);
            case Croatian: return NSLocalizedString(@"Croatian", nil);
            case Czech: return NSLocalizedString(@"Czech", nil);
            case Swedish: return NSLocalizedString(@"Swedish", nil);
            case Estonian: return NSLocalizedString(@"Estonian", nil);
            case Japanese: return NSLocalizedString(@"Japanese", nil);
            case Detect: return NSLocalizedString(@"AutoDetect", nil);
                
            default:
                [NSException raise:NSGenericException format:@"wrong input for @LanguageList.m row 305"];
        }
    }
    else
    {
        switch (langEnumItem)
        {
            case GGDetect: return NSLocalizedString(@"AutoDetect", nil);
            case GGAfrikaans: return NSLocalizedString(@"Afrikaans", nil);
            case GGAlbanian: return NSLocalizedString(@"Albanian", nil);
            case GGArabic: return NSLocalizedString(@"Arabic", nil);
            case GGArmenian: return NSLocalizedString(@"Armenian", nil);
            case GGAzerbaijani: return NSLocalizedString(@"Azerbaijani", nil);
            case GGBasque: return NSLocalizedString(@"Basque", nil);
            case GGBengali: return NSLocalizedString(@"Bengali", nil);
            case GGBosnian: return NSLocalizedString(@"Bosnian", nil);
            case GGBelarusian: return NSLocalizedString(@"Belarusian", nil);
            case GGBulgarian: return NSLocalizedString(@"Bulgarian", nil);
            case GGCatalan: return NSLocalizedString(@"Catalan", nil);
            case GGCebuano: return NSLocalizedString(@"Cebuano", nil);
            case GGChichewa: return NSLocalizedString(@"Chichewa", nil);
            case GGChinese_Siplified: return NSLocalizedString(@"Chinese Simplified", nil);
            case GGChinese_Traditional: return NSLocalizedString(@"Chinese Traditional", nil);
            case GGCroatian: return NSLocalizedString(@"Croatian", nil);
            case GGCorsican: return NSLocalizedString(@"Corsican", nil);
            case GGCzech: return NSLocalizedString(@"Czech", nil);
            case GGDanish: return NSLocalizedString(@"Danish", nil);
            case GGDutch: return NSLocalizedString(@"Dutch", nil);
            case GGEnglish: return NSLocalizedString(@"English", nil);
            case GGEsperanto: return NSLocalizedString(@"Esperanto", nil);
            case GGEstonian: return NSLocalizedString(@"Estonian", nil);
            case GGFilipino: return NSLocalizedString(@"Filipino", nil);
            case GGFinnish: return NSLocalizedString(@"Finnish", nil);
            case GGFrench: return NSLocalizedString(@"French", nil);
            case GGGalician: return NSLocalizedString(@"Galician", nil);
            case GGGeorgian: return NSLocalizedString(@"Georgian", nil);
            case GGGerman: return NSLocalizedString(@"German", nil);
            case GGGreek: return NSLocalizedString(@"Greek", nil);
            case GGGujarati: return NSLocalizedString(@"Gujarati", nil);
            case GGHaitian_Creole: return NSLocalizedString(@"Haitian Creole", nil);
            case GGHausa: return NSLocalizedString(@"Hausa", nil);
            case GGHebrew: return NSLocalizedString(@"Hebrew", nil);
            case GGHindi: return NSLocalizedString(@"Hindi", nil);
            case GGHmong: return NSLocalizedString(@"Hmong", nil);
            case GGHungarian: return NSLocalizedString(@"Hungarian", nil);
            case GGIcelandic: return NSLocalizedString(@"Icelandic", nil);
            case GGIgbo: return NSLocalizedString(@"Igbo", nil);
            case GGIndonesian: return NSLocalizedString(@"Indonesian", nil);
            case GGIrish: return NSLocalizedString(@"Irish", nil);
            case GGItalian: return NSLocalizedString(@"Italian", nil);
            case GGJapanese: return NSLocalizedString(@"Japanese", nil);
            case GGJavanese: return NSLocalizedString(@"Javanese", nil);
            case GGKannada: return NSLocalizedString(@"Kannada", nil);
            case GGKazakh: return NSLocalizedString(@"Kazakh", nil);
            case GGKhmer: return NSLocalizedString(@"Khmer", nil);
            case GGKorean: return NSLocalizedString(@"Korean", nil);
            case GGKurdish_Kurmanji: return NSLocalizedString(@"Kurdish (Kurmanji)", nil);
            case GGKyrgyz: return NSLocalizedString(@"Kyrgyz", nil);
            case GGLao: return NSLocalizedString(@"Lao", nil);
            case GGLatin: return NSLocalizedString(@"Latin", nil);
            case GGLatvian: return NSLocalizedString(@"Latvian", nil);
            case GGLithuanian: return NSLocalizedString(@"Lithuanian", nil);
            case GGLuxembourgish: return NSLocalizedString(@"Luxembourgish", nil);
            case GGMacedonian: return NSLocalizedString(@"Macedonian", nil);
            case GGMalagasy: return NSLocalizedString(@"Malagasy", nil);
            case GGMalay: return NSLocalizedString(@"Malay", nil);
            case GGMalayalam: NSLocalizedString(@"Malayalam", nil);
            case GGMaltese: return NSLocalizedString(@"Maltese", nil);
            case GGMaori: return NSLocalizedString(@"Maori", nil);
            case GGMarathi: return NSLocalizedString(@"Marathi", nil);
            case GGMongolian: return NSLocalizedString(@"Mongolian", nil);
            case GGMyanmar_Burmese: return NSLocalizedString(@"Myanmar (Burmese)", nil);
            case GGNepali: return NSLocalizedString(@"Nepali", nil);
            case GGNorwegian: return NSLocalizedString(@"Norwegian", nil);
            case GGPashto: return NSLocalizedString(@"Pashto", nil);
            case GGPersian: return NSLocalizedString(@"Persian", nil);
            case GGPolish: return NSLocalizedString(@"Polish", nil);
            case GGPortuguese: return NSLocalizedString(@"Portuguese", nil);
            case GGPunjabi: return NSLocalizedString(@"Punjabi", nil);
            case GGRomanian: return NSLocalizedString(@"Romanian", nil);
            case GGRussian: return NSLocalizedString(@"Russian", nil);
            case GGSamoan: return NSLocalizedString(@"Samoan", nil);
            case GGScots_Gaelic: return NSLocalizedString(@"Scots Gaelic", nil);
            case GGSesotho: return NSLocalizedString(@"Sesotho", nil);
            case GGSindhi: return NSLocalizedString(@"Sindhi", nil);
            case GGSinhala: return NSLocalizedString(@"Sinhala", nil);
            case GGShona: return NSLocalizedString(@"Shona", nil);
            case GGSerbian: return NSLocalizedString(@"Serbian", nil);
            case GGSlovak: return NSLocalizedString(@"Slovak", nil);
            case GGSlovenian: return NSLocalizedString(@"Slovenian", nil);
            case GGSomali: return NSLocalizedString(@"Somali", nil);
            case GGSpanish: return NSLocalizedString(@"Spanish", nil);
            case GGSundanese: return NSLocalizedString(@"Sundanese", nil);
            case GGSwahili: return NSLocalizedString(@"Swahili", nil);
            case GGSwedish: return NSLocalizedString(@"Swedish", nil);
            case GGTajik: return NSLocalizedString(@"Tajik", nil);
            case GGTamil: return NSLocalizedString(@"Tamil", nil);
            case GGTelugu: return NSLocalizedString(@"Telugu", nil);
            case GGThai: return NSLocalizedString(@"Thai", nil);
            case GGTurkish: return NSLocalizedString(@"Turkish", nil);
            case GGUkrainian: return NSLocalizedString(@"Ukrainian", nil);
            case GGUrdu: return NSLocalizedString(@"Urdu", nil);
            case GGUzbek: return NSLocalizedString(@"Uzbek", nil);
            case GGVietnamese: return NSLocalizedString(@"Vietnamese", nil);
            case GGWelsh: return NSLocalizedString(@"Welsh", nil);
            case GGYiddish: return NSLocalizedString(@"Yiddish", nil);
            case GGYoruba: return NSLocalizedString(@"Yoruba", nil);
            case GGZulu: return NSLocalizedString(@"Zulu", nil);
            default:
                [NSException raise:NSGenericException format:@"wrong input for @LanguageList.m row 412"];
        }
    }
    return nil;
}

@end
