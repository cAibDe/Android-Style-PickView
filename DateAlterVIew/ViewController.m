//
//  ViewController.m
//  DateAlterVIew
//
//  Created by zp on 16/5/17.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "ViewController.h"
#import "ZPAlterView.h"
@interface ViewController ()<ZPAlterViewDelegate>
@property (nonatomic, strong) ZPAlterView *zpAlter;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSDate *date;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(id)sender {
    
    if (self.label.text.length == 0) {
        self.date = [NSDate date];
    }else{
        self.date = [self dateFromString:self.label.text];
    }
    self.zpAlter = [[ZPAlterView alloc]initWithTitle:@"日期选择器" date:self.date cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
    self.zpAlter.delegate = self;
    [self.zpAlter showInView:self.view];
}
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
- (void)didClickButtonAtIndex:(NSInteger)currentIndex{
    switch (currentIndex) {
        case 0:
            NSLog(@"Click Cancel");
       
            break;
        case 1:
            NSLog(@"Click OK");
            NSString *str = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",@(self.zpAlter.comps.year),@(self.zpAlter.comps.month),@(self.zpAlter.comps.day),@(self.zpAlter.comps.hour),@(self.zpAlter.comps.minute)];
            self.label.text = str;
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
