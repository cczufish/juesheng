//
//  DatePicker.m
//  project
//
//  Created by runes on 13-5-6.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "DatePicker.h"

typedef enum {
    ePickerViewTagYear = 2012,
    ePickerViewTagMonth,
    ePickerViewTagDay,
    ePickerViewTagHour,
    ePickerViewTagMinute,
    ePickerViewTagSecond
}PickViewTag;

@interface DatePicker (private)
/**
 * 创建数据源
 */
-(void)createDataSource;

/**
 * create month Arrays
 */
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt;
@end


@implementation DatePicker

@synthesize delegate;
@synthesize yearPicker, monthPicker, dayPicker, hourPicker, minutePicker, secondPicker;
@synthesize date;
@synthesize yearArray, monthArray, dayArray, hourArray, minuteArray, secondArray;
@synthesize toolBar, hintsLabel;

@synthesize yearValue, monthValue, dayValue, hourValue, minuteValue, secondValue;

#pragma mark -
-(void)dealloc{
    [yearArray release];
    [monthArray release];
    [dayArray release];
    [hourArray release];
    [minuteArray release];
    [secondArray release];
    
    [date release];
    [yearPicker release];
    [monthPicker release];
    [dayPicker release];
    [hourPicker release];
    [minutePicker release];
    [secondPicker release];
    
    [toolBar release];
    [hintsLabel release];
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        NSMutableArray* tempArray1 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray2 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray3 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray4 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray5 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray6 = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self setYearArray:tempArray1];
        [self setMonthArray:tempArray2];
        [self setDayArray:tempArray3];
        [self setHourArray:tempArray4];
        [self setMinuteArray:tempArray5];
        [self setSecondArray:tempArray6];
        
        [tempArray1 release];
        [tempArray2 release];
        [tempArray3 release];
        [tempArray4 release];
        [tempArray5 release];
        [tempArray6 release];
        
        // 更新数据源
        [self createDataSource];
        
        
        // 创建 toolBar & hintsLabel & enter button
        UIToolbar* tempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self setToolBar:tempToolBar];
        [tempToolBar release];
        [self addSubview:self.toolBar];
        //        [toolBar setTintColor:[UIColor lightTextColor]];
        
        UILabel* tempHintsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 34)];
        [self setHintsLabel:tempHintsLabel];
        [tempHintsLabel release];
        [self.hintsLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.hintsLabel];
        [self.hintsLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.hintsLabel setTextColor:[UIColor whiteColor]];
        
        
        TTButton* tempBtn = [TTButton buttonWithStyle:@"toolbarButton:" title:@"确定"];
        
        [tempBtn sizeToFit];
        [self addSubview:tempBtn];
        [tempBtn setCenter:CGPointMake(320-15-tempBtn.frame.size.width*.5, 22)];
        [tempBtn addTarget:self action:@selector(actionEnter:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 初始化各个视图
        UIPickerView* yearPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 80, 216)];
        [self setYearPicker:yearPickerTemp];
        [yearPickerTemp release];
        [self.yearPicker setFrame:CGRectMake(0, 44, 80, 216)];
        
        UIPickerView* monthPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(81, 44, 60, 216)];
        [self setMonthPicker:monthPickerTemp];
        [monthPickerTemp release];
        [self.monthPicker setFrame:CGRectMake(80, 44, 60, 216)];
        
        UIPickerView* dayPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(141, 44, 60, 216)];
        [self setDayPicker:dayPickerTemp];
        [dayPickerTemp release];
        [self.dayPicker setFrame:CGRectMake(140, 44, 60, 216)];
        
        UIPickerView* hourPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(201, 44, 60, 216)];
        [self setHourPicker:hourPickerTemp];
        [hourPickerTemp release];
        [self.hourPicker setFrame:CGRectMake(201, 44, 60, 216)];
        
        UIPickerView* minutesPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(261, 44, 60, 216)];
        [self setMinutePicker:minutesPickerTemp];
        [minutesPickerTemp release];
        [self.minutePicker setFrame:CGRectMake(260, 44, 60, 216)];
        
        UIPickerView* secondsPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(321, 44, 60, 216)];
        [self setSecondPicker:secondsPickerTemp];
        [secondsPickerTemp release];
        [self.secondPicker setFrame:CGRectMake(320, 44, 60, 216)];
        
        
        [self.yearPicker setDataSource:self];
        [self.monthPicker setDataSource:self];
        [self.dayPicker setDataSource:self];
        [self.hourPicker setDataSource:self];
        [self.minutePicker setDataSource:self];
        [self.secondPicker setDataSource:self];
        
        [self.yearPicker setDelegate:self];
        [self.monthPicker setDelegate:self];
        [self.dayPicker setDelegate:self];
        [self.hourPicker setDelegate:self];
        [self.minutePicker setDelegate:self];
        [self.secondPicker setDelegate:self];
        
        
        
        [self.yearPicker setTag:ePickerViewTagYear];
        [self.monthPicker setTag:ePickerViewTagMonth];
        [self.dayPicker setTag:ePickerViewTagDay];
        [self.hourPicker setTag:ePickerViewTagHour];
        [self.minutePicker setTag:ePickerViewTagMinute];
        [self.secondPicker setTag:ePickerViewTagSecond];
        
        
        [self addSubview:self.yearPicker];
        [self addSubview:self.monthPicker];
        [self addSubview:self.dayPicker];
        [self addSubview:self.hourPicker];
        [self addSubview:self.minutePicker];
        [self addSubview:self.secondPicker];
        
        [self.yearPicker setShowsSelectionIndicator:YES];
        [self.monthPicker setShowsSelectionIndicator:YES];
        [self.dayPicker setShowsSelectionIndicator:YES];
        [self.hourPicker setShowsSelectionIndicator:YES];
        [self.minutePicker setShowsSelectionIndicator:YES];
        [self.secondPicker setShowsSelectionIndicator:YES];
        
        
        [self resetDateToCurrentDate];
    }
    return self;
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    if (ePickerViewTagYear ==  pickerView.tag) {
//        return 60.0f;
//    } else {
//        return 40.0f;
//    }
//}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray count];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray count];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray count];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray count];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray count];
    }
    
    if (ePickerViewTagSecond == pickerView.tag) {
        return [self.secondArray count];
    }
    return 0;
}
#pragma makr - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray objectAtIndex:row];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray objectAtIndex:row];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray objectAtIndex:row];
    }
    
    if (ePickerViewTagSecond == pickerView.tag) {
        return [self.secondArray objectAtIndex:row];
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        self.yearValue = [[self.yearArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagMonth == pickerView.tag){
        self.monthValue = [[self.monthArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagDay == pickerView.tag){
        self.dayValue = [[self.dayArray objectAtIndex:row]intValue];
    } else if(ePickerViewTagHour == pickerView.tag){
        self.hourValue = [[self.hourArray objectAtIndex:row]intValue];
    } else if(ePickerViewTagMinute == pickerView.tag){
        self.minuteValue = [[self.minuteArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagSecond == pickerView.tag){
        self.secondValue = [[self.secondArray objectAtIndex:row] intValue];
    }
    if (ePickerViewTagMonth == pickerView.tag || ePickerViewTagYear == pickerView.tag) {
        [self createMonthArrayWithYear:self.yearValue month:self.monthValue];
        [self.dayPicker reloadAllComponents];
    }
    
    NSString* str = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",self.yearValue, self.monthValue, self.dayValue, self.hourValue, self.minuteValue, self.secondValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    [self setDate:[dateFormat dateFromString:str]];
    [dateFormat release];
}
#pragma mark - 年月日闰年＝情况分析
/**
 * 创建数据源
 */
-(void)createDataSource{
    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
    NSDate *selected = [datePicker date];
    NSCalendar *calendarone = [NSCalendar currentCalendar];
    NSUInteger unitFlagsone = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponentone = [calendarone components:unitFlagsone fromDate:selected];
    // 年
    int yearInt = [dateComponentone year];
    [self.yearArray removeAllObjects];
    for (int i=yearInt -10; i<=yearInt; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // 月
    [self.monthArray removeAllObjects];
    for (int i=1; i<=12; i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    NSInteger month = [dateComponentone month];
    
    [self createMonthArrayWithYear:yearInt month:month];
    
    // 时
    [self.hourArray removeAllObjects];
    for(int i=0; i<24; i++){
        [self.hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    // 分
    [self.minuteArray removeAllObjects];
    for(int i=0; i<60; i++){
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    // 秒
    [self.secondArray removeAllObjects];
    for(int i=0; i<60; i++){
        [self.secondArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}
#pragma mark -
-(void)resetDateToCurrentDate{
    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
    NSDate *selected = [datePicker date];
    NSLog(@"now date is: %@", selected);
    NSCalendar *calendarone = [NSCalendar currentCalendar];
    NSUInteger unitFlagsone = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponentone = [calendarone components:unitFlagsone fromDate:selected];
    
    [self.yearPicker selectRow:[self.yearArray count]-1 inComponent:0 animated:YES];
    [self.monthPicker selectRow:[dateComponentone month]-1 inComponent:0 animated:YES];
    [self.dayPicker selectRow:[dateComponentone day]-1 inComponent:0 animated:YES];
    
    [self.hourPicker selectRow:[dateComponentone hour] inComponent:0 animated:YES];
    [self.minutePicker selectRow:[dateComponentone minute] inComponent:0 animated:YES];
    [self.secondPicker selectRow:[dateComponentone second] inComponent:0 animated:YES];
    
    
    [self setYearValue:[dateComponentone year]];
    [self setMonthValue:[dateComponentone month]];
    [self setDayValue:[dateComponentone day]];
    [self setHourValue:[dateComponentone hour]];
    [self setMinuteValue:[dateComponentone minute]];
    [self setSecondValue:[dateComponentone second]];
    
    NSString* str = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",self.yearValue, self.monthValue, self.dayValue, self.hourValue, self.minuteValue, self.secondValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    [self setDate:[dateFormat dateFromString:str]];
    [dateFormat release];
}
#pragma mark -
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt{
    int endDate = 0;
    switch (monthInt) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            endDate = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            endDate = 30;
            break;
        case 2:
            // 是否为闰年
            if (yearInt % 400 == 0) {
                endDate = 29;
            } else {
                if (yearInt % 100 != 0 && yearInt %4 ==4) {
                    endDate = 29;
                } else {
                    endDate = 28;
                }
            }
            break;
        default:
            break;
    }
    
    if (self.dayValue > endDate) {
        self.dayValue = endDate;
    }
    // 日
    [self.dayArray removeAllObjects];
    for(int i=1; i<=endDate; i++){
        [self.dayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}
#pragma mark - 点击确定按钮
-(IBAction)actionEnter:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DatePickerDelegateEnterActionWithDataPicker:)]) {
        [self.delegate DatePickerDelegateEnterActionWithDataPicker:self];
    }
}
#pragma mark - 设置提示信息
-(void)setHintsText:(NSString*)hints{
    [self.hintsLabel setText:hints];
}
#pragma mark -
-(void)removeFromSuperview{
    self.delegate = nil;
    [super removeFromSuperview];
}
@end
