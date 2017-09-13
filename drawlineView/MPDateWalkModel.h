//
//  MPDateWalkModel.h
//  tenMS
//
//  Created by plum on 17/7/6.
//  Copyright © 2017年 plum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MPDateWalkModel : NSObject <NSCoding>
@property(assign,nonatomic)CGFloat  steps;
@property(strong,nonatomic)NSString  *date;

@end
