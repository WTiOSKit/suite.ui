//
//  HyPopMenuView.m
//  HyPopMenuView
//
//  Created by  H y on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "_precompile.h"
#import "_popup.h"
#import "MenuLabel.h"
#import "POP.h"
#import "HyPopMenuView.h"
#import "UIColor+Extension.h"

#define Duration 0.2
#define KeyPath @"transform.scale"
#define CancelStrImgaeName @"tabbar_compose_background_icon_add"
#define kTitleRatio 0.4
#define HowMucHline 3
#define ButtonWidth screen_width/HowMucHline
#define ButtonHigh ButtonWidth
#define ButtonTag 200
#define Interval (0.195 / _ItmesArr.count)

NSString *const kHyPopMenuViewOpenAudioTypeKey = @"OpenAudioTypekey";
NSString *const kHyPopMenuViewOpenAudioNameKey = @"OpenAudioNamekey";

NSString *const kHyPopMenuViewCloseAudioTypeKey = @"CloseAudioTypekey";
NSString *const kHyPopMenuViewCloseAudioNameKey = @"CloseAudioNamekey";

NSString *const kHyPopMenuViewSelectAudioNameKey = @"SelectAudioNameKey";
NSString *const kHyPopMenuViewSelectAudioTypeKey = @"SelectAudioTypeKey";

CGRect ValidAnimateRect;

@interface HyPopMenuView () {
    UIImage *bulrImage;
}

@property (nonatomic, retain) NSArray *ItmesArr;

@property (nonatomic, strong) SelectdCompletionBlock block;

@property (nonatomic, strong) Block willSelectHandler;

@property (nonatomic, assign) BOOL is;

@property (nonatomic, assign) BOOL nested; // 嵌入view，不需要 X 按钮

@end

@implementation HyPopMenuView

+ (void)setAnimateValidRect:(CGRect)validRect {
    ValidAnimateRect = validRect;
}

+ (HyPopMenuView *)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
                          TopView:(UIView *)topView
       OpenOrCloseAudioDictionary:(NSDictionary *)openOrCloseAudioDictionary
           SelectdCompletionBlock:(SelectdCompletionBlock)block
                  willSelectBlock:(Block)willSelectHandler {

    HyPopMenuView *menu = [[HyPopMenuView alloc] initWithItmes:Items];
    [menu setOpenOrCloseAudioDictionary:openOrCloseAudioDictionary];
    [menu setTopView:topView];
    [menu SelectdCompletionBlock:block];
    [menu setWillSelectHandler:willSelectHandler];
    
    return menu;
}

- (instancetype)initWithItmes:(NSArray<MenuLabel *> *)Itmes {
    self = [super init];
    if (self) {
        _is = true;
        _ItmesArr = Itmes;
        if (CGRectIsNull(ValidAnimateRect)) {
            self.nested = NO;
            
            ValidAnimateRect = CGRectMake(0, 0, screen_width, screen_height);
        } else {
            self.nested = YES;
        }
        
        [self setFrame:ValidAnimateRect];
        
        [self initUI];
        
        [self show];
    }
    return self;
}

- (void)initUI {
    self.alpha = 0.0f;
//    UIView *DownView = [[UIView alloc] init];
//    CGFloat DownY = screen_height - 52;
//    [DownView setTag:10];
//    [DownView setFrame:(CGRect){{0,DownY},{screen_width,52}}];
//    [DownView setBackgroundColor:[UIColor clearColor]];
//    
//    CGFloat CANCELw = 28;
//    ImageView *CancelButton = [[ImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(DownView.bounds)/2 - CANCELw/2, CGRectGetHeight(DownView.bounds)/2 - CANCELw/2, CANCELw, CANCELw)];
//    UIImage *image = [UIImage imageNamed:CancelStrImgaeName];
//    [CancelButton setImage:image];
//    [CancelButton setTag:11];
//    [DownView addSubview:CancelButton];
//    [self addSubview:DownView];
    
    [self CirculatingItmes];
}

- (void)CirculatingItmes {
    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
    UIView *downView = [CancelButton superview];
    
    @weakify(self)
    
    [UIView animateWithDuration:Duration animations:^{
        @strongify(self)
        
        [self setAlpha:1];
        
//        CancelButton.transform=CGAffineTransformMakeRotation((M_PI/2)/2);
    }];
    
    NSInteger index = 0;
    for (MenuLabel *Obj in _ItmesArr) {
        CGFloat buttonX,buttonY;
        buttonX = (index % HowMucHline) * ButtonWidth;
        buttonY = ((index / HowMucHline) * (ButtonHigh +10));
        CGRect fromValue = CGRectMake(buttonX, CGRectGetMinY(self.frame), ButtonWidth, ButtonHigh);
        CGRect toValue = CGRectMake(buttonX, buttonY, ButtonWidth, ButtonHigh);
        if (index == 0) {
            _MaxTopViewY = CGRectGetMinY(toValue);
        }
        CustomButton *button = [self allocButtonIndex:index];
        button.MenuData = Obj;
        [button setFrame:fromValue];
        double delayInSeconds = index * Interval;
        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
        
        [self StartTheAnimationFromValue:fromValue ToValue:toValue Delay:delay Object:button CompletionBlock:^(BOOL CompletionBlock) {
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                        action:@selector(dismiss)];
//            [_BlurView addGestureRecognizer:tap];
        } HideDisplay:false];
        index ++;
    }
}

