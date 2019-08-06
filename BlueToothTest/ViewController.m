//
//  ViewController.m
//  BlueToothTest
//
//  Created by LYY on 2019/8/5.
//  Copyright © 2019 LYY. All rights reserved.
//

#import "ViewController.h"
#import "PeripheralListCell.h"
#import "LoadingView.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController ()<CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate>
@property (nonatomic,strong) CBCentralManager *centralManager;//蓝牙管理器
@property (nonatomic,strong) NSMutableArray *resourceArray;//设备列表
@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) CBPeripheral *peripheral;//当前选择的设备
@property (nonatomic,strong) CBCharacteristic *characteristic;//需要的服务特征值
@property (nonatomic,strong) LoadingView *loadingView;//加载状态
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[PeripheralListCell class] forCellReuseIdentifier:@"PeripheralListCell"];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.centralManager) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)resourceArray{
    if (!_resourceArray) {
        _resourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _resourceArray;
}
- (LoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] init];
    }
    return _loadingView;
}
#pragma mark ---CBCentralManagerDelegate
/**
 蓝牙状态
 * -- CBCentralManagerStateUnknown 未知状态 初始化时
 * -- CBCentralManagerStateResetting 正在重置状态
 * -- CBCentralManagerStateUnsupported 设备不支持状态
 * -- CBCentralManagerStateUnauthorized 设备未授权状态
 * -- CBCentralManagerStatePoweredOff 设备关闭状态
 * -- CBCentralManagerStatePoweredOn 设备开启状态 (调用搜索方法)
 @param central centralManagerDidUpdateState
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"蓝牙状态--未知");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"蓝牙状态--正在重置");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"蓝牙状态--设备不支持");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"蓝牙状态--设备未授权");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙状态--设备关闭");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙状态--设备开启搜索蓝牙");
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}

/**
 搜索蓝牙设备
 
 @param central 中心管理者
 @param peripheral 设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    //插入蓝牙设备
    if (![self.resourceArray containsObject:peripheral] && peripheral.name.length != 0) {
        [self.resourceArray addObject:peripheral];
    }
    [self.tableView reloadData];
}

/**
 蓝牙连接成功
 
 @param central 中心管理者
 @param peripheral 蓝牙实体
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [self.loadingView hidenLoadingView];
    [self.centralManager stopScan];
    //开启设备服务代理
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    self.peripheral = peripheral;
    [self.tableView reloadData];
    NSLog(@"蓝牙连接成功");
}
/**
 蓝牙连接失败
 
 @param central 中心管理者
 @param peripheral 设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"蓝牙连接失败--%@",error);
    [self.loadingView hidenLoadingView];
    self.peripheral = nil;
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}
/**
 蓝牙连接断开
 
 @param central 中心管理者
 @param peripheral s设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接断开");
    [self.loadingView hidenLoadingView];
    self.peripheral = nil;
    [self.tableView reloadData];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}
#pragma mark ---CBPeripheralDelegate
/**
 获取外围设备服务

 @param peripheral w设备
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
     NSLog(@"设备服务(CBService)----%@",peripheral.services);
    CBService *useSercice = nil;
    for (CBService *service in peripheral.services) {
        // 需要使用的服务UUID
//        NSLog(@"服务的UUID---%@",service.UUID.UUIDString);
//        if ([service.UUID.UUIDString isEqualToString:@"D0611E78-BBB4-4591-A5F8-487910AE4366"]) {
//            useSercice = service;
//        }
        
    }
    //模拟数据
    useSercice = peripheral.services[1];
    // 根据要使用的UUID查询服务特征
    if (useSercice) {
     [peripheral discoverCharacteristics:nil forService:useSercice];
    }
}

/**
 设备服务特征值回调

 @param peripheral 设备
 @param service 设备服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"设备服务特征值UUID---%@",service.characteristics);
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"服务特征值UUIDString---%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:@"需要的特征值"]) {
            // 获取需要的特征值
        }
    }
    // 全局定义服务特征值(模拟数据)
    self.characteristic = service.characteristics[0];
    // 接收一次
    [peripheral readValueForCharacteristic:self.characteristic];
    // 订阅,实时接收
    [peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    
    // 发送指令
    NSData *data = [@"硬件指令" dataUsingEncoding:NSUTF8StringEncoding];
    // 将指令写入蓝牙
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    // 当发现对应特制有信息调用发现特征信息回调
    [self.peripheral discoverDescriptorsForCharacteristic:self.characteristic];

}

/**
 从外围设备获取值

 @param peripheral 设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@"获取的外围设备的值---%@",characteristic);
}

/**
 读取外围设备实时数据

 @param peripheral 设备
 @param characteristic 数据特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (characteristic.isNotifying) {
        // 在广播时读区值
        [peripheral readValueForCharacteristic:characteristic];
    }else{
        // 断开连接
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

/**
 给外围设备写数据成功回调

 @param peripheral 设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"给外围设备数据写入成功---%@",characteristic.value);
}



#pragma mark ---tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeripheralListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PeripheralListCell"];
    CBPeripheral *peripheral = self.resourceArray[indexPath.row];
    cell.peripheralNameLab.text = [NSString stringWithFormat:@"设备名:%@",peripheral.name];
    cell.isConnect = peripheral == self.peripheral;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = self.resourceArray[indexPath.row];
    [self.loadingView showLoadingView];
    if (peripheral == self.peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }else{
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}
@end
