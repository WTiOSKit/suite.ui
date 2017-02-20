//
//  UILabel+Extension.m
//  component
//
//  Created by fallen.ink on 4/11/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UILabel+Extension.h"
#import "NSString+Size.h"
#import "_greats.h"

@implementation UILabel ( AttributeText )

- (void)setAttributedText:(NSString *)originText
              withKeyText:(NSString *)keyText
             keyTextColor:(UIColor *)textColor {
    do {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:originText];
        
        if (!keyText) break;
        if (![keyText length]) break;
        
        NSRange keyRange   = [originText rangeOfString:keyText];
        if (keyRange.location == NSNotFound) break;
        
        // Attribute setting
        while (keyRange.location != NSNotFound) {
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:textColor
                                   range:keyRange];
            
            // find next sub string
            NSUInteger nextIndex   = keyRange.location+keyRange.length;
            keyRange    = [originText rangeOfString:keyText
                                            options:NSLiteralSearch
                                              range:NSMakeRange(nextIndex, originText.length-nextIndex)];
        }
        
        
        self.attributedText = attributedText;
        
        return;
    } while (NO);
    
    // Normal setting
    self.text   = originText;
}

@end

#pragma mark - UILabel + ContentSize

@implementation UILabel ( ContentSize )

- (CGSize)contentSizeForWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}

- (CGSize)contentSize {
    return [self contentSizeForWidth:CGRectGetWidth(self.bounds)];
}

#pragma mark - 

- (CGFloat)heightWithLimitWidth:(CGFloat)width {
    return [self contentSizeForWidth:width].height;
}

- (int)lineCountWithLimitWidth:(CGFloat)width {
    int lineNum = [self.text textLineNumWithFont:self.font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    return lineNum;
}

- (BOOL)isTruncated {
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    return (size.height > self.frame.size.height);
}

@end

#pragma mark - System Adapt

@implementation UILabel ( Adapt )

- (void)adapted {
    
//    UIButton显示不全，加上sizeToFit 就可以解决
//    
//    [myBtn sizeToFit];
    
    if (IOS10_OR_LATER) {
//        UILable 显示不全，iOS10提供一个属性adjustsFontForContentSizeCategory
//        = YES来设置
//        
//        myLable.adjustsFontForContentSizeCategory
//        = YES
        self.adjustsFontSizeToFitWidth = YES;
    }
}

@end
