//
//  HBOpenPushNoticeView.m
//  HBAutomationOffice_dev
//
//  Created by Mac on 2020/12/26.
//  Copyright © 2020 yanruyu. All rights reserved.
//

#import "HBOpenPushNoticeView.h"
#import <Masonry.h>
/**
系统高度，宽度 bounds
*/
#define SCREEN_WIDTH            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
//宽高比用iPhone6
#define kAdaptedWidth(x) ((x) * SCREEN_WIDTH/375.0)
#define kAdaptedHeight(x) ((x) * SCREEN_HEIGHT/667.0)
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf

@interface HBOpenPushNoticeView ()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UIView *maskView;//背景
@property (nonatomic ,strong)UIView *bgView;//内容背景
@property (nonatomic ,strong)UIImageView *bgContImgView;//底下img
@property (nonatomic ,strong)UIImageView *topImgView;//上面图片
@property (nonatomic ,strong)UIButton *returnBtn;//退出按钮
@property (nonatomic ,strong)UIButton *agreeBtn;//同意
@end
@implementation HBOpenPushNoticeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setInitViewUI];
    }
    return self;
}
#pragma mark ==========设置子视图==========
-(void)setInitViewUI{
    CGFloat allWidth = SCREEN_WIDTH - 80;
    CGFloat btnWidth = 120;
    CGFloat btnHeight = 34;
    CGFloat rightSpacing = (allWidth-2*btnWidth)/6;
    //背景
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    //内容view
    CGFloat contenWidth = kAdaptedWidth(300);
    CGFloat contenHeight = 414;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(contenWidth, contenHeight));
    }];
    
    [self.bgView addSubview:self.bgContImgView];
    [self.bgContImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
    
    
    [self.bgView addSubview:self.returnBtn];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_centerX).offset(-rightSpacing);
        make.bottom.equalTo(self.bgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [self.bgView addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.returnBtn);
        make.left.equalTo(self.bgView.mas_centerX).offset(rightSpacing);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [self.bgView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(61);
        make.left.equalTo(self.bgView).offset(4);
        make.right.equalTo(self.bgView).offset(-4);
        make.bottom.equalTo(self.agreeBtn.mas_top).offset(-15);
    }];
    
}

#pragma mark ==========getter==========
-(UIImageView *)bgContImgView{
    if (!_bgContImgView) {
        _bgContImgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            //添加图片
            imgView.image = [UIImage imageNamed:@"oa_souye_bg"];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView ;
        }) ;
    }
    return _bgContImgView ;
}
-(UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            //添加图片
            imgView.image = [UIImage imageNamed:@"oa_souye_tan"];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView ;
        }) ;
    }
    return _topImgView ;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = ({
            UIView *view = [UIView new];//初始化控件
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0;
            
            view ;
        }) ;
    }
    return _maskView ;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = ({
            UIView *view = [UIView new];//初始化控件
            view.backgroundColor = [UIColor whiteColor];
            view.alpha = 0;
            view.layer.cornerRadius = 10;
            view.clipsToBounds = YES;
            
            view ;
        }) ;
    }
    return _bgView ;
}

-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = ({
            //创建按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置标题
            [button setTitle:@"开启推送" forState:UIControlStateNormal];
            //设置字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            //设置title颜色
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor redColor];
            button.layer.cornerRadius = 6;
            button.clipsToBounds = YES;
            //添加点击事件
            [button addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _agreeBtn;
}

-(UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = ({
            //创建按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置标题
            [button setTitle:@"暂不开启" forState:UIControlStateNormal];
            //设置字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            //设置title颜色
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            button.backgroundColor = Color_label_labelBlack;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.layer.cornerRadius = 6;
            button.clipsToBounds = YES;
            //添加点击事件
            [button addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _returnBtn;
}
//点击一键开启
-(void)clickAgreeBtn{
    [self hide];
    //跳到设置界面
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    });
}
#pragma mark ==========点击暂不开启==========
-(void)clickReturnBtn{
    [self hide];
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    WEAKSELF;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.maskView.alpha = 0.5;
        weakSelf.bgView.alpha = 1.0;
    } completion:nil];
}

- (void)hide{
    WEAKSELF;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.maskView.alpha = 0.0;
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
