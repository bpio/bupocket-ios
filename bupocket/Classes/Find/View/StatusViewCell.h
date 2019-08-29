//
//  StatusViewCell.h
//  bupocket
//
//  Created by huoss on 2019/8/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusUpdateModel.h"

typedef NS_ENUM(NSInteger, StatusCellType) {
    StatusCellTypeDefault,
    StatusCellTypeNormal,
    StatusCellTypeTop,
    StatusCellTypeBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface StatusViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier cellType:(StatusCellType)cellType;

@property (nonatomic, strong) UILabel * date;
@property (nonatomic, strong) UIButton * spot;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, assign) StatusCellType cellType;
@property (nonatomic, strong) StatusUpdateModel * statusUpdateModel;

@end

NS_ASSUME_NONNULL_END
