
/** @knowledge Comes form BeeFramework!! */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "extension/UIView+UISignal.h"
#import "extension/UIViewController+UISignal.h"

#pragma mark -

#undef	ui_signal
#define ui_signal( __name ) \
    property (nonatomic, readonly) NSString * __name; \
    + (NSString *)__name;

#undef	def_ui_signal
#define def_ui_signal( __name ) \
    dynamic __name; \
    + (NSString *)__name \
    { \
        static NSString * __local = nil; \
        if ( nil == __local ) \
        { \
            __local = [NSString stringWithFormat:@"signal.%@.%s",[self description], #__name]; \
        } \
        return __local; \
    } \
    - (NSString *)__name \
    { \
        return [self.class __name]; \
    }


#pragma mark -

@interface NSObject ( UISignalResponder )

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (BOOL)isUISignalResponder;

@end

#pragma mark -

@interface _UISignal : NSObject {
	BOOL				_dead;
	BOOL				_reach;
	NSUInteger			_jump;
	NSString *			_name;
	NSObject *			_object;
	NSObject *			_returnValue;

	NSTimeInterval		_initTimeStamp;
	NSTimeInterval		_sendTimeStamp;
	NSTimeInterval		_reachTimeStamp;
    
    
	NSMutableString *	_callPath;

}

@property (nonatomic, assign) BOOL				dead;			// 杀死SIGNAL
@property (nonatomic, assign) BOOL				reach;			// 是否触达顶级ViewController
@property (nonatomic, assign) NSUInteger		jump;			// 转发次数
@property (nonatomic, assign) id				source;			// 发送来源
@property (nonatomic, assign) id				target;			// 转发目标
@property (nonatomic, retain) NSString *		name;			// Signal名字
@property (nonatomic, retain) NSObject *		object;			// 附带参数
@property (nonatomic, retain) NSObject *		returnValue;	// 返回值，默认为空

@property (nonatomic, assign) NSTimeInterval	initTimeStamp;
@property (nonatomic, assign) NSTimeInterval	sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval	reachTimeStamp;

@property (nonatomic, readonly) NSTimeInterval	timeElapsed;		// 整体耗时
@property (nonatomic, readonly) NSTimeInterval	timeCostPending;	// 等待耗时
@property (nonatomic, readonly) NSTimeInterval	timeCostExecution;	// 处理耗时


@property (nonatomic, retain) NSMutableString *	callPath;


@property (nonatomic, readonly) NSString * YES_VALUE;
+ (NSString *)YES_VALUE;

@property (nonatomic, readonly) NSString * NO_VALUE;
+ (NSString *)NO_VALUE;


- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isSentFrom:(id)source;

- (BOOL)send;
- (BOOL)forward:(id)target;

- (void)clear;

// 只有某些特殊的SIGNAL需要加传真假值，如WebView
- (BOOL)boolValue;
- (void)returnYES;
- (void)returnNO;

@end
