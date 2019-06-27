//
//  NodeSettingsViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/19.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "NodeSettingsViewController.h"
#import "ListTableViewCell.h"
#import "BottomAlertView.h"
#import "ModifyAlertView.h"

@interface NodeSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * currentNodeURLKey;
@property (nonatomic, strong) NSString * nodeURLArrayKey;

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
    self.navigationItem.title = Localized(@"NodeSettings");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
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
    [self setupView];
    // Do any additional setup after loading the view.
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
    [self showNodeSettingsAlertWithModifyType:ModifyTypeNodeAdd index:0];
}
- (void)showNodeSettingsAlertWithModifyType:(ModifyType)modifyType index:(NSInteger)index
{
    NSString * title = Localized(@"AddNodePrompt");
    NSString * placeholder = title;
    if (modifyType == ModifyTypeNodeEdit) {
        title = Localized(@"EditNodePrompt");
        placeholder = self.listArray[index];
    }
    ModifyAlertView * alertView = [[ModifyAlertView alloc] initWithTitle:title placeholder:placeholder modifyType:modifyType confrimBolck:^(NSString * _Nonnull text) {
        if ([self.listArray containsObject:text]) {
            if ([self.listArray indexOfObject:text] != index || modifyType == ModifyTypeNodeAdd) {
                [Encapsulation showAlertControllerWithErrorMessage:Localized(@"NodeDuplication") handler:nil];
            }
            return;
        }
        [self getDataWithURL:text modifyType:modifyType index:index];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)getDataWithURL:(NSString *)URL modifyType:(ModifyType)modifyType index:(NSInteger)index
{
    [[HTTPManager shareManager] getNodeDataWithURL:[NSString stringWithFormat:@"%@%@", URL, Node_Check] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            if (modifyType == ModifyTypeNodeAdd) {
                [self.listArray addObject:URL];
            } else if (modifyType == ModifyTypeNodeEdit) {
                [self.listArray replaceObjectAtIndex:index withObject:URL];
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.listArray forKey:self.nodeURLArrayKey];
            [self.tableView reloadData];
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
    cell.detail.tag = indexPath.row;
    cell.title.text = self.listArray[indexPath.row];
    cell.listImage.image = [UIImage imageNamed:@"checked"];
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(55));
    if (indexPath.row == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    } else if (indexPath.row == self.listArray.count - 1) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
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
                [self showNodeSettingsAlertWithModifyType:ModifyTypeNodeEdit index:button.tag];
            } else if ([btn.titleLabel.text isEqualToString:titleArray[1]]) {
                NSString * message = @"";
                if (self.index == button.tag) {
                    self.index = 0;
                    [self setNodeURLWithIndex:self.index];
                    message = Localized(@"DeleteCurrentNode");
                }
                [Encapsulation showAlertControllerWithTitle:Localized(@"ConfirmDeleteNode") message:message cancelHandler:^(UIAlertAction *action) {
                } confirmHandler:^(UIAlertAction *action) {
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
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
}
- (void)setNodeURLWithIndex:(NSInteger)index
{
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    ListTableViewCell * lastcell = [self.tableView cellForRowAtIndexPath:lastIndex];
    lastcell.detail.hidden = YES;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ListTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detail.hidden = NO;
    _index = index;
    [[HTTPManager shareManager] SwitchedNodeWithURL:self.listArray[indexPath.row]];
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
