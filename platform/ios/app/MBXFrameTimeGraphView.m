#import "MBXFrameTimeGraphView.h"

@interface MBXFrameTimeGraphView ()

@property (nonatomic) CAScrollLayer *scrollLayer;
@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) UIBezierPath *path;

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
}

- (void)updatePathWithFrameDuration:(CFTimeInterval)frameDuration {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGPoint newPoint = CGPointMake(self.path.currentPoint.x + 1.0, self.scrollLayer.frame.size.height - fminf(frameDuration * 10000, self.scrollLayer.frame.size.height));

    [self.path addLineToPoint:newPoint];

    //NSLog(@"New line at %@", NSStringFromCGPoint(newPoint));

    self.shapeLayer.path = self.path.CGPath;

    [self.scrollLayer scrollToPoint:CGPointMake(self.path.currentPoint.x + 1.0 - self.frame.size.width, 0)];

    [CATransaction commit];
}

@end
