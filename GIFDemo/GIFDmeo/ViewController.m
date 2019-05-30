//
//  ViewController.m
//  GIFDmeo
//
//  Created by smok on 2017/8/21.
//  Copyright © 2017年 IVPS. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifImgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeAnimatedGif];
    [self showAnimatedGif];
}

- (void)makeAnimatedGif {
    static NSUInteger const kFrameCount = 5;
    // 循环方式：一直循环
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0,}};
    //控制时间
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: @0.4f,}};
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (int i = 0; i < kFrameCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);

    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    
}

- (void)showAnimatedGif {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2017.gif" ofType:nil]];
    self.gifImgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
}

@end
