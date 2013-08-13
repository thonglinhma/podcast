//
//  ALDownloadButton.m
//  Podcast
//  Created by Fabiano Francesconi on 16/07/13.
//  Copyright (c) 2013 Fabiano Francesconi. All rights reserved.
//
//
//  Created by Mike Tran on 8/13/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALDownloadButton.h"
#import "UIColor+Additions.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface ALDownloadButton()
@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *iconLayer;

@property (nonatomic, assign) BOOL isSpinning;

@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@end

#define kArrowSizeRatio .12
#define kStopSizeRatio  .3

@implementation ALDownloadButton

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    _lineWidth = self.frame.size.width * 0.025;
    _tintColor = [UIColor ios7Blue];
    
    self.progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.strokeColor = _tintColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressBackgroundLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = _tintColor.CGColor;
    _progressLayer.fillColor = nil;
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = _lineWidth * 2.0;
    [self.layer addSublayer:_progressLayer];
    
    self.iconLayer = [CAShapeLayer layer];
    _iconLayer.strokeColor = _tintColor.CGColor;
    _iconLayer.fillColor = nil;
    _iconLayer.lineCap = kCALineCapButt;
    _iconLayer.lineWidth = _lineWidth;
    _iconLayer.fillRule = kCAFillRuleNonZero;
    [self.layer addSublayer:_iconLayer];
    
    self.networkOperationQueue = [Nimbus networkOperationQueue];
}

- (void)cancelOperation
{
    [self.operation cancel];
}

- (void)dealloc
{
    [self cancelOperation];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (!self.isSpinning && self.progress == 0) {
        [self startSpinProgressBackgroundLayer];
    } else {
        [self cancelOperation];
        [self setProgress:0];
        if (_delegate && [_delegate respondsToSelector:@selector(downloadButtonDidStopLoad:)]) {
            [_delegate downloadButtonDidStopLoad:self];
        }
        
        return;
    }
    
    if (NIIsStringWithAnyText(_pathToDownload)) {
        [self cancelOperation];
        
        NSURL *url = [NSURL URLWithString:_pathToDownload];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:[url path] parameters:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSString *filePath = NIPathForDocumentsResource([[url path] lastPathComponent]);
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        
        __weak ALDownloadButton *weakSelf = self;
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if (weakSelf.isSpinning) {
                [weakSelf stopSpinProgressBackgroundLayer];
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(downloadButton:readBytes:totalBytes:)]) {
                [weakSelf.delegate downloadButton:weakSelf readBytes:bytesRead totalBytes:totalBytesRead];
            }
            NIDPRINT(@"Download %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
            [weakSelf setProgress:((float)totalBytesRead/(float)totalBytesExpectedToRead)];
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self setProgress:0];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(downloadButton:didDownloadFile:)]) {
                [weakSelf.delegate downloadButton:weakSelf didDownloadFile:filePath];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self setProgress:0];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(downloadButton:didFailWithError:)]) {
                [weakSelf.delegate downloadButton:weakSelf didFailWithError:error];
            }
        }];
        
        self.operation = operation;
        if(_delegate && [_delegate respondsToSelector:@selector(downloadButtonDidStartLoad:)]) {
            [_delegate downloadButtonDidStartLoad:self];
        }
        [self.networkOperationQueue addOperation:operation];
    } else {
        [self stopSpinProgressBackgroundLayer];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    _iconLayer.frame = self.bounds;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    [self drawBackgroundCircle:_isSpinning];
    
    // Draw progress
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = _lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    
    radius = (self.bounds.size.width - _lineWidth*4) / 2.0;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [_progressLayer setPath:processPath.CGPath];
    
    if ([self progress] == 1.0) {
    } else if (([self progress] > 0) && [self progress] < 1.0) {
        [self drawStop];
    } else {
        [self drawArrow];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    _progressBackgroundLayer.strokeColor = tintColor.CGColor;
    _progressLayer.strokeColor = tintColor.CGColor;
    _iconLayer.strokeColor = tintColor.CGColor;
}


- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressLayer.lineWidth = _lineWidth * 2.0;
    _iconLayer.lineWidth = _lineWidth;
}

#pragma mark -
#pragma mark Drawing

- (void)drawBackgroundCircle:(BOOL) partial
{
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    // Recompute the end angle to make it at 90% of the progress
    if (partial) {
        endAngle = (1.8F * (float)M_PI) + startAngle;
    }
    
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}

- (void)drawStop
{
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kStopSizeRatio;
    CGFloat sideSize = self.bounds.size.width * ratio;
    
    UIBezierPath *stopPath = [UIBezierPath bezierPath];
    [stopPath moveToPoint:CGPointMake(0, 0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, 0.0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, sideSize)];
    [stopPath addLineToPoint:CGPointMake(0.0, sideSize)];
    [stopPath closePath];
    
    // ...and move it into the right place.
    [stopPath applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    
    [_iconLayer setPath:stopPath.CGPath];
    [_iconLayer setStrokeColor:_progressLayer.strokeColor];
    [_iconLayer setFillColor:self.tintColor.CGColor];
}

- (void)drawArrow
{
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kArrowSizeRatio;
    CGFloat segmentSize = self.bounds.size.width * ratio;
    
    // Draw icon
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize * 3.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize, segmentSize * 3.3)];
    [path addLineToPoint:CGPointMake(-segmentSize, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, 0.0)];
    [path closePath];
    
    [path applyTransform:CGAffineTransformMakeTranslation(-segmentSize /2.0, -segmentSize / 1.2)];
    [path applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    _iconLayer.path = path.CGPath;
    _iconLayer.fillColor = nil;
}

#pragma mark Setters

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        
        if (_progress == 1.0) {
            [self animateProgressBackgroundLayerFillColor];
        }
        
        if (_progress == 0.0) {
            _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark Animations

- (void)animateProgressBackgroundLayerFillColor
{
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    
    colorAnimation.duration = .5;
    colorAnimation.repeatCount = 1.0;
    colorAnimation.removedOnCompletion = NO;
    
    colorAnimation.fromValue = (__bridge id) _progressBackgroundLayer.backgroundColor;
    colorAnimation.toValue = (__bridge id) _progressLayer.strokeColor;
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [_progressBackgroundLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
}

- (void)startSpinProgressBackgroundLayer
{
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_progressBackgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopSpinProgressBackgroundLayer
{
    [self drawBackgroundCircle:NO];
    
    [_progressBackgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}


@end
