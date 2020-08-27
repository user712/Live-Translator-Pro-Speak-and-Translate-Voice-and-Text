//
//  TraslationCostumCellsTableViewCell.m
//  Translator
//
//   tmp on 10/27/15.
//  Copyright © 2015 fakeCompany. 
//

#import "TraslationCostumCellsTableViewCell.h"
#import "UIFont+Bold.h"
#import "UIImage+Tint.h"

#define initial_cell_height 20

@implementation TraslationCostumCellsTableViewCell

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.sourceLanguage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.destinationLanguage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGRect foo = self.frame;
    if (![self.toolView isHidden])
    {
        [self setFrame:CGRectMake(foo.origin.x, foo.origin.y, foo.size.width, self.sourceLanguage.frame.size.height + self.destinationLanguage.frame.size.height + 80)];
    }
}

- (void) switchFavState
{
    _trans.faved = _trans.faved == [NSNumber numberWithInt:1] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    [[DatabaseDemon summon] save];
}

- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"translations"];
    self.frame = frame;
    if (self)
    {
        UIImage *deleteImage = [[UIImage imageNamed:@"bttnHomeDelete"] imageWithTintColor:[AppColors appRedColor]];
        UIImageView *foo = [[UIImageView alloc] initWithImage:deleteImage];
        foo.frame = CGRectMake(0, 0, 30, 30);
        foo.contentMode = UIViewContentModeScaleAspectFit;
        self.accessoryView = foo;
        
        CGRect r = self.accessoryView.frame;
        r.origin.y -= 20;
        
        [self.accessoryView setFrame:r];
        self.backgroundColor = [UIColor whiteColor];
        
        _sourceLanguage = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sourceLang"];
        _sourceLanguage.frame = CGRectMake(0, 1, self.frame.size.width - 40, initial_cell_height);
        _sourceLanguage.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _sourceLanguage.textLabel.numberOfLines = 0;
        [_sourceLanguage sizeToFit];
        _sourceLanguage.backgroundColor = [UIColor lightGrayColor];
        
        _destinationLanguage = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"destinationLang"];
        _destinationLanguage.frame = CGRectMake(0,_sourceLanguage.frame.size.height, _sourceLanguage.frame.size.width, _sourceLanguage.frame.size.height);
        _destinationLanguage.backgroundColor = [UIColor darkGrayColor];
        _destinationLanguage.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _destinationLanguage.textLabel.numberOfLines = 0;
        _destinationLanguage.textLabel.font = [_sourceLanguage.textLabel.font bolderFont];
        [_destinationLanguage sizeToFit];
        
        [self addSubview:_sourceLanguage];
        [self addSubview:_destinationLanguage];
        
        _toolView = [[HistoryToolView alloc] initWithFrame:self.frame andTransToWorkWith:nil andParent:nil];
        [self addSubview:_toolView];
        [self bringSubviewToFront:_toolView];
        [_toolView setHidden:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        NSLog(@"\u274COoooops TraslationCostumCellsTableViewCell->init(), initialisation failed");
    }
    return self;
}

- (id) initWithInputText:(NSString *) inText andOutputText:(NSString *) outText andFrame:(CGRect) frame
{
    self = [self initWithFrame:frame];
    _sourceLanguage.textLabel.text = inText;
    _destinationLanguage.textLabel.text = outText;
    [_sourceLanguage sizeToFit];
    _destinationLanguage.frame = CGRectMake(0,_sourceLanguage.frame.size.height, _sourceLanguage.frame.size.width, _sourceLanguage.frame.size.height);
    [_destinationLanguage sizeToFit];
    return self;
}

- (id) initWithTranslation:(TranslationHistory *) trans andFrame:(CGRect) frame
{
    _trans = trans;
    return [self initWithInputText:_trans.initialText andOutputText:_trans.translateText andFrame:frame];
}

- (NSArray *) setTranslationDirectionWith:(NSArray *) transDirection
{
    _trans.sourceLang = transDirection[0];
    _trans.destinationLang = transDirection[1];
    return @[_trans.sourceLang, _trans.destinationLang];
}

- (void) setEditing:(BOOL) editing animated:(BOOL) animated
{
    [super setEditing:editing animated:animated];
    self.bar.userInteractionEnabled = !editing;
}

- (void) centerAccesoryButtonForHeight:(CGFloat) height
{
    CGFloat locHeight = height;
    if(![_toolView isHidden])
    {
        locHeight += _toolView.bounds.size.height;
    }
    
    if (!self.accesoryButton)
    {
        self.accesoryButton = [[UIButton alloc] init];
        [self addSubview:self.accesoryButton];
    }
    
    CGFloat buttonSize = 40;
    [self.accesoryButton setFrame:CGRectMake(self.frame.size.width - buttonSize, locHeight / 2 - buttonSize / 2, buttonSize, buttonSize)];
    [self.accesoryButton setBackgroundColor:[UIColor clearColor]];
}

@end

