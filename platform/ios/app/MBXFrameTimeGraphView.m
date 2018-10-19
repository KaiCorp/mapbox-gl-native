#import "MBXFrameTimeGraphView.h"

const CGFloat EXAGGERATION = 4.f * 1000.f;
const CGFloat WIDTH = 4.f;

@interface MBXFrameTimeGraphView ()

@property (nonatomic) CAScrollLayer *scrollLayer;
@property (nonatomic) CAShapeLayer *thresholdLayer;
@property (nonatomic) CGFloat currentX;
//@property (nonatomic) NSMutableArray *barLayers;

@end

@implementation MBXFrameTimeGraphView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.opacity = 0.9f;

    self.scrollLayer = [CAScrollLayer layer];
    self.scrollLayer.scrollMode = kCAScrollHorizontally;
    self.scrollLayer.masksToBounds = YES;
    [self.layer addSublayer:self.scrollLayer];

    self.thresholdLayer = [CAShapeLayer layer];
    self.thresholdLayer.fillColor = [UIColor darkGrayColor].CGColor;
    [self.layer addSublayer:self.thresholdLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!CGRectEqualToRect(self.scrollLayer.frame, self.bounds)) {
        self.scrollLayer.frame = self.bounds;

        CGRect thresholdLineRect = CGRectMake(0, self.frame.size.height - [self renderDurationTargetMilliseconds], self.frame.size.width, 1);
        self.thresholdLayer.path = CGPathCreateWithRect(thresholdLineRect, nil);
    }
}

- (void)updatePathWithFrameDuration:(CFTimeInterval)frameDuration {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.currentX += WIDTH;

    CAShapeLayer *bar = [self barWithFrameDuration:frameDuration];
    bar.position = CGPointMake(self.currentX, self.frame.size.height);

    [self.scrollLayer addSublayer:bar];
    //[self.barLayers addObject:bar];

    // TODO: remove stale bars from the scrolllayer.

//    if (self.barLayers.count > (self.frame.size.width / WIDTH * 5)) {
//        [self.barLayers removeObjectsInRange:NSMakeRange(0, self.frame.size.width / WIDTH * 4)];
//        NSLog(@"Removed %.f bars from array", self.frame.size.width / WIDTH * 4);
//    }

    [self.scrollLayer scrollToPoint:CGPointMake(self.currentX - self.frame.size.width, 0)];

    [CATransaction commit];
}

- (CGFloat)renderDurationTargetMilliseconds {
    CGFloat target = (1.0 / UIScreen.mainScreen.maximumFramesPerSecond) * EXAGGERATION;
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

- (CAShapeLayer *)barWithFrameDuration:(CFTimeInterval)frameDuration {
    CAShapeLayer *bar = [CAShapeLayer layer];

    CGRect barRect = CGRectMake(0, 0, WIDTH, -(fminf(frameDuration * EXAGGERATION, self.frame.size.height)));
    UIBezierPath *barPath = [UIBezierPath bezierPathWithRect:barRect];
    bar.path = barPath.CGPath;
    bar.fillColor = [self colorForFrameDuration:frameDuration].CGColor;

    return bar;
}

- (UIColor *)colorForFrameDuration:(CFTimeInterval)frameDuration {
    CGFloat renderDurationTargetMilliseconds = [self renderDurationTargetMilliseconds];
    frameDuration *= EXAGGERATION;

    if (frameDuration < renderDurationTargetMilliseconds && frameDuration > (renderDurationTargetMilliseconds * 0.75)) {
        // Warning: orange
        return [UIColor colorWithRed:(CGFloat)(255.f/255.f) green:(CGFloat)(154.f/255.f) blue:(CGFloat)(82.f/255.f) alpha:1.f];
    } else if (frameDuration > renderDurationTargetMilliseconds) {
        // Danger: red
        return [UIColor colorWithRed:(CGFloat)(255.f/255.f) green:(CGFloat)(91.f/255.f) blue:(CGFloat)(86.f/255.f) alpha:1.f];
    } else {
        // OK: green
        return [UIColor colorWithRed:(CGFloat)(0.f/255.f) green:(CGFloat)(190.f/255.f) blue:(CGFloat)(123.f/255.f) alpha:1.f];
    }
}

@end
