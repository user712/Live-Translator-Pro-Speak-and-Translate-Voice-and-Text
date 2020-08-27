//
//  ButtonSettingState.h
//  Translator
//
//   1/20/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>

@interface ButtonSettingState : UIButton

- (void) switchState;
- (void) setActiveState:(BOOL) state;
- (BOOL) isActive;

@end
