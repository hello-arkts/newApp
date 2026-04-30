import 'package:mxcome/com/mxcome/app/IConstant.dart';

class IURLConstant {
  static const BASE_URL = IConstant.IS_DEBUG ? BASE_TEST_URL : BASE_RELEASE_URL;
  //开发地址
  //static const BASE_URL = 'http://192.168.31.108:8201';

  static const BASE_TEST_URL = "https://app-api.mxcome.com";

  static const BASE_RELEASE_URL = "https://gateway.mxcome.com";

  static const AUTH_CODE_URL =
      "${BASE_URL}/mall-portal/util/getAuthCode"; //获取验证码

  static const CHECK_CODE_URL =
      "${BASE_URL}/mall-portal/util/checkAuthCode"; //检查验证码

  static const REGISTER_URL = "${BASE_URL}/mall-portal/sso/register"; //注册

  static const SET_PASSWORD_URL =
      "${BASE_URL}/mall-portal/sso/setPassword"; //设置密码

  static const SET_PAY_PASSWORD_URL =
      "${BASE_URL}/mall-portal/sso/setPayPassword"; //设置支付密码

  static const UPDATE_PASSWORD_URL =
      "${BASE_URL}/mall-portal/util/updatePassword"; //修改密码

  static const LOGIN_URL = "${BASE_URL}/mall-portal/sso/login"; //登录

  static const INIT_URL = "${BASE_URL}/mall-auth/oauth/token"; //初始化

  static const LOGOUT_URL = "${BASE_URL}/mall-portal/sso/exitLogin"; //登出

  static const THREE_CHECK_PHONE =
      "${BASE_URL}/mall-portal/sso/checkThirdLogin"; //检查第三方是否绑定和登录

  static const THREE_REGISTER =
      "${BASE_URL}/mall-portal/sso/thirdBind"; //第三方注册登录

  static const MALL_HOME_CONTENT =
      "${BASE_URL}/mall-portal/home/content"; //首页广告内容

  static const MALL_NEW_PRODUCT_LIST =
      "${BASE_URL}/mall-portal/home/newProductList"; //推荐新品商品

  static const MALL_RECOMMEND_PRODUCT_LIST =
      "${BASE_URL}/mall-portal/home/recommendProductList"; //推荐商品列表

  static const MALL_PRODUCT_DETAIL =
      "${BASE_URL}/mall-portal/product/detail/"; //商品详情

  static const MALL_CATEGORY_TREE_LIST =
      "${BASE_URL}/mall-portal/product/categoryTreeList"; //商品分类

  static const MALL_HOT_CATEGORY =
      "${BASE_URL}/mall-portal/home/hotCategory"; //热门品种

  static const MALL_HOT_PRODUCT_CATEGORY2 =
      "${BASE_URL}/mall-portal/home/hotProductByCategory2"; //通过二级分类查询热销产品

  static const MALL_GET_SHOP_LIST_CATEGORY =
      "${BASE_URL}/mall-portal/home/getShopListByCategory"; //根据分类获取店铺

  static const MALL_GET_SUPER_WEDNESDAY =
      "${BASE_URL}/mall-portal/pocket/getSuperWednesday"; //超级星期三列表

  static const MALL_CART_LIST = "${BASE_URL}/mall-portal/cart/list"; //购物车列表

  static const MALL_CART_ADD = "${BASE_URL}/mall-portal/cart/add"; //添加购物车

  static const MALL_CART_UPDATE_QUANTITY =
      "${BASE_URL}/mall-portal/cart/update/quantity"; //修改购物车中某个商品的数量

  static const MALL_CART_DELETE =
      "${BASE_URL}/mall-portal/cart/delete"; //删除购物车中的某个商品

  static const MALL_MEMBER_ADDRESS_LIST =
      "${BASE_URL}/mall-portal/member/address/list"; //收货地址

  static const MALL_MEMBER_ADDRESS_ADD =
      "${BASE_URL}/mall-portal/member/address/add"; //增加收货地址

  static const MALL_MEMBER_ADDRESS_UPDATE =
      "${BASE_URL}/mall-portal/member/address/update/"; //修改收货地址

  static const MALL_MEMBER_ADDRESS_DELETE =
      "${BASE_URL}/mall-portal/member/address/delete/"; //删除收货地址

  static const MALL_UTIL_GET_REGION =
      "${BASE_URL}/mall-portal/util/getRegion"; //获取行政区域

