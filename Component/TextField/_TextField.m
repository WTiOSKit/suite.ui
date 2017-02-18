//
//  _TextField.m
//  consumer
//
//  Created by fallen on 16/9/1.
//
//

#import "_TextField.h"

@interface _TextField () {
    UIColor					*_currentBackgroundColor;
    UIColor					*_currentTextColor;
    BOOL					_isChangingBackgroundColorInternal;
}

@end

@implementation _TextField

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = self.canCopyContent;
    }
    
    return self.canCopyContent;
}

#pragma mark -

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    if(!_isChangingBackgroundColorInternal)
        _currentTextColor = self.textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    if(!_isChangingBackgroundColorInternal)
        _currentBackgroundColor = self.backgroundColor;
}

- (void)textFieldEditingDidBegin:(id)sender {
    _currentBackgroundColor = self.backgroundColor;
    _currentTextColor = self.textColor;
    _isChangingBackgroundColorInternal = YES;
    if(self.focusedBackgroundColor)
        self.backgroundColor = self.focusedBackgroundColor;
    if(self.focusedTextColor)
        self.textColor = self.focusedTextColor;
    _isChangingBackgroundColorInternal = NO;
}

- (void)textFieldEditingDidEnd:(id)sender {
    _isChangingBackgroundColorInternal = YES;
    self.backgroundColor = _currentBackgroundColor;
    self.textColor = _currentTextColor;
    _isChangingBackgroundColorInternal = NO;
}

- (void)addEvent {
    [self addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)initVariables {
    self.focusedBackgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    self.focusedTextColor = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self addEvent];
        [self initVariables];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addEvent];
        [self initVariables];
    }
    return self;
}

@end
