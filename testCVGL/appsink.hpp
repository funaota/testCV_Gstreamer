//
//  appsink.h
//  testCVGL
//
//  Created by takujifunao on 2016/11/10.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#ifndef appsink_h
#define appsink_h

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
#include <gst/app/gstappsink.h>
#include <gst/app/app.h>

void app_mainGst();
void app_createCVWin();

#endif /* appsink_h */
