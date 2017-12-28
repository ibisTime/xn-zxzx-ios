//
//  IdAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdAuthVC.h"

#import "NSString+Check.h"

#import "IdentifierAuthView.h"
#import "TLImagePicker.h"

#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"
#import "TLProgressHUD.h"
#import "APICodeMacro.h"

@interface IdAuthVC ()

@property (nonatomic, strong) IdentifierAuthView *identifierView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, assign) IdentifierAuthType type;          //照片类型

@property (nonatomic, copy) NSString *positivePic;              //正面照

@property (nonatomic, copy) NSString *otherSidePic;             //反面照

@property (nonatomic, copy) NSString *handheldPic;              //手持照

@end

@implementation IdAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    
    [self initIdentifierView];
}

#pragma mark - Init
- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.imageType = ImageTypeCamera;
        _imagePicker.clipHeight = (200/345.0)*kScreenWidth;
        _imagePicker.allowsEditing = NO;
        
    }
    return _imagePicker;
}

- (void)initIdentifierView {
    
    BaseWeakSelf;
    
    self.identifierView = [[IdentifierAuthView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.identifierView.identifierBlock = ^(IdentifierAuthType type) {
        
        if (type == IdentifierAuthTypeCommit) {
            
            [weakSelf commitIdentifier];
            
        }else {
            
            weakSelf.type = type;
            
            [weakSelf commitIDCard];
            
        }
        
    };
    
    [self.view addSubview:self.identifierView];
    
}

- (void)commitIdentifier {
    
    if (![self.positivePic valid]) {
        
        [TLAlert alertWithInfo:@"请上传身份证正面照"];
        return ;
    }
    
    if (![self.otherSidePic valid]) {
        
        [TLAlert alertWithInfo:@"请上传身份证反面照"];
        return ;
    }
    
    if (![self.handheldPic valid]) {
        
        [TLAlert alertWithInfo:@"请上传手持身份证照"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805254";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"identifyPic"] = self.positivePic;
    http.parameters[@"identifyPicReverse"] = self.otherSidePic;
    http.parameters[@"identifyPicHand"] = self.handheldPic;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"身份认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pushViewController];

        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - Events
- (void)commitIDCard {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            [TLProgressHUD showWithStatus:@""];
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone2];
                    
                }]];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                //                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                UIImage *image = photo;
                
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    //设置头像
                    UIImageView *imgView = [weakSelf.identifierView viewWithTag:1390 + self.type];
                    
                    imgView.image = image;
                    
                    [TLProgressHUD dismiss];
                    
                    switch (weakSelf.type) {
                        case IdentifierAuthTypeIDCardPositive:
                        {
                            weakSelf.positivePic = key;
                            
                        }break;
                            
                        case IdentifierAuthTypeIDCardOtherSide:
                        {
                            weakSelf.otherSidePic = key;
                            
                        }break;
                            
                        case IdentifierAuthTypeIDCardHandheld:
                        {
                            weakSelf.handheldPic = key;
                            
                        }break;
                            
                        default:
                            break;
                    }
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
