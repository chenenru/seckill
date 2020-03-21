package com.chenenru.gmall.manage.util;

import org.csource.fastdfs.ClientGlobal;
import org.csource.fastdfs.StorageClient;
import org.csource.fastdfs.TrackerClient;
import org.csource.fastdfs.TrackerServer;
import org.springframework.web.multipart.MultipartFile;


/**
 * @Author chenenru
 * @ClassName PmsUpLoadUtil
 * @Description
 * @Date 2020/2/19 16:55
 * @Version 1.0
 **/
public class PmsUpLoadUtil {
    public static String uploadImage(MultipartFile multipartFile) {
        String imgUrl = "http://192.168.99.100:8888";

        String tracker = PmsUpLoadUtil.class.getResource("/tracker.conf").getPath();

        try {
            ClientGlobal.init(tracker);
        } catch (Exception e) {
            e.printStackTrace();
        }

        TrackerClient trackerClient = new TrackerClient();

        //获得一个trackerServer实例
        TrackerServer trackerServer = null;
        try {
            trackerServer = trackerClient.getTrackerServer();
        } catch (Exception e) {
            e.printStackTrace();
        }

        //通过tracker获得一个Storage链接客户端
        StorageClient storageClient = new StorageClient(trackerServer, null);

        String[] uploadFile = new String[0];
        try {
            byte[] bytes = multipartFile.getBytes();//获取上传文件的二进制对象
            //获取文件后缀名
            String originalFilename = multipartFile.getOriginalFilename();
            int i = originalFilename.lastIndexOf(".");
            String extName = originalFilename.substring(i + 1);
            uploadFile = storageClient.upload_file(bytes, extName, null);

            for (String upLoadInfo : uploadFile) {
                imgUrl += "/" + upLoadInfo;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return imgUrl;
    }
}
