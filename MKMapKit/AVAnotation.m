//
//  AVAnotation.m
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 20/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVAnotation.h"

@implementation AVAnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate.latitude = newCoordinate.latitude;
    _coordinate.longitude = newCoordinate.longitude;
    _point = MKMapPointForCoordinate(_coordinate);
    NSString*string = MKStringFromMapPoint(self.point);
    self.title = string;
    self.subtitle = [NSString stringWithFormat:@"latitude=%f longitude=%f",self.coordinate.latitude, self.coordinate.longitude];
}
- (void)setPoint:(MKMapPoint)newPoint{
    _point.x = newPoint.x;
    _point.y = newPoint.y;
    _coordinate = MKCoordinateForMapPoint(_point);
}

@end
