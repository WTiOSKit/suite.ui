//
//  ITTArrowView.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import "ITTArrowView.h"

@implementation ITTArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.states = NormalStates;
        //self.image = [UIImage imageNamed:@"up_white@2x.png"];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
//    if (isSelected) {
//        ArrowStates states =_states ^ 1;
//        self.states = states;
//    }else {
//        [self setStates:_states];
//    }
    
}

-(void)setStates:(ArrowStates)states
{
    if (states != _states) {
        _states = states;
    }
    
    if (!self.images) {
        return;
    }
    
    if (_isSelected) {
        if (_states == UpStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:2]];
        } else if (_states == DownStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:1]];
        } else if (_states == NormalStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:0]];
        }
        
        if (self.block != nil) {
            self.block(_states);
        }
    } else {
        if (_states == UpStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:0]];
        } else if (_states == DownStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:0]];
        } else if (_states == NormalStates) {
            self.image = [UIImage imageNamed:[self.images objectAtIndex:0]];
        }
    }
}

@end
