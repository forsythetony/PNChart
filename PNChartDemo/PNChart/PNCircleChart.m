//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"
#import "UICountingLabel.h"

@interface PNCircleChart () {
    UICountingLabel *_gradeLabel;
}

@end

@implementation PNCircleChart

@synthesize fontSize;

- (UIColor *)labelColor
{
    if (!_labelColor) {
        _labelColor = PNDeepGrey;
    }
    return _labelColor;
}


- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        
        _lineWidth = [NSNumber numberWithFloat:8.0];
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,self.center.y) radius:self.frame.size.height*0.5 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;
        
        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = [_lineWidth floatValue];
        _circleBG.strokeColor = PNLightYellow.CGColor;
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBG];
        
		_gradeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 100.0 , 100.0)];
        
        self.hasPercentage = YES;
        
    }
    
    return self;
    
}

-(void)strokeChart
{
    //  Find font size
    
    float floatFontSize;
    
    if (fontSize) {
        floatFontSize = [fontSize floatValue];
    }
    else{
        floatFontSize = 13.0f;
    }
    
    
    //Add count label
    
    [_gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [_gradeLabel setFont:[UIFont boldSystemFontOfSize:floatFontSize]];
    [_gradeLabel setTextColor:self.labelColor];
    [_gradeLabel setCenter:CGPointMake(self.center.x,self.center.y)];
    _gradeLabel.method = UILabelCountingMethodEaseInOut;
    
    NSString *theFormat;
    
    if (self.hasPercentage) {
        theFormat = @"%d%%";
    }
    else
    {
        theFormat = @"%d";
    }
    _gradeLabel.format = theFormat;
    
    
    [self addSubview:_gradeLabel];
    
    //Add circle params
    
    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;
    
    //Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = [_current floatValue]/[_total floatValue];
    
    if (self.hasPercentage) {
        [_gradeLabel countFrom:0 to:[_current floatValue]/[_total floatValue]*100 withDuration:1.0];
    }
    else
    {
        [_gradeLabel countFrom:0 to:[_current floatValue] withDuration:1.0];
    }
    
    
}
-(void)strokeChartToValue:(NSNumber *)newCurrent
{
    //  Find font size
    
    float floatFontSize;
    
    if (fontSize) {
        floatFontSize = [fontSize floatValue];
    }
    else{
        floatFontSize = 13.0f;
    }
    
    
    //Add count label
    
    [_gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [_gradeLabel setFont:[UIFont boldSystemFontOfSize:floatFontSize]];
    [_gradeLabel setTextColor:self.labelColor];
    [_gradeLabel setCenter:CGPointMake(self.center.x,self.center.y)];
    _gradeLabel.method = UILabelCountingMethodEaseInOut;
    
    NSString *theFormat;
    
    if (self.hasPercentage) {
        theFormat = @"%d%%";
    }
    else
    {
        theFormat = @"%d";
    }
    _gradeLabel.format = theFormat;
    
    
    [self addSubview:_gradeLabel];
    
    //Add circle params
    
    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;
    
    //Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = 1.0;
    
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pathAnimation.fromValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
    
    pathAnimation.toValue = [NSNumber numberWithFloat:[newCurrent floatValue]/[_total floatValue]];
    
    //[_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _circle.strokeEnd   = [newCurrent floatValue]/[_total floatValue];
    
    if (self.hasPercentage) {
        [_gradeLabel countFrom:[_current floatValue] to:[newCurrent floatValue]/[_total floatValue]*100 withDuration:1.0];
    }
    else
    {
        [_gradeLabel countFrom:[_current floatValue] to:[newCurrent floatValue] withDuration:1.0];
    }
    
    self.current = newCurrent;
}

@end
