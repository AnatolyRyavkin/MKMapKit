//
//  AVAnotation.h
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 20/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic) MKMapPoint point;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate ;
- (void)setPoint:(MKMapPoint)newPoint;

@end

NS_ASSUME_NONNULL_END