  static const MALL_UTIL_GETREGION =
      "${BASE_URL}/mall-portal/util/getRegion"; //获取一级行政区域

  static const MALL_UTIL_GETCITY =
      "${BASE_URL}/mall-portal/util/getCity"; //获取二级行政区域

  static const MALL_UTIL_GETAREA =
      "${BASE_URL}/mall-portal/util/getArea"; //获取二级行政区域

  static const MALL_SSO_INFO = "${BASE_URL}/mall-portal/sso/info"; //获取会员信息

  static const MALL_ORDER_GENERATE_CONFIRM_ORDER =
      "${BASE_URL}/mall-portal/order/generateConfirmOrder"; //根据购物车信息生成确认单

  static const MALL_GET_PRICE_ADDRESS_ID =
      "${BASE_URL}/mall-portal/order/getPriceByAddressId"; //通过收货地址查询运费

  static const MALL_ORDER_PLACE_CONFIRM_ORDER =
      "${BASE_URL}/mall-portal/order/placeConfirmOrder"; //根据商品信息生成确认单

  static const MALL_ORDER_GENERATE_ORDER =
      "${BASE_URL}/mall-portal/order/generateOrder"; //生成订单

  static const MALL_ORDER_LIST =
      "${BASE_URL}/mall-portal/order/list"; //按状态分页获取用户订单列表

  static const MALL_ORDER_CANCEL_USER_ORDER =
      "${BASE_URL}/mall-portal/order/cancelUserOrder"; //取消订单

  static const MALL_ORDER_DELETE_ORDER =
      "${BASE_URL}/mall-portal/order/deleteOrder"; //删除订单

  static const MALL_COLLECTION_ADD =
      "${BASE_URL}/mall-portal/member/productCollection/add"; //添加收藏

  static const MALL_COLLECTION_DELETE =
      "${BASE_URL}/mall-portal/member/productCollection/delete"; //删除收藏

  static const MALL_COLLECTION_LIST =
      "${BASE_URL}/mall-portal/member/productCollection/list"; //显示收藏列表

  static const MALL_POCKET_HOME =
      "${BASE_URL}/mall-portal/pocket/pocketHome"; //口袋首页

  static const MALL_BANK_LIST = "${BASE_URL}/mall-portal/sso/bankList"; //银行卡列表

  static const MALL_ADD_BANK = "${BASE_URL}/mall-portal/sso/addBank"; //添加银行卡

  static const MALL_EDIT_BANK = "${BASE_URL}/mall-portal/sso/editBank"; //修改银行卡

  static const MALL_DELETE_BANK =
      "${BASE_URL}/mall-portal/sso/deleteBank"; //删除银行卡

  static const MALL_THIRD_BIND_LIST =
      "${BASE_URL}/mall-portal/sso/thirdBindList"; //用户第三方绑定列表

  static const MALL_BIND_THIRD =
      "${BASE_URL}/mall-portal/sso/bindThird"; //绑定第三方

  static const MALL_UNBINDT_THIRD =
      "${BASE_URL}/mall-portal/sso/unbindThird"; //解绑第三方

  static const MALL_POCKET_ADD = "${BASE_URL}/mall-portal/pocket/add"; //添加口袋任务

  static const MALL_PRODUCT_POCKET_LIST =
      "${BASE_URL}/mall-portal/pocket/list"; //根据商品ID查出任务口袋

  static const MALL_POCKET_MEMBER_SAVE =
      "${BASE_URL}/mall-portal/pocketMember/save"; //接受任务

  static const MALL_MERCHANT_PRODUCT =
      "${BASE_URL}/mall-portal/product/findByMerchantId"; //查询商户的商品

  static const MALL_GET_POCKET_CONFIG =
      "${BASE_URL}/mall-portal/pocket/getPocketConfig"; //查看规则

  static const MALL_GET_POCKET_MEMBER =
      "${BASE_URL}/mall-portal/pocket/getPocketMember"; //历史任务

  static const MALL_BALANCE_LIST =
      "${BASE_URL}/mall-portal/sso/balanceList"; //余额变动明细

  static const MALL_UPDATE_INFO =
      "${BASE_URL}/mall-portal/sso/updateInfo"; //编译个人信息

  static const MALL_PARSE_FILES =
      "${BASE_URL}/mall-portal/util/parseFiles"; //上传文件

  static const MALL_UPDATE_ICON =
      "${BASE_URL}/mall-portal/sso/updateIcon"; //修改头像

