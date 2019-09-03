//
//  AVStudent.h
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 21/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    GenderMan = 0,
    GenderWomen
}Gender;

@interface AVStudent : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic) MKMapPoint point;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate ;
- (void)setPoint:(MKMapPoint)newPoint;

@property NSString*firstName;
@property NSString*lastName;
@property NSDate*dateBirth;
@property Gender gender;
@property UIImage*image;


@end

NS_ASSUME_NONNULL_END
