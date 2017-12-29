//
//  MineHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    
    MineHeaderSeletedTypeDefault = 0,   //用户资料
    MineHeaderSeletedTypeSelectPhoto,   //拍照
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) UIImageView *userPhoto;

@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;

@end
