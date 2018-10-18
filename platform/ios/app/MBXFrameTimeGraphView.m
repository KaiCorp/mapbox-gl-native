#import "MBXFrameTimeGraphView.h"

const CGFloat exaggeration = 1000.f;

@interface MBXFrameTimeGraphView ()

@property (nonatomic) CAScrollLayer *scrollLayer;
@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) UIBezierPath *path;
@property (nonatomic) CAShapeLayer *thresholdLayer;

@end

@implementation MBXFrameTimeGraphView

- (void)layoutSubviews {
    [super layoutSubviews];

    self.userInteractionEnabled = NO;

    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 1;

    if (!self.scrollLayer) {
        self.scrollLayer = [CAScrollLayer layer];
        self.scrollLayer.frame = self.bounds;
        self.scrollLayer.scrollMode = kCAScrollHorizontally;
        self.scrollLayer.masksToBounds = YES;
        [self.layer addSublayer:self.scrollLayer];
    }

    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.scrollLayer.frame;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        //self.shapeLayer.masksToBounds = YES;
        [self.scrollLayer addSublayer:self.shapeLayer];
    }

    if (!self.path) {
        self.path = [UIBezierPath bezierPath];
        [self.path moveToPoint:CGPointMake(0, self.scrollLayer.frame.size.height)];
    }

    if (!self.thresholdLayer) {
        // Threshold line at target render duration
        CGRect thresholdLineRect = CGRectMake(0, self.frame.size.height - [self renderDurationTargetMilliseconds], self.frame.size.width, 2);
        UIBezierPath *thresholdPath = [UIBezierPath bezierPathWithRect:thresholdLineRect];
        self.thresholdLayer = [CAShapeLayer layer];
        self.thresholdLayer.path = thresholdPath.CGPath;
        self.thresholdLayer.fillColor = [UIColor greenColor].CGColor;

        [self.layer addSublayer:self.thresholdLayer];
    }
}

- (void)updatePathWithFrameDuration:(CFTimeInterval)frameDuration {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGPoint newPoint = CGPointMake(self.path.currentPoint.x + 1.0, self.frame.size.height - fminf(frameDuration * exaggeration, self.frame.size.height));

    [self.path addLineToPoint:newPoint];

    //NSLog(@"New line at %@", NSStringFromCGPoint(newPoint));

    self.shapeLayer.path = self.path.CGPath;

    [self.scrollLayer scrollToPoint:CGPointMake(self.path.currentPoint.x + 1.0 - self.frame.size.width, 0)];

    [CATransaction commit];
}

- (CGFloat)renderDurationTargetMilliseconds {
    CGFloat target = (1.0 / UIScreen.mainScreen.maximumFramesPerSecond) * exaggeration;
    return [self roundedFloat:target];
}

- (CGFloat)roundedFloat:(CGFloat)f {
#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
    CGFloat scaleFactor = [UIScreen mainScreen].nativeScale;
#elif TARGET_OS_MAC
    CGFloat scaleFactor = [NSScreen mainScreen].backingScaleFactor;
#endif
    return round(f * scaleFactor) / scaleFactor;
}

@end
