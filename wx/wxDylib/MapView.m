//
//  MapView.m
//  wechat
//
//  Created by admin on 2017/7/31.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import "MapView.h"
#import "FishConfigurationCenter.h"
//@import WechatPod;
//#import "WeChatPluginConfig.h"
#import <WechatPod/WechatPod.h>
#import <objc/runtime.h>
#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

#define GEORGIA_TECH_LATITUDE 33.777328
#define GEORGIA_TECH_LONGITUDE -84.397348
#define ZOOM_LEVEL 14

@implementation MyPoint

-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t subTitle:(NSString *)subTitle{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
        _subtitle = subTitle;
    }
    return self;
}
@end


@interface MapView()<MKMapViewDelegate>{
    
}
@end

@implementation MapView

static MapView *__shareMap;
+(instancetype)shareMapView{
    if (__shareMap == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        __shareMap = [[MapView alloc] initWithFrame:window.bounds];
        //[window addSubview:__shareMap];
        [__shareMap initView];
    }
    return __shareMap;
}

- (void)initView{
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 30)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onColse) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:back];
    
    UIButton *colse = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, 80, 30)];
    [colse setTitle:@"关闭定位" forState:UIControlStateNormal];
    [colse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [colse addTarget:self action:@selector(onColseLication) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:colse];
    
    UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 20, 60, 30)];
    [select setTitle:@"选择" forState:UIControlStateNormal];
    [select setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(onSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:select];
    
    UIButton *curr = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 60, 80, 30)];
    [curr setTitle:@"当前位置" forState:UIControlStateNormal];
    [curr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [curr addTarget:self action:@selector(currLocation) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:curr];
    
    UIButton *address = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 100, 80, 30)];
    [address setTitle:@"公司位置" forState:UIControlStateNormal];
    [address setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [address addTarget:self action:@selector(defaultAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:address];
    
    self.delegate = self;
    self.showsUserLocation = YES;
    self.showsCompass = YES;
    self.showsScale = YES;
    
    CGFloat width = 16;
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    centerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.4];
    centerView.layer.cornerRadius = width/2;
    centerView.layer.masksToBounds = YES;
    centerView.center = self.center;
    [self addSubview:centerView];
    
    //UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    //[self addGestureRecognizer:tap];
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [window addSubview:self];
    
    NSDictionary *locationInfo = [FishConfigurationCenter sharedInstance].locationInfo;
    double latitude = [locationInfo[@"latitude"] doubleValue];
    double longitude = [locationInfo[@"longitude"] doubleValue];
    if (latitude >0 ) {
        [self setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) zoomLevel:ZOOM_LEVEL animated:NO];
    }
}


- (void)onSelect{
    CGPoint touchPoint = self.center;
    CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
    
    //NSString *titile = [NSString stringWithFormat:@"%f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude];
    //[self setCenterCoordinate:touchMapCoordinate zoomLevel:ZOOM_LEVEL animated:NO];
    
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"latitude"] = @(touchMapCoordinate.latitude);
    info[@"longitude"] = @(touchMapCoordinate.longitude);
    MMLocationMgr *mgr = [objc_getClass("MMLocationMgr") new];
    id obj = [mgr getAddressByLocation:touchMapCoordinate];
    
    NSString * shortAddress = [mgr shortAddressFromAddressDic:obj];
    
    if (shortAddress.length) {
        info[@"name"] = shortAddress;
        [FishConfigurationCenter sharedInstance].locationInfo = info;
        if (weak_self.customAction) {
            weak_self.customAction(weak_self, 1);
        }
        [weak_self onColse];
        return;
    }
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:cl completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *mark = placemarks.firstObject;
        NSString *des = mark.addressDictionary[@"Name"];
        info[@"name"] = des ?: [NSString stringWithFormat:@"%0.4f,%0.4f",touchMapCoordinate.latitude, touchMapCoordinate.longitude];
        
        [FishConfigurationCenter sharedInstance].locationInfo = info;
        if (weak_self.customAction) {
            weak_self.customAction(weak_self, 1);
        }
        [weak_self onColse];
    }];
    
}

- (void)defaultAddress{
    CLLocationCoordinate2D tmp = CLLocationCoordinate2DMake(31.20686410, 121.55909035);
    [self setCenterCoordinate:tmp zoomLevel:ZOOM_LEVEL animated:NO];
}
- (void)currLocation{
    [self setCenterCoordinate:_location.location.coordinate zoomLevel:ZOOM_LEVEL animated:NO];
}

- (void)onColse{
    [self removeFromSuperview];
}

- (void)onColseLication{
    [FishConfigurationCenter sharedInstance].locationInfo = nil;
    if (self.customAction) {
        self.customAction(self, 1);
    }
    [self onColse];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (_location) {
        self.location = userLocation;
        return;
    }//31.20465960,+121.56338317
    self.location = userLocation;
    NSDictionary *locationInfo = [FishConfigurationCenter sharedInstance].locationInfo;
    double latitude = [locationInfo[@"latitude"] doubleValue];
    if (latitude == 0 ) {
        [self setCenterCoordinate:userLocation.location.coordinate zoomLevel:ZOOM_LEVEL animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"title = %@", view.annotation.title);
    if ([view.annotation.title isEqualToString:@"我的位置"]) {
        self.selectView = nil;
    }else {
        self.selectView = view;
    }
}

- (void)onTap:(UILongPressGestureRecognizer *)tap{
    if (tap.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [tap locationInView:self];
    CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
    
    NSString *titile = [NSString stringWithFormat:@"%f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude];
   
    
    //[self setCenterCoordinate:touchMapCoordinate zoomLevel:ZOOM_LEVEL animated:NO];
    
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:cl completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        NSString *des = mark.addressDictionary[@"Name"];
        MyPoint *point = [[MyPoint alloc] initWithCoordinate:touchMapCoordinate andTitle:titile subTitle:des];
        [self addAnnotation:point];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self selectAnnotation:point animated:YES];
        });
    }];
}
#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}
@end
