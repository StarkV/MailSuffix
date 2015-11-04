//
//  ViewController.m
//  MailSuffix
//
//  Created by GSH on 15/11/4.
//  Copyright © 2015年 GSH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) IBOutlet UITextField *mailTextField;   //邮箱输入框
@property(nonatomic,strong) IBOutlet UILabel *suffixLbl;           //配合输入框显示的label
@property(nonatomic,strong) NSMutableArray *emailArray;        //需要做匹配的后缀
@property(nonatomic,strong) NSString *email;                   //完整的邮箱

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.emailArray = [NSMutableArray arrayWithObjects:@"@qq.com",@"@163.com",@"@126.com",@"@yahoo.com",@"@139.com",@"@henu.com", nil];
    self.email = [[ NSMutableString alloc]initWithCapacity:0];
    self.suffixLbl.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidEndEditing:(UITextField *)textField{             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    textField.text = self.email;
    self.suffixLbl.text = @"";
    NSLog(@"%@",self.email);
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
    
    //获取完整的输入文本
    NSString *completeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //以@符号分割文本
    NSArray *temailArray = [completeStr componentsSeparatedByString:@"@"];
    //获取邮箱前缀
    NSString *emailString = [temailArray firstObject];
    
    //邮箱匹配 没有输入@符号时 用@匹配
    NSString *matchString = @"@";
    if(temailArray.count > 1){
        //如果已经输入@符号 截取@符号以后的字符串作为匹配字符串
        matchString = [completeStr substringFromIndex:emailString.length];
    }
    //匹配邮箱 得到所有跟当前输入匹配的邮箱后缀
    NSMutableArray *suffixArray = [self checkEmailStr:matchString];
    
    //边界控制 如果没有跟当前输入匹配的后缀置为@""
    NSString *fixStr = suffixArray.count > 0 ? [suffixArray firstObject] : @"";
    //将lblEmail部分字段隐藏
    NSInteger cutLenth = suffixArray.count > 0 ? completeStr.length : emailString.length;
    
    //最终的邮箱地址
    self.email = fixStr.length > 0 ? [NSString stringWithFormat:@"%@%@",emailString,fixStr] : completeStr;
    //self.strEmail = [NSString stringWithFormat:@"%@%@",emailString,fixStr];
    
    //设置lblEmail 的attribute
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",emailString,fixStr]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,cutLenth)];
    self.suffixLbl.attributedText = attributeString;     
    
    //清空文本框内容时 隐藏lblEmail
    if(completeStr.length == 0){
        self.suffixLbl.text = @"";
        self.email = @"";
    }
    return YES;
}

- (NSMutableArray *)checkEmailStr:(NSString *)string{
    NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str in self.emailArray) {
        if([str hasPrefix:string]){
            [filterArray addObject:str];
        }
    }
    return filterArray;
}
- (IBAction)gestureTap:(UITapGestureRecognizer *)sender {
    [self.mailTextField resignFirstResponder];
}

@end
