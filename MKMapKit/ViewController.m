//
//  ViewController.m
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 19/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    UIBarButtonItem*barButtonAddPointCenter = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddPinMeeting)];
    UIBarButtonItem*barButtonAddArrayStudents = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionAddStudents)];
    UIBarButtonItem*barButtonVisibleAllStudents = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(actionVisibleStudents)];
    self.navigationItem.rightBarButtonItems = @[barButtonAddPointCenter,barButtonAddArrayStudents,barButtonVisibleAllStudents];
    UIBarButtonItem*barButtonDrawCircle = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionDrawCircle:)];
    UIBarButtonItem*barButtonDrawRouts = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionDrawRouts:)];
    self.navigationItem.leftBarButtonItems = @[barButtonDrawCircle,barButtonDrawRouts];

    self.formatter = [[NSDateFormatter alloc]init];
    self.formatter.dateFormat = @"dd/MM/yyyy";

    self.navigationItem.title = @" Here is the meeting place at date - ";
    self.arrayStudents = [[NSMutableArray alloc]init];
    self.dictionary = [[NSMutableDictionary alloc]init];
    for(int i=0;i<100;i++){
        AVStudent*student = [[AVStudent alloc]init];
        [self.arrayStudents addObject:student];
    }
    [self actionVisibleStudents];
}

#pragma mark - Delegat textFieldForAlert

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.navigationItem.title = [NSString stringWithFormat:@" Here is the meeting place at date - %@",textField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.formatter dateFromString:textField.text])
        return YES;
    else
        textField.text = @"date error! enter again";
    return NO;
}

#pragma mark - GetAddress

-(NSString*)getAddressForStudent:(AVStudent*)student{
    __block NSMutableString*addressString = [[NSMutableString alloc]init];
    __block NSArray*arrayAddress;
    CLGeocoder*geocoder = [[CLGeocoder alloc]init];
    CLLocation*location = [[CLLocation alloc]initWithLatitude:student.coordinate.latitude longitude:student.coordinate.longitude];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray< CLPlacemark *> * __nullable placemarks, NSError * __nullable error){
        if(!error){
            NSArray*array = placemarks;
            if(array.count>0){
                CLPlacemark*placemark = [array objectAtIndex:0];
                CNPostalAddress *postalAddress = placemark.postalAddress;

                    arrayAddress = [[NSArray alloc]initWithObjects:postalAddress.street,postalAddress.subLocality,postalAddress.city,
                                    postalAddress.subAdministrativeArea,postalAddress.state,postalAddress.postalCode,postalAddress.country,
                                    postalAddress.ISOCountryCode, nil];

                for(NSString*string in arrayAddress){
                    if(![string isEqualToString:@""])
                        [addressString appendString:[NSString stringWithFormat:@" %@ .",string]];
                }
                [self.tableInfo reloadData];
            }else{
            }
        }
        else
            [error debugDescription];
    }];
    return addressString;
}

#pragma mark - RendereMapView

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{

    if([overlay isMemberOfClass:[MKCircle class]]){
        MKCircleRenderer*render = [[MKCircleRenderer alloc]initWithOverlay:overlay];
        switch (self.flagNumberCircle) {
            case 1:
                render.fillColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];
                break;
            case 2:
                render.fillColor = [[UIColor yellowColor]colorWithAlphaComponent:0.3];
                break;
            case 3:
                render.fillColor = [[UIColor blueColor]colorWithAlphaComponent:0.1];
                break;

            default:
                break;
        }
         return render;
    }else{
        MKPolylineRenderer*render = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
        render.strokeColor = [UIColor redColor];
        render.lineWidth = 2;
        render.lineCap = kCGLineCapRound;
        render.lineJoin = kCGLineJoinRound;
        return render;
    }
}

#pragma mark - actions

