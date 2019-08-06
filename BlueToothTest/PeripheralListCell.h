//
//  PeripheralListCell.h
//  BlueToothTest
//
//  Created by LYY on 2019/8/5.
//  Copyright © 2019 LYY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PeripheralListCell : UITableViewCell
@property (nonatomic,strong) UILabel *peripheralNameLab;
@property (nonatomic,assign) BOOL isConnect;
@property (nonatomic,strong) UILabel *connectLab;
@end

NS_ASSUME_NONNULL_END
