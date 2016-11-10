//
//  fakesink.c
//  testCVGL
//
//  Created by takujifunao on 2016/11/10.
//  Copyright © 2016年 takujifunao. All rights reserved.
//

#include "fakesink.hpp"

typedef struct _GstGLBuffer GstGLBuffer;
struct _GstGLBuffer
{
    GstBuffer buffer;
    GObject *obj;
    gint width;
    gint height;
    GLuint texture;
};

GLuint omniTex;
guint8 *ddata;

void onGstBuffer (GstElement * fakesink, GstBuffer * buf, GstPad * pad, gpointer data){
    
    
    GstVideoMeta* videoinfo = gst_buffer_get_video_meta(buf);
    if(videoinfo){
        NSLog(@"width: %d, height: %d",videoinfo->width, videoinfo->height);
        NSLog(@"format: %d",videoinfo->format);
        NSLog(@"format: %d", GST_VIDEO_FORMAT_NV12);
        GstMapInfo map;
        gst_buffer_map(videoinfo->buffer, &map, GST_MAP_READ);
        ddata = map.data;
        gst_buffer_unmap(buf, &map);
    }
}


void createCVWin(){
    
    if(ddata){
        
        cv::Mat mYUV(720 + 720/2,1280,CV_8UC1,ddata);
        cv::Mat mRGB(720,1280,CV_8UC3);
        cv::cvtColor(mYUV, mRGB, CV_YUV2BGRA_NV12, 3);
        
        cv::namedWindow("D", CV_WINDOW_AUTOSIZE);
        cv::imshow("D", mRGB);
        cv::waitKey(10);
        
    }
    
}

void fake_mainGst(){
    
    GMainLoop *loop = NULL;
    GstPipeline *pipeline = NULL;
    GstBus *bus = NULL;
    
    GstElement *fakesink = NULL;
    GstState state;
    GAsyncQueue *queue_input_buf = NULL;
    GAsyncQueue *queue_output_buf = NULL;
    
    loop = g_main_loop_new (NULL, FALSE);
    
    pipeline = GST_PIPELINE (gst_parse_launch("udpsrc port=5003 caps=application/x-rtp,media=(string)video,payload=(int)96,clock-rate=(int)90000,encoding-name=H264 ! rtph264depay ! decodebin ! fakesink sync=1", NULL));
    
    bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
    gst_bus_add_signal_watch (bus);
    gst_object_unref (bus);
    
    gst_element_set_state (GST_ELEMENT (pipeline), GST_STATE_PAUSED);
    state = GST_STATE_PAUSED;
    
    if (gst_element_get_state (GST_ELEMENT (pipeline), &state, NULL, GST_CLOCK_TIME_NONE) != GST_STATE_CHANGE_NO_PREROLL) {
        g_debug ("failed to pause pipeline\n");
        return;
    }
    
    fakesink = gst_bin_get_by_name (GST_BIN (pipeline), "fakesink0");
    g_object_set (G_OBJECT (fakesink), "signal-handoffs", TRUE, NULL);
    g_signal_connect (fakesink, "handoff", G_CALLBACK (onGstBuffer), NULL);
    queue_input_buf = g_async_queue_new ();
    queue_output_buf = g_async_queue_new ();
    g_object_set_data (G_OBJECT (fakesink), "queue_input_buf", queue_input_buf);
    g_object_set_data (G_OBJECT (fakesink), "queue_output_buf", queue_output_buf);
    g_object_set_data (G_OBJECT (fakesink), "loop", loop);
    g_object_unref (fakesink);
    
    gst_element_set_state (GST_ELEMENT (pipeline), GST_STATE_PLAYING);
    
    g_main_loop_run (loop);
    
    gst_element_set_state (GST_ELEMENT (pipeline), GST_STATE_NULL);
    g_object_unref (pipeline);
    
    while (g_async_queue_length (queue_input_buf) > 0) {
        GstBuffer *buf = (GstBuffer *) g_async_queue_pop (queue_input_buf);
        gst_buffer_unref (buf);
    }
    
    while (g_async_queue_length (queue_output_buf) > 0) {
        GstBuffer *buf = (GstBuffer *) g_async_queue_pop (queue_output_buf);
        gst_buffer_unref (buf);
    }
}
