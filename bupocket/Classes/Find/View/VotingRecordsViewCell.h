//
//  VotingRecordsViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/3/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VotingRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VotingRecordsViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) VotingRecordsModel * votingRecordsModel;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UIButton * recordType;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * nodeType;
@property (nonatomic, strong) UILabel * number;
@property (nonatomic, strong) UILabel * state;
@property (nonatomic, strong) UILabel * date;

@end

NS_ASSUME_NONNULL_END
