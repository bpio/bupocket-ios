//
//  NodeSettingsViewController.m
//  bupocket
//
//  Created by bupocket on 2019/6/19.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "NodeSettingsViewController.h"
#import "ListTableViewCell.h"
#import "BottomAlertView.h"
#import "TextInputAlertView.h"

@interface NodeSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * currentNodeURLKey;
@property (nonatomic, strong) NSString * nodeURLArrayKey;
@property (nonatomic, assign) BOOL ifSetting;
@property (nonatomic, strong) NSString * seq;
@property (nonatomic, strong) NSString * defaultSeq;

@end

@implementation NodeSettingsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * title = ([defaults boolForKey:If_Switch_TestNetwork]) ? [NSString stringWithFormat:@"%@（%@）", Localized(@"NodeSettings"), Localized(@"TestNetworkPrompt")] : Localized(@"NodeSettings");
    self.navigationItem.title = title;
    if ([defaults boolForKey:If_Switch_TestNetwork]) {
            self.nodeURLArrayKey = Node_URL_Array_Test;
            self.currentNodeURLKey = Current_Node_URL_Test;
    } else {
        self.nodeURLArrayKey = Node_URL_Array;
        self.currentNodeURLKey = Current_Node_URL;
    }
    self.listArray = [NSMutableArray arrayWithArray:[defaults objectForKey:self.nodeURLArrayKey]];
    self.index = [self.listArray indexOfObject:[defaults objectForKey:self.currentNodeURLKey]];
    if (self.index == NSNotFound) {
        self.index = 0;
    }
    [self setupNav];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * save = [UIButton createButtonWithTitle:Localized(@"Save") TextFont:FONT_NAV_TITLE TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(saveAcrion)];
    save.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    save.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:save];
}
- (void)saveAcrion
{
    if (self.ifSetting == YES) {
        if (self.index == 0) {
            [[HTTPManager shareManager] SwitchedNodeWithURL:self.listArray[self.index]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
            return;
        }
        [self CheckDefaultURLWithCustomURL:self.listArray[self.index] modifyType:InputTypeNodeEdit index:self.index isChoice:YES];
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - ScreenScale(60)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    CustomButton * addNodesBtn = [[CustomButton alloc] init];
    [addNodesBtn setTitle:Localized(@"AddCustomNodes") forState:UIControlStateNormal];
    [addNodesBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [addNodesBtn setImage:[UIImage imageNamed:@"import"] forState:UIControlStateNormal];
    [self.view addSubview:addNodesBtn];
    addNodesBtn.backgroundColor = [UIColor whiteColor];
    [addNodesBtn addTarget:self action:@selector(addNodesAction) forControlEvents:UIControlEventTouchUpInside];
    [addNodesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScreenScale(60));
    }];
}
- (void)addNodesAction
{
    if (self.listArray.count >= 10) {
        return;
    }
    [self showNodeSettingsAlertWithModifyType:InputTypeNodeAdd index:0];
}
- (void)showNodeSettingsAlertWithModifyType:(InputType)modifyType index:(NSInteger)index
{
    TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:modifyType confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
        if (modifyType == InputTypeNodeEdit && [text isEqualToString:self.listArray[index]]) {
            return;
        }
        if ([self.listArray containsObject:text]) {
            if ([self.listArray indexOfObject:text] != index || modifyType == InputTypeNodeAdd) {
                [Encapsulation showAlertControllerWithErrorMessage:Localized(@"NodeDuplication") handler:nil];
            }
            return;
        }
        [self CheckDefaultURLWithCustomURL:text modifyType:modifyType index:index isChoice:NO];
    } cancelBlock:^{
        
    }];
    if (modifyType == InputTypeNodeEdit) {
        alertView.textField.text = self.listArray[index];
        [alertView.textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)CheckDefaultURLWithCustomURL:(NSString *)URL modifyType:(InputType)modifyType index:(NSInteger)index isChoice:(BOOL)isChoice
{
    [[HTTPManager shareManager] getNodeDataWithURL:[NSString stringWithFormat:@"%@%@", [self.listArray firstObject], Node_Check] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"error_code"] integerValue];
        if (code == Success_Code) {
            self.seq = responseObject[@"result"][@"header"][@"seq"];
            [self CheckWithURL:URL modifyType:modifyType index:index isChoice:isChoice];
        } else {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
        }
    } failure:^(NSError *error) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
    }];
}
- (void)CheckWithURL:(NSString *)URL modifyType:(InputType)modifyType index:(NSInteger)index isChoice:(BOOL)isChoice
{
    [[HTTPManager shareManager] getNodeDataWithURL:[NSString stringWithFormat:@"%@%@", URL, Node_Check] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"error_code"] integerValue];
        if (code == Success_Code) {
            self.defaultSeq = responseObject[@"result"][@"header"][@"seq"];
            if (llabs([self.seq longLongValue] - [self.defaultSeq longLongValue]) <= Seq_Subtract_Max) {
                if (isChoice) {
                    [[HTTPManager shareManager] SwitchedNodeWithURL:self.listArray[self.index]];
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
                } else {
                    if (modifyType == InputTypeNodeAdd) {
                        [self.listArray addObject:URL];
                    } else if (modifyType == InputTypeNodeEdit) {
                        [self.listArray replaceObjectAtIndex:index withObject:URL];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:self.listArray forKey:self.nodeURLArrayKey];
                    [self.tableView reloadData];
                }
            } else {
                [Encapsulation showAlertControllerWithTitle:Localized(@"PromptTitle") message:Localized(@"NodeUrlError") confirmHandler:^ {
                    
                }];
            }
        } else {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
        }
    } failure:^(NSError *error) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(55);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.detail setImage:[UIImage imageNamed:@"node_settings_more"] forState:UIControlStateNormal];
    [cell.detail addTarget:self action:@selector(moreAcrion:) forControlEvents:UIControlEventTouchUpInside];
    cell.detail.userInteractionEnabled = YES;
    cell.detail.tag = indexPath.row;
    cell.title.text = self.listArray[indexPath.row];
    [cell.listImage setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    cell.lineView.hidden = (indexPath.row == self.listArray.count - 1);
    cell.detail.hidden = (indexPath.row == 0);
    cell.listImage.hidden = (_index != indexPath.row);
    return cell;
}
- (void)moreAcrion:(UIButton *)button
{
    NSArray * titleArray = @[Localized(@"Edit"), Localized(@"Delete")];
    BottomAlertView * alertView = [[BottomAlertView alloc] initWithHandlerArray:titleArray handlerType:HandlerTypeNodeSettings handlerClick:^(UIButton * _Nonnull btn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([btn.titleLabel.text isEqualToString:titleArray[0]]) {
                [self showNodeSettingsAlertWithModifyType:InputTypeNodeEdit index:button.tag];
            } else if ([btn.titleLabel.text isEqualToString:titleArray[1]]) {
                NSString * message = (self.index == button.tag) ? Localized(@"DeleteCurrentNode") : @"";
                [Encapsulation showAlertControllerWithTitle:Localized(@"ConfirmDeleteNode") message:message confirmHandler:^{
                    if (self.index == button.tag) {
                        [self setNodeURLWithIndex:0];
                        [self saveAcrion];
                    }
                    [self.listArray removeObjectAtIndex:button.tag];
                    [[NSUserDefaults standardUserDefaults] setObject:self.listArray forKey:self.nodeURLArrayKey];
                    [self.tableView reloadData];
                    
                }];
            }
        });
    } cancleClick:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setNodeURLWithIndex:indexPath.row];
}
- (void)setNodeURLWithIndex:(NSInteger)index
{
    if (index == self.index) return;
    self.ifSetting = (index != self.index);
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    ListTableViewCell * lastcell = [self.tableView cellForRowAtIndexPath:lastIndex];
    lastcell.listImage.hidden = YES;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ListTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.listImage.hidden = NO;
    _index = index;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
