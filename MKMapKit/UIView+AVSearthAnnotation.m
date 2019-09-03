//
//  UIView+AVSearthAnnotation.m
//  MKMapKit
//
//  Created by Anatoly Ryavkin on 24/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "UIView+AVSearthAnnotation.h"


@implementation UIView (AVSearthAnnotation)


-(MKAnnotationView*)superAnnotation{
    if([self isKindOfClass:[MKAnnotationView class]])
        return (MKAnnotationView*)self;
    if(![self superview])
        return nil;
    return [[self superview] superAnnotation];
}

@end
