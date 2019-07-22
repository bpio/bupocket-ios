//
//  AddressBookListViewCell.h
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

//@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UILabel * addressName;
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UILabel * describe;
//@property (nonatomic, strong) UIImageView * detailImage;

@property (nonatomic, strong) AddressBookModel * addressBookModel;

@end

NS_ASSUME_NONNULL_END
