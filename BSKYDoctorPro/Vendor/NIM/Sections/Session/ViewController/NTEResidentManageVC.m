//
//  NTEResidentManageVC.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NTEResidentManageVC.h"

@interface NTEResidentManageVC ()

@end

@implementation NTEResidentManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonColligationModel *infoModel = self.dataList[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(infoModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