  static const MALL_ADD_IDENTITY_INFO =
      "${BASE_URL}/mall-portal/sso/addMemberIdentityInfo"; //添加实名认证

  static const MALL_GET_IDENTITY_INFO =
      "${BASE_URL}/mall-portal/sso/getMemberIdentityInfo"; //查询实名认证

  static const MALL_UPDATE_GENERATORID =
      "${BASE_URL}/mall-portal/sso/updateGeneratorId"; //变更账号ID

  static const MALL_UPDATE_PHONE =
      "${BASE_URL}/mall-portal/sso/updatePhone"; //修改手机号

  static const MALL_PRODUCT_SEARCH =
      "${BASE_URL}/mall-portal/product/search"; //搜索产品

  static const MALL_SIGN_WEEK_LIST =
      "${BASE_URL}/mall-portal/sso/signWeekList"; //签到本周记录

  static const MALL_SIGN = "${BASE_URL}/mall-portal/sso/sign"; //签到

  static const MALL_FILL_SIGN = "${BASE_URL}/mall-portal/sso/fillSign"; //补签

  static const MALL_PAY_SUCCESS =
      "${BASE_URL}/mall-portal/order/paySuccess"; //支付成功回调

  static const MALL_ACTIVITY_LIST =
      "${BASE_URL}/mall-portal/activityMember/list"; //现有活动列表

  static const MALL_ACTIVITY_GET_INFO =
      "${BASE_URL}/mall-portal/activityMember/getInfo"; //活动详情

  static const MALL_ACTIVITY_SAVE =
      "${BASE_URL}/mall-portal/activityMember/save"; //会员领取活动

  static const MALL_FIND_CONFIG_BY_ACTIVITY =
      "${BASE_URL}/mall-portal/activityMember/findConfigByActivity"; //查询可领取排名奖励

  static const MALL_FIND_GIFT_BY_ACTIVITY =
      "${BASE_URL}/mall-portal/activityMember/findGiftByActivity"; //查询可领取关卡奖励

  static const MALL_FIND_GIFT_BY_POCKET_CODE =
      "${BASE_URL}/mall-portal/pocketMember/findGiftByPocketCode"; //根据口袋码查出可领取赠品

  static const MALL_ACTIVITY_MEMBER_INFO =
      "${BASE_URL}/mall-portal/activityMember/getActivityMemberInfo"; //活动会员信息

  static const MALL_GENERATE_CONFIRM_GIFT_ORDER =
      "${BASE_URL}/mall-portal/order/generateConfirmGiftOrder"; //根据赠品领取确认单信息

  static const MALL_GET_POCKET_INFO =
      "${BASE_URL}/mall-portal/pocket/getPocketInfo"; //获取任务赠品详情

  static const MALL_FIND_END_ACTIVITY =
      "${BASE_URL}/mall-portal/activityMember/findEndActivity"; //历史活动

  static const MALL_CONFIRM_RECEIVE_ORDER =
      "${BASE_URL}/mall-portal/order/confirmReceiveOrder"; //确认收货

  static const MALL_ORDER_PAYAPPLY =
      "${BASE_URL}/mall-portal/order/payApply"; //在线支付申请（合并订单）

  static const MALL_ORDER_PAYAPPLY_SHOP =
      "${BASE_URL}/mall-portal/order/payApplyShop"; //在线支付申请（店铺订单）

  static const MALL_ORDER_BALANCE_PAYAPPLY =
      "${BASE_URL}/mall-portal/order/balancePayApply"; //余额支付申请（合并订单）

  static const MALL_ORDER_BALANCE_PAYAPPLY_SHOP =
      "${BASE_URL}/mall-portal/order/balancePayApplyShop"; //余额支付申请（店铺订单）

  static const MALL_ACTIVITY_GET_POCKET_LIST =
      "${BASE_URL}/mall-portal/activityMember/getPocketList"; //根据活动查询任务口袋列表

  static const MALL_ORDER_DETAIL =
      "${BASE_URL}/mall-portal/order/detail/"; //订单详情

  static const MALL_POCKET_FIND_BY_BUY =
      "${BASE_URL}/mall-portal/pocketMember/findByBuy"; //购买记录

  static const MALL_POCKET_FIND_BY_RETURN =
      "${BASE_URL}/mall-portal/pocketMember/findByReturn"; //退单记录

