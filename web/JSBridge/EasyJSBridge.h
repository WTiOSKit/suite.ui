//
//  TeacherWebViewJSInterface.h
//  QQing
//
//  Created by 陶澄 on 15/6/29.
//
//

#import <Foundation/Foundation.h>

@protocol EasyJSBridgeDelegate <NSObject>

- (void)callbackWithContent:(NSString *)content methodName:(NSString *)methodName;

@end

@interface EasyJSBridge : NSObject {

}

@property (nonatomic,weak) id<EasyJSBridgeDelegate> delegate;

/*
 * 通过EasyJS与h5页面交互
 *
 * @return param    content     返回的参数
 * @return param    methodName  返回的方法名，通过这个可以区分是什么回调
 *
 */
- (void)callbackWithContent:(NSString *)content methodName:(NSString *)methodName;


- (NSString *)callbackGetContentWithMethodName:(NSString *)methodName;

@end
