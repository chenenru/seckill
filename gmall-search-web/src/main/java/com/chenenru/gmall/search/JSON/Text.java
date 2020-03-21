package com.chenenru.gmall.search.JSON;

/**
 * @Author chenenru
 * @ClassName Text
 * @Description
 * @Date 2020/3/13 0:02
 * @Version 1.0
 **/
import java.io.*;
import java.util.Random;

import com.chenenru.gmall.bean.PmsBaseCatalog1;
import com.chenenru.gmall.service.CatalogService;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;

public class Text {
    @Autowired
    CatalogService catalogService;
    public static void main(String[] args) throws IOException, JSONException {
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


        for(int i=0;i<5;i++){
            JSONObject jsonObject=new JSONObject();//创建JSONObject对象
            jsonObject.put("Num",random.nextInt(100)+1);//产生1-100的随机数
            jsonObject.put("age",random.nextInt(8)+18);//产生18-25的随机数
            jsonObject.put("Goal",random.nextInt(41)+60);//产生60-100的随机数
            jsonArray.put(jsonObject);//将jsonObject对象旁如jsonarray数组中
        }
        String jsonString=jsonArray.toString();//将jsonarray数组转化为字符串
        String JsonString=tool.stringToJSON(jsonString);//将jsonarrray字符串格式化
        bufferedWriter.write(JsonString);//将格式化的jsonarray字符串写入文件
        bufferedWriter.flush();//清空缓冲区，强制输出数据
        bufferedWriter.close();//关闭输出流
    }
}