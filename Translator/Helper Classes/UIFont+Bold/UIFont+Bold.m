//
//  UIFont+Bold.m
//  Translator
//
//   2/6/18.
//  
//

#import "UIFont+Bold.h"

@implementation UIFont (Bold)

- (UIFont *) bolderFont
{
    UIFontDescriptor *fontDescriptor = [self fontDescriptor];
    UIFontDescriptorSymbolicTraits traits = fontDescriptor.symbolicTraits;
    traits = traits | UIFontDescriptorTraitBold;
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:traits];
    return [UIFont fontWithDescriptor:boldFontDescriptor size:self.pointSize - 1];
}

@end