-(void)actionDrawCircle:(UIBarButtonItem*)sender{
    [self.detailView removeFromSuperview];
    self.flagNumberCircle = 0;
    [self.mapView removeOverlays:self.mapView.overlays];
    for(int i=1;i<4;i++){
        self.flagNumberCircle++;
        MKCircle*circle = [MKCircle circleWithCenterCoordinate:self.pinMeeting.coordinate radius:140000*i];
        [self.mapView addOverlay:circle level:MKOverlayLevelAboveLabels];
    }
    UIView*detailMeetingView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 200, 90)];
    detailMeetingView.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.3];

    int count1= 0; int count2 = 0; int count3 = 0;
    CLLocation*locationPinMeeting = [[CLLocation alloc]initWithLatitude:self.pinMeeting.coordinate.latitude longitude:self.pinMeeting.coordinate.longitude];
    for(AVStudent*student in self.arrayStudents){
        CLLocation*locationStudent = [[CLLocation alloc]initWithLatitude:student.coordinate.latitude longitude:student.coordinate.longitude];
        CLLocationDistance distanceStudentAtPinMeeting = [locationStudent distanceFromLocation:locationPinMeeting];
        if(distanceStudentAtPinMeeting<=140000*1)
            count1++;
        else if(distanceStudentAtPinMeeting<=140000*2)
            count2++;
        else if(distanceStudentAtPinMeeting<=140000*3)
            count3++;
    }

    for(int i=0;i<90;){
        UILabel*lableCome = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(detailMeetingView.bounds), CGRectGetMinY(detailMeetingView.bounds)+i,
                                                                    CGRectGetWidth(detailMeetingView.bounds), CGRectGetHeight(detailMeetingView.bounds)/3)];
        [lableCome setTextColor:[UIColor blueColor]];
        [lableCome setFont:[UIFont systemFontOfSize:12 weight:0.4]];
        switch (i) {
            case 0:
                [lableCome setText:[NSString stringWithFormat:@" 90 percent's come %i students",count1]];
                break;
            case 30:
                lableCome.text = [NSString stringWithFormat:@" 50 percent's come %i students",count2];
                break;
            case 60:
                lableCome.text = [NSString stringWithFormat:@" 10 percent's come %i students",count3];
                break;

            default:
                break;
        }
        i=i+30;
        [detailMeetingView addSubview:lableCome];
    }
    [self.mapView addSubview:detailMeetingView];
    self.detailView = detailMeetingView;

}

-(void)actionDrawRouts:(UIBarButtonItem*)sender{

    MKDirectionsRequest*request = [[MKDirectionsRequest alloc]init];
    request.requestsAlternateRoutes = NO;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    MKPlacemark*placemarkDestination = [[MKPlacemark alloc]initWithCoordinate:self.pinMeeting.coordinate];
    MKMapItem*itemDestination = [[MKMapItem alloc]initWithPlacemark:placemarkDestination];
    request.destination = itemDestination;
    for(AVStudent*student in self.arrayStudents){
        MKPlacemark*placemarkSourse = [[MKPlacemark alloc]initWithCoordinate:student.coordinate];
        MKMapItem*itemSourse = [[MKMapItem alloc]initWithPlacemark:placemarkSourse];
        request.source = itemSourse;
        MKDirections*directions = [[MKDirections alloc]initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            if(error)
                [error debugDescription];
            else{
                NSArray*arrayRoutes = response.routes;
                if(arrayRoutes.count==0)
                    NSLog(@"student %@ dont will be come",student.lastName);
                MKRoute*route = [arrayRoutes objectAtIndex:0];
                MKPolyline*polyline = route.polyline;
                [self.mapView addOverlay:polyline level:MKOverlayLevelAboveLabels];
            }
        }];
    }
}

