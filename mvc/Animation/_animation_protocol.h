//
//  _animation_protocol.h
//  hairdresser
//
//  Created by fallen.ink on 6/8/16.
//
//

@protocol _AnimationDelegate <NSObject> // fixme: 貌似核心动画有类似的delegate

- (void)animation:(id)animator willStart:(BOOL)bStart;

- (void)animation:(id)animator willEnd:(BOOL)end;

@end

@protocol _AnimationDataSource <NSObject>

//- (UIView *)

@end