//
//  UICustomDatePicker.h
//  Seldon_2
//
//  Created by admin on 12.08.13.
//  Copyright (c) 2013 AETP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate;


@interface CustomDatePicker : UIView
{
    
    NSCalendar *_calendar;
    NSDate *_date;
    NSDate *_maximumDate;
    NSDate *_minimumDate;
    NSTimeZone *_timeZone;

    
}

@property(nonatomic, copy)   NSCalendar *calendar;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSDate *maximumDate;
@property(nonatomic, retain) NSDate *minimumDate;
@property(nonatomic, retain) NSTimeZone *timeZone;

@property(nonatomic,assign) id<CustomDatePickerDelegate> delegate;

-(id)initWithImageForDay:(UIImage*)dayImage andMonthImage:(UIImage*)monthImage andYearImage:(UIImage*)yearImage forRect:(CGRect)rect;


@end

@protocol CustomDatePickerDelegate <NSObject>

@optional

-(void)datePickerDateChange:(CustomDatePicker*)picker forDate:(NSDate*) date;

@end