//
//  WalletManagementViewCell.h
//  bupocket
//
//  Created by huoss on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletManagementViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UILabel * walletName;
@property (nonatomic, strong) UILabel * walletAddress;
@property (nonatomic, strong) UIButton * currentUse;
@property (nonatomic, strong) UIButton * manage;
@property (nonatomic, strong) UIImageView * detailImage;

@property (nonatomic, copy) void (^manageClick)(void);

@property (nonatomic, strong) WalletModel * walletModel;

@end

NS_ASSUME_NONNULL_END
