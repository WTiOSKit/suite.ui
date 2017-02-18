//
//  ITTSegement.h
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTArrowView.h"


// Notice: @"已经被特定定制了，不在具备运行时的扩展性!"

@interface ITTSegement : UIControl

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) ArrowStates currentState;
@property (nonatomic, strong) UILabel *firstLabel;
/**
 images:
 @[
    @[@"state normal", @"state selected"],
    @[@"state normal", @"state selected"],
    @[@"state normal", @"state selected 1", @"state selected 2"],
  ]
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items images:(NSArray *)images;

@end
