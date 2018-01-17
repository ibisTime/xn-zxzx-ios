//
//  PedestrianBaseVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianBaseVC.h"

#import "UIBarButtonItem+convience.h"

#import "TLAlert.h"
#import <TFHpple.h>
#import "NSString+Check.h"

@interface PedestrianBaseVC ()

@end

@implementation PedestrianBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBackItem];
}

#pragma mark -  Init
- (void)initBackItem {
    
    UIButton *btn = [UIButton buttonWithImageName:@"返回-白色"];
    
    btn.frame = CGRectMake(-10, 0, 40, 44);
    
    btn.contentMode = UIViewContentModeScaleToFill;
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:btn.bounds];
    [customView addSubview:btn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customView];
}

#pragma mark - Events
- (void)clickBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)systemErrorWithBlock:(SystemErrorBlock)block encoding:(NSString *)encoding responseObject:(id)responseObject {
    //如果返回的内容有class='error'就报系统繁忙
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    NSArray *errorArr = [hpple searchWithXPathQuery:@"//div[@class='error']"];
    
    if (errorArr.count > 0) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        
        if (block) {
            
            block();
        }
    }
    
    //如果返回的内容是HTML格式再进行判断
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];

    if (![htmlStr containsString:@"DOCTYPE html"]) {
        
        return ;
    }
    //如果返回的内容没有title元素就报系统繁忙
    NSArray *titleArr = [hpple searchWithXPathQuery:@"//title"];
    NSString *title = @"";
    
    for (TFHppleElement *element in titleArr) {
        
        title = element.content;
    }
    
    if (![title valid]) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        
        if (block) {
            
            block();
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