  static const MALL_REGISTER_TOKEN =
      "${BASE_URL}/mall-portal/sso/getUserRegistrationTokens"; //注册token

  static const MALL_UPDATE_ADDRESS =
      "${BASE_URL}/mall-portal/order/updateAddress"; //修改收货地址

  static const MALL_LOGISTICS_INFO =
      "${BASE_URL}/mall-portal/order/getLogisticsInfo"; //查看物流

  static const MALL_GET_SHOP_INFO =
      "${BASE_URL}/mall-portal/shop/getShopInfo"; //店铺详情接口

  static const MALL_SHOP_CATEGORY_TREE =
      "${BASE_URL}/mall-portal/shop/getShopCategoryTree"; //店铺树形分类

  static const MALL_GET_PRODUCT_LABEL =
      "${BASE_URL}/mall-portal/shop/getProductByLabel"; //通过标签和条件查询店铺商品

  static const MALL_AFTER_SALES_LIST =
      "${BASE_URL}/mall-portal/returnApply/getAfterSalesList"; //售后列表

  static const MALL_RETRUN_APPLY_CREATE =
      "${BASE_URL}/mall-portal/returnApply/create"; //申请售后

  static const MALL_RETURN_APPLY_PLATFORM_IN =
      "${BASE_URL}/mall-portal/returnApply/platformIn"; //平台介入

  static const MALL_RETURN_APPLY_CANCEL =
      "${BASE_URL}/mall-portal/returnApply/cancel"; //取消申请

  static const MALL_RETURN_APPLY_INFO_BY_ORDER_ID =
      "${BASE_URL}/mall-portal/returnApply/getReturnInfoByOrderId"; //通过orderId查询售后详情

  static const MALL_CHECK_PAY_PASSWORD =
      "${BASE_URL}/mall-portal/sso/checkPayPassword"; //验证支付密码

  static const MALL_OSS_WITHDRAW = "${BASE_URL}/mall-portal/sso/withdraw"; //提现

  static const MALL_OSS_GET_WITHDRAW_INFO =
      "${BASE_URL}/mall-portal/sso/getWithdrawInfo"; //提现信息

  static const MALL_INCOME_INFO =
      "${BASE_URL}/mall-portal/pocketMember/getIncomeInfo"; //收益明细

  static const MALL_GET_POCKET_ACTIVITY_LEVEL =
      "${BASE_URL}/mall-portal/pocketMember/getPocketByActivityLevel"; //所有活动任务

  static const MALL_GET_PAY_RESULT =
      "${BASE_URL}/mall-portal/order/getPayResult"; //查询支付结果

  static const MALL_DELETE_USER =
      "${BASE_URL}/mall-portal/util/exitUser"; //注销账号

  static const MALL_GET_ORDER_STATUS_NUM =
      "${BASE_URL}/mall-portal/order/getOrderStatusNUm"; //获取订单数

  static const MALL_GET_LOGISTICS =
      "${BASE_URL}/mall-portal/order/getLogistics"; //获取配送方式和快递公司

  static const MALL_GIVE_UP_ACTIVITY =
      "${BASE_URL}/mall-portal/activityMember/giveUpActivity"; //放弃活动

  static const MALL_PASS_LEVEL =
      "${BASE_URL}/mall-portal/activityMember/passLevel"; //继续闯关

  static const MALL_GET_ACTIVITY_PROFIT_AMOUNT =
      "${BASE_URL}/mall-portal/activityMember/getActivityProfitAmount"; //淘金收益查询

  static const MALL_GET_ACTIVITY_RANDOM_LEVEL_GIFT =
      "${BASE_URL}/mall-portal/activityMember/getActivityRandomLevelGift"; //查询活动抽中的奖品

  static const MALL_GET_RANDOM_LEVEL_GIFT =
      "${BASE_URL}/mall-portal/activityMember/getRandomLevelGift"; //关卡抽奖

  static const MALL_VERSION_INFO =
      "${BASE_URL}/mall-portal/util/versionInfo"; //版本更新

  static const MALL_GET_BANK = "${BASE_URL}/mall-portal/util/getBank"; //获取银行

  static const MALL_RETURN_APPLY_CONFIRM =
      "${BASE_URL}/mall-portal/returnApply/createConfirm"; //确认退款

  static const MALL_IS_BETA = "${BASE_URL}/mall-portal/util/isBeta"; //是否是beta环境

  static const MALL_EXCHANGE_GIFT_LIST =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/exchangeGiftList"; //兑换奖品

