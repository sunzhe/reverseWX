//
//  MapView.h
//  wechat
//
//  Created by admin on 2017/7/31.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "Masonry.h"
@interface MMLocationMgr: NSObject
- (id)getAddressByLocation:(struct CLLocationCoordinate2D)arg1;
- (id)shortAddressFromAddressDic:(id)arg1;
@end

typedef void(^CustomAction)(id obj, int idx);

@interface MyPoint : NSObject <MKAnnotation>

//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t subTitle:(NSString *)subTitle;

@end


@interface MapView : MKMapView

@property(nonatomic, strong)MKAnnotationView *selectView;
@property(nonatomic, strong)MKUserLocation *location;
@property(nonatomic, copy)CustomAction customAction;


+(instancetype)shareMapView;
- (void)show;
@end
