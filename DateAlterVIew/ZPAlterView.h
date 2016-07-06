//
//  ZPAlterView.h
//  DateAlterVIew
//
//  Created by zp on 16/5/17.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZPAlterViewDelegate <NSObject>

- (void)didClickButtonAtIndex:(NSInteger)currentIndex;

@end

@interface ZPAlterView : UIView

@property (nonatomic, weak) id<ZPAlterViewDelegate> delegate;
@property (nonatomic, strong) NSDateComponents *comps;
- (instancetype)initWithTitle:(NSString *)title date:(NSDate *)date cancelButtonTitle:(NSString *)cancelBUttonTitle sureButtonTitle:(NSString *)sureButtonTitle;

- (void)showInView:(UIView *)view;

@end
