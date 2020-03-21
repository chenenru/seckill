package com.chenenru.gmall.manage;

import org.csource.common.MyException;
import org.csource.fastdfs.ClientGlobal;
import org.csource.fastdfs.StorageClient;
import org.csource.fastdfs.TrackerClient;
import org.csource.fastdfs.TrackerServer;
import org.junit.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;

@SpringBootTest
public class GmallManageWebApplicationTests {

    @Test
    public void contextLoads() throws IOException, MyException {

        String tracker = GmallManageWebApplicationTests.class.getResource("/tracker.conf").getPath();

        ClientGlobal.init(tracker);

        TrackerClient trackerClient = new TrackerClient();

        //获得一个trackerServer实例
        TrackerServer trackerServer = trackerClient.getTrackerServer();

        //通过tracker获得一个Storage链接客户端
        StorageClient storageClient = new StorageClient(trackerServer, null);

        String[] uploadFile = storageClient.upload_file("h:/OHR.PlutoCrescent_ZH-CN3538488331_1920x1080.jpg", "jpg", null);

        String url = "http://192.168.99.100:8888";

        for (String upLoadInfo : uploadFile) {
            url += "/" + upLoadInfo;
        }
        System.out.println(url);
    }

}
