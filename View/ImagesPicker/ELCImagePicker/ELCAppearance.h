//
//  ELCAppearance.h
//  consumer
//
//  Created by fallen on 16/12/19.
//
//

#import "_greats.h"

@interface ELCAppearance : NSObject

@singleton( ELCAppearance )

@property (nonatomic, strong) NSString *selectedImageName;
@property (nonatomic, assign) BOOL  showOrderNum; // 选择的序号

@end

#define elcAppearance [ELCAppearance sharedInstance]
