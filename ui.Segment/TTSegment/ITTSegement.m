//
//  ITTSegement.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import "ITTSegement.h"

@implementation ITTSegement {
    NSMutableArray *allItems;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items images:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImages:images];
        
        [self _initViews:items];
    }
    
    return self;
}

- (void)_initViews:(NSArray *)items {
    allItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    
    float viewWidth =  [UIScreen mainScreen].bounds.size.width ;
    float itemWidth = viewWidth/items.count;
    
    self.items = items;
    //    NSArray *upImages = @[@"up_red@2x.png", @"up_white@2x.png"];
    //    NSArray *downImages = @[@"down_red@2x.png", @"down_white@2x.png"];
    
    for (int i = 0; i < items.count; i++) {
        NSArray *imgs = [self.images objectAtIndex:i];
        NSString *itemName = items[i];
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, self.height)];
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:itemView.bounds];
        if (i == 0) {
            self.firstLabel = titleLabel;
        }
        //        titleLabel.x += 14;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textColor = [UIColor themeColor];
        titleLabel.text = itemName;
        titleLabel.tag = 2013;
        [itemView addSubview:titleLabel];
        
        if (i != 1) {
            ITTArrowView *arrowView = [[ITTArrowView alloc] initWithFrame:CGRectMake(itemWidth-27, 0, 13, 18)];
            if (IS_SCREEN_4_INCH ||
                IS_SCREEN_35_INCH) {
                arrowView.frame = CGRectMake(itemWidth - 17, 0, 13, 18);
            }
            arrowView.images = imgs;
            
            __weak ITTSegement *this = self;
            arrowView.block = ^(ArrowStates state){
                ITTSegement *strong = this;
                strong.currentState = state;
            };
            
            arrowView.tag = 2014;
            if (i == 0) {
                arrowView.isSelected = YES;
            } else if (i == 2) {
                arrowView.states = NormalStates;
            }
            
            [itemView addSubview:arrowView];
            [arrowView setCenterY:itemView.height/2];
        }
        
        [self addSubview:itemView];
        [allItems addObject:itemView];
        
        { // 加分隔符
            if (i < items.count-1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(itemView.width-1,
                                                                        10, 2, itemView.height-10*2)];
                line.backgroundColor = [UIColor colorWithRed:232./255.
                                                       green:232./255.
                                                        blue:232./255.
                                                       alpha:1.0];
                [itemView addSubview:line];
                [line bringToFront];
            }
        }
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, screen_width, 1)];
    lineView.backgroundColor = [UIColor gray003Color];
    [self addSubview:lineView];
}

- (void)setSelectedIndex:(int)selectedIndex {
    _selectedIndex = selectedIndex;
    
    for (int i = 0; i < allItems.count; i++) {
        UIView *itemView = allItems[i];
        UILabel *titleLabel = (UILabel *)[itemView viewWithTag:2013];
        ITTArrowView *arrowView = (ITTArrowView *)[itemView viewWithTag:2014];
        
        if (i == selectedIndex) {
            titleLabel.textColor = [UIColor themeColor];
            arrowView.isSelected = YES;
            
            if (selectedIndex == 2) {
                if (arrowView.states == NormalStates) {
                    arrowView.states = DownStates;
                } else {
                    arrowView.states = arrowView.states == UpStates ? DownStates : UpStates;
                }
            } else {
                arrowView.states = DownStates;
            }
        } else {
            titleLabel.textColor = [UIColor gray005Color];
            arrowView.isSelected = NO;
            
            arrowView.states = NormalStates;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float width = [UIScreen mainScreen].bounds.size.width/self.items.count;
    int index = point.x /width;
    self.selectedIndex = index;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end

