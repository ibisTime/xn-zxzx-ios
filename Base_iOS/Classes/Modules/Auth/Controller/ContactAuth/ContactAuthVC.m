//
//  ContactAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ContactAuthVC.h"

#import "ContactManager.h"
#import "ContactModel.h"
#import "HTMLStrVC.h"

#import "UIButton+EnLargeEdge.h"
#import "UILabel+Extension.h"

#import "TLAuthHelper.h"

#import <Contacts/Contacts.h>
#import "NSString+Check.h"

@interface ContactAuthVC ()

@property (nonatomic, strong) NSMutableArray<ContactModel *> *dataSourceArray; //!< 数据源.

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation ContactAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录认证";
    
    [self initSubview];

}

#pragma mark - Init
- (void)initSubview {
    
    self.title = @"通讯录认证";
    
    self.dataSourceArray = [NSMutableArray array];
    
    self.contacts = [NSMutableArray array];
    
    //顶部视图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    topView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:topView];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"通讯录")];
    
    CGFloat iconH = 82;
    
    iconIV.frame = CGRectMake(0, (topView.height - iconH)/2.0, 120, 82);
    
    iconIV.centerX = kScreenWidth/2.0;
    
    [topView addSubview:iconIV];
    
    //借款协议
    UIButton *selectBtn = [UIButton buttonWithImageName:@"同意" selectedImageName:@"未同意"];
    
    selectBtn.tag = 1250;
    
    selectBtn.frame = CGRectMake(15, topView.yy + 15, 14, 14);
    
    [selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:selectBtn];
    
    UILabel *agreeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    agreeLbl.text = @"我同意";
    
    agreeLbl.frame = CGRectMake(selectBtn.xx + 7, selectBtn.y, 40, 12);
    
    [self.view addSubview:agreeLbl];
    
    UIButton *authProtocolBtn = [UIButton buttonWithTitle:@"《通讯录授权协议》" titleColor:[UIColor colorWithHexString:@"#4385b3"] backgroundColor:kClearColor titleFont:12];
    
    [authProtocolBtn setEnlargeEdge:10];
    
    [authProtocolBtn addTarget:self action:@selector(clickAuthProtocol) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:authProtocolBtn];
    [authProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(agreeLbl.xx);
        make.top.mas_equalTo(agreeLbl.y);
        
    }];
    
        UIButton *infoRuleBtn = [UIButton buttonWithTitle:@"《信息收集及使用规则》" titleColor:[UIColor colorWithHexString:@"#4385b3"] backgroundColor:kClearColor titleFont:12];
    
        [infoRuleBtn setEnlargeEdge:10];
    
        [infoRuleBtn addTarget:self action:@selector(clickInfoRule) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:infoRuleBtn];
        [infoRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(12);
            make.left.mas_equalTo(authProtocolBtn.mas_right).mas_equalTo(0);
            make.top.mas_equalTo(agreeLbl.y);
    
        }];
    
    CGFloat leftMargin = 15;
    
    UIButton *authBtn = [UIButton buttonWithTitle:@"立即认证" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15 cornerRadius:22.5];
    
    authBtn.frame = CGRectMake(leftMargin, selectBtn.yy + 17, kScreenWidth - leftMargin*2, 45);
    
    [authBtn addTarget:self action:@selector(getContactList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:authBtn];
    //温馨提示
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13.0];
    
    promptLbl.backgroundColor = kClearColor;
    
    promptLbl.numberOfLines = 0;
    
    promptLbl.frame = CGRectMake(leftMargin, authBtn.yy + 20, kScreenWidth - 2*leftMargin, 100);
    
    [promptLbl labelWithTextString:@"温馨提示\n1.请使用您本人的手机授权。\n2.提供通讯录信息，有助于您通过认证。\n3.我们将严格遵守协议，保护用户隐私。" lineSpace:10];
    
    [self.view addSubview:promptLbl];
    
}

#pragma mark - Data
- (void)getContact {
    
    [[ContactManager getInstance] getAddressBookWithSort:SortByFirstName completionBlock:^(int code, NSArray<ContactModel *> *personArray, NSString *msg) {
        
        if (code == 1) {
            
            [_dataSourceArray removeAllObjects];
            [_dataSourceArray addObjectsFromArray:personArray];
            
            NSLog(@"arrayCount = %ld", _dataSourceArray.count);
            
            [self requestContactAuth];
            
        } else if (code == -1) {
            
            NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
            
            NSString *displayName = [infoDict objectForKey:@"CFBundleDisplayName"];
            
            NSString *promptStr = [NSString stringWithFormat:@"通讯录未授权，请前往“设置->%@->通讯录“中开启通讯录", displayName];
            
            [TLAlert alertWithTitle:@"提示" msg:promptStr confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [TLAuthHelper openSetting];
            }];
        }
        
    }];
}

#pragma mark - Events
- (void)getContactList {
    
    UIButton *btn = [self.view viewWithTag:1250];
    
    if (btn.selected) {
        
        [TLAlert alertWithInfo:@"同意《通讯录授权协议》和《信息收集及使用规则》才能授权"];
        return ;
    }
    
    [self getContact];
}

- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (void)clickAuthProtocol {
    
    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeAuthProtocol;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)clickInfoRule {
    
    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeInfoRule;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)requestContactAuth {
    
    for (ContactModel *contact in self.dataSourceArray) {
        
        NSDictionary *dic = [NSDictionary dictionary];
        
        NSString *name = @"";
        
        //姓名不存在就传公司名
        if (contact.firstName == nil && contact.lastName == nil) {
            
            name = contact.organization == nil ? @"无": contact.organization;
            
        } else {
            
            NSString *firstName = contact.firstName == nil ? @"": contact.firstName;
            
            NSString *lastName = contact.lastName == nil ? @"": contact.lastName;
            
            name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            
            if (![name valid]) {
                
                continue ;
            }
        }
        
        NSString *mobile = @"无";
        
        if (contact.phones.count > 0) {
            
            LabelStringModel *stringModel = contact.phones[0];
            
            mobile = stringModel.content;
            //如果mobile为空就跳过本次循环
            if (![mobile valid]) {
                
                continue ;
            }
        }
        
        dic = @{@"name": name,
                @"mobile": mobile,
                };
        
        [self.contacts addObject:dic];
        
    }
    
    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.showView = self.view;
    
    http.code = @"805257";
    http.parameters[@"addressBookList"] = self.contacts;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"通讯录认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pushViewController];
            
        });
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getContactAfteriOS9 {
    
    if (![TLAuthHelper isEnableContact]) {
        
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        
        NSString *displayName = [infoDict objectForKey:@"CFBundleDisplayName"];
        
        NSString *promptStr = [NSString stringWithFormat:@"通讯录未授权，请前往“设置->%@->通讯录“中开启通讯录", displayName];
        
        [TLAlert alertWithTitle:@"提示" msg:promptStr confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [TLAuthHelper openSetting];
        }];
    }
    
    // 3.创建通信录对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    // 4.创建获取通信录的请求对象
    // 4.1.拿到所有打算获取的属性对应的key
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4.2.创建CNContactFetchRequest对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    // 5.遍历所有的联系人
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // 1.获取联系人的姓名
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        NSLog(@"%@ %@", lastname, firstname);
        
        // 2.获取联系人的电话号码
        NSArray *phoneNums = contact.phoneNumbers;
        for (CNLabeledValue *labeledValue in phoneNums) {
            // 2.1.获取电话号码的KEY
            NSString *phoneLabel = labeledValue.label;
            
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
            NSLog(@"%@ %@", phoneLabel, phoneValue);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
