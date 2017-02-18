//
//  TeacherWebViewJSInterface.m
//  QQing
//
//  Created by 陶澄 on 15/6/29.
//
//

#import "EasyJSBridge.h"
#import "BaseWebViewController.h"
#import <AdSupport/AdSupport.h>

@implementation EasyJSBridge

- (void)callbackWithContent:(NSString *)content methodName:(NSString *)methodName {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackWithContent:methodName:)]) {
        [self.delegate callbackWithContent:content methodName:methodName];
    }
}

- (NSString *)callbackGetContentWithMethodName:(NSString *)methodName {
//    TestDebugLog2(@"H5模块", @"H5调用qqJSCallBackGetContent: %@", methodName);
    
//    if ([methodName isEqualToString:@"tk"]) {
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", [[Cache sharedInstance] token]);
//        return [[Cache sharedInstance] token];
//    } else if ([methodName isEqualToString:@"si"]) {
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", [[Cache sharedInstance] sessionId]);
//        return [[Cache sharedInstance] sessionId];
//    } else if ([methodName isEqualToString:@"ver"]) {
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", [AppSystem appVersion]);
//        return [AppSystem appVersion];
//    } else if ([methodName isEqualToString:@"deviceinfo"]) {
//        // 4.7.0版本中开始加入
//        NSMutableDictionary* dictToReturn = [NSMutableDictionary dictionary];
//        [dictToReturn setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"deviceid"];
//        [dictToReturn setObject:@"ios" forKey:@"devicetype"];
//        [dictToReturn setObject:[[UIDevice currentDevice] model] forKey:@"devicemodel"];
//        [dictToReturn setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey] forKey:@"appid"];
//        [dictToReturn setObject:[AppSystem appVersion] forKey:@"appversion"];
//        [dictToReturn setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
//        [dictToReturn setObject:@"AppStore" forKey:@"tunnel"];
//        
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dictToReturn options:0 error:nil];
//        NSString *stringToReturn = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] URLEncodedString];
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", stringToReturn);
//        return stringToReturn;
//    } else if ([methodName isEqualToString:@"userinfo"]) {
//        // 4.7.0版本中开始加入
//        NSMutableDictionary* dictToReturn = [NSMutableDictionary dictionary];
//        [dictToReturn setObject:[NSString stringWithFormat:@"%d", [StudentInfoModel sharedInstance].isLoggedin] forKey:@"islogin"];
//        [dictToReturn setObject:([StudentInfoModel sharedInstance].qingqingUserId ? [StudentInfoModel sharedInstance].qingqingUserId : @"") forKey:@"userid"];
//        [dictToReturn setObject:([[Cache sharedInstance] token] ? [[Cache sharedInstance] token] : @"") forKey:@"token"];
//        [dictToReturn setObject:([[Cache sharedInstance] sessionId] ? [[Cache sharedInstance] sessionId] : @"") forKey:@"sessionid"];
//        [dictToReturn setObject:[NSString stringWithFormat:@"%d", [[StudentInfoModel sharedInstance].cityId intValue]] forKey:@"cityid"];
//        [dictToReturn setObject:[[[CityCache sharedInstance] nameForId:[StudentInfoModel sharedInstance].cityId default:kDefaultUserCityName] URLEncodedString] forKey:@"cityname"];
//        
//        [dictToReturn setObject:[NSString stringWithFormat:@"%d", [[StudentInfoModel sharedInstance].sex intValue]] forKey:@"sex"];          // 4.8.0中加入
//        [dictToReturn setObject:[NSString stringWithFormat:@"%d", [StudentInfoModel sharedInstance].isFromZhiKang] forKey:@"iszhikang"];     // 4.8.0中加入
//        [dictToReturn setObject:[NSString stringWithFormat:@"%d", [[StudentInfoModel sharedInstance].gradeId intValue]] forKey:@"gradeid"];  // 4.8.0中加入
//        
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dictToReturn options:0 error:nil];
//        NSString *stringToReturn = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] URLEncodedString];
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", stringToReturn);
//        return stringToReturn;
//    } else if ([methodName isEqualToString:@"locationinfo"]) {
//        // 4.7.0版本中开始加入
//        [Utils showLoadingView];
//        
//        __block NSMutableDictionary* dictToReturn = [NSMutableDictionary dictionary];
//        __block BOOL done = NO;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            [[LocationService sharedInstance] currentLocationWithBlock:^(LocationModel *location) {
//                [dictToReturn setObject:[NSString stringWithFormat:@"%d", location.cityID] forKey:@"cityid"];
//                [dictToReturn setObject:[(location.cityNameString ? location.cityNameString : @"") URLEncodedString] forKey:@"cityname"];
//                [dictToReturn setObject:[(location.district ? location.district : @"") URLEncodedString] forKey:@"district"];
//                [dictToReturn setObject:[NSString stringWithFormat:@"%f", location.longitude] forKey:@"longitude"];
//                [dictToReturn setObject:[NSString stringWithFormat:@"%f", location.latitude] forKey:@"latitude"];
//                
//                done = YES;
//            }];
//        });
//        while (!done) {
//            RUNLOOP_RUN_FOR_A_WHILE;   // 或者使用 pthread_yield_np();
//        }
//        [Utils hideLoadingView];
//        
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dictToReturn options:0 error:nil];
//        NSString *stringToReturn = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] URLEncodedString];
//        TestDebugLog2(@"H5模块", @"H5调用返回:%@", stringToReturn);
//        return stringToReturn;
//    }
    
    return nil;
}

@end