  static const MALL_EXCHANGE_GIFT =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/exchangeGift"; //兑换奖品

  static const MALL_RED_HOME = "${BASE_URL}/mall-portal/red/redHome"; //红包首页

  static const MALL_RED_RECORD_LIST =
      "${BASE_URL}/mall-portal/red/redRecordList"; //红包推广明细

  static const MALL_GET_RECEIVE_GIFT =
      "${BASE_URL}/mall-portal/pocket/getReceiveGift"; //查询可领取奖品

  static const MALL_COUPON_CENTER_LIST =
      "${BASE_URL}/mall-portal/member/coupon/couponList"; //领券中心列表

  static const MALL_MY_COUPON_LIST =
      "${BASE_URL}/mall-portal/member/coupon/myCouponList"; //我的优惠券

  static const MALL_CHANGE_POCKET =
      "${BASE_URL}/mall-portal/pocketMember/changePocket"; //更换任务

  static const MALL_FIND_PRODUCT_BY_POCKET =
      "${BASE_URL}/mall-portal/pocket/findProductByPocket"; //分页查询推荐任务

  static const MALL_MY_EXCHANGE_GIFTS =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/myExchangeGifts"; //查询我的兑换礼品订单列表

  static const MALL_COUPON_ADD =
      "${BASE_URL}/mall-portal/member/coupon/add/"; //领取指定优惠券

  static const MALL_PRODUCT_COUPON_LIST =
      "${BASE_URL}/mall-portal/member/coupon/productOfCouponList"; //当前优惠券的商品列表

  static const MALL_PRIZE_BUY_LIST =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/buyList"; //奖品的购买记录

  static const MALL_PRIZE_USE_ORDER =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/useOrder"; //使用实物奖品

  static const MALL_USE_COUPON_ID =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/useCouponById"; //使用兑换券奖品

  static const MALL_EXCHANGE_GIFT_DETAIL =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/exchangeGiftDetail"; //查询兑换礼品详情

  static const MALL_PRIZE_LOGISTICS_DETAIL_LIST =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/logisticsDetailList"; //物流信息列表

  static const MALL_PRIZE_CONFIRM_ORDER =
      "${BASE_URL}/mall-portal/exchangeGiftCoupon/confirmOrder"; //确认收货

  static const MALL_RETURN_CREATE_COUPON =
      "${BASE_URL}/mall-portal/returnApply/createCoupon"; //确认收货

  static const MALL_MERGE_PAY_POPUP =
      "${BASE_URL}/mall-portal/order/getPayApplyInfo"; //合并支付弹窗

  static const MALL_MERGE_ORDER_CANCEL =
      "${BASE_URL}/mall-portal/order/cancelUserOrderAll"; //合并取消订单

  static const MALL_FINISH_RED_WINDOW =
      "${BASE_URL}/mall-portal/red/endRedWindow"; //完成红包弹窗

  static const MALL_GET_SYSTEM_SETTINGS =
      "${BASE_URL}/mall-portal/util/settingInfo"; //获取系统设置信息

  static const MALL_GET_SERVICE_TIME =
      "${BASE_URL}/mall-portal/util/serviceTime"; //获取服务时间

  static const MALL_GET_HISTORY_RED =
      "${BASE_URL}/mall-portal/red/historyRedHome"; //获取历史红包

  static const MALL_CREATE_KOL_LINK =
      "${BASE_URL}/mall-portal/sso/createKolLink"; //修改昵称

  static const MALL_SSO_MY_SUBORDINATE =
      "${BASE_URL}/mall-portal/sso/getChildListByMemberId"; //我的下级

  static const MALL_SSO_REBATE_HOME =
      "${BASE_URL}/mall-portal/sso/rebateHome"; //消费返利中心

  static const MALL_SSO_BIND_SUPERIOR =
      "${BASE_URL}/mall-portal/sso/bindParentMember"; //绑定上级用户

  static const MALL_SSO_INFO_BY_ID =
      "${BASE_URL}/mall-portal/sso/getMemberByMemberId"; //根据用户id获取用户信息

  static const MALL_SSO_REBATE_DETAIL =
      "${BASE_URL}/mall-portal/sso/rebateInfo"; //消费返利明细

  static const MALL_SSO_REBATE_CYCLE =
      "${BASE_URL}/mall-portal/sso/rebateCycle"; //消费返利周期

