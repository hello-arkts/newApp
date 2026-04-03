import 'IConstant.dart';

class PageConstant {
  //------------------------------------路由部分
  static const WEB_BASE_URI = IConstant.IS_DEBUG ? WEB_TEST_URL : WEB_RELEASE_URL;
  static const WEB_TEST_URL = "https://web.mxcome.com/";
  static const WEB_RELEASE_URL = "https://v.mxcome.com/";
  static const APP_BASE_URI = "mxcome://app/";
  static const MXCOME_WEB_URI = "mxcome://web/";
  static const URI_PARAMS_KEY = "params";
  static const OPEN_TYPE = "open_type";

  static const OPEN_TYPE_POP = 1; //弹层
  static const OPEN_TYPE_NEW = 0; //新窗口

  //--------------------routers----------------------


//------------------------------------js交互部分
  static const JS_OBJECT = "mxcome";

//--------------------js method----------------------
  static const JS_GET_TOKEN = "get_token"; //获取token 无参数
  static const JS_OPEN_LOGIN = "open_login"; //弹出登录 无参数
  static const JS_CLOSE_WINDOW = "close_window"; //关闭窗口

}
