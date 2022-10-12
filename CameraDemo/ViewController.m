//
//  ViewController.m
//  CameraDemo
//
//  Created by Tim.Milne on 10/12/22.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h> // Camera capture

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession                    *_session;
    AVCaptureDevice                     *_device;
    AVCaptureDeviceInput                *_input;
    AVCaptureMetadataOutput             *_output;
    AVCaptureVideoPreviewLayer          *_prevLayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the bar code scanner session, device, input, output, and preview layer
    _session = [[AVCaptureSession alloc] init];
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _device = [self frontCamera];
    
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@\n", error);
    }
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    // Start scanning for barcodes
    [_session startRunning];
}

- (AVCaptureDevice *)frontCamera {
    return [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[ AVCaptureDeviceTypeBuiltInWideAngleCamera ]
                                                                  mediaType:AVMediaTypeVideo
                                                                   position:AVCaptureDevicePositionFront].devices.firstObject;
}

- (AVCaptureDevice *)backCamera {
    return [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[ AVCaptureDeviceTypeBuiltInWideAngleCamera ]
                                                                  mediaType:AVMediaTypeVideo
                                                                   position:AVCaptureDevicePositionBack].devices.firstObject;
}

@end
