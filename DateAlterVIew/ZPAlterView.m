//
//  ZPAlterView.m
//  DateAlterVIew
//
//  Created by zp on 16/5/17.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "ZPAlterView.h"
#import "IQKeyboardManager.h"
#define ZPAlertView_Width 270.0
#define ZPAlert_TitleLabel_Height 50.0
#define ZPAlert_DateView_Height 250
#define ZPAlert_Button_Height 50.0
#define ZPAlert_Date_Width (ZPAlertView_Width- 40)/3
#define ZPAlert_Date_Height 100
@interface ZPAlterView()<UITextFieldDelegate>
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  日期
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  取消button标题
 */
@property (nonatomic, copy) NSString *cancelButtonTitle;
/**
 *  确定button标题
 */
@property (nonatomic, copy) NSString *sureButtonTitle;
/**
 *  弹出的背景
 */
@property (nonatomic, strong) UIView *backGroundView;
/**
 *  时间选择器
 */
@property (nonatomic, strong) UIView *alertView;


@property (strong,nonatomic)UIDynamicAnimator * animator;

@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation ZPAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title date:(NSDate *)date cancelButtonTitle:(NSString *)cancelBUttonTitle sureButtonTitle:(NSString *)sureButtonTitle{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        self.title = title;
        self.cancelButtonTitle = cancelBUttonTitle;
        self.sureButtonTitle = sureButtonTitle;
        self.date = date;        
        [self setUpUI];
        [self getDateInfo];
        
    }
    return self;
}
- (void) getDateInfo
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    self.comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour  |NSCalendarUnitMinute fromDate:self.date];
    
    NSArray *array = @[@(self.comps.year),
                       @(self.comps.month),
                       @(self.comps.day),
                       @(self.comps.hour),
                       @(self.comps.minute)];
    self.dateArray = [NSMutableArray arrayWithArray:array];
    
    
//    NSLog(@"年 = year = %ld",(long)_comps.year);
//    NSLog(@"月 = month = %ld",_comps.month);
//    NSLog(@"日 = day = %ld",_comps.day);
//    NSLog(@"时 = hour = %ld",_comps.hour);
//    NSLog(@"分 = minute = %ld",_comps.minute);
    [self upDateDate];
    
}
- (NSInteger)getNumberOfDaysInMonthWithDate:(NSString *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM";

    // 返回的格林治时间
    NSDate *date2 = [formatter dateFromString:date];
    
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date2];
    return range.length;
}