  static const MALL_KOL_GET_NUMSAI_KOL =
      "${BASE_URL}/mall-portal/kol/getNumsaiKol"; //消费返利周期

  static const MALL_SSO_GET_BALANCE_WINDOW =
      "${BASE_URL}/mall-portal/sso/getBalanceWindow"; //每日福利余额变动弹窗

  static const MALL_SSO_END_BALANCE_WINDOW =
      "${BASE_URL}/mall-portal/sso/endBalanceWindow"; //结束弹窗

  static const MALL_KOL_GET_RED_AMOUNT =
      "${BASE_URL}/mall-portal/kol/getRedAmount"; //获取红包总额

  static const MALL_SEND_EMAIL =
      "${BASE_URL}/mall-portal/sso/sendEmail"; //发送邮箱验证码

  static const MALL_BINDING_EMAIL =
      "${BASE_URL}/mall-portal/sso/BindingEmail"; //绑定邮箱

  static const MALL_GET_COIN_LIST =
      "${BASE_URL}/mall-portal/sso/getCoinListMemberId"; //获取用户提币地址

  static const MALL_COIN_WITHDRAW =
      "${BASE_URL}/mall-portal/sso/coinWithdraw"; //用户提币

  static const MALL_COIN_TRADE = "${BASE_URL}/mall-portal/sso/CoinTrade"; //用户转让

  static const MALL_COIN_TRADE_LIST =
      "${BASE_URL}/mall-portal/sso/getCoinTradeList"; //转让记录

  static const MALL_COIN_WITHDRAW_LIST =
      "${BASE_URL}/mall-portal/sso/getCoinWithdrawList"; //转出记录

  static const MALL_DRAW_PRODUCT_LIST =
      "${BASE_URL}/mall-portal/drawProduct/productList"; //抽奖产品列表

  static const MALL_DRAW_PRODUCT =
      "${BASE_URL}/mall-portal/drawProduct/draw"; //中奖产品

  static const MALL_DRAW_PRODUCT_HISTORY =
      "${BASE_URL}/mall-portal/drawProduct/drawProductList"; //中奖产品记录

  static const MALL_PRODUCT_ADVERTISING =
      "${BASE_URL}/mall-portal/sso/productAdvertising"; //虚拟商品广告

  static const MALL_DRAW_PRODUCT_DETAIL =
      "${BASE_URL}/mall-portal/drawProduct/detail/"; //中奖商品详情

  static const MALL_FIND_DRAW_PRODUCT_LIST =
      "${BASE_URL}/mall-portal/drawProduct/drawProductDetail"; //通过商品找抽奖记录

  static const MALL_NEW_DRAW_PRODUCT_LIST =
      "${BASE_URL}/mall-portal/drawProduct/newDrawProductList"; //最新抽奖记录

  static const MALL_RANDOM_DRAW =
      "${BASE_URL}/mall-portal/drawProduct/randomDraw"; //随机抽奖

  static const MALL_SELECT_AGREE =
      "${BASE_URL}/mall-portal/sso/selectAgree"; //查询协议是否同同意

  static const MALL_AGREE = "${BASE_URL}/mall-portal/sso/agree"; //协议同意接口

  static const MALL_LIST_BY_PRODUCT_SHOP =
      "${BASE_URL}/mall-portal/member/coupon/listByProductShop/"; //获取当前商家优惠券

  static const MALL_COUPON_LIST =
      "${BASE_URL}/mall-portal/home/coupon1List"; //优惠券列表（精选优惠）

  static const MALL_COUPON_DETAIL =
      "${BASE_URL}/mall-portal/member/coupon/couponDetail"; //优惠券详情（精选优惠）

  static const MALL_COUPON_DETAIL_BY_ID_SHOP =
      "${BASE_URL}/mall-portal/home/productByShopid"; // 店铺精选

  static const MALL_PRODUCT_BY_SHOPID =
      "${BASE_URL}/mall-portal/home/shopBrandByShopid"; // 店铺品牌详情

  static const MALL_SHOP_LIST_BY_ID_SHOP =
      "${BASE_URL}/mall-portal/home/shopList"; // 商超列表

  static const MALL_SHOP_FEATURED_PROMOTION =
      "${BASE_URL}/mall-portal/home/homeAdvertiseList"; // 快捷功能列表

  static const MALL_SHOP_FEATURED_PROMOTION_DETAIL =
      "${BASE_URL}/mall-portal/home/homeAdvertiseDetail"; // 快捷功能详情
}
