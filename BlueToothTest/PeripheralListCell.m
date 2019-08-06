//
//  PeripheralListCell.m
//  BlueToothTest
//
//  Created by LYY on 2019/8/5.
//  Copyright © 2019 LYY. All rights reserved.
//

#import "PeripheralListCell.h"

@implementation PeripheralListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.peripheralNameLab.frame = CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width/2, 44);
    self.connectLab.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-12, 0, [UIScreen mainScreen].bounds.size.width/2-24, 44);
    
}
- (void)setIsConnect:(BOOL)isConnect{
    _isConnect = isConnect;
    if (isConnect) {
        self.connectLab.text = @"已连接";
        self.connectLab.textColor = [UIColor greenColor];
    }else{
        self.connectLab.text = @"点击连接";
        self.connectLab.textColor = [UIColor redColor];
    }
}
- (UILabel *)peripheralNameLab{
    if (!_peripheralNameLab) {
        _peripheralNameLab = [[UILabel alloc] init];
        _peripheralNameLab.textColor = [UIColor grayColor];
        _peripheralNameLab.font = [UIFont systemFontOfSize:14];
        _peripheralNameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_peripheralNameLab];
    }
    return _peripheralNameLab;
}
- (UILabel *)connectLab{
    if (!_connectLab) {
        _connectLab = [[UILabel alloc] init];
        _connectLab.font = [UIFont systemFontOfSize:14];
        _connectLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_connectLab];
    }
    return _connectLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
