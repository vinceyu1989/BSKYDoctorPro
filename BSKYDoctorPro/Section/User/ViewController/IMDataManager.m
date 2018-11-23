//
//  IMDataManager.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDataManager.h"
#import "BSFormsDicRequest.h"
#import "BSDictModel.h"

@implementation IMDataManager
static IMDataManager *_instance;

+ (IMDataManager *)dataManager{
    if (_instance == nil) {
        _instance = [[IMDataManager alloc] init];
    }
    
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initilationData];
    }
    return self;
}
- (void)dealloc
{
    _instance = nil;
}
- (void)initilationData{
//    [self getLabelOptionDic];
}
- (NSMutableDictionary *)IMSelectOptions{
    if (!_IMSelectOptions) {
        _IMSelectOptions = [[NSMutableDictionary alloc] init];
    }
    return _IMSelectOptions;
}
- (void)getLabelOptionDicBlock:(IMConfigSuccessBlock )block{
    BSFormsDicRequest *infoAllRequest = [[BSFormsDicRequest alloc]init];
    infoAllRequest.dictTypes = @[@"im_is_no",@"im_sex",@"im_crowd_tags"];
    Bsky_WeakSelf
    [infoAllRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        [self initSelectOptions:infoAllRequest.dictArray];
        if (block) {
            block();
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (void)initSelectOptions:(NSArray *)array{
    [self.IMSelectOptions removeAllObjects];
    for (BSDictModel *model in array) {
        [self.IMSelectOptions setObject:model.dictList forKey:model.type];
    }
}
@end
