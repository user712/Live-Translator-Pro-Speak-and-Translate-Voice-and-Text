#import "SubscriptionItem.h"

@implementation SubscriptionItem

- (id) initWithProduct:(SKProduct *) product
{
    self = [super init];
    if (self)
    {
        self.product = product;
        
        NSNumberFormatter *formatter = [self priceFormatter];
        formatter.locale = self.product.priceLocale;
        self.localPrice = [formatter stringFromNumber:product.price];
        if (!self.localPrice)
        {
            self.localPrice = [NSString stringWithFormat:@"%@%@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol], product.price];
        }
        [self updateSubscriptionPeriod];
        [self updateTrialPeriod];
    }
    return self;
}

- (void) updateSubscriptionPeriod
{
    if (@available(iOS 11.2, *))
    {
        SKProductPeriodUnit unit = self.product.subscriptionPeriod.unit;
        NSUInteger numberOfUnits = self.product.subscriptionPeriod.numberOfUnits;
        NSString *unitsString;
        
        if (numberOfUnits == 0)
        {
            return;
        }
        
        switch (unit)
        {
            case SKProductPeriodUnitDay:
                unitsString = numberOfUnits == 1 ? NSLocalizedString(@"dayKey", nil) : NSLocalizedString(@"daysKey", nil);
                break;
            case SKProductPeriodUnitWeek:
                unitsString = numberOfUnits == 1 ? NSLocalizedString(@"weekKey", nil) : NSLocalizedString(@"weeksKey", nil);
                break;
            case SKProductPeriodUnitMonth:
                unitsString = numberOfUnits == 1 ? NSLocalizedString(@"monthKey", nil) : NSLocalizedString(@"monthsKey", nil);
                break;
            case SKProductPeriodUnitYear:
                unitsString = numberOfUnits == 1 ? NSLocalizedString(@"yearKey", nil) : NSLocalizedString(@"yearsKey", nil);
                break;
            default:
                unitsString = NSLocalizedString(@"monthKey", nil);
                break;
        }
        if (numberOfUnits > 1)
        {
            self.subscriptionPeriod = [NSString stringWithFormat:@"%ld %@", (long)numberOfUnits, unitsString];
        }
        else
        {
            self.subscriptionPeriod = unitsString;
        }
    }
    else
    {
        self.subscriptionPeriod = NSLocalizedString(@"monthKey", nil);
    }
}

- (void) updateTrialPeriod
{
    self.trialPeriod = [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"weekKey", nil)];
}

- (NSNumberFormatter *) priceFormatter
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    return formatter;
}

- (void) printData
{
    NSLog(@"Product = %@ *** Local Price = %@", self.product.productIdentifier, self.localPrice);
}

@end
