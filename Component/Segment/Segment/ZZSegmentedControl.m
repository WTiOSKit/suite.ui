//
//  ZZSegmentedControl.m
//  TalentService
//
//  Created by charles on 15/8/28.
//  Copyright (c) 2015年 zhizhen. All rights reserved.
//

#import "ZZSegmentedControl.h"
#import "_precompile.h"
#import "_ui_core.h"

@interface ZZSegmentedControl()
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)UILabel *lineLabel1;
@property(nonatomic,strong)UILabel *lineLabel2;
@end
@implementation ZZSegmentedControl
-(instancetype)initWithItems:(NSArray *)items{
    self = [super initWithItems:items];
    if (self) {
        [self setSegmentControll];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setSegmentControll];
    }
    return self;
}


-(void)setSegmentControll{
    self.tintColor = [UIColor clearColor];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.exclusiveTouch = YES; //不可多点同时点下
    NSDictionary *seleted = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName ,nil];
    [self setTitleTextAttributes:seleted forState:UIControlStateSelected];
    
    NSDictionary *disseleted = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeBlackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName ,nil];
    [self setTitleTextAttributes:disseleted forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.selectedSegmentIndex = 0;
    
    /**
     *  横线
     */
    [self addSubview:self.lineLabel];
    [self addSubview:self.lineLabel1];
    [self addSubview:self.lineLabel2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineLabel.width = self.frame.size.width/self.numberOfSegments;
    self.lineLabel.y = self.frame.size.height-self.lineLabel.height;
    self.lineLabel1.height = self.frame.size.height - 2*PIXEL_8;
    self.lineLabel1.x = self.frame.size.width/self.numberOfSegments;
    self.lineLabel1.y = PIXEL_8;
    self.lineLabel2.height = self.frame.size.height - 2*PIXEL_8;
    self.lineLabel2.x = 2*(self.frame.size.width/self.numberOfSegments);
    self.lineLabel2.y = PIXEL_8;
}

-(void)change:(UISegmentedControl*)seg{
    NSUInteger  index = self.numberOfSegments;
    [UIView  animateWithDuration:0.1 animations:^{
        self.lineLabel.x = (screen_width/index)*self.selectedSegmentIndex;
    }];
    if (self.delegate) {
        [self.delegate  segmentControl:self andIndex:seg.selectedSegmentIndex];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    [self change:self];
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.height = PIXEL_4;
        _lineLabel.backgroundColor = [UIColor themeColor];
    }
    return _lineLabel;
}

- (UILabel *)lineLabel1 {
    if (!_lineLabel1) {
        _lineLabel1 = [[UILabel alloc] init];
        _lineLabel1.width = PIXEL_1;
        _lineLabel1.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f0];
    }
    return _lineLabel1;
}

- (UILabel *)lineLabel2 {
    if (!_lineLabel2) {
        _lineLabel2 = [[UILabel alloc] init];
        _lineLabel2.width = PIXEL_1;
        _lineLabel2.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f0];
    }
    return _lineLabel2;
}

@end
