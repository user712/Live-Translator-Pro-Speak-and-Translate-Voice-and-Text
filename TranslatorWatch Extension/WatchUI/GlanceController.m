//
//  GlanceController.m
//  TranslatorWatch Extension
//
//   12/4/15.
//  Copyright © 2015 Dev. 
//

#import "GlanceController.h"
#import "HistoryDemon.h"
#import "IODProfanityFilter.h"

@interface GlanceController()

@end


@implementation GlanceController

- (void) awakeWithContext:(id) context
{
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void) willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self configureView];
}

- (void) configureView
{
    if ([[HistoryDemon summon] count] > 0)
    {
        [self weShowTheLastTrans];
         NSDictionary *bar = [[HistoryDemon summon].itemList lastObject];
        
        [_topLabel setText:[self filterText:bar[@"initText"] forLang:bar[@"langFrom"]]];
        [_topImage setImageNamed:bar[@"langFrom"]];
        [_botLabel setText:[self filterText:bar[@"transText"] forLang:bar[@"langTo"]]];
        [_botImage setImageNamed:bar[@"langTo"]];
    
    }
    else
    {
        [self weShowTheLabel];
        [_greetingLabel setText:NSLocalizedString(@"watchAppGlance", nil)];
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

- (void) weShowTheLabel
{
    [_transGroup setHidden:YES];
    [_greetingLabel setHidden:NO];
}

- (void) weShowTheLastTrans
{
    [_transGroup setHidden:NO];
    [_greetingLabel setHidden:YES];
}

- (void) didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