- (CustomButton *)allocButtonIndex:(NSInteger)index {
    CustomButton *button = [[CustomButton alloc] init];
    [button setTag:(index + 1) + ButtonTag];
    [button setAlpha:0.0f];
    [button setTitleColor:[UIColor colorWithWhite:0.38 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return button;
}

-(void)StartTheAnimationFromValue:(CGRect)fromValue
                          ToValue:(CGRect)toValue
                            Delay:(CFTimeInterval)delay
                           Object:(id/*<UIView *>*/)obj
                  CompletionBlock:(void(^) (BOOL CompletionBlock))completionBlock HideDisplay:(BOOL)HideDisplay{
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = delay;
    CGFloat springBounciness = 10.f;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    CGFloat springSpeed = 20.f;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toValue];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromValue];
    
    POPSpringAnimation *SpringAnimationAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    SpringAnimationAlpha.removedOnCompletion = YES;
    SpringAnimationAlpha.beginTime = delay;
    SpringAnimationAlpha.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat toV,fromV;
    if (HideDisplay) {
        fromV = 1.0f;
        toV = 0.0f;
    }else{
        fromV = 0.0f;
        toV = 1.0f;
    }
    
    SpringAnimationAlpha.springSpeed = springSpeed;     // value between 0-20
    SpringAnimationAlpha.toValue = @(toV);
    SpringAnimationAlpha.fromValue = @(fromV);
    
    [obj pop_addAnimation:SpringAnimationAlpha forKey:SpringAnimationAlpha.name];
    [obj pop_addAnimation:springAnimation forKey:springAnimation.name];
    [springAnimation setCompletionBlock:^(POPAnimation *spring, BOOL Completion) {
        if (!completionBlock) {
            return ;
        }
        completionBlock(Completion);
    }];
    
}

- (void)DismissCompletionBlock:(void(^) (BOOL CompletionBlock)) completionBlock {

    NSInteger index = 0;
    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
    UIView *downView = CancelButton.superview;

    for (MenuLabel *label in _ItmesArr) {
        CustomButton *button = (CustomButton *)[self viewWithTag:(index + 1) + ButtonTag];
        button.MenuData = label;
        CGFloat buttonX,buttonY;
        buttonX = (index % HowMucHline) * ButtonWidth;
        buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (screen_height/2.9);
        
        CGRect toValue = CGRectMake(buttonX, screen_height, ButtonWidth, ButtonHigh);
        CGRect fromValue = CGRectMake(buttonX, buttonY, ButtonWidth, ButtonHigh);
        double delayInSeconds = (_ItmesArr.count - index) * Interval;
        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
        
        [UIView animateWithDuration:0.2 animations:^{
            [CancelButton setAlpha:0.1f];
            CancelButton.transform = CGAffineTransformMakeRotation(0);
            [downView setBackgroundColor:[UIColor clearColor]];
        }];
        
        [self StartTheAnimationFromValue:fromValue ToValue:toValue Delay:delay Object:button CompletionBlock:^(BOOL CompletionBlock) {
        } HideDisplay:true];
        index ++;
    }
    
    [self HidDelay:PopupAnimationDelayTimeInterval CompletionBlock:completionBlock];
}

- (void)setTopView:(UIView *)TopView {
    if (![TopView isKindOfClass:[NSNull class]] &&
        [TopView isKindOfClass:[UIView class]]) {
        _TopView = TopView;
        [self addSubview:_TopView];
    }
    
}

