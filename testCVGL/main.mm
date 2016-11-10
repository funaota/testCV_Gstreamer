//
//  main.cpp
//  testCVGL
//
//  Created by takujifunao on 2016/10/28.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#include "fakesink.hpp"
#include "appsink.hpp"
#include <stdio.h>
#include <iostream>

int main(int argc, char * argv[]) {
    
    gst_init(&argc, &argv);
   
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      fake_mainGst();
       	// app_mainGst(); 
   });
//    
   while(1){
   		createCVWin();
       	// app_createCVWin();
   }
    
    return 0;
}


