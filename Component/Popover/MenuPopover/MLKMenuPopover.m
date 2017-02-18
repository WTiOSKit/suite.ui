//
//  MLKMenuPopover.m
//  MLKMenuPopover
//
//  Created by NagaMalleswar on 20/11/14.
//  Copyright (c) 2014 NagaMalleswar. All rights reserved.
//

#import "MLKMenuPopover.h"
#import "pop.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import <QuartzCore/QuartzCore.h>

#define MENU_ITEM_HEIGHT        44
#define FONT_SIZE               16
#define CELL_IDENTIGIER         @"MenuPopoverCell"
#define MENU_TABLE_VIEW_FRAME   CGRectMake(0, 0, frame.size.width, frame.size.height)
#define SEPERATOR_LINE_RECT     CGRectMake(10, MENU_ITEM_HEIGHT - 1, self.frame.size.width - 20, 1)
//FIXME:修改了箭头大小，对全局UI影响请指正 原来18  10  --王云鹏
#define MENU_POINTER_RECT       CGRectMake(frame.origin.x+frame.size.width-23, frame.origin.y+2, 14, 9)

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.2f //解决键盘弹起状态下menu消失太慢的问题 原来0.5f

#define MENU_POINTER_TAG        1011
#define MENU_TABLE_VIEW_TAG     1012

#define LANDSCAPE_WIDTH_PADDING 50

@interface MLKMenuPopover ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuImages;
@property (nonatomic, strong) UIButton *containerButton;

@property (nonatomic, strong) UITableView *tableView;

- (void)hide;
- (void)addSeparatorImageToCell:(UITableViewCell *)cell;

@end

@implementation MLKMenuPopover

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)aMenuItems menuImages:(NSArray *)amenuImages closeTo:(QQcloseToBorderStyle)closeToBorderStyle {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.menuItems = aMenuItems;
        self.menuImages = amenuImages;
        // Adding Container Button which will take care of hiding menu when user taps outside of menu area
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:[UIColor clearColor]];
        [self.containerButton addTarget:self action:@selector(dismissMenuPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        // Adding Menu Options Pointer
        UIImageView *menuPointerView = [[UIImageView alloc] initWithFrame:MENU_POINTER_RECT];
        menuPointerView.image = [UIImage imageNamed:@"course_menu_bg"];
        menuPointerView.tag = MENU_POINTER_TAG;
        [self.containerButton addSubview:menuPointerView];
        
        // Adding menu Items table
        UITableView *menuItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, frame.size.height)];
        
        menuItemsTableView.dataSource = self;
        menuItemsTableView.delegate = self;
        menuItemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        menuItemsTableView.scrollEnabled = NO;
        menuItemsTableView.backgroundColor = [UIColor clearColor];
        menuItemsTableView.tag = MENU_TABLE_VIEW_TAG;
        
        switch (closeToBorderStyle) {
            case QQcloseToBorderStyleLeft:
                menuPointerView.x = frame.origin.x+18;
                break;
                
            case QQcloseToBorderStyleRight:
                menuPointerView.frame = MENU_POINTER_RECT;
                break;
                
            default:
                break;
        }
        
        [self addSubview:menuItemsTableView];
        
        self.tableView = menuItemsTableView;
        
        [self.containerButton addSubview:self];
    }
    
    return self;
}

#pragma mark - UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = CELL_IDENTIGIER;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor colorWithRGBHex:0x797979]];
        
        /*
         *修改Frame待定
        CGRect imageFrame = cell.imageView.frame;
        imageFrame.origin.x = 12;
        cell.imageView.frame = imageFrame;
        
        CGRect labelFrame = cell.textLabel.frame;
        labelFrame.origin.x = 12+imageFrame.size.width+4;
        cell.textLabel.frame = labelFrame;
        */
    }
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    if( [tableView numberOfRowsInSection:indexPath.section] > ONE && !(indexPath.row == numberOfRows - 1) ) {
        [self addSeparatorImageToCell:cell];
    }
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    if (self.menuImages.count) {
        cell.imageView.image = self.menuImages[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    [self.menuPopoverDelegate menuPopover:self didSelectMenuItemAtIndex:indexPath.row];
}

#pragma mark - Actions

- (void)dismissMenuPopover {
    [self hide];
}

- (void)showInView:(UIView *)view {
    self.containerButton.alpha = ZERO;
    self.containerButton.frame = view.bounds;
    [view addSubview:self.containerButton];
        
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ONE;
                     }
                     completion:^(BOOL finished) {}];
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    positionAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(self.displayFrame.origin.x+self.displayFrame.size.width, 11, 0, 0)];
//    positionAnimation.toValue = [NSValue valueWithCGRect:self.displayFrame];
//    positionAnimation.springBounciness = 15.0f;
//    positionAnimation.springSpeed = 20.0f;
//    [self.tableView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
}

- (void)hide {
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ZERO;
                     }
                     completion:^(BOOL finished) {
                         [self.containerButton removeFromSuperview];
                     }];
    
//    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    positionAnimation.fromValue = [NSValue valueWithCGRect:self.displayFrame];
//    positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(self.displayFrame.origin.x+self.displayFrame.size.width, self.tableView.origin.y, 0, 0)];
//    positionAnimation.completionBlock = ^ (POPAnimation *anim, BOOL finished) {
////        [self.containerButton removeFromSuperview];
//    };
//    [self.tableView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
}

#pragma mark - Separator Methods

- (void)addSeparatorImageToCell:(UITableViewCell *)cell {
    UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:SEPERATOR_LINE_RECT];
    [separatorImageView setBackgroundColor:[UIColor whiteColor]];
    separatorImageView.alpha = 0.7;
    separatorImageView.opaque = YES;
    [cell.contentView addSubview:separatorImageView];
}

#pragma mark - Orientation Methods

- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL landscape = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    UIImageView *menuPointerView = (UIImageView *)[self.containerButton viewWithTag:MENU_POINTER_TAG];
    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:MENU_TABLE_VIEW_TAG];
    
    if( landscape ) {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    } else {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
}

@end
