//
//  NodePlanViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodePlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodePlanViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) NodePlanModel * nodePlanModel;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UIImageView * listImageBg;
@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel * nodeType;
@property (nonatomic, strong) UILabel * votesObtained;
@property (nonatomic, strong) UILabel * numberOfVotes;
@property (nonatomic, strong) UIView * moreOperations;

@property (nonatomic, copy) void (^invitationVoteClick)(void);
@property (nonatomic, copy) void (^votingRecordClick)(void);
@property (nonatomic, copy) void (^cancellationVotesClick)(void);

@end

NS_ASSUME_NONNULL_END
