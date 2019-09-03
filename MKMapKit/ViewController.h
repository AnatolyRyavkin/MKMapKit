//
//  ViewController.h
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 19/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AVAnotation.h"
#import "AVStudent.h"
#import "AVAlertController.h"
#import "UIView+AVSearthAnnotation.h"
#import <CoreLocation/CLAvailability.h>
#import <Contacts/Contacts.h>


@interface ViewController : UIViewController<MKMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray*arrayStudents;
@property AVAnotation*pointMeeting;
@property UITextField*textFieldPlaceMeeting;
@property AVAlertController*ac;
@property NSDateFormatter*formatter;
@property AVStudent*studentSelect;
@property NSMutableDictionary*dictionary;
@property UIBarButtonItem*barButtonInfo;
@property NSString*address;
@property UITableView*tableInfo;
@property AVAnotation*pinMeeting;
@property int flagNumberCircle;
@property (weak) UIView*detailView;

@end;