- (void)selectd:(CustomButton *)button {
    if (self.willSelectHandler) self.willSelectHandler();
    
    NSInteger tag = button.tag - (ButtonTag + 1);
    typeof(self) weak = self;
    for (MenuLabel *label in _ItmesArr) {
        NSInteger index = [_ItmesArr indexOfObject:label];
        CustomButton *buttons = (CustomButton *)[self viewWithTag:(index + 1) + ButtonTag];
        if (index == tag) {
            [button SelectdAnimation];
        } else {
            [buttons CancelAnimation];
        }
    }
    [self HidDelay:0.3f CompletionBlock:^(BOOL completion) {
        if (!weak.block) {
            return ;
        }
        weak.block(button.MenuData,tag);
    }];
    if (_OpenOrCloseAudioDictionary == nil) {
        return;
    }
    BOOL isname = false;
    NSArray *Keys = [_OpenOrCloseAudioDictionary allKeys];
    isname = [Keys containsObject:kHyPopMenuViewSelectAudioNameKey];
    
    BOOL istype = false;
    NSString *SelectAudioName,*SelectAudioType;
    istype = [Keys containsObject:kHyPopMenuViewSelectAudioTypeKey];
    if (isname && istype) {
        SelectAudioType = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewSelectAudioTypeKey];
        SelectAudioName = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewSelectAudioNameKey];
    }else{
        SelectAudioType = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewCloseAudioTypeKey];
        SelectAudioName = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewCloseAudioNameKey];
    }
    [self playSoundName:SelectAudioName ForType:SelectAudioType];
}

-(void)HidDelay:(NSTimeInterval)delay
CompletionBlock:(void(^)(BOOL completion))blcok
{
    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
    UIView *downView = [CancelButton superview];
    [self setUserInteractionEnabled:false];
    typeof(self) weak = self;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
       
        [downView setBackgroundColor:[UIColor clearColor]];
        CancelButton.transform = CGAffineTransformMakeRotation(0);
        [CancelButton setAlpha:0.1f];
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateKeyframesWithDuration:Duration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [weak setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        [weak removeFromSuperview];
        if (!blcok) {
            return ;
        }
        blcok(finished);
    }];
}

-(void)SelectdCompletionBlock:(SelectdCompletionBlock) block{

    _block = block;
}

- (void)dismiss {
    UIView *button = [self viewWithTag:10];
    [button setUserInteractionEnabled:false];
    [self setUserInteractionEnabled:false];
    
    @weakify(self)
    [self DismissCompletionBlock:^(BOOL CompletionBlock) {
        @strongify(self)
        
        [self removeFromSuperview];
    }];
    if (_OpenOrCloseAudioDictionary == nil) {
        return;
    }
    NSString *CloseAudioType = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewCloseAudioTypeKey];
    NSString *CloseAudioName = [_OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewCloseAudioNameKey];
    [self playSoundName:CloseAudioName ForType:CloseAudioType];
}

-(void)setOpenOrCloseAudioDictionary:(NSDictionary *)OpenOrCloseAudioDictionary{

    _OpenOrCloseAudioDictionary = OpenOrCloseAudioDictionary;
    if (_OpenOrCloseAudioDictionary == nil) {
        return;
    }
    NSString *OpenAudioType = [OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewOpenAudioTypeKey];
    NSString *OpenAudioName = [OpenOrCloseAudioDictionary objectForKey:kHyPopMenuViewOpenAudioNameKey];
    [self playSoundName:OpenAudioName ForType:OpenAudioType];
    
}

-(void)playSoundName:(NSString *)name
             ForType:(NSString *)type

{
    NSString *AudioName = [NSString stringWithFormat:@"%@.%@",name,type];
    NSURL *url=[[NSBundle mainBundle]URLForResource:AudioName withExtension:nil];

    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //把需要销毁的音效文件的ID传递给它既可销毁
    //AudioServicesDisposeSystemSoundID(soundID);
    
    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
    //AudioServicesPlayAlertSound(soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
}

- (void)show {
    UIWindow *window = [_Popup sharedInstance].window;
    [window addSubview:self];
}

@end

@interface CustomButton ()

@end

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        //3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addTarget:self action:@selector(scaleToSmall)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleToDefault)
       forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

-(void)setMenuData:(MenuLabel *)MenuData{

    _MenuData = MenuData;
    UIImage *image = [UIImage imageNamed:MenuData.iconName];
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:MenuData.title forState:UIControlStateNormal];
    UIColor *color = [UIColor getPixelColorAtLocation:CGPointMake(50, 20) inImage:image];
    [self setTitleColor:color forState:UIControlStateNormal];
    
}

- (void)scaleToSmall
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:KeyPath];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.1f];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:KeyPath];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.1f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

-(void)SelectdAnimation{

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:KeyPath];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @1.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

-(void)CancelAnimation{

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:KeyPath];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
    
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWidth = contentRect.size.width/1.7;
    CGFloat imageX = CGRectGetWidth(contentRect)/2 - imageWidth/2;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = CGRectGetHeight(self.bounds) - (imageHeight + 30);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = 20;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX,titleY, titleWidth, titleHeight);
}

@end

@implementation ImageView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view) {
        return view.superview.superview;//view.superview; or view.superview.superview; or view.superview.superview.superview;... if has
    }else
    return nil;
}

@end
