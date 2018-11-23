//
//  ArchiveFamilySearchView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchTypeFamilyList = 0,
    SearchTypeDisease    = 1,
} SearchType;;

typedef void(^SearchBlock)(NSString *key);
typedef void(^QRBlock)(void);

@interface ArchiveFamilySearchView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic ,copy) SearchBlock searchBlock;
@property (nonatomic ,copy) QRBlock qrBlock;
@property (nonatomic ,assign) BOOL hasQR;
@property (nonatomic ,strong) NSString *placeholder;
@end
