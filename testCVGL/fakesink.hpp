//
//  fakesink.h
//  testCVGL
//
//  Created by takujifunao on 2016/11/10.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#ifndef fakesink_h
#define fakesink_h

#include <stdio.h>
#include <iostream>
#include <gst/gst.h>
#include <gst/video/video.h>
#include <opencv2/core.hpp>
#include <opencv2/videoio/videoio_c.h>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/videoio.hpp>
#import <GLKit/GLKit.h>

void fake_mainGst();
void createCVWin();

#endif /* fakesink_h */