-(void)actionAlertPlaceMeeting:(UIButton*)sender{

    self.ac = [AVAlertController alertControllerWithTitle:@"Hello frends" message:@"DATE MEETING:" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField*textFieldPlaceMeeting = [[UITextField alloc]init];
    ViewController*avvc = self;
    [self.ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textFieldPlaceMeeting = textField;
        textField.delegate = avvc;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"input date dd/mm/yyyy";
    }];
    [self.ac addAction:[UIAlertAction actionWithTitle:@"exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:self.ac animated:YES completion:nil];

}

-(void)actionVisibleStudents{
    CGFloat delta = 1;
    MKMapRect visibleRect = MKMapRectNull;
    for(AVStudent*student in self.arrayStudents){
        MKMapRect rectStudent = MKMapRectMake(student.point.x-delta/2, student.point.y-delta/2, delta, delta);
        visibleRect = MKMapRectUnion(visibleRect, rectStudent);
    }
    [self.mapView setVisibleMapRect:visibleRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}

-(void)actionAddPinMeeting{
    CLLocationCoordinate2D coordinate = [self.mapView centerCoordinate];
    AVAnotation*annotation = [[AVAnotation alloc]init];
    [annotation setCoordinate:coordinate];
    MKMapPoint point = MKMapPointForCoordinate(coordinate);
    NSString*string = MKStringFromMapPoint(point);
    annotation.title = string;
    annotation.subtitle = [NSString stringWithFormat:@"latitude=%f longitude=%f",coordinate.latitude, coordinate.longitude];
    [self.mapView addAnnotation:annotation];
    self.pinMeeting = annotation;
}

-(void)actionAddStudents{
     [self.mapView addAnnotations:self.arrayStudents];
}

-(void)actionRiases:(UIButton*)sender{
    MKAnnotationView*annotationVievTemp = [(UIView*)sender superAnnotation];
    self.studentSelect = (AVStudent*)annotationVievTemp.annotation;
    UIViewController*vc = [[UIViewController alloc]init];
    vc.preferredContentSize = CGSizeMake(300, 450);
    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController*pc = vc.popoverPresentationController;
    pc.permittedArrowDirections =  UIMenuControllerArrowLeft;
    pc.sourceView = sender;
    pc.sourceRect = sender.bounds;
    UITableView*table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 450) style:UITableViewStylePlain];
    table.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.5];
    [vc.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    self.tableInfo = table;
    UILabel*label = [[UILabel alloc]initWithFrame:table.bounds];
    [label setText:@"MapView"];
    [table.tableHeaderView addSubview:label];
    self.address = [self getAddressForStudent:self.studentSelect];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - DelegatMapView

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView{
   
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    if(newState==MKAnnotationViewDragStateEnding){
        AVAnotation*annotationPlaceMeeting = view.annotation;
        CGPoint pointCenterAnnotationView = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
        CLLocationCoordinate2D pointCenter2D = [self.mapView convertPoint:pointCenterAnnotationView toCoordinateFromView:self.mapView];
        annotationPlaceMeeting.coordinate = pointCenter2D;
    }
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *identifierAnnotation = @"annotation";
    if ([annotation isKindOfClass:[AVAnotation class]]){
        MKAnnotationView*annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifierAnnotation];
        if(annotationView){
            annotationView.annotation = annotation;
        }else{
            annotationView =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifierAnnotation];
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailButton addTarget:self action:@selector(actionAlertPlaceMeeting:) forControlEvents:UIControlEventTouchDown];
            annotationView.leftCalloutAccessoryView=detailButton;
            annotationView.draggable = YES;
            annotationView.canShowCallout = YES;
            [annotationView setRestorationIdentifier: identifierAnnotation];
            annotationView.image =[UIImage imageNamed:@"lol.png"];
            annotationView.frame = CGRectMake(-30, -30, 60, 60);
            annotationView.annotation = annotation;
        }
        return annotationView;
    }else if ([annotation isKindOfClass:[AVStudent class]]){
        static NSString *identifierStudent = @"student";
        MKAnnotationView*annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifierStudent];
        if(annotationView){
            annotationView.annotation = annotation;
        }else{
            annotationView =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifierStudent];
            /* можно барбаттон
             UIView*viewForToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
             viewForToolBar.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0.2];
             annotationView.rightCalloutAccessoryView = viewForToolBar;
             UIToolbar*toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,70, 50)];
             self.barButtonInfo = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(action)];
             [toolBar setItems:@[self.barButtonInfo]];
             [viewForToolBar addSubview:toolBar];
             */
        }
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.leftCalloutAccessoryView = detailButton;
        [detailButton addTarget:self action:@selector(actionRiases:) forControlEvents:UIControlEventTouchDown];
        annotationView.enabled = YES;
        annotationView.draggable = NO;
        annotationView.canShowCallout = YES;
        annotationView.image = [(AVStudent*)annotation image];
        annotationView.frame = CGRectMake(-20, -20, 40, 40);
        annotationView.annotation = annotation;
        return annotationView;
    }else{
        MKPinAnnotationView*pin = [[MKPinAnnotationView alloc]init];
        pin.pinTintColor = [UIColor purpleColor];
        return pin;
    }
}

#pragma mark - tableViewDelegat and dataSourse

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath isEqual:[NSIndexPath indexPathForRow:9 inSection:0]])
        return 150;
    if(!(indexPath.row%2))
        return 20;
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UITextView*textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.bounds), 150)];

    switch (indexPath.row) {
        case 1:
            [cell.textLabel setText:self.studentSelect.firstName];
            break;
        case 3:
            [cell.textLabel setText:self.studentSelect.lastName];
            break;
        case 5:
            [cell.textLabel setText:[self.formatter stringFromDate:self.studentSelect.dateBirth]];
            break;
        case 7:
            [cell.textLabel setText:(self.studentSelect.gender==GenderMan)?@"Man":@"Women"];
            break;
        case 9:
            [cell.contentView addSubview:textView];
            textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
            textView.font = [UIFont systemFontOfSize:20];
            textView.textAlignment = NSTextAlignmentLeft;
            textView.text = self.address;
            break;
        case 0:
             [cell.textLabel setText:@"First name"];
             [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            break;
        case 2:
             [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
             [cell.textLabel setText:@"Last name"];
            break;
        case 4:
             [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
             [cell.textLabel setText:@"Date birth"];
            break;
        case 6:
             [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
             [cell.textLabel setText:@"Gender"];
            break;
        case 8:
             [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
             [cell.textLabel setText:@"Address"];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Info at student";
}


@end
