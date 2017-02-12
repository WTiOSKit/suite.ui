//
//  MQCache.h
// fallen.ink
//
//  Created by qingqing on 15/12/28.
//
//

#import <Foundation/Foundation.h>

@interface MQCache : NSObject

@singleton( MQCache )

- (void)createMqttMessageTable;

- (void)handleExpiredMqttMessage;

- (void)updateMqttmessageWithMessageID:(long long)messageID
                       withMessageTime:(long long)messageTime;

- (void)insertLocalMqttMessageWithMessageID:(long long)messageID
                            withMessageTime:(long long)messageTime
                            withMessageType:(long long)messageType
                            withMessageBody:(NSString *)messageBody;

- (BOOL)mqttMessageExistWithMessageID:(long long)messageID;

@end
