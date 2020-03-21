package com.chenenru.gmall.search;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.PmsBaseCatalog1;
import com.chenenru.gmall.bean.PmsBaseCatalog2;
import com.chenenru.gmall.bean.PmsBaseCatalog3;
import com.chenenru.gmall.search.JSON.Tool;
import com.chenenru.gmall.service.CatalogService;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.*;
import java.util.List;
import java.util.Random;

@RunWith(SpringRunner.class)
@SpringBootTest
public class GmallSearchWebApplicationTests {

    @Reference
    CatalogService catalogService;
    public static void main(String[] args){
    }

    @Test
    public void contextLoads() throws IOException, JSONException {
        Random random=new Random();//创建random实例对象，程序中会用，用于产生随机数
        Tool tool=new Tool();//创建格式化json字符串工具类
        JSONArray jsonArray=new JSONArray();//创建JSONArray对象
        File file=new File("Test.json");
        if(!file.exists())//判断文件是否存在，若不存在则新建
        {
            file.createNewFile();
        }
        FileOutputStream fileOutputStream=new FileOutputStream(file);//实例化FileOutputStream
        OutputStreamWriter outputStreamWriter=new OutputStreamWriter(fileOutputStream,"utf-8");//将字符流转换为字节流
        BufferedWriter bufferedWriter= new BufferedWriter(outputStreamWriter);//创建字符缓冲输出流对象


        List<PmsBaseCatalog1> catalog1 = catalogService.getCatalog1();
        System.out.println(catalog1.toString());
        for (PmsBaseCatalog1 pmsBaseCatalog1:catalog1){
            List<PmsBaseCatalog2> catalog2 = catalogService.getCatalog2(pmsBaseCatalog1.getId());
            for (PmsBaseCatalog2 pmsBaseCatalog2:catalog2){
                List<PmsBaseCatalog3> catalog3 = catalogService.getCatalog3(pmsBaseCatalog2.getId());
                /*for (PmsBaseCatalog3 pmsBaseCatalog3:catalog3){
                    //JSONObject jsonObject=new JSONObject();//创建JSONObject对象

                    //jsonObject.put("Num",random.nextInt(100)+1);

                    //jsonArray.put(jsonObject);//将jsonObject对象旁如jsonarray数组中

                }*/
                pmsBaseCatalog2.setCatalog3List(catalog3);
            }
            pmsBaseCatalog1.setCatalog2s(catalog2);
        }
        System.out.println(catalog1.toString());




        /*for(int i=0;i<5;i++){
            JSONObject jsonObject=new JSONObject();//创建JSONObject对象
            jsonObject.put("Num",random.nextInt(100)+1);//产生1-100的随机数
            jsonObject.put("age",random.nextInt(8)+18);//产生18-25的随机数
            jsonObject.put("Goal",random.nextInt(41)+60);//产生60-100的随机数
            jsonArray.put(jsonObject);//将jsonObject对象旁如jsonarray数组中
        }*/
        jsonArray.put(catalog1);
        String jsonString=jsonArray.toString();//将jsonarray数组转化为字符串
        String JsonString=tool.stringToJSON(jsonString);//将jsonarrray字符串格式化
        bufferedWriter.write(JsonString);//将格式化的jsonarray字符串写入文件
        bufferedWriter.flush();//清空缓冲区，强制输出数据
        bufferedWriter.close();//关闭输出流
    }

}
