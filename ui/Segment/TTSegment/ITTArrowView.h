//
//  ITTArrowView.h
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 正常态 与 选中态，由来SelectedIndex确定
 
 * 选中态中又分为两种状态
 
 * normal, up\down
 
 * normal, down
 */
typedef enum arrowStates {
    NormalStates    = 0,
    SelectedStates  = 1,
    DownStates      = SelectedStates,
    UpStates        = 2,
} ArrowStates;

typedef void(^StateHadChangedBlock)(ArrowStates state);

@interface ITTArrowView : UIImageView

@property (nonatomic, strong) NSArray *images;

@property(nonatomic, assign) ArrowStates states;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, copy) StateHadChangedBlock block;

//- (id)initWithFrame:(CGRect)frame stateBlock:(StateHadChangedBlock)block;

@end
