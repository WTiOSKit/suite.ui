//
//  TextFieldDelegate.m
//
//  Created by fallen.ink on 3/30/16.
//
//

#import "TextFieldDelegate.h"

@implementation TextFieldDelegate

#pragma mark - Initialize

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *temp = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    textField.text = temp;
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > self.max) {
        textField.text = [textField.text substringToIndex:self.max];
    }
    
    if (self.textFieldChanged) {
        self.textFieldChanged(textField);
    }
}

@end
