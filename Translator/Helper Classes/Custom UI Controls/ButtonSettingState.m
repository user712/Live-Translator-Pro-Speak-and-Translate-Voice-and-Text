//
//  ButtonSettingState.m
//  Translator
//
//   1/20/16.
//  Copyright © 2016 Dev. 
//

#import "ButtonSettingState.h"
#import "AppColors.h"

@implementation ButtonSettingState

- (instancetype) init
{
    self = [super init];
    [self setFrame:CGRectMake(0, 0, 80, 27)];
    [self setActiveState:NO];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setUserInteractionEnabled:NO];
}

- (void) setActiveState:(BOOL) state
{
    if (state)
    {
        [self setTitle:NSLocalizedString(@"btnON", nil) forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"bttnSettingsON"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self bringSubviewToFront:self.titleLabel];
        self.tag = 1;
    }
    else
    {
        [self setTitle:NSLocalizedString(@"btnOFF", nil) forState:UIControlStateNormal];
        //[self.titleLabel setText:@""];
        [self setBackgroundImage:[UIImage imageNamed:@"bttnSettingsOFF"] forState:UIControlStateNormal];
        [self setTitleColor:[AppColors appBlueColor] forState:UIControlStateNormal];
        self.tag = 0;
    }
}

- (BOOL) isActive
{
    if (self.tag == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) switchState
{
    [self setActiveState:![self isActive]];
}

@end
