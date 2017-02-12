//
//  UITextField+CalculateCursorOffset.m
//  查找光标位置
//
//  Created by renren on 5/21/15.
//  Copyright (c) 2015 renren. All rights reserved.
//

#import "UITextField+CalculateCursorOffset.h"

@implementation UITextField (CalculateCursorOffset)

- (CGFloat)cursorOffset
{
    NSArray *textrect = [self selectionRectsForRange:[self selectedTextRange]];
    CGRect rect = ((UITextSelectionRect *)textrect[0]).rect;
    
    if (rect.origin.x > 100000) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
        if (self.textAlignment == NSTextAlignmentCenter){
            CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
            CGFloat width = CGRectGetWidth(self.frame);
            return width - (width - size.width)/2.0f;
        } else if (self.textAlignment == NSTextAlignmentRight){
            return CGRectGetWidth(self.frame);
        } else {
            return size.width;
        }
    }
    
    return rect.origin.x;
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                    attributes:attribute
                                                       context:nil].size;
    
    return retSize;
}



@end
