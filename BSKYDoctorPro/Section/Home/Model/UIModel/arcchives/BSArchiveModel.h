//
//  BSArchiveModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ArchiveModelTypeDatePicker = 0,             //时间选择器
    ArchiveModelTypeCustomPicker = 1,           //自定义选择器（选项自定义）
    ArchiveModelTypeTextField = 2,              //文本输入条（textField）
    ArchiveModelTypeSelect = 3,                 //选择卡
    ArchiveModelTypeLabel = 4,                  //文本
    ArchiveModelTypeTextView = 5,               //文本输入框(textView)
    ArchiveModelTypeSlectAndTextView = 6,       //带有文本输入框的选项卡
    ArchiveModelTypeSlectOnLine = 7,            //选项卡（title与选项在一条线上不换行）
    ArchiveModelTypeAddCell = 8,                //用于跳转到新界面的cell              /*
    ArchiveModelTypeAddSection = 9,             //用于跳转的到新界面的section            这几项用于既往史的界面转化
    ArchiveModelTypeAddSubCell = 10,            //用于添加的cell是tableview的类型      */
    ArchiveModelTypeImagePicker = 11,           //图像选择器（会跳转相册与相机，图片已做压缩,目前上限为200K）
    ArchiveModelTypeControllerPicker = 12,      //界面跳转选择器，选项需要跳转新的界面控制器
    ArchiveModelTypeTextFieldWithUnit = 13,     //有单位的文本输入条
    ArchiveModelTypeCustomOptionsPicker = 14,   //用于多选的自定义选择器
    ArchiveModelTypeCanEditSelect = 15,         //可编辑的选项卡
} ArchiveModelType;

@class ArchivePickerModel;
@class ArchiveSelectModel;
@class ArchiveLimitModel;
@class ArchiveSelectOptionModel;
@class ArchiveAddModel;

@interface BSArchiveModel : NSObject
@property (nonatomic ,copy) NSString *title;                    //表单的名称
@property (nonatomic ,copy) NSString *code;                     //表单code(唯一标示，用于映射数据模型中的值)
@property (nonatomic ,copy) NSString *sourceCode;               //对应数据字典名字
@property (nonatomic ,copy) NSString *value;                    //对应的值
@property (nonatomic ,copy) NSString *descripe;                 //描述补充
@property (nonatomic ,assign) ArchiveModelType type;            //表单类型
@property (nonatomic ,copy) NSString *placeholder;              //占位值
@property (nonatomic ,copy) NSString *contentStr;               //对应值的描述
@property (nonatomic ,copy) NSString *unit;                     //单位
@property (nonatomic ,copy) NSString *upModelName;              //所属类的名称（适用于交叉映射数据模型）
@property (nonatomic ,assign) BOOL  isRequired;                 //是否必填
@property (nonatomic ,assign) BOOL  canEdit;                    //是否可编辑
@property (nonatomic ,assign) NSUInteger keybordType;           //键盘类型
@property (nonatomic ,strong) ArchiveAddModel *addModel;        //下级表单
@property (nonatomic ,strong) ArchivePickerModel *pickerModel;  //自定义选择器模型（picker）
@property (nonatomic ,strong) ArchiveSelectModel *selectModel;  //选择器模型 （select）
@property (nonatomic ,strong) ArchiveLimitModel *limit;         //限制模型 （limit）这个暂没构思好
@property (nonatomic ,copy) NSArray *pickerModels;              //多项picker选择器模型（尚不完善）
@property (nonatomic ,strong) id object; //?                    //应急对象
@end

@interface ArchivePickerModel : NSObject
@property (nonatomic ,strong) NSArray *options;         //选项数组
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,strong) id selectOption;
@end

@interface ArchiveLimitModel : NSObject
@end

@interface ArchiveSelectModel : NSObject
@property (nonatomic ,assign) BOOL multiple;            //是否是多选
@property (nonatomic ,assign) NSUInteger selectNum;     //选项上线
@property (nonatomic ,strong) NSArray *options;         //选项数组
@property (nonatomic ,copy) NSString *value;            //选项的值（椐实际情况而定，jw的用的是所有选项值相加，zl在单选是选项的value，多选时用到的是selectArray）
@property (nonatomic ,strong) NSArray *others;           //其他选项的值（适用于不来自于自带的选项里的值，如zl中的点击其他跳转其他选项界面进行选择）
@property (nonatomic ,strong) NSArray *selectArray;     //所选择的选项（目前仅用于中年）
@end

@interface ArchiveAddModel : NSObject
@property (nonatomic ,strong) NSArray *adds;            //下级内容表单
@property (nonatomic ,assign) NSUInteger index;         //下标（计委独有，标记其对应在数组中的位置）
@end

@interface ArchiveSelectOptionModel : NSObject
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,copy) NSString *lebel;
@property (nonatomic ,copy) NSString *dictId;
@property (nonatomic ,copy) NSString *standardCode;
@end

@interface ArchiveModel : NSObject
@property (nonatomic ,copy) NSString *contentStr;       //描述
@property (nonatomic ,copy) NSString *code;             //code(唯一标示与UI对象对应）
@property (nonatomic ,strong) NSArray *content;         //表单模型数组
@end
