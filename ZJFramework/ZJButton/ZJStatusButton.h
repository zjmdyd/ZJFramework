//
//  ZJStatusButton.h
//  PhysicalDate
//
//  Created by ZJ on 3/21/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EventStatus) {
    EventStatusOfrequest,   // 申请
    EventStatusOfUnFinish,  // 未完成
    EventStatusOfFinish,    // 已完成
    EventStatusOfReject,    // 已拒绝
    EventStatusOfOverdue,   // 已过期
};

/**
 *  无背景色 无事件的button
 */
@interface ZJStatusButton : UIButton

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) EventStatus status;

@end
