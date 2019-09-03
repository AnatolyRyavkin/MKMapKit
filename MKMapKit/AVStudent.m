//
//  AVStudent.m
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 21/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVStudent.h"
#import <UIKit/UIKit.h>

@implementation AVStudent


-(NSString*)dataBirthChangeFromDateInString:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MMM/yyyy";
    return [formatter stringFromDate:date];
}

-(NSDate*)randomDateBirth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MMM/yyyy";
    NSDate*dateBirthBegin =[formatter dateFromString:@"01.Jan.1970"];
    NSDate*dateBirthEnd =[formatter dateFromString:@"01.Jan.2003"];
    NSTimeInterval intervalDateBirth = [dateBirthEnd timeIntervalSinceDate:dateBirthBegin];
    NSTimeInterval randomCountSecAtDatsBirthBegin = (NSTimeInterval)((arc4random()*10000) % (NSUInteger)intervalDateBirth);
    NSDate*dateBirth = [[NSDate alloc]initWithTimeInterval:randomCountSecAtDatsBirthBegin sinceDate:dateBirthBegin];
    return dateBirth;
}

-(Gender)randomGender{
    return (arc4random()%2) ? GenderMan : GenderWomen;
}

-(MKMapPoint)getPointHome{
    MKMapPoint center = MKMapPointMake(162269727, 83915950);
    NSInteger delta = 10000000;
    CGFloat randomX = arc4random()%delta+center.x-delta/2;
    CGFloat randomY = arc4random()%delta+center.y-delta/2;
    return MKMapPointMake(randomX, randomY);
}

-(id)init{
    self = [super init];
    if(self){

        self.gender = [self randomGender];

        self.dateBirth = [self randomDateBirth];

        NSArray*arrayGlasChar = [[NSArray alloc]initWithObjects:@"y",@"u",@"a",@"o",@"i",@"a",@"u",@"o",@"i",@"j",nil];

        NSArray*arraySoglasChar = [[NSArray alloc]initWithObjects:     @"q",@"w",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"w",
                                   @"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",
                                   @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",
                                   @"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"c",@"v",@"b",@"n",@"m",nil];

        NSMutableString*firstName = [[NSMutableString alloc]init];
        int lit = arc4random();
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (lit%2==0) ? [arrayGlasChar objectAtIndex:arc4random()% (arrayGlasChar.count-1)] :
            [arraySoglasChar objectAtIndex:(arc4random()% (arraySoglasChar.count-1))];
            lit++;
            if(i==0)
                [firstName appendString:[strChar uppercaseString]];
            else
                [firstName appendString:strChar];
        }
        if (self.gender == GenderWomen)
            [firstName appendString:@"a"];

        NSMutableString*lastName = [[NSMutableString alloc]init];
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (arc4random()%2==0) ? [arrayGlasChar objectAtIndex:(arc4random()%(arrayGlasChar.count-1))] :  [arraySoglasChar objectAtIndex:(arc4random()%(arraySoglasChar.count-1))];
            if(i==0)
                [lastName appendString:[strChar uppercaseString]];
            else
                [lastName appendString:strChar];
        }

        if(self.gender == GenderMan){
            [lastName appendString: (arc4random()%2==0) ? @"in" : @"of"];
            self.image = [UIImage imageNamed:@"cat1.png"];
        }else{
           [lastName appendString: (arc4random()%2==0) ? @"ina" : @"ofa"];
            self.image = [UIImage imageNamed:@"cat2.png"];
        }
        self.lastName = lastName;
        self.firstName = firstName;
        self.point = [self getPointHome];
        self.title = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"dd/MMM/yyyy";
        self.subtitle = [formatter stringFromDate:self.dateBirth];
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate.latitude = newCoordinate.latitude;
    _coordinate.longitude = newCoordinate.longitude;
    _point = MKMapPointForCoordinate(_coordinate);
}
- (void)setPoint:(MKMapPoint)newPoint{
    _point.x = newPoint.x;
    _point.y = newPoint.y;
    _coordinate = MKCoordinateForMapPoint(_point);
}

@end
