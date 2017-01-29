//
//  _AlertView.m
//  Ape_uni
//
//  Created by Chenyu Lan on 8/21/13.
//  Copyright (c) 2013 Fenbi. All rights reserved.
//
//  inspired by CYAlertView

#import <UIKit/UIKit.h>

@interface _AlertView : UIAlertView

@property (nonatomic, strong) UIColor *userTitleColor DEPRECATED;

@property (nonatomic, strong) UIColor *userMessageColor DEPRECATED;

@property (nonatomic, strong) NSString *userMessage DEPRECATED;

/**
 *  MUST set userMessage
 */
@property (nonatomic, strong) NSDictionary *userKeyMessageColorMap DEPRECATED; // NSString : UIColor

- (void)applyUserStyle DEPRECATED; // MUST call it

@end