- (void)setUpUI{
    /**
     半透明背景
     */
    self.backGroundView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    self.backGroundView.backgroundColor = [UIColor blackColor];
    self.backGroundView.alpha = 0.4;
    [self addSubview:self.backGroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.backGroundView addGestureRecognizer:tap];
    /**
     *  时间选择器
     *
     */
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake((keyWindow.frame.size.width- ZPAlertView_Width)/2, keyWindow.frame.size.height, ZPAlertView_Width, 350)];
    self.alertView.layer.cornerRadius = 10;
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.clipsToBounds = YES;
    [self addSubview:self.alertView];
    
    /**
     *  标题
    */
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZPAlertView_Width, ZPAlert_TitleLabel_Height)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:titleLabel];
    /**
     *  时间
     */
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, ZPAlert_TitleLabel_Height, ZPAlertView_Width, ZPAlert_DateView_Height)];
    dateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    dateView.layer.borderWidth = 1;
    [self.alertView addSubview:dateView];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = ZPAlert_Date_Width;
    CGFloat height = ZPAlert_Date_Height;
    
    for (int i = 0; i <5 ; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(10+x, 10+y, width, height);
        view.backgroundColor = [UIColor redColor];
        view.tag = 1000+i;
        UIButton *addBUtton = [UIButton buttonWithType:UIButtonTypeSystem];
        addBUtton.backgroundColor = [UIColor grayColor];
        [addBUtton setTitle:@"+" forState:UIControlStateNormal];
        addBUtton.frame = CGRectMake(0, 0, view.bounds.size.width, 40);
        [addBUtton addTarget:self action:@selector(addNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addBUtton];
        UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reduceButton.backgroundColor = [UIColor grayColor];
        [reduceButton setTitle:@"-" forState:UIControlStateNormal];
        reduceButton.frame = CGRectMake(0, view.bounds.size.height-40, view.bounds.size.width, 40);
        [reduceButton addTarget:self action:@selector(reduceNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:reduceButton];
        
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, view.bounds.size.width, view.bounds.size.height-80)];
        textfield.tag = 2000+i;
        textfield.delegate = self;
        textfield.textAlignment = NSTextAlignmentCenter;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.textColor = [UIColor greenColor];
        [textfield addTarget:self action:@selector(textfieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [view addSubview:textfield];
        [dateView addSubview:view];
        if (i%3 == 2) {
            x = 40;
            y += height+10;
        }else{
            x += width+10;
        }
    }
    /**
     *  button
     */
    UIButton *cancelBUtton = [self createButtonWithFrame:CGRectMake(0, ZPAlert_TitleLabel_Height+ZPAlert_DateView_Height, ZPAlertView_Width/2, ZPAlert_Button_Height) Title:self.cancelButtonTitle];
    cancelBUtton.tag = 1;
    [self.alertView addSubview:cancelBUtton];
    UIButton *sureBUtton = [self createButtonWithFrame:CGRectMake(ZPAlertView_Width/2,ZPAlert_TitleLabel_Height+ZPAlert_DateView_Height, ZPAlertView_Width/2, ZPAlert_Button_Height) Title:self.sureButtonTitle];
    sureBUtton.tag = 2;
    [self.alertView addSubview:sureBUtton];
}

- (void)click:(UITapGestureRecognizer *)tap{
    CGPoint tapLocation = [tap locationInView:self.backGroundView];
    CGRect alertFrame = self.alertView.frame;
    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
        [self dismiss];
    }
}
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor blueColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}
- (void)addNumberAction:(UIButton *)button{
    if (button.superview.tag == 1000) {
        self.comps.year++;
        NSLog(@"新的一年%@",@(self.comps.year));
        [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
        [self upDateDate];
    }
    if (button.superview.tag == 1001) {
        self.comps.month++;
        if (self.comps.month > 12) {
            self.comps.month = 1;
            self.comps.year++;
            [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
        }
        NSLog(@"新的一月%@",@(self.comps.month));
        [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
        [self upDateDate];
        NSInteger newMaxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
        NSLog(@"newMaxDay = %@",@(newMaxDay));
        if (newMaxDay<self.comps.day) {
            self.comps.day = newMaxDay;
            [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        }
        [self upDateDate];
    }
    if (button.superview.tag == 1002) {
        NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
        self.comps.day++;
        NSLog(@"maxday = %@",@(maxDay));
        if (self.comps.day > maxDay) {
            self.comps.day = 1;
            self.comps.month++;
            if (self.comps.month > 12) {
                self.comps.month = 1;
                self.comps.year++;
                [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
            }
            [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
        }
        NSLog(@"新的一天%@",@(self.comps.day));
        [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        [self upDateDate];
    }
    if (button.superview.tag == 1003) {
        self.comps.hour++;
        if (self.comps.hour > 23) {
            self.comps.hour = 00;
            NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
            self.comps.day++;
            if (self.comps.day > maxDay) {
                self.comps.day = 1;
                self.comps.month++;
                if (self.comps.month > 12) {
                    self.comps.month = 1;
                    self.comps.year++;
                    [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
                }
                [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
            }

            [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        }
        NSLog(@"新的一小时%@",@(self.comps.hour));
        [self.dateArray replaceObjectAtIndex:3 withObject:@(self.comps.hour)];
        [self upDateDate];
    }
    if (button.superview.tag == 1004) {
        self.comps.minute++;
        if (self.comps.minute > 59) {
            self.comps.minute = 00;
            self.comps.hour++;
            if (self.comps.hour > 23) {
                self.comps.hour = 00;
                NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
                self.comps.day++;
                if (self.comps.day > maxDay) {
                    self.comps.day = 1;
                    self.comps.month++;
                    if (self.comps.month > 12) {
                        self.comps.month = 1;
                        self.comps.year++;
                        [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
                    }
                    [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
                }
                [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
            }
            [self.dateArray replaceObjectAtIndex:3 withObject:@(self.comps.hour)];
        }
        NSLog(@"新的一分钟%@",@(self.comps.minute));
        [self.dateArray replaceObjectAtIndex:4 withObject:@(self.comps.minute)];
        [self upDateDate];
    }
    
}
- (void)reduceNumberAction:(UIButton *)button{
    if (button.superview.tag == 1000) {
        self.comps.year--;
        NSLog(@"新的一年%@",@(self.comps.year));
        [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
        [self upDateDate];
    }
    if (button.superview.tag == 1001) {
        self.comps.month--;
        if (self.comps.month <1) {
            self.comps.month = 12;
            self.comps.year--;
            [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
        }
        NSLog(@"新的一月%@",@(self.comps.month));
        [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
        [self upDateDate];
        NSInteger newMaxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
        NSLog(@"newMaxDay = %@",@(newMaxDay));
        if (newMaxDay<self.comps.day) {
            self.comps.day = newMaxDay;
            [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        }
        [self upDateDate];
    }
    if (button.superview.tag == 1002) {
        NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
        self.comps.day--;
        NSLog(@"maxday = %@",@(maxDay));
        if (self.comps.day <1 ) {
            self.comps.day = maxDay;
            self.comps.month--;
            if (self.comps.month <1 ) {
                self.comps.month = 12;
                self.comps.year--;
                [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
            }
            [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
        }
        NSLog(@"新的一天%@",@(self.comps.day));
        [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        [self upDateDate];
    }
    if (button.superview.tag == 1003) {
        self.comps.hour--;
        if (self.comps.hour<00 ) {
            self.comps.hour = 23;
            NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
            self.comps.day--;
            if (self.comps.day < 1) {
                self.comps.day = maxDay;
                self.comps.month--;
                if (self.comps.month <1 ) {
                    self.comps.month = 12;
                    self.comps.year--;
                    [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
                }
                [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
            }
            
            [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
        }
        NSLog(@"新的一小时%@",@(self.comps.hour));
        [self.dateArray replaceObjectAtIndex:3 withObject:@(self.comps.hour)];
        [self upDateDate];
    }
    if (button.superview.tag == 1004) {
        self.comps.minute--;
        if (self.comps.minute < 00) {
            self.comps.minute = 59;
            self.comps.hour--;
            if (self.comps.hour < 00) {
                self.comps.hour = 23;
                NSInteger maxDay = [self getNumberOfDaysInMonthWithDate:[NSString stringWithFormat:@"%@-%@",@(self.comps.year),@(self.comps.month)]];
                self.comps.day--;
                if (self.comps.day <1 ) {
                    self.comps.day = maxDay;
                    self.comps.month--;
                    if (self.comps.month <1 ) {
                        self.comps.month = 12;
                        self.comps.year--;
                        [self.dateArray replaceObjectAtIndex:0 withObject:@(self.comps.year)];
                    }
                    [self.dateArray replaceObjectAtIndex:1 withObject:@(self.comps.month)];
                }
                [self.dateArray replaceObjectAtIndex:2 withObject:@(self.comps.day)];
            }
            [self.dateArray replaceObjectAtIndex:3 withObject:@(self.comps.hour)];
        }
        NSLog(@"新的一分钟%@",@(self.comps.minute));
        [self.dateArray replaceObjectAtIndex:4 withObject:@(self.comps.minute)];
        [self upDateDate];
    }

}
-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(button.tag -1)];
    }
    [self dismiss];
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:1 delay:0.2f usingSpringWithDamping:0.4f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alertView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismiss{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [UIView animateWithDuration:1 delay:0.2f usingSpringWithDamping:0.4f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
        self.alertView.frame = CGRectMake((keyWindow.frame.size.width- ZPAlertView_Width)/2, keyWindow.frame.size.height, ZPAlertView_Width, 250);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertView = nil;
    }];
}
- (void)upDateDate{
    for (int i = 0; i<self.dateArray.count; i++) {
        UITextField *textField = [self viewWithTag:2000+i];
        textField.text = [NSString stringWithFormat:@"%@",self.dateArray[i]];
    }
}
- (void)textfieldChanged:(UITextField*)textfield{
    switch (textfield.tag) {
        case 2000:
        {
            self.comps.year = [textfield.text integerValue];
        }
            break;
        case 2001:{
            self.comps.month = [textfield.text integerValue];
            break;
        }
        case 2002:{
            self.comps.day = [textfield.text integerValue];
            break;
        }
        case 2003:{
            self.comps.hour = [textfield.text integerValue];
            break;
        }
        case 2004:{
            self.comps.minute = [textfield.text integerValue];
            break;
        }
        default:
            break;
    }
    
}
@end
