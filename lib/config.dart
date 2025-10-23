class Config {
  /*
   * product 青桐智盒项目
   */
  // 生产环境baseUrl
  static final String hostUrl = 'https://services.njscgzc.cn:9000/';
  // 电子公证书
  static const String notarialCertificate =
      "https://sc.njguochu.com:9229/notarialCertificate";
  // mqt 配置
  static String mqttPath = "wss://www.scgzdt.cn/ws";
  static int mqttPort = 15679;
  static String mqttAccount = "gc";
  static String mqttPassword = "Iml5imyb";
  // ca签字
  static String caUrl = "https://scgzdt.com:9007/";

  /*
   * test  测试环境baseUrl
   */

// //  南京测试地址
//   static final String hostUrl = 'https://testgz.njguochu.com:22203/';
//   // ca签字
//   static String caUrl = "https://testgz.njguochu.com:19006/";
// //  电子公证书
//   static const String notarialCertificate =
//       "https://testgz.njguochu.com:29200/notarialCertificate";
//
//   // // mqtt地址
//   static String mqttPath = "wss://testgz.njguochu.com:33672/ws";
//   static int mqttPort = 33672;
//   static String mqttAccount = "admin";
//   static String mqttPassword = "aaaaaa";

//     // 武汉测试地址
//   static final String hostUrl = 'https://testgz.njguochu.com:28074';
//   // ca签字
//   static Sqttring caUrl = "https://testgz.njguochu.com:19006/";
// //  电子公证书
//   static const String notarialCertificate =
//       "https://testgz.njguochu.com:29200/notarialCertificate";
//   //
//   // mqtt地址
//   static String mqttPath = "wss://testgz.njguochu.com:28079/ws";
//   static int mqttPort = 28079;
//   static String mqttAccount = "admin";
//   static String mqttPassword = "n#o0Scmdamg6";
  /*
   * local
   * */
  // 宋光程
  // static final String hostUrl = "http://qftg7a.natappfree.cc"; //'http://192.168.0.45:9000/';
  // 包文磊
  // static final String hostUrl = 'http://192.168.1.50:9000/';
  // 霍邵东
  // static final String hostUrl = 'http://192.168.1.51:9000/';
  // 华文川
  // static final String hostUrl = 'http://192.168.0.107:9000/';
  // 张启东 192.168.1.18
  // static final String hostUrl = 'http://192.168.1.18:9000/';
  // 顾桂杰
  // static final String  hostUrl = 'http://192.168.1.34:9000/';
  // test http://192.168.1.37:9528/
  // static final String hostUrl = 'http://15850686312.gnway.cc:80/';
  // http://192.168.1.189:8001/lotteryOrder
  // 张浩杰
  // static String hostUrl = 'http://192.168.1.32:9000/';

  // mqt配置
  // static String mqttPath = "ws://192.168.1.234:15675/ws";
  // static int mqttPort = 15675;
  // static String mqttAccount = "guest";
  // static String mqttPassword = "guest";shi

  // static String mqttPath = "ws://192.168.1.242:15675/ws";
  // static int mqttPort = 15675;
  // static String mqttAccount = "admin";
  // static String mqttPassword = "12345";

  // static String mqttPath = "ws://192.168.1.242:15675/ws";
  // static int mqttPort = 15675;
  // static String mqttAccount = "guest";
  // static String mqttPassword = "guest";

  // static  String caUrl = "https://scgzdt.com:9005/";

  // static  String caUrl = "https://shicheng.njguochu.com:9223/";0+*

  //缓存对象
  static final String lastUserAcc = 'LastUserAccount';

  // 缓存用户手机号
  static final String lastUserPhoneNumber = "lastUserPhoneNumber";

  // 缓存用户密码
  static final String lastUserPassWord = "lastUserPassWord";

  /*
  * 全局静态变量配置
  */

  //声网RTC 的 APP_ID 和 Token
  static String aPPId = '';
  static String token = '';

  //腾讯RTC 的 _sdkAppId 和 _secretKey
  static int sdkAppId = 1400454379;
  static String secretKey =
      '134d9892e8eb661c7d34f3e7476369ee9280e76f02157067c1ad5c10c6479ac5';

  //模块
  static String userModule = "/user-api";
  static String notaryModule = "/notarization";
  static String annexModule = "/annex";
  static String voteModule = "/vote";
  static String buyersModule = "/buyers-api";
  static String parkModule = "/park";
  static String identificationModule = "/identification";
  static String bankModule = "/bank";
  static String caModule = "/cgz";
  static String enforcement = '/enforcement-api';
  static String easyEnforcement = '/easy-enforcement-api';
  static String room = '/yxroom-api';
  static String appraise = "/appraise";
  static String fileSever = '/file-server';

  ///头像地址
  static String splicingImageUrl(String i) {
    //测试 https://shicheng.njguochu.com:9214/ //生产  https://scoss.njguochu.com:45/
    // String imageUrl = "https://shicheng.njguochu.com:9214/";
    // if (imageUrl.isEmpty) {
    //   imageUrl = 'https://scoss.njguochu.com:45/';
    // }
    // imageUrl = imageUrl.replaceAll("\n", "");
    // if (i != null && !i.startsWith("http")) {
    //   return imageUrl.endsWith("/") ? imageUrl + i : imageUrl + "/" + i;
    // } else {
    //   return i;
    //

    // }
    return i;
  }
}
