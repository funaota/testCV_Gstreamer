//
//  appsink.c
//  testCVGL
//
//  Created by takujifunao on 2016/11/10.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#include "appsink.hpp"

GMainLoop *loop;
GstElement *pipeline, *appsink;
GError *error = NULL;
guint8 *dddata;

void new_sample(GstElement *sink){
    GstBuffer *buffer;
    GstSample *sample;
    GstMapInfo map;
  
    sample = gst_app_sink_pull_sample(GST_APP_SINK(sink));
    buffer = gst_sample_get_buffer(sample);
    
    gst_buffer_map(buffer, &map, GST_MAP_READ);
    dddata = map.data;
    gst_buffer_unmap(buffer, &map);
    gst_sample_unref(sample);
}

void app_createCVWin(){
    
    if(dddata){
        
        cv::Mat frame(720,1280,CV_8UC3,dddata);
        cv::namedWindow("D", CV_WINDOW_AUTOSIZE);
        cv::imshow("D", frame);
        cv::waitKey(10);
        
        if(frame.data == NULL){
            NSLog(@"data is NULL");
        }else{
            //            glGenTextures(1, &omniTex);
            //            glBindTexture(GL_TEXTURE_2D, omniTex);
            //            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, frame.cols, frame.rows, 0, GL_BGRA, GL_UNSIGNED_BYTE, frame.data);
            //
            
        }
    }
    
}

void app_mainGst(){
    
    
    loop = g_main_loop_new(NULL, FALSE);
    
    pipeline = gst_parse_launch(
                                "udpsrc port=5003 caps=application/x-rtp,media=(string)video,payload=(int)96,clock-rate=(int)90000,encoding-name=H264 ! rtph264depay ! avdec_h264 ! videoconvert ! appsink name=sink"
                                , &error );
    
    if(error != NULL){
        g_print("could not construct pipe: %s",error->message);
        g_error_free(error);
        exit(-1);
    }
    
    appsink = gst_bin_get_by_name(GST_BIN(pipeline), "sink");
    

    NSLog(@"kiteru 1");
    
    g_object_set(appsink, "emit-signals", TRUE, NULL);
    g_object_set(appsink, "sync", TRUE, NULL);
    g_signal_connect(appsink, "new-sample", G_CALLBACK(new_sample), NULL);
    gst_element_set_state(pipeline, GST_STATE_PLAYING);
    

    g_main_loop_run(loop);
    
    
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(GST_OBJECT(pipeline));
    g_main_loop_unref(loop);
    
    
    
}
