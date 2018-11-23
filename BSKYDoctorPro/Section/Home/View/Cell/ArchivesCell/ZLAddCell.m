//
//  AddCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLAddCell.h"
#import "ZLAddSubCell.h"

@interface ZLAddCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;

@end

@implementation ZLAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
//    self.height = 100;
//    self.deleteBtn.hidden = YES;
//    self.deleteImageView.hidden = YES;
    self.contentView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.scrollEnabled = NO;
    self.contentTableView.userInteractionEnabled = NO;
    [self.contentTableView registerNib:[ZLAddSubCell nib] forCellReuseIdentifier:[ZLAddSubCell cellIdentifier]];
}
- (void)setModel:(BSArchiveModel *)model{
    _model = model;
//    [self.contentTableView layoutIfNeeded];
//    CGFloat height = self.contentTableView.contentSize.height;
    CGFloat addHeight = [_model.addModel.adds count] * 44;
    [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addHeight);
    }];
    [self.contentTableView reloadData];
}
- (void)layoutSubviews{
    CGFloat height = self.contentTableView.height;
    NSLog(@"height is ...%f",height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(delectAction:)]){
        [self.delegate delectAction:self];
    }
}
#pragma mark TableViewDelegate && Datasource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_model.addModel.adds count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    
    cell = [self.contentTableView dequeueReusableCellWithIdentifier:[ZLAddSubCell cellIdentifier] forIndexPath:indexPath];
    ZLAddSubCell *tableCell = (ZLAddSubCell *)cell;
    tableCell.model = model;
    return cell;
}
- (BSArchiveModel *)getArchiveModelWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *cellModel = nil;
    cellModel = [_model.addModel.adds objectAtIndex:indexPath.row];
    
    return cellModel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
@end
