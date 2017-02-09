//
//  ELCAppearance.m
//  consumer
//
//  Created by fallen on 16/12/19.
//
//

#import "ELCAppearance.h"

@implementation ELCAppearance

@def_singleton( ELCAppearance )

- (instancetype)init {
    if (self = [super init]) {
        self.selectedImageName = @"selected_photo_overlay";
        self.showOrderNum = YES;
    }
    
    return self;
}

@end
