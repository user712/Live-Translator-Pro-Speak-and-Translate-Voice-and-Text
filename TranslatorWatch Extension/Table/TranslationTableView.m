//
//  TranslationTableView.m
//  Translator
//
//   12/15/15.
//  Copyright © 2015 Dev. 
//

#define NR_OF_ROWS 5

#import "TranslationTableView.h"

@interface TranslationTableView ()

@end

@implementation TranslationTableView

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
}

- (void) willActivate
{
    [super willActivate];
    [self configureTable];
    [self setGreetingMessage];
    [_theTable scrollToRowAtIndex:_theTable.numberOfRows ];
    [self setTitle:NSLocalizedString(@"historyTitle", nil)];
}

- (void) didDeactivate
{
    [super didDeactivate];
}

- (void) configureTable
{
    [_theTable setNumberOfRows:[[HistoryDemon summon] count] withRowType:@"TableRowController"];
    for (int i=0; i<_theTable.numberOfRows; i++)
    {
        TableRowController *foo = [_theTable rowControllerAtIndex:i];
        NSDictionary *bar = [[HistoryDemon summon].itemList objectAtIndex:_theTable.numberOfRows - 1 - i];
        [foo.topLabel setText:[self filterText:bar[@"initText"] forLang:bar[@"langFrom"]]];
        [foo.bottomLabel setText:[self filterText:bar[@"transText"] forLang:bar[@"langTo"]]];
        [foo.topImage setImageNamed:bar[@"langFrom"]];
        [foo.bottomImage setImageNamed:bar[@"langTo"]];
    }
}

- (NSString *) filterText:(NSString *) text forLang:(NSString *) lang
{
    if (/* DISABLES CODE */ (NO))
    { //textFiltering is enabled
        if ([IODProfanityFilter wordsetFor:lang])
        {
            return [IODProfanityFilter stringByFilteringString:text];
        }
    }
    return text;
}

- (void) setGreetingMessage
{
    if (_theTable.numberOfRows < 1)
    {
        [_hiddenMessage setText:NSLocalizedString(@"nothingToSeeHere", nil)];
        [_hiddenMessage setHidden:NO];
    }
    else
    {
        [_hiddenMessage setHidden:YES];
    }
}

@end



