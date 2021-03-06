//
//  main.cpp
//  testCVGL
//
//  Created by takujifunao on 2016/10/28.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#include "fakesink.hpp"
#include <stdio.h>
#include <iostream>
#include <gst/gst.h>

int main(int argc, char * argv[]) {
    
    gst_init(&argc, &argv);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        fake_mainGst();
    });
    
    while(1){
        createCVWin();
    }
    
    return 0;
}


