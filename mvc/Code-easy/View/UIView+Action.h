//
//  UIView+Action.h
// fallen.ink
//
//  Created by 李杰 on 3/24/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Action)

/**
 *  onXXXXXX: (UITapGestureRecognizer *)rec
 */
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;

- (void)addTapGestureWithTarget:(id)target action:(SEL)action acceptEventInterval:(NSTimeInterval)interval;

/**
 *  onXXXXXX: (UITapGestureRecognizer *)rec
 */
- (void)addDoubleTapGestureWithTarget:(id)target action:(SEL)action;

/**
 *  onXXXXXX: (UIPanGestureRecognizer *)rec
 */
- (void)addPanGestureWithTarget:(id)target action:(SEL)action;

/**
 *  onXXXXXX: (UILongPressGestureRecognizer *)rec
 *
 *  rec.state, UIGestureRecognizerStateBegan, UIGestureRecognizerStateChanged, UIGestureRecognizerStateEnded
 */
- (void)addLongPressGestureWithTarget:(id)target action:(SEL)action;

@end
