//
//  tempInterfaceController.m
//  Translator
//
//   12/17/15.
//  Copyright © 2015 Dev. 
//

#import "tempInterfaceController.h"
#import "WatchAppConnectivity.h"

@interface tempInterfaceController ()

@end

NSMutableArray *foo;
NSString *currentLang;
NSString *contxt;

@implementation tempInterfaceController

- (void) awakeWithContext:(id) context
{
    [super awakeWithContext:context];
    contxt = context;
    [self setUpPicker];
}

- (NSArray *) formTheList
{
    NSMutableArray *foo = [[NSMutableArray alloc] init];
    for (int i=0; i<[LanguageList numberOfLanguages]; i++)
    {
        LanguagePicker *bar = [[LanguagePicker alloc] initWithTitle:[LanguageList enumToString:i] andLabel:[LanguageList getLanguage:i]];
        [foo addObject:bar];
    }
    return [foo copy];
}

- (void) setUpPicker
{
    foo = [[self formTheList] mutableCopy];
    
    int i = 0;
    int selectedItem = 1;
    
    while (i < [foo count])
    {
        LanguagePicker *bar = foo[i];
        
        NSString *baz = [[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:bar.label];
        NSString *lastSelectedLanguage;
        
        if ([contxt isEqualToString:@"top"])
        {
            lastSelectedLanguage = [[LanguageSelectDemon summon] getCurrentSourceLanguage];
        }
        else
        {
            lastSelectedLanguage = [[LanguageSelectDemon summon] getCurrentDestinationlanguage];
        }
        
        if (!baz)
        {
            [foo removeObjectAtIndex:i];
        }
        else
        {
            LanguagePicker *bar = foo[i];
            if ([bar.label isEqualToString:lastSelectedLanguage])
            {
                selectedItem = i;
                NSLog(@"baz = %@, lastlang = %@, selectedItem = %d",bar.label,lastSelectedLanguage, selectedItem);
            }
            
            i++;
        }
    }
    [_picker setItems:[foo copy]];
    [_picker setEnabled:YES];
    [_picker setSelectedItemIndex:selectedItem];
}

- (void) willActivate
{
    [super willActivate];
}

- (void) didDeactivate
{
    [super didDeactivate];
}

- (IBAction) pickerChangedValue:(NSInteger) value
{
    LanguagePicker * bar = foo[value];
    currentLang = bar.label;
}

- (IBAction) selectLang
{
    if ([contxt isEqualToString:@"top"])
    {
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:currentLang];
    }
    else
    {
        [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:currentLang];
    }
    
    [[WatchAppConnectivity sharedConnection] syncNewLanguageWithPhone];
    [self dismissController];
}
@end

