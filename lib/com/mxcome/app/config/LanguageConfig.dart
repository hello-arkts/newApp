import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';

class LanguageConfig {
  static String get(String key) {
    if (TextUtils.isEmpty(key)) return '';
    Map<String, String>? map = _map[LanguagePage.language];
    map ??= _map[LanguageType.EN];
    String? value;
    if (map != null) {
      if (map.containsKey(key)) value = map[key];
    }
    if (TextUtils.isEmpty(value)) value = key;
    return value.toString();
  }

  static const Map<String, Map<String, String>> _map = {
    //英语
    LanguageType.EN: {
      LanguageConfigKeys.app_name: "MXCOME",
      LanguageConfigKeys.language: "Choose Language", //语言
      LanguageConfigKeys.search: "Search", //搜索
      LanguageConfigKeys.language_tip:
          "The default language is automatically selected based on your device setting. Select and change to your preferred language", //根据系统语言，我们将自动适配，你也可以手动选择适合自己的语言
      LanguageConfigKeys.Base_unknown_err:
          "The network error. Please try again later", //网络异常，请稍后再试
      LanguageConfigKeys.Base_coming_soon:
          "Under development, please wait", //正在开发中，敬请期待
      LanguageConfigKeys.Base_submit_hint: "Tip", //提示
      LanguageConfigKeys.Base_submit_success: "Submitted", //提交成功
      LanguageConfigKeys.Base_successfully_added: "Added", //添加成功
      LanguageConfigKeys.Base_successfully_modified: "Modified", //修改成功
      LanguageConfigKeys.Base_operation_successful: "Success", //操作成功
      LanguageConfigKeys.Base_operation_tips: "Operation tips", //操作提示
      LanguageConfigKeys.Base_set_successful: "Success", //设置成功
      LanguageConfigKeys.Base_copy_success: "Copied", //复制成功
      LanguageConfigKeys.Base_clean_up: "Clean up", //清除
      LanguageConfigKeys.Base_delete: "Delete", //删除
      LanguageConfigKeys.Shop_submit: "Submit", //提交
      LanguageConfigKeys.Base_view_image: "View picture", //查看图片
      LanguageConfigKeys.Login_welcome_world_of_gold:
          "Welcome to the MXCOME world", //欢迎移民淘金世界
      LanguageConfigKeys.Login_select_country:
          "Select a country or region", //选择国家或地区
      LanguageConfigKeys.Login_register: "Sign up", //注册
      LanguageConfigKeys.Login_register_new: "Sign up", //新用户注册
      LanguageConfigKeys.Login_duplicate_register_tip:
          "This mobile phone number has been bound to another account. You will be taken to the login page", //该手机号已被其他账号绑定，将为您跳转至登录页
      LanguageConfigKeys.Login_skip: "Skip", //跳过
      LanguageConfigKeys.Login_country_th: "Thailand", //泰国
      LanguageConfigKeys.Login_country_en: "U.S.A.", //美国
      LanguageConfigKeys.Login_country_zh: "China", //中国
      LanguageConfigKeys.Login_register_success:
          "Please set the login password", //注册成功，请设置登录密码
      LanguageConfigKeys.Login_reset_password: "Reset password", //重设密码
      LanguageConfigKeys.Login_sms_code: "OTP is：", //短信验证码
      LanguageConfigKeys.Login_sms_code_error: "OTP incorrect", //验证码错误
      LanguageConfigKeys.Login_sms_code_timeout: "OTP timeout", //验证码超时
      LanguageConfigKeys.Login_password_or_confirm_password_error:
          "The passwords you entered are inconsistent, so please re-enter", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Login_password_tip: "Password", //请输入密码
      LanguageConfigKeys.Login_password_first_tip:
          "Please enter a password of 8 digits or more", //请输入8位及以上密码
      LanguageConfigKeys.Login_password_again_tip: "Re-enter", //请再次输入密码
      LanguageConfigKeys.Login_password_format_error:
          "The password format is incorrect. Please fill in according to the format", //密码格式错误，请按照下面格式填写
      LanguageConfigKeys.Login_set_password_tip1:
          "The password is composed of letters and numbers. The first letter must be capitalized and be with 8-32 digits in length", //密码由字母加数字组成，首字母必须大写，长度最少8位
      LanguageConfigKeys.Login_set_password_tip2:
          "Please take good care of your passwords and avoid using simple combinations", //请妥善保管密码，并避免使用简单密码组合
      LanguageConfigKeys.Login_forgot_password_tip1:
          "Please enter the phone number registered", //请输入与MXCOME账号绑定的手机号
      LanguageConfigKeys.Login_forgot_password_tip2:
          "Get OTP to reset your password", //获取验证码后可重设密码
      LanguageConfigKeys.Login_forgot_password_tip3:
          "If the phone number cannot receive the OTP， click and change the new phone number", //手机号无法收取验证码，可点击手机换绑
      LanguageConfigKeys.Login_welcome_login: "Welcome to login", //欢迎登录
      LanguageConfigKeys.Login_mobile_tip:
          "Please input phone number", //请输入手机号码
      LanguageConfigKeys.Login_mobile_error:
          "Mobile number format error", //手机号格式错误
      LanguageConfigKeys.Login_user_or_password_error:
          "Mobile phone number or password is incorrect, so please re-enter", //手机号或密码错误，请重新输入
      LanguageConfigKeys.Login_forgot_password: "Forgot your password?", //忘记密码
      LanguageConfigKeys.Login_code_tip: "Please input OTP", //请输入验证码
      LanguageConfigKeys.Login_login_app: "Login MXCOME", //登录MXCOME
      LanguageConfigKeys.Login_send_code: "Get OTP", //获取验证码
      LanguageConfigKeys.Login_resend_code: "Resend", //重新发送
      LanguageConfigKeys.Login_login: "Log in", //登录
      LanguageConfigKeys.Login_verify_phone: "Verify phone", //验证手机
      LanguageConfigKeys.Login_other_login_type:
          "Third-party authorized login", //第三方授权登录
      LanguageConfigKeys.Login_bind_phone: "Bind phone number", //绑定手机号
      LanguageConfigKeys.Login_login_accept_tip:
          "By continuing, you have read and agreed to it", //继续即表示您已同意
      LanguageConfigKeys.Login_service:
          "MXCOME Service Agreement and Privacy Policy", //《MXCOME服务协议与隐私政策》
      LanguageConfigKeys.Login_input_invite_code:
          "Please input invitation code (optional)", //请输入邀请码（可选）
      LanguageConfigKeys.Login_input_invite_code_required:
          "Please input invitation code (required)", //请输入邀请码（必填）
      LanguageConfigKeys.Login_input_invite_code_invalid:
          "Invalid invitation code", //邀请码无效
      LanguageConfigKeys.Login_input_invite_code_title: "Invitation code", //邀请码
      LanguageConfigKeys.Login_input_invite_code_content:
          "Invitation codes are from public beta or red packet entry\nMXCOME has the latest interpretation right", //邀请码分为公测邀请码与红包闯关邀请码\n最新解释权归平台所有
      LanguageConfigKeys.Login_invite_code_error:
          "Invitation code error", //邀请码错误
      LanguageConfigKeys.Login_invite_consent_agreement: "Agree", //同意协议
      LanguageConfigKeys.Login_password_set_success:
          "Password set successfully", //密码设置成功
      LanguageConfigKeys.Login_password_modify_success:
          "Password modification successful", //密码修改成功
      LanguageConfigKeys.Verify_code_tip:
          "The verification code has been sent to mobile phone", //短信已发送到手机
      LanguageConfigKeys.Verify_safe_verify: "Security verification", //安全验证
      LanguageConfigKeys.Verify_safe_verify_tip1:
          "For your account security, this operation needs to be verified", //为了你的账号安全，本次操作需要进行验证
      LanguageConfigKeys.Verify_safe_verify_tip2:
          "Please move the icon below to the circular area", //请将下方的图标移动到圆形区域内
      LanguageConfigKeys.WebPage_click_reload: "Click to reload", //点击重新加载
      LanguageConfigKeys.ViewUtils_cancel: "Cancel", //取消
      LanguageConfigKeys.ViewUtils_confirm: "Confirm", //确定
      LanguageConfigKeys.ViewUtils_no_data: "No content", //暂无内容
      LanguageConfigKeys.ViewUtils_no_more: "No more data", //没有更多数据了
      LanguageConfigKeys.ViewUtils_retry: "Retry", //重试
      LanguageConfigKeys.Loading: "Loading", //正在加载
      LanguageConfigKeys.Shop_home: "MXGET", //淘金
      LanguageConfigKeys.Shop_category: "Category", //分类
      LanguageConfigKeys.Shop_cart: "My Cart", //购物车
      LanguageConfigKeys.Shop_grow: "Growth", //成长
      LanguageConfigKeys.Shop_grow_continue_day:
          "Signed in for | consecutive days", //已连续签到%s天
      LanguageConfigKeys.Shop_grow_this_month: "This month", //本月
      LanguageConfigKeys.Shop_grow_countersign: "Fill", //补签
      LanguageConfigKeys.Shop_grow_unsigned: "Unsigned", //未签到
      LanguageConfigKeys.Shop_grow_countersigned: "Filled", //已补签
      LanguageConfigKeys.Shop_grow_signed: "Signed", //已签到
      LanguageConfigKeys.Shop_grow_growth_benefits: "Growth benefits", //成长福利
      LanguageConfigKeys.Shop_grow_surprise: "Surprise", //惊喜
      LanguageConfigKeys.Shop_product_task_recommend:
          "Tasks Recommendation", //任务推荐
      LanguageConfigKeys.Shop_product_shop_stroll: "Shop Stroll", //店铺闲逛
      LanguageConfigKeys.Shop_product_shop_stroll_tip:
          "When shopping, you can combine the “recommended list“", //逛街时，可以DIY组合“推荐清单”哦
      LanguageConfigKeys.Shop_product_hot_activity: "Popular Activities", //热门活动
      LanguageConfigKeys.Shop_product_recommend: "Top sellers", //热销榜
      LanguageConfigKeys.Shop_product_profit: "MXGET sellers", //淘金榜
      LanguageConfigKeys.Shop_product_best_seller: "Household sellers", //持家榜
      LanguageConfigKeys.Shop_product_search:
          "Search tasks/activities/products", //搜任务/活动/商品
      LanguageConfigKeys.Shop_product_delivery: "Delivery", //配送
      LanguageConfigKeys.Shop_product_parameter: "Parameters", //参数
      LanguageConfigKeys.Shop_product_spec: "Specifications", //规格
      LanguageConfigKeys.Shop_product_spec_select:
          "% s pieces selected", //已选择%s件
      LanguageConfigKeys.Shop_product_service: "Service", //服务
      LanguageConfigKeys.Featured_promotion_title: "Featured Deals", //精选优惠
      LanguageConfigKeys.Featured_promotion_view_all: "View All", //查看所有
      LanguageConfigKeys.Featured_promotion_category_restaurant:
          "Influencer Restaurants", //网红餐厅
      LanguageConfigKeys.Featured_promotion_category_hotel:
          "Hotels & Stays", //酒店住宿
      LanguageConfigKeys.Featured_promotion_category_car: "Car & Pickup", //租车接机
      LanguageConfigKeys.Featured_promotion_category_ticket:
          "Attraction Tickets", //景点门票
      LanguageConfigKeys.Featured_promotion_category_popular_thai:
          "Popular Thai Products", //热门泰货
      LanguageConfigKeys.Featured_promotion_category_leisure:
          "Leisure & Entertainment", //休闲娱乐
      LanguageConfigKeys.Shop_product_shop: "Shop", //店铺
      LanguageConfigKeys.Shop_product_consulting: "Consultation", //咨询
      LanguageConfigKeys.Shop_product_join: "Join", //加入
      LanguageConfigKeys.Shop_product_rise: "Up", //起
      LanguageConfigKeys.Shop_product_join_cart: "Add to cart", //加入购物车
      LanguageConfigKeys.Shop_product_cart_add_success:
          "Successfully added to shopping cart", //已成功加入购物车
      LanguageConfigKeys.Shop_product_now_buy: "Buy Now", //立即购买
      LanguageConfigKeys.Shop_product_goods: "Overview", //概述
      LanguageConfigKeys.Shop_product_detail: "Details", //详情
      LanguageConfigKeys.Shop_product_select_spec:
          "Select Specifications", //选择规格
      LanguageConfigKeys.Shop_product_quantity: "Number", //数量
      LanguageConfigKeys.Shop_product_money: "Share&Get", //赚
      LanguageConfigKeys.Shop_product_mxget: "MXGET Task", //淘金赚
      LanguageConfigKeys.Shop_product_user_join_mxget:
          "| Users Joined MXGET", //已有%s名用户参与“淘金赚”
      LanguageConfigKeys.Shop_product_view_list: "View the list", //查看榜单
      LanguageConfigKeys.Shop_product_see: "Check", //查看
      LanguageConfigKeys.Shop_product_select: "Select", //选择
      LanguageConfigKeys.Shop_product_free_freight: "Free freight", //免运费
      LanguageConfigKeys.Shop_product_nation_branding: "Brand Origin: ", //品牌国家
      LanguageConfigKeys.Shop_product_place: "site: ", //site
      LanguageConfigKeys.Shop_product_producer: "Country of Origin: ", //产地
      LanguageConfigKeys.Shop_product_free_charge_overtime_tip:
          "This order is free of charge if delivery is later than 7 days", //超过7天到货，直接免单
      LanguageConfigKeys.Shop_product_ship_to: "Ship to: %s", //发货地: %s
      LanguageConfigKeys.Shop_product_now_pay_tip:
          "Expected delivery within 48 hours upon payment", //现在付款，品牌承诺48小时内发货
      LanguageConfigKeys.Shop_product_hot_category: "Popular Categories", //热门品类
      LanguageConfigKeys.Shop_product_hot_product: "Popular Products", //热销产品
      LanguageConfigKeys.Shop_brand_shop: "Brand Stores", //品牌店铺
      LanguageConfigKeys.Shop_brand_subscribe: "Subscribe", //订阅
      LanguageConfigKeys.Shop_brand_subscribed: "Subscribed", //已订阅
      LanguageConfigKeys.Shop_brand_goto_shop: "Goto shop", //进店铺
      LanguageConfigKeys.Shop_brand_receive: "Accept tasks", //可接任务
      LanguageConfigKeys.Shop_brand_family: "Household love", //爱持家
      LanguageConfigKeys.Shop_brand_period: "Installment", //分期
      LanguageConfigKeys.Shop_brand_free_package: "Delivery free", //包邮
      LanguageConfigKeys.Shop_brand_overtime_free:
          "Free for delivery timeout", //超时免单
      LanguageConfigKeys.Shop_brand_down_up: "From low to high", //由低到高
      LanguageConfigKeys.Shop_brand_up_down: "From high to low", //由高到低
      LanguageConfigKeys.Shop_brand_choose: "Screening conditions", //筛选条件
      LanguageConfigKeys.Shop_brand_enable: "Optional", //可选
      LanguageConfigKeys.Shop_brand_price: "Price", //价格
      LanguageConfigKeys.Shop_cart_empty:
          "Your selected products will be added to the cart", //挑选喜欢的装进购物车
      LanguageConfigKeys.Shop_cart_select_all: "Select all", //全选
      LanguageConfigKeys.Shop_cart_total: "Total", //总计
      LanguageConfigKeys.Shop_cart_settlement: "Pay Now", //结算
      LanguageConfigKeys.Shop_cart_delete: "Delete", //删除
      LanguageConfigKeys.Shop_cart_is_delete:
          "Delete the selected goods or not?", //是否删除选择商品?
      LanguageConfigKeys.Shop_cart_select_goods:
          "Please select the goods", //请先选择商品
      LanguageConfigKeys.Shop_cart_select_goods_settlement:
          "Please select the goods before the settlement", //请先选择商品再结算
      LanguageConfigKeys.Shop_mine_adv: "More Play\nMore Earn", //越玩越赚
      LanguageConfigKeys.Shop_mine_not_login: "Not Logged in", //未登录
      LanguageConfigKeys.Shop_mine_member_service: "Coupon", //优惠券
      LanguageConfigKeys.Shop_mine_shop_service: "Operation Management", //运营管理
      LanguageConfigKeys.Shop_mine_member_service_tips:
          "More share, more get", //多推多得
      LanguageConfigKeys.Shop_mine_shop_service_tips:
          "Open a shop and enjoy good gifts", //开通橱窗享好礼
      LanguageConfigKeys.Shop_mine_account_balance: "Balance", //余额
      LanguageConfigKeys.Shop_mine_withdrawal_balance:
          "Available balance", //可提金额
      LanguageConfigKeys.Shop_mine_today_withdrawal_balance:
          "Today available balance", //今日可提
      LanguageConfigKeys.Shop_mine_confirm_withdrawal:
          "Confirm withdrawal", //确认提现
      LanguageConfigKeys.Shop_mine_withdrawal_amount:
          "Cash withdrawal amount", //提现金额
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip1:
          "Minimum ฿ 100 or multiple of 100, maximum ฿ 10000/day", //最低฿100或100的倍数，最高฿10000/天
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip2:
          "Withdrawal rate %s%", //提现费率3%
      LanguageConfigKeys.Shop_mine_gold_coin: "Gold Coins", //金币
      LanguageConfigKeys.Shop_mine_address_manage: "Address Management", //地址管理
      LanguageConfigKeys.Shop_mine_help: "Help Center", //帮助中心
      LanguageConfigKeys.Shop_mine_profit_study: "MXCOME college", //淘金学院
      LanguageConfigKeys.Shop_mine_order: "My Orders", //订单
      LanguageConfigKeys.Shop_mine_wallet: "My Wallet", //资产
      LanguageConfigKeys.Shop_mine_more: "More", //更多
      LanguageConfigKeys.Shop_mine_edit_member_info: "Edit profile", //编辑个人资料
      LanguageConfigKeys.Shop_mine_unknown: "Secrecy", //保密
      LanguageConfigKeys.Shop_mine_boy: "Man", //男
      LanguageConfigKeys.Shop_mine_girl: "Woman", //女
      LanguageConfigKeys.Shop_mine_year_tip:
          "You need to be over 14 years old", //您的年龄需要大于14周岁
      LanguageConfigKeys.Shop_mine_change_avatar: "Change Avatar", //更换头像
      LanguageConfigKeys.Shop_mine_name: "Name", //姓名
      LanguageConfigKeys.Shop_mine_account_id: "Account ID", //账号ID
      LanguageConfigKeys.Shop_mine_account_modify_once:
          "Account ID can only be modified once a year.", //账号ID一年只能修改一次
      LanguageConfigKeys.Shop_mine_account_id_already_exists:
          "ID already exists", //ID已存在
      LanguageConfigKeys.Shop_mine_change_account_id: "Change", //变更账号ID
      LanguageConfigKeys.Shop_mine_verifying: "Under review", //审核中
      LanguageConfigKeys.Shop_mine_passed: "Certified", //已实名
      LanguageConfigKeys.Shop_mine_real_name_auth:
          "Identity Verification", //实名认证
      LanguageConfigKeys.Shop_mine_verify_status: "Audit status", //审核状态
      LanguageConfigKeys.Shop_mine_verify_status_tip1:
          "Identity authentication is under review", //身份认证正在审核中
      LanguageConfigKeys.Shop_mine_verify_status_tip2:
          "Please check later. You can continue to participate in the MXGET task", //请稍后查看，您可以继续参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip1:
          "The certificate information cannot be verified", //证件信息无法核实
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip2:
          "Please resubmit the correct ID photos and information", //请重新提交正确的证件照片及信息
      LanguageConfigKeys.Shop_mine_verify_start_mxget:
          "Participate in the MXGET task", //参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_reapply: "Reapply", //重新申请
      LanguageConfigKeys.Shop_mine_select_certificate:
          "Please select identification type", //请选择证件类型
      LanguageConfigKeys.Shop_mine_upload_positive:
          "Please upload the front of your ID card/Passport", //请上传证件的正面
      LanguageConfigKeys.Shop_mine_re_upload: "Re-upload", //重新上传
      LanguageConfigKeys.Shop_mine_register_phone: "Register phone", // 注册手机
      LanguageConfigKeys.Shop_mine_id_card: "ID card", //身份证
      LanguageConfigKeys.Shop_mine_passport: "passport", //护照
      LanguageConfigKeys.Shop_mine_id_number: "ID Number", //身份证号
      LanguageConfigKeys.Shop_mine_passport_number: "Passport Number", //护照号
      LanguageConfigKeys.Shop_mine_validity: "Validity", //有效期
      LanguageConfigKeys.Shop_mine_select_bank: "Select Bank", //选择银行
      LanguageConfigKeys.Shop_mine_first_name: "Last Name", //姓氏
      LanguageConfigKeys.Shop_mine_last_name: "First Name", //名字
      LanguageConfigKeys.Shop_mine_color_pictures:
          "Support JPG, PNG, PDF file size not more than 5M", //支持JPG、PNG、PDF 文件大小不超过5M
      LanguageConfigKeys.Shop_mine_upload_after_tip:
          " After uploading your ID card/Passport, fill in the form below with accurate details from your ID card/Passport", //证件上传后，根据证件信息补全证件号、有效期、姓名
      LanguageConfigKeys.Shop_mine_verify_tip1:
          "Please confirm the type of your identification", //请确认您所持有的证件类型
      LanguageConfigKeys.Shop_mine_verify_tip2:
          "Document must be in original color copy", //需要彩色文件
      LanguageConfigKeys.Shop_mine_verify_tip3:
          "Details on your ID card/Passport must be clearly visible", //姓名、证件号码，有效期和详细地址清晰可见
      LanguageConfigKeys.Shop_mine_verify_tip4:
          "ID card/Passport must be in validity period", //证件必须在有效期内
      LanguageConfigKeys.Shop_mine_verify_confirm: "Confirm submit", //确认提交
      LanguageConfigKeys.Shop_mine_verify_failed: "Verification Failed", //审核不通过
      LanguageConfigKeys.Shop_mine_verify_wait_time:
          "Wait patiently, and it's expected to complete the certification audit within | working days", //耐心等待，预计|个工作日内完成认证审核
      LanguageConfigKeys.Shop_mine_unreal_name: "Not Authorized", //未实名
      LanguageConfigKeys.Shop_mine_nickname: "Nickname", //昵称
      LanguageConfigKeys.Shop_mine_describe: "Personal Signature", //个性签名
      LanguageConfigKeys.Shop_mine_birthday: "Birthday", //生日
      LanguageConfigKeys.Shop_mine_gender: "Gender", //性别
      LanguageConfigKeys.Shop_mine_select_gender: "Select gender", //选择性别
      LanguageConfigKeys.Shop_mine_take_picture: "Take a picture", //拍照
      LanguageConfigKeys.Shop_mine_photo_album: "Photo album", //从手机选择
      LanguageConfigKeys.Shop_mine_canceled: "Cancel", //取消
      LanguageConfigKeys.Shop_mine_member_level: "Member level", //会员等级
      LanguageConfigKeys.Shop_mine_not_opened: "Not opened", //未开通
      LanguageConfigKeys.Shop_mine_bind_now: "Bind Now", //立即绑定
      LanguageConfigKeys.Shop_mine_get_center: "Vouchers", //领券中心
      LanguageConfigKeys.Shop_mine_promotion_rewards: "MXCOME Rewards", //推广奖励
      LanguageConfigKeys.Shop_mine_voucher_center: "Voucher Center", //领券中心
      LanguageConfigKeys.Shop_mine_valid_to: "Validity %s", //有效期至 %s
      LanguageConfigKeys.Shop_mine_usage_time: "Usage time %s", //使用时间 %s
      LanguageConfigKeys.Shop_mine_to_use: "To use", //去使用
      LanguageConfigKeys.Shop_mine_to_be_use: "To be used", //待使用
      LanguageConfigKeys.Shop_mine_used: "Used", //已使用
      LanguageConfigKeys.Shop_mine_get_now: "Get Now", //立即领取
      LanguageConfigKeys.Shop_mine_use_coupons: "Use coupons", //使用优惠券
      LanguageConfigKeys.Shop_mine_currently_available:
          "Currently available (%s)", //当前可用(%s)
      LanguageConfigKeys.Shop_mine_discount_deduction:
          "Discount deduction", //优惠抵扣
      LanguageConfigKeys.Shop_mine_full_available:
          "Available for over %sTHB", //满%s可用
      LanguageConfigKeys.Shop_mine_all_platforms:
          "Available all platforms", //全平台可用
      LanguageConfigKeys.Shop_mine_all_shops: "Available all shops", //全平台可用
      LanguageConfigKeys.Shop_mine_category_available:
          "Category available", //指定分类可用
      LanguageConfigKeys.Shop_mine_specific_product_available:
          "Specific product available", //指定商品可用
      LanguageConfigKeys.Shop_mine_voucher: "Voucher", //代金券
      LanguageConfigKeys.Shop_mine_coupon: "Coupon", //优惠券
      LanguageConfigKeys.Shop_mine_platform_voucher: "Platform", //平台
      LanguageConfigKeys.Shop_mine_merchant_voucher: "brand", //品牌
      LanguageConfigKeys.Shop_mine_my_coupon: "My Coupons", //我的优惠券
      LanguageConfigKeys.Shop_mine_received_successfully:
          "Received successfully", //领取成功
      LanguageConfigKeys.Shop_mine_go_get_voucher: "Go get Voucher", //去领券
      LanguageConfigKeys.Shop_mine_applicable_range: "Applicable range", //适用范围
      LanguageConfigKeys.Shop_mine_products_applicable_coupon:
          "The products applicable to this coupon", //该券适用的商品
      LanguageConfigKeys.Shop_mine_my_prize: "My prizes", //我的奖品
      LanguageConfigKeys.Shop_mine_red_title: "Red Level Challenge", //红包闯关
      LanguageConfigKeys.Shop_mine_red_history_title:
          "Challenge History", //红包闯关第一季
      LanguageConfigKeys.Shop_mine_red_total_number:
          "Total Period: %s", //总期数: %s
      LanguageConfigKeys.Shop_mine_red_no_data:
          "You have not participated in the red packet challenge yet, so there is no data.", //您暂未参与过红包闯关，暂无数据
      LanguageConfigKeys.Shop_mine_red_sub_title:
          "฿111000 Real Huge Red Packet Delivery", //฿111,000真实巨额红包大派送
      LanguageConfigKeys.Shop_mine_number_promoters:
          "Number of Promoters", //推广人数
      LanguageConfigKeys.Shop_mine_total_number_promoters:
          "Total Number of Promotions", //推广人数
      LanguageConfigKeys.Shop_mine_new_today: "New Today", //今日新增
      LanguageConfigKeys.Shop_mine_promotion_details:
          "Promotion Details", //推广明细
      LanguageConfigKeys.Shop_mine_Daily_direct_promotion_prizes:
          "Daily direct promotion of prizes", //每日直推奖品
      LanguageConfigKeys.Shop_mine_choose_prize: "Choose prize", //选择奖品
      LanguageConfigKeys.Shop_mine_promotion_rules: "Promotion rules", //推广规则
      LanguageConfigKeys.Shop_mine_promotion_rules_tip1:
          "1. Users who have not participated in the red packet activity are considered 'newcomers'. If you recommend a user who is not a newcomer, you will only receive bonus points", //1. 没有参加红包闯关的用户即为“新人”, 非新人购买，您仅得分润
      LanguageConfigKeys.Shop_mine_promotion_rules_tip2:
          "2. If you directly recommend three newcomers, you will get the first red packet x 1; if your friends also recommend three newcomers, you will get the second red packet x 1; according to this principle, you can get the third red packet x 1; there is no limit to the number of red packets in each level, and you can get the more red packets if you recommend more! If you meet the level amount, you will automatically enter the next level", //2. 您直推三位新人获得第一层红包 x 1；您好友也推荐了三位新人，您将获得第二层红包 x 1；根据此原则，您可得到第三层红包 x 1；每层红包不限个数，多推多得！满足关卡金额自动进入下一关
      LanguageConfigKeys.Shop_mine_promotion_rules_tip3:
          "3. The higher the amount of products you recommend, the higher the amount of profit and bonus you get", //3. 推荐商品金额越高，分润及红包奖励金额越大
      LanguageConfigKeys.Shop_mine_promotion_rules_tip4:
          "4. Click on 'Promotion Details' to view more details", //4. 点击“推广明细”可以查看推广详情
      LanguageConfigKeys.Shop_mine_promotion_rules_tip5:
          "5. Click 'Redeem Prizes' to redeem your favourite prizes according to the 'Direct Recommendation Value'. Click 'View Prizes' to view the prizes you have already redeemed. Please use it within the validity period.", //5. 点击“兑换奖品”可以根据“直推值”兑换您喜欢的奖品，已兑奖品可点击“查看奖品”，请在有效期内使用
      LanguageConfigKeys.Shop_mine_promotion_rules_tip6:
          "6. MXCOME has the final explanation right of the promotion", //6. 推广活动最终解释权归属平台所有
      LanguageConfigKeys.Shop_mine_exchange_voucher: "Exchange Voucher", //兑换券
      LanguageConfigKeys.Shop_mine_entity_prizes: "Entity prizes", //实物奖品
      LanguageConfigKeys.Shop_mine_my_push: "My Push", //我的直推 //
      LanguageConfigKeys.Shop_mine_my_push_value: "My Push Value", //我的直推值
      LanguageConfigKeys.Shop_mine_second_level: "Second level", //二级推荐
      LanguageConfigKeys.Shop_mine_third_level: "Third level", //三级推荐
      LanguageConfigKeys.Shop_mine_processing: "Processing", //进行中
      LanguageConfigKeys.Shop_mine_issued: "Issued", //已发放
      LanguageConfigKeys.Shop_mine_exchange_success_tip:
          "Currently, | people have successfully redeemed", //当前已有|人兑换成功
      LanguageConfigKeys.Shop_mine_select_prizes: "Select prizes", //挑选奖品
      LanguageConfigKeys.Shop_mine_now_use: "Now use", //立即使用
      LanguageConfigKeys.Shop_mine_detail: "Detail", //查看详情
      LanguageConfigKeys.Shop_mine_expired: "%s expired", //%s 过期
      LanguageConfigKeys.Shop_mine_direct_push: "Push %s", //直推%s人
      LanguageConfigKeys.Shop_mine_hot: "Hot", //热门
      LanguageConfigKeys.Shop_mine_end_remain:
          "There's still time until the end", //距结束还剩
      LanguageConfigKeys.Shop_mine_exchange_prizes: "Exchange Prizes", //兑换奖品
      LanguageConfigKeys.Shop_mine_store_consumption:
          "Store consumption", //门店消费
      LanguageConfigKeys.Shop_mine_express_delivery: "Express delivery", //快递发货
      LanguageConfigKeys.Shop_mine_exchange_records: "Exchange records", //兑换记录
      LanguageConfigKeys.Shop_mine_value: "Value", //价值
      LanguageConfigKeys.Shop_mine_stock: "Stock", //库存
      LanguageConfigKeys.Shop_mine_direct_push_value: "Push Value", //直推值
      LanguageConfigKeys.Shop_mine_using_direct_push_value:
          "Using Push Values", //消耗直推值
      LanguageConfigKeys.Shop_mine_enable: "Enable", //可兑
      LanguageConfigKeys.Shop_mine_exchange_successful:
          "Exchange successful", //兑换成功
      LanguageConfigKeys.Shop_mine_confirm_exchange: "Confirm exchange", //确定兑换
      LanguageConfigKeys.Shop_mine_confirm_use: "Confirm use", //确定使用
      LanguageConfigKeys.Shop_mine_confirm_use_tip:
          "Click to confirm, indicating that the redemption is complete. Please proceed with caution", //点击确定，表示兑换完成，请谨慎操作
      LanguageConfigKeys.Shop_mine_voucher_code_info:
          "Voucher code info", //券码信息
      LanguageConfigKeys.Shop_mine_prize_info: "Prize info", //奖品信息
      LanguageConfigKeys.Shop_mine_exchange_number: "Exchange number", //兑换单号
      LanguageConfigKeys.Shop_mine_exchange_time: "Exchange time", //兑换时间
      LanguageConfigKeys.Shop_mine_usage_rules: "Usage rules", //使用规则
      LanguageConfigKeys.Shop_mine_usage_rules_tip1:
          "1. Click to use immediately, i.e. exchange/ship, no change, no return, no cash exchange", //1. 点击立即使用，即兑换/发货，不找零、不退换、不兑现金
      LanguageConfigKeys.Shop_mine_usage_rules_tip2:
          "2. Please pay attention to the usage time of the gift. Please use it as soon as possible, and it will expire", //2. 请注意礼品使用时间，请尽快使用，过期失效
      LanguageConfigKeys.Shop_mine_usage_rules_tip3:
          "3. The final interpretation right belongs to the platform", //3. 最终解释权归属平台
      LanguageConfigKeys.Shop_mine_usage_expiration_time:
          "Expiration time %s", //过期时间 %s
      LanguageConfigKeys.Shop_mine_usage_total_sheets: "Total | sheets", //共 | 张
      LanguageConfigKeys.Shop_mine_logistics_info: "Logistics info", //物流信息
      LanguageConfigKeys.Shop_mine_receiving_time: "Receiving time", //收货时间
      LanguageConfigKeys.Shop_order_waiting_for_shipment:
          "Waiting for shipment", //等待发货
      LanguageConfigKeys.Shop_mine_keep_working_hard:
          "Congratulations! Keep going", //恭喜，请再接再厉
      LanguageConfigKeys.Shop_mine_obtain_red: "Obtain red packet", //获得红包
      LanguageConfigKeys.Shop_mine_to_be_updated: "To be updated", //待更新
      LanguageConfigKeys.Shop_mine_run_to_zero: "expired", //过期失效
      LanguageConfigKeys.Shop_mine_select_option: "Select Period", //选择期数
      LanguageConfigKeys.Shop_order_all: "All", //全部
      LanguageConfigKeys.Shop_order_received: "Received", //可接
      LanguageConfigKeys.Shop_order_changed: "Changed", //可接
      LanguageConfigKeys.Shop_order_wait_pay: "Unpaid", //待付款
      LanguageConfigKeys.Shop_order_wait_deliver: "Processing", //待发货
      LanguageConfigKeys.Shop_order_wait_receipt: "Shipped", //待收货
      LanguageConfigKeys.Shop_order_shipped: "Shipped", //已发货
      LanguageConfigKeys.Shop_order_receive_finish: "Received", //已收货
      LanguageConfigKeys.Shop_order_completed: "Completed", //已完成
      LanguageConfigKeys.Shop_order_canceled: "Canceled", //已取消
      LanguageConfigKeys.Shop_order_after_sales_order:
          "After sales orders", //售后订单
      LanguageConfigKeys.Shop_order_delete_title:
          "Are you sure to delete the order?", //确认删除订单？
      LanguageConfigKeys.Shop_order_delete_content:
          "The order record cannot be retrieved after deletion", //删除后该订单记录无法找回
      LanguageConfigKeys.Shop_order_again_patronage:
          "Looking forward to your visit again", //期待您再次惠顾
      LanguageConfigKeys.Shop_order_after_sales: "After-Sales", //售后
      LanguageConfigKeys.Shop_order_confirm_order: "Confirm order", //确认订单
      LanguageConfigKeys.Shop_order_empty: "No Order", //暂无订单
      LanguageConfigKeys.Shop_order_search: "Search order", //搜索订单
      LanguageConfigKeys.Shop_order_mine_order: "My Order", //我的订单
      LanguageConfigKeys.Shop_order_now_pay: "Pay now", //立即付款
      LanguageConfigKeys.Shop_order_confirm_pay: "Confirm", //确认支付
      LanguageConfigKeys.Shop_order_remain: "Duration", //剩余
      LanguageConfigKeys.Shop_order_pay: "Pay", //支付
      LanguageConfigKeys.Shop_order_cancel_order: "Cancel order", //取消订单
      LanguageConfigKeys.Shop_order_change_address: "Change address", //更换地址
      LanguageConfigKeys.Shop_order_contact_customer_service:
          "Contact customer", //联系客服
      LanguageConfigKeys.Shop_order_confirm_receipt:
          "Confirm to take delivery", //确认收货
      LanguageConfigKeys.Shop_order_confirm_receipt_tip:
          "To protect your rights, please confirm after receiving the goods", //为保障您的权益，请收货后再确认
      LanguageConfigKeys.Shop_order_again_buy: "Buy again", //再次购买
      LanguageConfigKeys.Shop_order_service1:
          "Triple value compensation for any fake products received", //假一赔三
      LanguageConfigKeys.Shop_order_service2: "After-sales Service", //品牌售后
      LanguageConfigKeys.Shop_order_service3: "Genuine traceability", //正品溯源
      LanguageConfigKeys.Shop_order_service4: "Delivery Terms:", //超时免单
      LanguageConfigKeys.Shop_order_service5: "Fast Shipping", //快速发货
      LanguageConfigKeys.Shop_order_service6: "Free Shipping", //商品包邮
      LanguageConfigKeys.Shop_order_service7: "Support for installment", //支持分期
      LanguageConfigKeys.Shop_order_service8: "Quick Refund", //快速退款
      LanguageConfigKeys.Shop_order_delete_order: "Delete order", //删除订单
      LanguageConfigKeys.Shop_order_view_logistics:
          "Check the logistics", //查看物流
      LanguageConfigKeys.Shop_order_apply_service: "Apply for service", //申请售后
      LanguageConfigKeys.Shop_order_piece_in_total: "%s piece in total", //共%s件
      LanguageConfigKeys.Shop_order_coupons_ticket_available:
          "%s ticket(s) available", //%s张可用
      LanguageConfigKeys.Shop_order_coupons: "Coupon", //优惠券
      LanguageConfigKeys.Shop_order_tax: "VAT (7%)", //增值税 (7%)
      LanguageConfigKeys.Shop_order_tax_fee7: "Tax (VAT7%)", //税费 (VAT7%)
      LanguageConfigKeys.Shop_order_select_delivery: "Select Express", //选择快递
      LanguageConfigKeys.Shop_order_logistics_company:
          "Logistics Company", //物流公司
      LanguageConfigKeys.Shop_order_select_logistics_company:
          "Choose Logistics Company", //选择物流公司
      LanguageConfigKeys.Shop_order_delivery1: "Surface Mail", //平邮
      LanguageConfigKeys.Shop_order_delivery2: "Express Delivery", //快递
      LanguageConfigKeys.Shop_order_delivery3: "Thailand Post", //泰国邮政
      LanguageConfigKeys.Shop_order_freight_details: "Freight Details", //运费详情
      LanguageConfigKeys.Shop_order_goods_total: "Total price", //商品总价
      LanguageConfigKeys.Shop_order_total: "Total", //合计
      LanguageConfigKeys.Shop_order_payment_required: "Payment required", //需付款
      LanguageConfigKeys.Shop_order_total_discount: "Total discount", //共优惠
      LanguageConfigKeys.Shop_order_freight: "Freight", //运费
      LanguageConfigKeys.Shop_order_total_freight: "Total freight", //合计运费
      LanguageConfigKeys.Shop_order_place_order: "Place order", //提交订单
      LanguageConfigKeys.Shop_order_select_receive_address:
          "Please select a receiving address", //请添加收货地址
      LanguageConfigKeys.Shop_order_wait_for_payment:
          "Waiting for payment", //等待支付
      LanguageConfigKeys.Shop_order_order_sn: "Order Number", //订单编号
      LanguageConfigKeys.Shop_order_add_points: "Add Points", //获取积分
      LanguageConfigKeys.Shop_order_payment_type: "Payment Mode", //支付方式
      LanguageConfigKeys.Shop_order_order_time: "Order Time", //下单时间
      LanguageConfigKeys.Shop_order_payment_time: "Payment Time", //支付时间
      LanguageConfigKeys.Shop_order_receive_address: "Delivery Address", //收货信息
      LanguageConfigKeys.Shop_order_delivery_type: "Delivery Mode", //配送方式
      LanguageConfigKeys.Shop_order_delivery_time: "Delivery Time", //发货时间
      LanguageConfigKeys.Shop_order_calc_delivery_time:
          "Expected delivery", //预计发货
      LanguageConfigKeys.Shop_order_delivering: "Delivering", //配送中
      LanguageConfigKeys.Shop_order_signed_in: "Signed in", //已签收
      LanguageConfigKeys.Shop_order_to_be_settled: "To be settled", //待结算
      LanguageConfigKeys.Shop_order_be_careful: "Be careful", //注意
      LanguageConfigKeys.Shop_order_rule_tips:
          "According to the activity rules, the platform will conduct statistical settlement for 7 days when it is over. In this process, there may be ranking and reward changes due to user's chargeback. Please understand. The more following orders, the higher completion rates. Hope you enjoy it and earn more profits.", //根据活动规则，活动结束后，由平台进行为期7天的统计结算，此过程可能存在用户退单导致的排名及奖励变化，请谅解，跟单将有效提升成单率，祝您越来越顺，越玩越赚。
      LanguageConfigKeys.Shop_order_no_app_found:
          "No corresponding APP is found", //没有找到对应APP
      LanguageConfigKeys.Shop_order_pay_success: "Pay Success", //支付成功
      LanguageConfigKeys.Shop_order_pay_success_winning:
          "Congratulations on winning the lottery opportunity, 100% of the prize", //恭喜获得抽奖机会，100%中奖哦
      LanguageConfigKeys.Shop_order_pay_success_tip1:
          "Share the good goods with your friends！", //快去分享好货给好友吧！
      LanguageConfigKeys.Shop_order_share_goods: "Share qualified goods", //分享好货
      LanguageConfigKeys.Shop_order_pay_success_tip2:
          "Security Reminder: MXCOME will not require you to provide bank card information or pay additional fees for any reason except for real name authentication. Please beware of phishing links or fraudulent phone calls!", //安全提醒：除实名认证外MXCOME不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话！
      LanguageConfigKeys.shop_order_card_email_title:
          "Email / Web3 Wallet Registration Email (required)",
      LanguageConfigKeys.shop_order_card_email_hint:
          "Please provide your email address to receive coupon information.",
      LanguageConfigKeys.shop_order_card_email_not_empty:
          "Email cannot be empty.",
      LanguageConfigKeys.shop_order_card_email_error:
          "Please enter the correct email address", //请输入正确的邮箱地址
      LanguageConfigKeys.shop_order_virtual_product_tip:
          "Please confirm that you have entered the correct email address before paying for the order. Once the virtual goods are shipped, returns and exchanges are not supported , MXCOME does not assume responsibility.", //请确认输入正确邮箱地址后支付订单，虚拟商品一旦发货，不支持退换货，平台不承担责任。
      LanguageConfigKeys.Shop_order_delivery_to: "Ship to", //商品配送至
      LanguageConfigKeys.Shop_order_coupons_disable: "Unused coupons", //未使用优惠券
      LanguageConfigKeys.Shop_order_status: "Order status", //订单状态
      LanguageConfigKeys.Shop_order_confirm_change:
          "Confirm replacement", //确认更换
      LanguageConfigKeys.Shop_order_user_pay: "Pay", //用户付款
      LanguageConfigKeys.Shop_order_shop_deliver: "Deliver", //店铺发货
      LanguageConfigKeys.Shop_order_express_delivery: "Express", //快递配送
      LanguageConfigKeys.Shop_order_user_receipt: "Receive", //用户收货
      LanguageConfigKeys.Shop_order_detail_tip1: "To be paid", //等待支付
      LanguageConfigKeys.Shop_order_detail_tip2:
          "Payment completed, and the delivery is expected to be taken within 48 hours.", //支付完成，商家承诺在48小时内完成发货
      LanguageConfigKeys.Shop_order_detail_tip3: "Preparing", //店铺备货中
      LanguageConfigKeys.Shop_order_detail_tip4:
          "It will be delivered soon, and stay tuned.", //即将发货，敬请期待
      LanguageConfigKeys.Shop_order_delivery_detail: "Delivery details", //快递详情
      LanguageConfigKeys.Shop_order_order_completed: "Order completed", //订单已完成
      LanguageConfigKeys.Shop_order_order_canceled: "Order cancelled", //订单已取消
      LanguageConfigKeys.Shop_order_suggestions: "Customer advice", //客户建议
      LanguageConfigKeys.Shop_order_invalid: "Invalid order", //无效订单
      LanguageConfigKeys.Shop_order_prompt_pay: "Promptpay QR", //Promptpay QR
      LanguageConfigKeys.Shop_order_cashier: "Cashier", //收银台
      LanguageConfigKeys.Shop_order_pay_amount: "Pay Amount (฿)", //支付金额(฿)
      LanguageConfigKeys.Shop_order_pay_remaining_time:
          "Payment remaining time", //支付剩余时间
      LanguageConfigKeys.Shop_order_pay_qr_code:
          "Please take a screenshot to save the QR code", //请截图保存二维码
      LanguageConfigKeys.Shop_order_balance_pay: "Balance payment", //余额支付
      LanguageConfigKeys.Shop_order_kbank_pay: "Kbank", //泰国开泰银行
      LanguageConfigKeys.Shop_order_scb_pay: "SCB", //泰国汇商银行
      LanguageConfigKeys.Shop_order_bank_card_pay: "Bank card payment", //银行卡支付
      LanguageConfigKeys.Shop_order_select_pay: "Select payment", //请选择支付方式
      LanguageConfigKeys.Shop_order_official_pay: "Official payment", //官方支付
      LanguageConfigKeys.Shop_order_third_party_pay:
          "Third party payment", //第三方支付
      LanguageConfigKeys.Shop_order_delivery_collect: "Parcel ready", //快递揽收
      LanguageConfigKeys.Shop_order_brand_commitment: "Brand Assurance", //品牌承诺
      LanguageConfigKeys.Shop_order_platform_policy: "Platform Policy", //平台政策
      LanguageConfigKeys.Shop_order_brand: "Brand", //品牌
      LanguageConfigKeys.Shop_order_delivery: "Logistics", //物流
      LanguageConfigKeys.Shop_order_user: "User", //用户
      LanguageConfigKeys.Shop_order_sender_max_time:
          "Delivery/within 48 hours", //发货/48小时内
      LanguageConfigKeys.Shop_order_delivery_max_time:
          "Delivery/within 72 hours", //配送/72小时内
      LanguageConfigKeys.Shop_order_receipt_max_time:
          "Confirm receipt/within 48 hours", //收货/48小时内"
      LanguageConfigKeys.Shop_order_consume: "Time-consuming", //共耗时
      LanguageConfigKeys.Shop_order_promise: "Break a contract", //违约
      LanguageConfigKeys.Shop_order_platform_in: "Platform intervention", //平台介入
      LanguageConfigKeys.Shop_order_eligible:
          "The current order meets the requirements of「%s」", //当前订单符合「%s」条件
      LanguageConfigKeys.Shop_order_responsibility_division:
          "Clarify responsibilities", //责任划分
      LanguageConfigKeys.Shop_order_platform_tip1:
          "Platform handling principle: the breaching party shall bear the responsibility; The breaching party shall bear the corresponding postage.", //平台处理原则，谁违约，谁担责；违约方承担对应邮费
      LanguageConfigKeys.Shop_order_result: "Result", //处理结果
      LanguageConfigKeys.Shop_order_bear_the_postage: "Postage by %s", //由%s承担邮费
      LanguageConfigKeys.Shop_order_phone_verify: "Phone Authentication", //手机验证
      LanguageConfigKeys.Shop_order_set_pay_pwd:
          "Set payment password", //设置支付密码
      LanguageConfigKeys.Shop_order_confirm_pay_pwd:
          "Confirm payment password", //确认支付密码
      LanguageConfigKeys.Shop_order_pay_pwd_error:
          "Payment password error, please re-enter", //支付密码错误，请重新输入
      LanguageConfigKeys.Shop_order_id_verify: "ID Authentication", //身份验证
      LanguageConfigKeys.Shop_order_set_pay_pwd_tip:
          "Please set the payment password for payment verification", //请设置支付密码，用于支付验证
      LanguageConfigKeys.Shop_order_confirm_pay_pwd_tip:
          "Please enter again", //请再次输入
      LanguageConfigKeys.Shop_order_password_error:
          "The passwords you entered are inconsistent, so please re-enter", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Shop_order_please_enter_pwd:
          "Please enter the payment password", //请输入支付密码
      LanguageConfigKeys.Shop_order_prompt_pay_tip1:
          "Save the QR Code through screenshot ", //截图保存二维码
      LanguageConfigKeys.Shop_order_prompt_pay_tip2:
          "Please open any of your mobile banking apps for scanning code payment", //请打开您的任何手机银行应用进行扫码支付
      LanguageConfigKeys.Shop_order_prompt_pay_tip3:
          "Please confirm the order payment amount", //请确认订单支付金额
      LanguageConfigKeys.Shop_order_prompt_pay_tip4:
          "PromptPay does not support original route refunds, which will be refunded to your account balance", //PromptPay不支持原路退款，产生退款，款项将退入您的账户余额
      LanguageConfigKeys.Shop_order_prompt_pay_tip5:
          "After successful payment, please wait patiently for a moment on this page and click the button below to query the payment status", //付款成功后，请在此页面耐心等待片刻 点击下方按钮，查询付款状态
      LanguageConfigKeys.Shop_order_timeout: "Payment timeout", //支付超时
      LanguageConfigKeys.Shop_order_place_new_order:
          "The order has timed out, so please place a new order", //订单已取消，请重新下单
      LanguageConfigKeys.Shop_order_got_it: "Got it!", //明白了
      LanguageConfigKeys.Shop_order_iknow: "Got it", //知道了
      LanguageConfigKeys.Shop_order_cancel_payment:
          "You have canceled the payment", //您已取消了支付
      LanguageConfigKeys.Shop_order_after_pay_query:
          "After paying, click Query", //付款后，点击查询
      LanguageConfigKeys.Shop_order_not_pay:
          "Order not paid, please pay first", //订单未支付，请先付款
      LanguageConfigKeys.Shop_order_paying:
          "Order processing is in progress. Please try it again later", //订单处理中，请稍后再试
      LanguageConfigKeys.Shop_order_pay_failed: "Payment failed", //支付失败
      LanguageConfigKeys.Shop_order_install_scb:
          "Please install SCB EASY", //请安装SCB EASY
      LanguageConfigKeys.Shop_order_download_tip:
          "You have not downloaded the bank app yet, so please download it first!", //您还未下载银行APP，请先下载!
      LanguageConfigKeys.Shop_order_confirm_close_title:
          "Are you sure that you want to leave the cashier?", //确认要离开收银台?
      LanguageConfigKeys.Shop_order_confirm_close_message:
          "Your order has not been paid yet. Please pay as soon as possible!", //您的订单还未完成支付 请尽快支付!
      LanguageConfigKeys.Shop_order_confirm_close: "Confirm Departure", //确认离开
      LanguageConfigKeys.Shop_order_confirm_continue: "Continue Pay", //继续支付
      LanguageConfigKeys.Shop_order_not_support_pay:
          "This payment method is currently not supported", //暂不支持该支付方式
      LanguageConfigKeys.Shop_order_insufficient_balance:
          "Insufficient balance, please choose another payment method", //余额不足，请选择其它支付方式
      LanguageConfigKeys.Shop_order_package: "Package", //包裹
      LanguageConfigKeys.Shop_order_selected: "%s selected", //已选%s张
      LanguageConfigKeys.Shop_order_total_baby: "%s piece in total", //共%s件宝贝
      LanguageConfigKeys.Shop_order_return_coupon: "Return coupon", //退回优惠券
      LanguageConfigKeys.Shop_order_return_coupon_tip:
          "The coupon has been returned and you can use it again", //优惠券已退回，您可再次使用
      LanguageConfigKeys.Shop_order_detail_address_nav:
          "Address navigation", //地址导航
      LanguageConfigKeys.Shop_order_detail_address_nav_tip:
          "After purchase, the voucher code will be sent to your email / Web3 Wallet Registration Email.", //购买后，券码将发送至邮箱 / Web3钱包注册邮箱
      LanguageConfigKeys.Shop_sales_status: "After-sales status", //售后状态
      LanguageConfigKeys.Shop_sales_policy: "After-sales policy", //售后政策
      LanguageConfigKeys.Shop_sales_refund:
          "Refund for unpaid commodity", //未发货退款
      LanguageConfigKeys.Shop_sales_refund_success: "Refund succeeded", //退款成功
      LanguageConfigKeys.Shop_sales_refund_item1: "Wrong purchase", //买错了
      LanguageConfigKeys.Shop_sales_refund_item2:
          "No recommendation from friends", //朋友不推荐此商品
      LanguageConfigKeys.Shop_sales_refund_item3: "No reason", //没有理由
      LanguageConfigKeys.Shop_sales_return_refund: "Return and refund", //退货退款
      LanguageConfigKeys.Shop_sales_return_refund_item1:
          "Meet the return and refund requirements", //符合退货退款条件
      LanguageConfigKeys.Shop_sales_overtime:
          "Free for delivery timeout", //超时免单
      LanguageConfigKeys.Shop_sales_overtime_item1:
          "Meet the requirements of free for delivery timeout", //符合超时免单条件
      LanguageConfigKeys.Shop_sales_submit_order: "Submit", //提交订单
      LanguageConfigKeys.Shop_sales_merchant_verify: "Merchant review", //商家审核
      LanguageConfigKeys.Shop_sales_serivce_score: "Service score", //服务评分
      LanguageConfigKeys.Shop_sales_delivery_serive: "Delivery service", //快递服务
      LanguageConfigKeys.Shop_sales_verify_product: "Audit product", //审核商品
      LanguageConfigKeys.Shop_sales_detail: "After-sales details", //售后详情
      LanguageConfigKeys.Shop_sales_pending_refunded: "pending refund", //已退款
      LanguageConfigKeys.Shop_sales_refunded: "Refunded", //已退款
      LanguageConfigKeys.Shop_sales_refunded_reason: "refund reason", //退款原因
      LanguageConfigKeys.Shop_sales_number: "After-sale No", //售后单号
      LanguageConfigKeys.Shop_sales_apply_time: "Application time", //申请时间
      LanguageConfigKeys.Shop_sales_apply_type: "After-sales type", //售后类型
      LanguageConfigKeys.Shop_sales_apply_reason: "Reason", //申请原因
      LanguageConfigKeys.Shop_sales_take_info:
          "Delivery pickup information", //取件信息
      LanguageConfigKeys.Shop_sales_after_sales: "Complete", //完成售后
      LanguageConfigKeys.Shop_sales_refund_time: "Refund time", //退款时间
      LanguageConfigKeys.Shop_sales_return_balance:
          "Refund to the account balance in the end", //完成售后将退款至账户余额
      LanguageConfigKeys.Shop_sales_return_amount: "Refund amount", //退款金额
      LanguageConfigKeys.Shop_sales_platform_in:
          "Apply for platform intervention", //申请平台介入
      LanguageConfigKeys.Shop_sales_cancel_apply: "Cancel application", //取消申请
      LanguageConfigKeys.Shop_sales_cancel_success:
          "Cancel the application successfully", //取消申请成功
      LanguageConfigKeys.Shop_sales_least_two_pictures:
          "Upload at least two pictures", //至少上传两张图片
      LanguageConfigKeys.Shop_sales_apply: "Apply", //售后申请
      LanguageConfigKeys.Shop_sales_processing: "Processing", //处理中
      LanguageConfigKeys.Shop_sales_completed: "Completed", //售后完成
      LanguageConfigKeys.Shop_sales_application_record: "History", //申请记录
      LanguageConfigKeys.Shop_sales_service: "After-sales service", //售后服务
      LanguageConfigKeys.Shop_sales_service_tip1:
          "Please choose based on realities", //请根据实际情况进行选择
      LanguageConfigKeys.Shop_sales_service_tip2:
          "Malicious after-sales may lead to account ban for 30 days", //若恶意售后，可能导致违规封禁30天
      LanguageConfigKeys.Shop_sales_order_elapsed: "Time-consume", //订单已耗时
      LanguageConfigKeys.Shop_sales_overtime_tip1:
          "Platform notice: if the delivery is not completed for more than 7 days, users can apply for 'overtime free of charge'", //根据平台政策，超过7天未完成配送可申请超时免单
      LanguageConfigKeys.Shop_sales_overtime_tip2:
          "When the after-sales progress is over, the goods received can not be returned", //售后处理完毕后收到商品，可不予退回
      LanguageConfigKeys.Shop_sales_overtime_tip3:
          "Refunds will be returned according to the refund method selected", //退款将根据选择的退款方式退回
      LanguageConfigKeys.Shop_sales_service_detail:
          "Service charge details", //服务费明细
      LanguageConfigKeys.Shop_sales_total_service_fee:
          "Total service charge", //总服务费
      LanguageConfigKeys.Shop_sales_finish_route:
          "After-sales refund track", //售后完成退款路径
      LanguageConfigKeys.Shop_sales_balance: "Account balance", //账号余额
      LanguageConfigKeys.Shop_sales_apply_submit: "Submit Application", //提交申请
      LanguageConfigKeys.Shop_sales_verify_tip1:
          "Please wait patiently for the merchant to review and refund within 24 hours after the review", //请耐心等待商家审核，审核完成后24小时退款
      LanguageConfigKeys.Shop_sales_verify_tip2:
          "Please wait patiently for the merchant's review", //请耐心等待商家审核
      LanguageConfigKeys.Shop_sales_verify_tip3:
          "Your after-sales application has been successfully submitted and is waiting for the merchant to review. It will be processed within %s hours!", //售后申请已提交成功，待商家审核，将在12小时内处理完毕
      LanguageConfigKeys.Shop_sales_refund_tip1:
          "Only within 24 hours after placing an order can you change your address and apply for a refund", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_refund_tip2:
          "The service fee from the order and the vouchers are not refundable", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_return_refund_tip1:
          "Only change the address and refund application within 24 hours after placing the order", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_return_refund_tip2:
          "The service fee generated by the order and the coupons used will not be refunded", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_upload_photo:
          "Upload product image", //上传商品图片
      LanguageConfigKeys.Shop_sales_upload_photo_tip1:
          "Please upload the product photo. If it is damaged artificially, it is not supported to return or exchange goods", //请上传商品照片，若人为造成损坏，不支持退换货
      LanguageConfigKeys.Shop_sales_upload_photo_tip2:
          "Please keep the integrity of the product packaging, and the store will review it after receiving the goods", //请保持商品包装完整性，店铺收货后将进行审核
      LanguageConfigKeys.Shop_address_add: "Add", //新增
      LanguageConfigKeys.Shop_address_select_change:
          "Please select the replace address", //请选择更换地址
      LanguageConfigKeys.Shop_address_receipt_address:
          "Shipping Address", //收货地址
      LanguageConfigKeys.Shop_address_receipt_address_empty:
          "No receiving address is available", //暂无收货地址
      LanguageConfigKeys.Shop_address_add_receipt_info: "New Address", //新增收货信息
      LanguageConfigKeys.Shop_address_add_receipt_address:
          "New Address", //添加收货地址
      LanguageConfigKeys.Shop_address_edit_receipt_address:
          "Edit Address", //编辑收货地址
      LanguageConfigKeys.Shop_address_postcode_select: "Select postcode", //选择邮编
      LanguageConfigKeys.Shop_address_set_as_default_address:
          "Default Address", //设为默认
      LanguageConfigKeys.Shop_address_default: "Default", //默认
      LanguageConfigKeys.Shop_address_consignee: "Name", //收货人
      LanguageConfigKeys.Shop_address_phone: "Phone Number", //手机号
      LanguageConfigKeys.Shop_address_location: "Mailing Address", //所在地区
      LanguageConfigKeys.Shop_address_my_location: "My location", //定位
      LanguageConfigKeys.Shop_address_Locating: "Locating", //正在定位
      LanguageConfigKeys.Shop_address_detail_address: "Detailed Address", //详细地址
      LanguageConfigKeys.Shop_address_post_code: "Postcode", //邮编
      LanguageConfigKeys.Shop_address_consignee_empty:
          "Please enter consignee", //请输入收货人姓名
      LanguageConfigKeys.Shop_address_phone_empty:
          "Please enter your phone number", //请输入收货人手机号
      LanguageConfigKeys.Shop_address_location_empty:
          "Select Region", //请选择收货人所在地区
      LanguageConfigKeys.Shop_address_detail_address_empty:
          "Please enter the detailed address", //请输入详细收货地址
      LanguageConfigKeys.Shop_address_detail_address_hint:
          "Please enter the detailed shipping address, including the specific house/building number", //请输入详细收货地址，精确到门牌号
      LanguageConfigKeys.Shop_address_post_code_empty:
          "Please enter the postcode", //请输入邮编
      LanguageConfigKeys.Shop_address_save: "Save", //保存
      LanguageConfigKeys.Shop_address_is_delete:
          "Delete receiving address?", //是否删除收货地址?
      LanguageConfigKeys.Shop_address_select: "Select", //选择
      LanguageConfigKeys.Shop_address_please_select: "Please select", //请选择
      LanguageConfigKeys.Shop_address_please_enter: "Please enter", //请输入
      LanguageConfigKeys.Shop_address_street_address:
          "Street address and house number", //街道及门牌
      LanguageConfigKeys.Shop_address_assist_enter: "Assist", //辅助
      LanguageConfigKeys.Shop_address_confirm_detail_address:
          "Please confirm the detailed address.", //请确定详细地址
      LanguageConfigKeys.Shop_address_contact_info: "Contact", //联络信息
      LanguageConfigKeys.Shop_address_address_info: "Address", //地址信息
      LanguageConfigKeys.Shop_address_please_select_region:
          "Please select a region", //请选择区域
      LanguageConfigKeys.Shop_address_get_current_location:
          "Use My Current Location", //获取当前定位
      LanguageConfigKeys.Shop_address_found_for_you: "Found for you", //已为您找到
      LanguageConfigKeys.Shop_address_government: "Province", //府
      LanguageConfigKeys.Shop_address_county: "District", //县
      LanguageConfigKeys.Shop_address_village: "Sub-district", //镇
      LanguageConfigKeys.Shop_address_keywords:
          "Please enter address keywords", //请输入地址关键词
      LanguageConfigKeys.Shop_address_finish: "Complete", //完成
      LanguageConfigKeys.Shop_address_confirm_delivery_correct:
          "Please confirm the correct delivery information to avoid delivery delays", //请确认正确收件信息，避免收件延迟
      LanguageConfigKeys.Shop_setting_title: "Settings", //设置
      LanguageConfigKeys.Shop_setting_subscribe_follow:
          "Subscription and following", //订阅与关注
      LanguageConfigKeys.Shop_setting_subscribe_follow_detail:
          "Manage your subscriptions and following", //管理你的订阅与关注
      LanguageConfigKeys.Shop_setting_notification_manage:
          "Notice Management", //通知管理
      LanguageConfigKeys.Shop_setting_notification_manage_detail:
          "Whether to accept recommendations and attention messages", //是否接受推荐和关注的消息
      LanguageConfigKeys.Shop_setting_privacy_setting:
          "Privacy Settings", //隐私设置
      LanguageConfigKeys.Shop_setting_privacy_setting_detail:
          "Manage the content of information seen by others.", //管理其他人看到的信息内容
      LanguageConfigKeys.Shop_setting_account_safe:
          "Account and Security", //账号与安全
      LanguageConfigKeys.Shop_setting_account_safe_detail:
          "Change phone number, passwords, and account binding", //更改手机号、密码与账号绑定
      LanguageConfigKeys.Shop_setting_Language_change: "Change Language", //语言切换
      LanguageConfigKeys.Shop_setting_Language_change_detail:
          "Change the default language setting to your preferred language", //切换默认界面语言，默认为当前系统语言
      LanguageConfigKeys.Shop_setting_user_agreement: "User Agreement", //用户协议
      LanguageConfigKeys.Shop_setting_user_agreement_detail:
          "Sign and comply with relevant laws and regulations", //根据相关法律法规签署并遵照执行
      LanguageConfigKeys.Shop_setting_about: "About", //关于
      LanguageConfigKeys.Shop_setting_about_detail: "About MXCOME", //关于MXCOME
      LanguageConfigKeys.Shop_setting_about_version: "Version", //版本号
      LanguageConfigKeys.Shop_setting_about_new_version: "New Version", //新版本
      LanguageConfigKeys.Shop_setting_last_version:
          "It is already the latest version", //已是最新版本
      LanguageConfigKeys.Shop_setting_update_new_version:
          "Here is a new version!", //有新版本啦!
      LanguageConfigKeys.Shop_setting_update_time: "Update time", //更新时间
      LanguageConfigKeys.Shop_setting_now_update: "Update now", //立即更新
      LanguageConfigKeys.Shop_setting_account_cancellation:
          "Delete Account", //注销账号
      LanguageConfigKeys.Shop_setting_account_cancellation_detail:
          "Delete all data and log off permanently", //删除所有数据，永久注销
      LanguageConfigKeys.Shop_setting_account_cancel_tip1:
          "This will cancel your account", //这将注销你的账号
      LanguageConfigKeys.Shop_setting_account_cancel_tip2:
          "It must be noted that your MXCOME account (including your user ID, nickname, personal information, asset balance, etc.) will be permanently deleted from MXCOME and cannot be retrieved", //必须注意，你的MXCOME账号（包括你的用户ID、昵称、个人资料、资产余额等）将在MXCOME永久删除，无法找回。
      LanguageConfigKeys.Shop_setting_account_delete: "Delete", //注销
      LanguageConfigKeys.Shop_setting_account_confirm_delete:
          "Confirm account delete", //确认注销账号
      LanguageConfigKeys.Shop_setting_account_confirm_tip1:
          "Account balance %s, will permanently expire", //账户余额%s，将永久失效
      LanguageConfigKeys.Shop_setting_account_confirm_tip2:
          "Data such as account information and revenue records cannot be restored", //账号信息及收益记录等数据无法恢复
      LanguageConfigKeys.Shop_setting_account_not_delete: "Not Delete", //暂不注销
      LanguageConfigKeys.Shop_setting_account_now_delete: "Delete Now", //立即注销
      LanguageConfigKeys.Shop_setting_change_login: "Switch account", //切换账号
      LanguageConfigKeys.Shop_setting_exit_login: "Log out", //退出登录
      LanguageConfigKeys.Shop_setting_phone: "Phone Number", //手机号
      LanguageConfigKeys.Shop_setting_phone_detail:
          "Change phone number", //修改手机号
      LanguageConfigKeys.Shop_setting_update: "Modify", //修改
      LanguageConfigKeys.Shop_setting_update_pwd: "Change Password", //修改密码
      LanguageConfigKeys.Shop_setting_update_pwd_detail:
          "Change your password anytime", //随时修改你的密码
      LanguageConfigKeys.Shop_setting_pay_pwd: "Payment Password", //支付密码
      LanguageConfigKeys.Shop_setting_set_pay_pwd:
          "Setting payment password", //设置支付密码
      LanguageConfigKeys.Shop_setting_change_pay_pwd:
          "Change payment password", //修改支付密码
      LanguageConfigKeys.Shop_setting_pay_pwd_detail:
          "Setting and change Payment Password", //设置与修改支付密码
      LanguageConfigKeys.Shop_setting_third_auth: "Link Accounts", //第三方授权
      LanguageConfigKeys.Shop_setting_facebook: "Facebook", //Facebook
      LanguageConfigKeys.Shop_setting_google: "Google", //Google
      LanguageConfigKeys.Shop_setting_apple: "Apple", //Apple
      LanguageConfigKeys.Shop_setting_bind: "Bind", //绑定
      LanguageConfigKeys.Shop_setting_unbind: "Unbind", //解绑
      LanguageConfigKeys.Shop_activity: "Activities", //活动
      LanguageConfigKeys.Shop_activity_sponsor: "Sponsor", //主办方
      LanguageConfigKeys.Shop_activity_time: "Activity time", //活动时间
      LanguageConfigKeys.Shop_activity_complete_task:
          "Complete MXGET missions", //完成淘金任务
      LanguageConfigKeys.Shop_activity_obtain_goods_profit:
          "Obtain goods profit", //获得商品分润
      LanguageConfigKeys.Shop_activity_obtain_level_prize:
          "Obtain level prize", //获得关卡奖励
      LanguageConfigKeys.Shop_activity_obtain_top_prize:
          "Obtain top prize", //获得排名大奖
      LanguageConfigKeys.Shop_activity_obtain_top_prize_tips:
          "Top prize", //排名大奖
      LanguageConfigKeys.Shop_activity_now_start: "Challenge now", //立即挑战
      LanguageConfigKeys.Shop_activity_quick_understand: "Details", //快速了解
      LanguageConfigKeys.Shop_activity_top: "Top %s", //%s名
      LanguageConfigKeys.Shop_activity_count_down: "Count down", //倒计时
      LanguageConfigKeys.Shop_activity_level_count: "Level", //当前关卡
      LanguageConfigKeys.Shop_activity_level_prize: "Level prize", //关卡奖
      LanguageConfigKeys.Shop_activity_this_task: "This task", //本关任务
      LanguageConfigKeys.Shop_activity_closed: "Closed", //已结束
      LanguageConfigKeys.Shop_activity_not_exist: "Activity ended", //活动已结束
      LanguageConfigKeys.Shop_activity_current_top: "Current Top", //当前排名
      LanguageConfigKeys.Shop_activity_activity_top: "Activity Top", //活动排名
      LanguageConfigKeys.Shop_activity_not_listed: "Not listed", //未上榜
      LanguageConfigKeys.Shop_activity_top_big_prize: "Top big prize", //排名大奖
      LanguageConfigKeys.Shop_activity_get_gold: "Profit Received", //已淘金
      LanguageConfigKeys.Shop_activity_for_the_level: "%s level", //第%s关
      LanguageConfigKeys.Shop_activity_st_place: "%s st place", //%s等奖
      LanguageConfigKeys.Shop_activity_random_level_prize:
          "Level reward is randomly assigned 1 piece. Complete the challenge event to receive", //关卡奖励随机分配1件，完成活动挑战领取
      LanguageConfigKeys.Shop_activity_details: "Activity Challenge", //活动闯关
      LanguageConfigKeys.Shop_activity_over_status: "Status", //通关状态
      LanguageConfigKeys.Shop_activity_after_the_prize:
          "Receive prize after the competition", //完赛后领取奖励
      LanguageConfigKeys.Shop_activity_over_all_level: "Cleared", //已通关
      LanguageConfigKeys.Shop_activity_failed: "Failed", //淘汰
      LanguageConfigKeys.Shop_activity_not_start: "Not Started", //未开始
      LanguageConfigKeys.Shop_activity_doing: "Processing", //进行中
      LanguageConfigKeys.Shop_activity_prize: "Activity Prize", //活动奖品
      LanguageConfigKeys.Shop_activity_view_prize: "View Prizes", //查看奖品
      LanguageConfigKeys.Shop_activity_enter_activity: "View activity", //查看活动
      LanguageConfigKeys.Shop_activity_now_break_barrier:
          "Start activity", //立即闯关
      LanguageConfigKeys.Shop_activity_continue_break_barrier:
          "Continue activity", //继续闯关
      LanguageConfigKeys.Shop_activity_podium: "Podium", //领奖台
      LanguageConfigKeys.Shop_activity_completed_game: "Completed Game", //完赛
      LanguageConfigKeys.Shop_activity_mine_prize: "My prize", //我的奖励
      LanguageConfigKeys.Shop_activity_dispatched: "Dispatched", //已派完
      LanguageConfigKeys.Shop_activity_task_progressing:
          "Activity in progressing", //任务进行中
      LanguageConfigKeys.Shop_activity_activity_progressing:
          "Task in progressing", //活动进行中
      LanguageConfigKeys.Shop_activity_task_randomly_prize:
          "After the task is completed, the system will randomly issue task rewards", //待任务完成后系统将随机发放任务奖励
      LanguageConfigKeys.Shop_activity_activity_randomly_prize:
          "After the activity is completed, the system will randomly distribute the level rewards", //待活动完成后系统将随机发放关卡奖励
      LanguageConfigKeys.Shop_activity_for_the_level_prize:
          "%s level prize", //第%s关奖励
      LanguageConfigKeys.Shop_activity_top_prize: "Top prize", //排名奖
      LanguageConfigKeys.Shop_activity_task_prize: "Task prize", //任务奖品
      LanguageConfigKeys.Shop_activity_congratulation_complete_activity:
          "Congratulations on completing the activity task", //恭喜，完成活动任务
      LanguageConfigKeys.Shop_activity_congratulation_complete_task:
          "Congratulations on completing the task", //恭喜，完成任务
      LanguageConfigKeys.Shop_activity_get: "Get", //领取
      LanguageConfigKeys.Shop_activity_received: "Received", //已领取
      LanguageConfigKeys.Shop_activity_expired: "Expired", //已过期
      LanguageConfigKeys.Shop_activity_lottery_draw: "Lottery draw", //抽奖
      LanguageConfigKeys.Shop_activity_get_prize: "Get Prize", //领奖
      LanguageConfigKeys.Shop_activity_get_prize_stop: "Award deadline", //领奖截止
      LanguageConfigKeys.Shop_activity_available: "Available", //可领取
      LanguageConfigKeys.Shop_activity_item_level_prize: "Level prize", //件关卡奖励
      LanguageConfigKeys.Shop_activity_item_top_prize: "Top prize", //件排名奖励
      LanguageConfigKeys.Shop_activity_item_task_prize: "Task prize", //件任务奖励
      LanguageConfigKeys.Shop_activity_no_prize_available:
          "No prize available", //暂无可领取奖励
      LanguageConfigKeys.Shop_activity_please_select_prize:
          "Please select a prize", //请选择奖励
      LanguageConfigKeys.Shop_activity_history_activities:
          "History Activities", //历史活动
      LanguageConfigKeys.Shop_activity_history_tasks: "History Tasks", //历史任务
      LanguageConfigKeys.Shop_activity_draw_now: "Draw a lottery now", //立即抽奖
      LanguageConfigKeys.Shop_activity_continue_draw:
          "Continue the lottery", //继续抽奖
      LanguageConfigKeys.Shop_activity_total_mxget:
          "Activity Total MXGET", //本次活动共计淘金
      LanguageConfigKeys.Shop_activity_mxget_detail: "MXGET detail", //淘金明细
      LanguageConfigKeys.Shop_activity_view_details: "View Details", //查看明细
      LanguageConfigKeys.Shop_activity_activity_achievements:
          "Activity achievements", //活动成就
      LanguageConfigKeys.Shop_activity_level_draw_now_tip:
          "After the activity statistics are completed, a lottery can be drawn. Good luck to you", //活动统计完成后可抽奖，祝您好运
      LanguageConfigKeys.Shop_activity_top_rewards_tip:
          "After the event, you can get the activity ranking. You can receive an award at the end of the statistics", //活动结束并获得活动排名，统计结束可领奖
      LanguageConfigKeys.Shop_activity_statistics_completed:
          "Statistics completed", //距离统计完成
      LanguageConfigKeys.Shop_activity_countdown_drawing_receiving_prize:
          "Countdown to drawing/receiving prizes", //抽/领奖倒计时
      LanguageConfigKeys.Shop_activity_no_level_reward_tip:
          "Not received level rewards, keep working hard", //未获得关卡奖励，再接再厉
      LanguageConfigKeys.Shop_activity_no_rank_reward_tip:
          "Ranking not shortlisted, keep up the effort", //排名未入围，再接再厉
      LanguageConfigKeys.Shop_activity_success_get_level_reward_tip:
          "Congratulations on winning the level award", //恭喜获取关卡奖
      LanguageConfigKeys.Shop_activity_success_get_rank_reward_tip:
          "Congratulations on winning the ranking award", //恭喜获取排名奖
      LanguageConfigKeys.Shop_activity_no_prizes_level:
          "This level has no prizes", //该关卡没有奖品
      LanguageConfigKeys.Shop_activity_lottery_complete: "Complete", //完成
      LanguageConfigKeys.Shop_activity_lottery_tip1:
          "Click on the 'Draw Now' button to start", //点击“立即抽奖”按钮开始抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip2:
          "Each level only has one chance for a lottery. Complete the lottery in order", //每关仅有1次抽奖机会，按顺序完成抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip3:
          "Some products require payment for the balance", //部分商品需要支付差额
      LanguageConfigKeys.Shop_activity_lottery_tip4:
          "MXCOME has the final interpretation rights of this activity", //本活动最终解释权归平台所有
      LanguageConfigKeys.Shop_activity_click_challenge:
          "Click to start the challenge", //点击即可开始挑战
      LanguageConfigKeys.Shop_activity_challenge_failed_profit:
          "Exchange Failed, still able to calculate transaction profit", //挑战失败，仍可计算成交分润
      LanguageConfigKeys.Shop_activity_abandoning: "Abandon", //放弃活动
      LanguageConfigKeys.Shop_activity_rules: "Activity Rules", //活动规则
      LanguageConfigKeys.Shop_activity_complete_level_lock_new_level:
          "Complete this level to unlock a new one", //完成本关，即可解锁新关
      LanguageConfigKeys.Shop_activity_ranking_information:
          "Display ranking information after participation", //参与后展示排名信息
      LanguageConfigKeys.Shop_activity_rule_tip1:
          "Unlock new levels with 10 transactions per level", //每关任意成交1单，即可解锁新关卡
      LanguageConfigKeys.Shop_activity_rule_tip2:
          "Successful level challenge, draw the level award at the podium", //关卡挑战成功，在领奖台抽取关卡奖
      LanguageConfigKeys.Shop_activity_rule_tip3:
          "Successfully challenged the event and received a ranking award based on ranking", //活动挑战成功，根据排名获得排名奖
      LanguageConfigKeys.Shop_activity_rule_tip4:
          "The more transactions, the faster the completion speed, and the higher the ranking", //成交越多，完成速度越快，排名越高
      LanguageConfigKeys.Shop_activity_abandoning_tip:
          "During the event period, you are not allowed to participate in this event again.\nThe products sold will be distributed profits after the statistical period", //活动期间不得再次参与本次活动\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_success_participated:
          "Successfully participated", //参与成功
      LanguageConfigKeys.Shop_activity_success_participated_tip1:
          "Congratulations on successfully participating in MXGET activity", //恭喜，成功参与淘金活动
      LanguageConfigKeys.Shop_activity_success_participated_tip2:
          "Strive to overcome challenges and receive generous profits and prizes that belong to you", //努力闯关，获得属于你的丰厚利润与奖品
      LanguageConfigKeys.Shop_activity_confirm_abandonment: "Confirm", //确定放弃
      LanguageConfigKeys.Shop_activity_arbitrary_deal:
          "Completed 1 orders", //任意成交1单
      LanguageConfigKeys.Shop_activity_deal: "Deal", //成交
      LanguageConfigKeys.Shop_activity_one_step_success:
          "One step away from success", //距成功一步之遥
      LanguageConfigKeys.Shop_activity_continue_recommend:
          "Before the end of the activity, you can continue to recommend", //活动结束前，可以继续推荐
      LanguageConfigKeys.Shop_activity_wait_statistics_completed:
          "Congratulations, please be patient and wait for the statistics to be completed", //恭喜，请耐心等待统计完成
      LanguageConfigKeys.Shop_activity_congratulations_get_prize:
          "Congratulations. Click to accept the prize", //恭喜完成，点击领奖
      LanguageConfigKeys.Shop_activity_successfully_crossed:
          "Successfully crossed the level", //闯关成功
      LanguageConfigKeys.Shop_activity_successfully_crossed_tip:
          "Congratulations on successfully passing the level. Well begun is half done! During the event, you can choose any unlocked level to continue recommending", //恭喜，闯关成功，好的开始是成功的一半！\n活动期间，您可选择任意已解锁关卡继续推荐
      LanguageConfigKeys.Shop_activity_enter_next_level:
          "Enter Next Level", //进入下一关
      LanguageConfigKeys.Shop_activity_all_level_success:
          "Congratulations on clearance", //恭喜通关
      LanguageConfigKeys.Shop_activity_all_level_success_tip:
          "Congratulations on successfully completing all activity levels. \nCurrently, there is still time to recommend the Sprint Ranking Award", //恭喜您顺利完成所有活动关卡\n当前仍有时间，继续推荐冲刺排名大奖
      LanguageConfigKeys.Shop_activity_all_level_success_tip2:
          "Congratulations on successfully completing all activity levels.", //恭喜您顺利完成所有活动关卡
      LanguageConfigKeys.Shop_activity_obsolete: "Obsolete", //已淘汰
      LanguageConfigKeys.Shop_activity_obsolete_tip:
          "Failure is the mother of success. You can challenge again! \n You will receive profit from the sold product after the statistical period", //失败乃成功之母，您可以再次发起挑战！\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_homepage: "Back to Home", //返回首页
      LanguageConfigKeys.Shop_activity_remaining_collection_time:
          "Remaining collection time", //截止领奖时间
      LanguageConfigKeys.Shop_activity_waiting_statistics:
          "Waiting for completion of statistics", //等待统计完成
      LanguageConfigKeys.Shop_activity_get_prize_finish:
          "The time for receiving the prize has ended", //领奖时间已结束
      LanguageConfigKeys.Shop_activity_selected: "Selected", //已抽中
      LanguageConfigKeys.Shop_activity_total_prizes: "Total prizes", //奖品总计
      LanguageConfigKeys.Shop_activity_after_receiving_check_order:
          "After receiving the prize, check in the order", //领奖后请在订单查看
      LanguageConfigKeys.Shop_activity_no_lottery: "No lottery", //未抽奖
      LanguageConfigKeys.Shop_activity_not_counted: "Not counted", //未统计
      LanguageConfigKeys.Shop_activity_mxget_activity:
          "MXGET Activities", //淘金活动
      LanguageConfigKeys.Shop_activity_48_hours:
          "Less than 48 hours until the end of the activity", //距活动结束不足48小时
      LanguageConfigKeys.Shop_activity_soon_timeout:
          "Please complete the activity as soon as possible after accepting it", //接受活动后请尽快完成
      LanguageConfigKeys.Shop_pocket: "Pocket", //口袋
      LanguageConfigKeys.Shop_pocket_task: "Tasks", //任务
      LanguageConfigKeys.Shop_pocket_late_task_over:
          "Late, the task is over", //来晚了，任务已结束
      LanguageConfigKeys.Shop_pocket_select_product: "Select Goods", //选择商品
      LanguageConfigKeys.Shop_pocket_task_over: "Task ended", //任务已结束
      LanguageConfigKeys.Shop_pocket_completed_profit:
          "Complete profits", //完成分润
      LanguageConfigKeys.Shop_pocket_obsolete: "Obsolete", //已淘汰
      LanguageConfigKeys.Shop_pocket_share_profit: "Profits", //分润
      LanguageConfigKeys.Shop_pocket_profit: "Profits", //利润
      LanguageConfigKeys.Shop_pocket_task_stock: "Task stock", //任务库存
      LanguageConfigKeys.Shop_pocket_task_start_time:
          "Task Start Time", //任务开始时间
      LanguageConfigKeys.Shop_pocket_level: "Pocket", //口袋
      LanguageConfigKeys.Shop_pocket_more_orders_to_level:
          "To reach %s, complete %s more orders", //距%s还需要完成%s单
      LanguageConfigKeys.Shop_pocket_detail: "Pocket Details", //口袋详情
      LanguageConfigKeys.Shop_pocket_see_rules: "View Rules", //查看规则
      LanguageConfigKeys.Shop_pocket_activity_rules: "Activity Rules", //活动规则
      LanguageConfigKeys.Shop_pocket_mine_pocket: "My Pocket", //我的口袋
      LanguageConfigKeys.Shop_pocket_task_volume: "Tasks Limit", //任务容量
      LanguageConfigKeys.Shop_pocket_activity_volume: "Activity Limit", //活动容量
      LanguageConfigKeys.Shop_pocket_pocket_upgrade: "Upgrade Limit", //口袋升级
      LanguageConfigKeys.Shop_pocket_accept_share_profit:
          "Maximum profit sharing", //最大分润
      LanguageConfigKeys.Shop_pocket_mine_income: "Earning", //我的收益
      LanguageConfigKeys.Shop_pocket_history_income: "Past Income", //历史收益
      LanguageConfigKeys.Shop_pocket_this_month_income: "Monthly Income", //本月收益
      LanguageConfigKeys.Shop_pocket_today_income: "Current Income", //今日收益
      LanguageConfigKeys.Shop_pocket_like: "Likes", //点赞
      LanguageConfigKeys.Shop_pocket_like_empty_tip:
          "Like your favorite product. We will recommend products and tasks based on your preferences", //点赞心仪的商品\n我们将根据您的喜好进行商品及任务推荐
      LanguageConfigKeys.Shop_pocket_go_stroll: "Explore", //去逛逛
      LanguageConfigKeys.Shop_pocket_tasking: "In progress", //正在进行
      LanguageConfigKeys.Shop_pocket_mxget_history: "MXGET History", //淘金历史
      LanguageConfigKeys.Shop_pocket_task_completion_degree:
          "Complete %s", //完成%s
      LanguageConfigKeys.Shop_pocket_days: "day", //天
      LanguageConfigKeys.Shop_pocket_hours: "hr.", //更多精彩活动,敬请期待
      LanguageConfigKeys.Shop_pocket_copy_link: "Copy Link", //复制链接
      LanguageConfigKeys.Shop_pocket_add: "Add", //添加
      LanguageConfigKeys.Shop_pocket_incomplete: "Incomplete", //未完成
      LanguageConfigKeys.Shop_pocket_completed: "Completed", //已完成
      LanguageConfigKeys.Shop_pocket_time: "Task Time", //任务时间
      LanguageConfigKeys.Shop_pocket_lock_stock: "Lock stock", //锁定库存
      LanguageConfigKeys.Shop_pocket_maximum_profit_sharing:
          "Maximum profit sharing", //最大分润
      LanguageConfigKeys.Shop_pocket_piece: "piece", //件
      LanguageConfigKeys.Shop_pocket_accept_task: "Accept task", //接受任务
      LanguageConfigKeys.Shop_pocket_space: "Pocket space", //口袋空间
      LanguageConfigKeys.Shop_pocket_order_received_success:
          "Order receiving successfully", //恭喜，接单成功
      LanguageConfigKeys.Shop_pocket_order_receiving_failed:
          "Order receiving failed", //抱歉，接单失败
      LanguageConfigKeys.Shop_pocket_rule_title: "Order Rules", //接单规则
      LanguageConfigKeys.Shop_pocket_rule_tip1:
          "All brands of the store are self-operated, ",
      LanguageConfigKeys.Shop_pocket_rule_tip2:
          "No capital investment is needed ",
      LanguageConfigKeys.Shop_pocket_rule_tip3:
          "Users can recommend products to their friends",
      LanguageConfigKeys.Shop_pocket_rule_tip4:
          "After the friend confirms the receipt of the goods",
      LanguageConfigKeys.Shop_pocket_rule_tip5:
          "The more recommendation, the more earning",
      LanguageConfigKeys.Shop_pocket_rule_tip6:
          "The number of tasks that a MXWINNER can take depends on the pocket level",
      LanguageConfigKeys.Shop_pocket_rule_tip7:
          "When the task and activity time are over",
      LanguageConfigKeys.Shop_pocket_rule_tip8: "When withdrawing cash",
      LanguageConfigKeys.Shop_pocket_rule_tip9: "Click farming is prohibited",
      LanguageConfigKeys.Shop_pocket_rule_tip10:
          "Users should consciously abide by national laws",
      LanguageConfigKeys.Shop_pocket_rule_value_tip1:
          "With 100% genuine products and official after-sales guarantee",
      LanguageConfigKeys.Shop_pocket_rule_value_tip2:
          "Make money easily by taking orders with a mobile phone",
      LanguageConfigKeys.Shop_pocket_rule_value_tip3:
          "After friends complete the purchase of goods, users can get benefits",
      LanguageConfigKeys.Shop_pocket_rule_value_tip4:
          "The user's income will be automatically transferred to the balance which can be withdrawn at any time",
      LanguageConfigKeys.Shop_pocket_rule_value_tip5:
          "The higher the pocket level, the higher the receivable tasks",
      LanguageConfigKeys.Shop_pocket_rule_value_tip6:
          "It means that the higher the pocket level, the more tasks you can take",
      LanguageConfigKeys.Shop_pocket_rule_value_tip7:
          "The task of MXWINNER is naturally suspended",
      LanguageConfigKeys.Shop_pocket_rule_value_tip8:
          "Users must complete real-name authentication and bank card binding",
      LanguageConfigKeys.Shop_pocket_rule_value_tip9:
          "If the system finds it out, the order will be suspended",
      LanguageConfigKeys.Shop_pocket_rule_value_tip10:
          "and regulations and pay taxes on income according to law.",
      LanguageConfigKeys.Shop_pocket_simple_level: "Level", //等级
      LanguageConfigKeys.Shop_pocket_simple_capacity: "Capacity", //容量
      LanguageConfigKeys.Shop_pocket_simple_foul: "Foul", //违规
      LanguageConfigKeys.Shop_pocket_success_tips1:
          "If you want to quickly improve your income, pay attention to MXGET College immediately", //想快速提高收益，立即关注淘金学院
      LanguageConfigKeys.Shop_pocket_success_tips2:
          "Please complete the task within 48 hours which will be closed after timeout", //请在48小时内完成该任务，超时关闭
      LanguageConfigKeys.Shop_pocket_success_tips3:
          "The order will occupy a task capacity. Order replacement is allowed", //接单将占用一个任务容量，支持更换
      LanguageConfigKeys.Shop_pocket_failed_level_tips:
          "Please continue to complete the existing task, and the order cannot be received repeatedly", //请继续完成现有任务，不可重复接单
      LanguageConfigKeys.Shop_pocket_failed_capacity_tips:
          "Please upgrade the task pocket level to be qualified for receiving orders", //请提升任务口袋等级，达到接单资格
      LanguageConfigKeys.Shop_pocket_failed_foul_tips:
          "After the closing time for violations, the order will be automatically resumed", //违规封禁时间结束后，自动恢复接单
      LanguageConfigKeys.Shop_pocket_view_pockets: "View Pocket", //查看口袋
      LanguageConfigKeys.Shop_pocket_select_a_task:
          "Please select a task", //请选择一个任务
      LanguageConfigKeys.Shop_pocket_task_stock_insufficient:
          "Insufficient task inventory", //任务库存不足
      LanguageConfigKeys.Shop_pocket_total_pieces: "Total %s pieces", //共计%s件
      LanguageConfigKeys.Shop_pocket_complete_orders:
          "Complete 10 orders", //完成10单
      LanguageConfigKeys.Shop_pocket_task_prize: "Task Prize", //任务奖品
      LanguageConfigKeys.Shop_pocket_tip: "Tip", //友情提示
      LanguageConfigKeys.Shop_pocket_48_hours:
          "Less than 48 hours until the end of the task", //距任务结束不足48小时
      LanguageConfigKeys.Shop_pocket_task_soon_timeout:
          "Please complete the task as soon as possible after accepting it", //接受任务后请尽快完成
      LanguageConfigKeys.Shop_pocket_task_end_time: "Task end time", //任务截止
      LanguageConfigKeys.Shop_pocket_goods_sold: "Sold", //商品已售
      LanguageConfigKeys.Shop_pocket_goods_stock: "Stock", //商品库存
      LanguageConfigKeys.Shop_pocket_task_detail: "Task Details", //任务详情
      LanguageConfigKeys.Shop_pocket_rule_policy: "Rule policy", //规则策略
      LanguageConfigKeys.Shop_pocket_number_to_be_completed:
          "Orders Requirement", //完成单量
      LanguageConfigKeys.Shop_pocket_task_profit_sharing:
          "Profits Receivable per Order", //可接分润
      LanguageConfigKeys.Shop_pocket_upgrade: "Next Pocket Level", //升级后
      LanguageConfigKeys.Shop_pocket_current_level: "Current Level", //当前等级
      LanguageConfigKeys.Shop_pocket_current_level_tip:
          "can accept tasks with profit value ≤%s", //可接分润≤%s的所有任务商品
      LanguageConfigKeys.Shop_pocket_doing: "Processing", //进行中
      LanguageConfigKeys.Shop_pocket_counted: "To Be Counted", //待统计
      LanguageConfigKeys.Shop_pocket_challenge_now: "Challenge Now", //立即挑战
      LanguageConfigKeys.Shop_pocket_continue_to_challenge:
          "Continue challenge", //继续挑战
      LanguageConfigKeys.Shop_pocket_join_now: "Join Now", //立即参与
      LanguageConfigKeys.Shop_pocket_participated: "Participated", //已参与
      LanguageConfigKeys.Shop_pocket_task_completed: "Completed", //已成交
      LanguageConfigKeys.Shop_pocket_conversion_rate: "Conversion rate", //转化率
      LanguageConfigKeys.Shop_pocket_remain: "Duration", //还剩
      LanguageConfigKeys.Shop_pocket_counted_shop: "Counted stop", //统计完成
      LanguageConfigKeys.Shop_pocket_completed_counted:
          "Completed Counted", //已完成统计
      LanguageConfigKeys.Shop_pocket_task_counted_tip:
          "1.When you finish a task, there is a %s days period for calculating incomes.\n2.Once the counting is complete, your dynamic income will be added to your balance and is available for withdrawal. If someone cancels an order, the earnings for that order will not be added to your balance.", //任务结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_activity_counted_tip:
          "1.When you finish a activity, there is a %s days period for calculating incomes.\n2.Once the counting is complete, your dynamic income will be added to your balance and is available for withdrawal. If someone cancels an order, the earnings for that order will not be added to your balance.", //活动结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_task_finish: "Completed", //已完结
      LanguageConfigKeys.Shop_pocket_get_now: "Get Now", //立即领取
      LanguageConfigKeys.Shop_pocket_upcoming_profits:
          "Upcoming profits", //即将分润
      LanguageConfigKeys.Shop_pocket_upcoming_award: "Upcoming award", //即将派奖
      LanguageConfigKeys.Shop_pocket_recommend_now: "Recommend", //立即推荐
      LanguageConfigKeys.Shop_pocket_buyer: "Buyer", //购买者
      LanguageConfigKeys.Shop_pocket_purchase_record:
          "Transaction record", //成交记录
      LanguageConfigKeys.Shop_pocket_purchase_users: "Users", //用户
      LanguageConfigKeys.Shop_pocket_purchase_time: "Purchase time", //购买时间
      LanguageConfigKeys.Shop_pocket_purchase_quantity: "Quantity", //数量
      LanguageConfigKeys.Shop_pocket_chargeback_record: "Refund Record", //退单记录
      LanguageConfigKeys.Shop_pocket_chargeback_time: "Chargeback time", //退单时间
      LanguageConfigKeys.Shop_pocket_total_purchase:
          "Total transaction income", //总成交收益
      LanguageConfigKeys.Shop_pocket_total_chargeback:
          "Total refund income", //总退单收益
      LanguageConfigKeys.Shop_pocket_sold_out: "Sold out", //已售罄
      LanguageConfigKeys.Shop_pocket_prize: "Rewards", //奖品
      LanguageConfigKeys.Shop_pocket_promotion_center:
          "Promotion Center", //推广中心
      LanguageConfigKeys.Shop_pocket_promotion_qualification:
          "Promotion qualification", //推广资格
      LanguageConfigKeys.Shop_pocket_red_level: "Red level ", //红包闯关
      LanguageConfigKeys.Shop_pocket_not_active: "Not active", //未激活
      LanguageConfigKeys.Shop_pocket_activated: "Activated", //已激活
      LanguageConfigKeys.Shop_pocket_not_red_level:
          "Did not obtain the qualification for red level", //未获得红包闯关资格
      LanguageConfigKeys.Shop_pocket_earned: "Earned", //已赚到
      LanguageConfigKeys.Shop_pocket_period_validity:
          "Period of validity", //有效期
      LanguageConfigKeys.Shop_pocket_complete_task_tip:
          "Lease complete any task within the validity period", //请于有效期内完成任意任务
      LanguageConfigKeys.Shop_pocket_mxget_task: "MXGET Tasks", //淘金任务
      LanguageConfigKeys.Shop_pocket_change_task: "Change task", //更换任务
      LanguageConfigKeys.Shop_pocket_current_task: "Current task", //当前任务
      LanguageConfigKeys.Shop_pocket_this_week: "This week", //本周
      LanguageConfigKeys.Shop_pocket_this_month: "This month", //本月
      LanguageConfigKeys.Shop_pocket_last_month: "Last month", //上月
      LanguageConfigKeys.Shop_pocket_enable_prize: "With prize", //可领奖
      LanguageConfigKeys.Shop_pocket_winning_task_prize:
          "Winning task prizes", //获得任务奖品
      LanguageConfigKeys.Shop_pocket_winning_task_prize_tip:
          "After receiving the prize, you can view the shipping status in the order", //领奖后，可在订单中查看发货状态
      LanguageConfigKeys.Shop_pocket_sale: "Sales", //销售
      LanguageConfigKeys.Shop_pocket_prize_price: "Prize Price", //奖品价
      LanguageConfigKeys.Shop_bank_card: "Bank Account", //银行账户
      LanguageConfigKeys.Shop_bank_add_card: "Add Bank Account", //添加银行账户
      LanguageConfigKeys.Shop_bank_edit_card: "Edit Bank Account", //修改银行账户
      LanguageConfigKeys.Shop_bank_id_card_user: "ID card user", //身份证用户
      LanguageConfigKeys.Shop_bank_passport_user: "Passport user", //护照用户
      LanguageConfigKeys.Shop_bank_only_en_th:
          "English and Thai only", //仅支持英文及泰文
      LanguageConfigKeys.Shop_bank_add_card_tip1:
          "For ID card users, the account name must be consistent with the real-name authentication name.", //身份证用户，账户姓名必须与实名认证姓名保持一致
      LanguageConfigKeys.Shop_bank_add_card_tip2:
          "For passport users, you must hold a Thai bank account. You could change the name if necessary.", //护照用户，必须是泰国银行账户持有人，如有必要可更改姓名
      LanguageConfigKeys.Shop_bank_add_card_tip3:
          "Please enter the bank name and account number correctly, or it is failed to withdraw.", //请正确输入银行名称及银行帐号，否则将提现失败
      LanguageConfigKeys.Shop_bank_bank_name: "Bank Name", //银行名称
      LanguageConfigKeys.Shop_bank_card_number: "Bank account", //银行账号
      LanguageConfigKeys.Shop_bank_next_step: "Next", //下一步
      LanguageConfigKeys.Shop_bank_unkown_open_bank: "Unknown Bank", //未知银行
      LanguageConfigKeys.Shop_bank_delete_card: "Delete bank card?", //是否删除银行卡?
      LanguageConfigKeys.Shop_bank_card_already_exist:
          "The bank account has already been linked to another account. Please change the linked bank account", //该银行账号已被其他账号绑定，请更换绑定银行账号！
      LanguageConfigKeys.Shop_wallet_mxcome: "MXCOME Protection", //MXCOME安全保障中
      LanguageConfigKeys.Shop_wallet_mxget_income: "Dynamic Income", //动态收益
      LanguageConfigKeys.Shop_wallet_transferred_balance:
          "Transferred balance", //转入余额
      LanguageConfigKeys.Shop_wallet_chargeback: "Chargeback", //退单
      LanguageConfigKeys.Shop_wallet_rebate: "rebate", //消费返利
      LanguageConfigKeys.Shop_wallet_daily_benefits: "Daily benefits", //每日福利
      LanguageConfigKeys.Shop_wallet_newcomer_join: "Register benefits", //注册福利
      LanguageConfigKeys.Shop_wallet_last_income: "Recent\nIncome", //最近一笔
      LanguageConfigKeys.Shop_wallet_income_detail: "MXGET detail", //收益明细
      LanguageConfigKeys.Shop_wallet_pocket_money: "Pocket money", //零花钱
      LanguageConfigKeys.Shop_wallet_now_apply: "Apply now", //立即申请
      LanguageConfigKeys.Shop_wallet_recharge: "Recharge", //充值
      LanguageConfigKeys.Shop_wallet_withdrawal: "Withdraw", //提现
      LanguageConfigKeys.Shop_wallet_withdrawal_finish: "Withdrawn", //已提现
      LanguageConfigKeys.Shop_wallet_withdrawal_fail:
          "(Withdrawal failed)", //提现失败
      LanguageConfigKeys.Shop_wallet_refund: "Refund", //退款
      LanguageConfigKeys.Shop_wallet_service_charges_fee:
          "Withdrawal handling fee", //提现手续费
      LanguageConfigKeys.Shop_wallet_service_fee:
          "Withdrawal handling fee", //手续费
      LanguageConfigKeys.Shop_wallet_fee_rate: "Rate", //费率
      LanguageConfigKeys.Shop_wallet_income: "Income", //收益
      LanguageConfigKeys.Shop_wallet_bank_card_bind: "Bank card bound", //已绑定银行卡
      LanguageConfigKeys.Shop_wallet_card_tip:
          "Account check, withdrawal, recharge", //查账单、提现、充值
      LanguageConfigKeys.Shop_wallet_withdrawal_tip:
          "Your withdrawal request has been successfully submitted. Please be patient and wait for further updates", //提现申请已提交成功，请耐心等待
      LanguageConfigKeys.Shop_wallet_withdrawal_amount_tip:
          "Please enter the correct amount", //请输入正确的金额
      LanguageConfigKeys.Shop_wallet_withdrawal_balance_tip:
          "The withdrawal amount cannot exceed the withdrawable amount", //提现金额不能超过可提现金额
      LanguageConfigKeys.Shop_wallet_today_withdrawal_balance_tip:
          "The withdrawal amount exceeds today's available withdrawal amount", //提现金额超过今日可提金额
      LanguageConfigKeys.Shop_wallet_withdrawal_time_tip:
          "The withdrawal will be credited within 24 hours. Withdrawals on statutory holidays will be automatically deferred to working days.", //提现打款周期为每周一次，每周五统一打款，如申请时间在打款时间之后，顺延到下个打款周期，请合理安排时间
      LanguageConfigKeys.Shop_wallet_cash_withdrawal_rules:
          "Withdrawal Rules", //提现规则
      LanguageConfigKeys.Shop_wallet_balance_detail: "Balance Details", //资产明细
      LanguageConfigKeys.Shop_wallet_all: "All", //查看所有
      LanguageConfigKeys.Shop_wallet_balance: "Balance", //余额
      LanguageConfigKeys.Shop_wallet_task_profit_sharing:
          "Task profit sharing", //任务分润
      LanguageConfigKeys.Shop_wallet_red_packet_withdrawal:
          "Red Packet Withdrawal", //红包提现
      LanguageConfigKeys.Shop_wallet_mxget_profit: "MXGET profit", //淘金分润
      LanguageConfigKeys.Shop_wallet_buy_goods: "Buy goods", //购买商品
      LanguageConfigKeys.shop_wallet_expire_date: "Expire Date", //卡有效期
      LanguageConfigKeys.shop_wallet_change_name: "Change name", //更换姓名
      LanguageConfigKeys.shop_wallet_change_name_tip:
          "Please confirm the information. Incorrect account will make it impossible to withdraw cash.", //请确认资料，账户错误将导致无法提现
      LanguageConfigKeys.Shop_search_everyone: "Everyone is searching", //大家都在搜
      LanguageConfigKeys.Shop_search_history: "History search", //历史搜索
      LanguageConfigKeys.Shop_monday: "Monday", //周一
      LanguageConfigKeys.Shop_tuesday: "Tuesday", //周二
      LanguageConfigKeys.Shop_wednesday: "Wednesday", //周三
      LanguageConfigKeys.Shop_thursday: "Thursday", //周四
      LanguageConfigKeys.Shop_friday: "Friday", //周五
      LanguageConfigKeys.Shop_saturday: "Saturday", //周六
      LanguageConfigKeys.Shop_sunday: "Sunday", //周日
      LanguageConfigKeys.Shop_today: "Today", //今天
      LanguageConfigKeys.Shop_notification: "Notice", //通知
      LanguageConfigKeys.Shop_permission_denied: "Disallow", //拒绝
      LanguageConfigKeys.Shop_permission_granted: "Allow", //允许
      LanguageConfigKeys.Shop_permission_setting_cancel: "Cancel", //取消
      LanguageConfigKeys.Shop_permission_setting_open: "Go Open", //去开启
      LanguageConfigKeys.Shop_permission_camera_title:
          "“MXCOME” wants to access your camera", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_camera_content:
          "Please allow MXCOME to use your camera permissions for features such as avatar and ID photo uploading", //请允许MXCOME使用你的相机权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_camera_setting_title:
          "Enable camera permissions", //开启相机权限
      LanguageConfigKeys.Shop_permission_camera_setting_content:
          "Please enable camera permissions in [Settings Application] before using functions such as taking photos", //请在[设置-应用]中开启摄像头权限，开启后才可使用拍照等功能
      LanguageConfigKeys.Shop_permission_photos_title:
          "'MXCOME' requests for storage permissions", //“MXCOME”申请存储权限
      LanguageConfigKeys.Shop_permission_photos_content:
          "Please allow MXCOME to use storage permissions for functions such as uploading avatars and ID photos", //请允许MXCOME使用存储权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_photos_setting_title:
          "Enable storage permissions", //开启存储权限
      LanguageConfigKeys.Shop_permission_photos_setting_content:
          "Please enable the storage permission of reading and writing in [Settings Application] before photo uploading and using other functions", //请在[设置-应用]中开启读写存储权限，开启后才可使用照片上传等功能
      LanguageConfigKeys.Shop_permission_location_title:
          "Location Permission Usage Instructions", //位置权限使用说明
      LanguageConfigKeys.Shop_permission_location_content:
          "MXCOME wants to access your geographical location, and will provide an accurate shipping address based on your geographical location. You have the right to refuse or cancel the authorization, and the cancellation will not affect your use of other services", //MXCOME想访问您的地理位置，将根据您的地理位置提供准确的收货地址，您有权拒绝或取消授权，取消后不影响您使用其他服务
      LanguageConfigKeys.Shop_permission_location_setting_title:
          "Open Location Permissions", //开启位置权限
      LanguageConfigKeys.Shop_permission_location_setting_content:
          "Please enable the location permission in [Settings-Application] before using functions such as positioning", //请在[设置-应用]中开启位置权限，开启后才可使用定位等功能
      LanguageConfigKeys.Shop_permission_scan_title:
          "“MXCOME” wants to access your camera", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_scan_content:
          "Please allow MXCOME to obtain your camera for functions such as QR code scanning and products identification", //请允许MXCOME获取你的相机，用于扫描二维码、识别商品等功能
      LanguageConfigKeys.Shop_permission_scan_setting_title:
          "Enable camera permissions", //开相机权限
      LanguageConfigKeys.Shop_permission_scan_setting_content:
          "Please enable camera permissions in [Setting-Application] before using functions such as scanning", //请在[设置-应用]中开启相机权限，开启后才可使用扫描等功能
      LanguageConfigKeys.Shop_pocket_change_record: "Replacing records",
      LanguageConfigKeys.Shop_pocket_surplus_task:
          "The current pocket level can still receive | tasks", //当前口袋等级还可领取%s个任务
      LanguageConfigKeys.Shop_pocket_view_task: "View tasks", //查看任务
      LanguageConfigKeys.Shop_order_merge_cancel:
          "The following orders need to be cancelled together", //以下订单需一起取消
      LanguageConfigKeys.Shop_order_merge_pay:
          "The following orders need to be paid together", //以下订单需一起付款
      LanguageConfigKeys.Shop_order_cancel_back: "Return", //返回
      LanguageConfigKeys.Shop_order_goods_limit:
          "| product(s) can be purchased per account", //每个账号每次购买商品不能超过|个
      LanguageConfigKeys.Shop_product_red_pop_tip1:
          "Please complete your first order recommendation within the day, otherwise you will lose your qualification for the current red packet challenge.", //请于%s天内完成首单推荐，否则此资格将永远丧失
      LanguageConfigKeys.Shop_product_red_pop_tip2:
          "After completing your first order, you will automatically get bonus promotion time.", //完成首单后，将自动获得有奖推广时间
      LanguageConfigKeys.Shop_product_obtaining_red_qualification:
          "Qualify for red pocket access", //获得红包闯关资格
      LanguageConfigKeys.Shop_product_crossed_level_success_tip:
          "Master, %s red pocket has arrived, welcome to withdraw cash at any time!", //高手，%s红包已到手，欢迎随时提现
      LanguageConfigKeys.Shop_pocket_waiting_exciting_activities:
          "More exciting activities, please stay tuned", //更多精彩活动,敬请期待
      LanguageConfigKeys.Shop_pocket_change_task_tips1:
          "Support for changing the task corresponding to the pocket level", //支持更换口袋等级相对应的任务
      LanguageConfigKeys.Shop_pocket_change_task_tips2:
          "Before the end of the original task, you can check it in the “Change Record”", //原任务结束前，可在“更换记录”中查看
      LanguageConfigKeys.Shop_mine_passing_levels: "Breaking in", //正在闯关
      LanguageConfigKeys.Shop_mine_direct_push_tips:
          "The more direct recommendations you have, the faster you break in", //直推越多，闯关越快
      LanguageConfigKeys.Shop_mine_total_gains: "Cumulative Amount", //累计获得
      LanguageConfigKeys.Shop_mine_date_to: "untill", //至
      LanguageConfigKeys.Shop_pocket_super_wednesday:
          "Super Wednesday", //Super Wednesday
      LanguageConfigKeys.Shop_pocket_category_super_wednesday:
          "Super\nWednesday", //Super\nWednesday
      LanguageConfigKeys.Login_create_mine_link:
          "Create Exclusive Link", //创建专属链接
      LanguageConfigKeys.Login_nickname_exists:
          "The name already exists, please re-enter it", //该昵称已存在，请重新输入
      LanguageConfigKeys.Login_link_create_success:
          "Congratulations, your exclusive link has been created", //恭喜，您的专属链接已创建
      LanguageConfigKeys.Login_copy_link:
          "Copy the link and post on other Social Media Platforms", //复制链接，粘贴至TikTok等社交应用
      LanguageConfigKeys.Login_kol_name_hint:
          "Please enter a nickname with at least 1 characters", //昵称至少1位
      LanguageConfigKeys.Login_kol_name_tip:
          "Exclusive Names: English and numbers only, unchangeable once set.\nEdit Avatar and Nickname in the app's personal center.\nExample of an Exclusive Link:",
      LanguageConfigKeys.Login_input_kol_name:
          "Please input Exclusive Name", //请输入专属名称
      LanguageConfigKeys.Login_input_kol_share:
          "Create your Exclusive Link now for easy promotion", //立即创建专属链接，便于推广
      LanguageConfigKeys.Login_input_kol_recommend:
          "Quickly promote your Exclusive Link", //快速推广您的专属链接
      LanguageConfigKeys.shop_mine_receive_discount: "Claim Discount", //领取优惠
      LanguageConfigKeys.shop_mine_platform_coupon_tips:
          "MXCOME: Brand's Self-Operated Platform, 100% Authentic Products", //MXCOME 品牌自营平台，100%正品保证
      LanguageConfigKeys.shop_mine_platform_coupon_hint:
          "Platform Coupons will be issued from time to time", //平台优惠券将不定期发放
      LanguageConfigKeys.shop_mine_rebate_status_hint_1:
          "Waiting for statistics, the more lower level purchases,the higher the rebate.", //等待统计，下级购买越多返利越多
      LanguageConfigKeys.shop_mine_rebate_status_hint_2:
          "Waiting for settlement, rebates will not be calculated for orders that are not completed.", //等待结算，订单未完成将不计算返利
      LanguageConfigKeys.shop_mine_rebate_status_hint_3:
          "Settlement completed, total rebate has been automatically transferred to", //结算完成，总返利已自动转入
      LanguageConfigKeys.shop_mine_rebate_status_hint_4:
          "Only | more order is needed to upgrade.", //还差 | 单，即可升级
      LanguageConfigKeys.shop_mine_rebate_rules_1:
          "Statistics of total order volume and expected revenue on the 7th day", //第7天统计总单量及预期收益
      LanguageConfigKeys.shop_mine_rebate_rules_2:
          "The rebate will be settled on the 7th day after the end of statistics. Orders confirmed overtime will no longer receive rebates.", //统计结束后第7天结算返利，超时确认的订单不再返利
      LanguageConfigKeys.shop_mine_rebate_rules_3:
          "Increasing the order quantity can upgrade and get rebates. My purchase supports upgrades, but the rebates are not calculated.", //增加单量可升级返利，本人购买支持升级，但不计算返利
      LanguageConfigKeys.shop_mine_rebate_current_order: "Current orders",
      LanguageConfigKeys.shop_mine_rebate_condition:
          "Upgrade to maximum rebate on 8 orders",
      LanguageConfigKeys.shop_mine_rebate_order: "Orders",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate: "My subordinates",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate_nums:
          "Number of subordinates",
      LanguageConfigKeys.shop_mine_rebate_bind_time: "Bind time",
      LanguageConfigKeys.shop_mine_rebate_view_subordinate: "View subordinates",
      LanguageConfigKeys.shop_mine_rebate_my_profits: "My Rebate",
      LanguageConfigKeys.shop_mine_rebate_expect_total_rebate:
          "Expected total rebates",
      LanguageConfigKeys.shop_mine_rebate_total_rebate: "Total rebates",
      LanguageConfigKeys.shop_mine_rebate_order_num: "Order Num",
      LanguageConfigKeys.shop_mine_rebate_to_be_counted: "To Be Counted",
      LanguageConfigKeys.shop_mine_rebate_already_counted: "Already Counted",
      LanguageConfigKeys.shop_mine_rebate_pending_settlement: "Unsettlement",
      LanguageConfigKeys.shop_mine_rebate_settled: "Settled",
      LanguageConfigKeys.shop_mine_rebate_period_range: "Week %s",
      LanguageConfigKeys.shop_mine_rebate_calculate_order: "Statistical orders",
      LanguageConfigKeys.shop_mine_rebate_settlement_order: "Settlement rebate",
      LanguageConfigKeys.shop_mine_rebate_my_rebate: "Rebate",
      LanguageConfigKeys.shop_mine_rebate_my_expect_rebate: "Expect Rebate",
      LanguageConfigKeys.shop_mine_rebate_exclusive_qr_code:
          "Exclusive QR Code",
      LanguageConfigKeys.shop_mine_rebate_my_superior: "My Superior",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips1:
          "Friends can become subordinates by scanning the code",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips2:
          "During the event, if subordinates purchase any product, you can get consumer rebates",
      LanguageConfigKeys.shop_mine_rebate_save: "save",
      LanguageConfigKeys.shop_mine_rebate_recommend: "recommend",
      LanguageConfigKeys.shop_mine_rebate_no_superior: "No superiors",
      LanguageConfigKeys.shop_mine_rebate_bind_superior: "Binding superiors",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_tips:
          "Press confirm to join.",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_confirm: "confirm",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_success:
          "Bind the superior successfully",
      LanguageConfigKeys.shop_mine_rebate_save_success: "save success",
      LanguageConfigKeys.shop_mine_rebate_album: "album",
      LanguageConfigKeys.shop_mine_rebate_recognition_error:
          "Recognition error",
      LanguageConfigKeys.shop_home_monthly_benefits_tip:
          "Get MXCOME benefits/subsidies with every order, earn money through referral recommendations!",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_1:
          "Purchase any selected item each month.",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_2:
          "You can get | ‘Red Envelope Pass’ promotional benefits",
      LanguageConfigKeys.shop_home_load_more: "load more",
      LanguageConfigKeys.shop_home_balance_window_tip_1:
          "Congratulations on winning|cash reward",
      LanguageConfigKeys.shop_home_balance_window_tip_2:
          "Disbursed to|Account Balance",
      LanguageConfigKeys.shop_home_rebate_close_tip:
          "Service is temporarily unavailable",
      LanguageConfigKeys.shop_home_rebate_order_unfinished_tip:
          "Order unfinished",
      LanguageConfigKeys.shop_web3_email_sent: "Email sent", //邮件已发送
      LanguageConfigKeys.shop_web3_format_incorrect:
          "The email format is incorrect", //邮件格式不正确
      LanguageConfigKeys.shop_web3_luck_draw: "Luck draw", //抽奖
      LanguageConfigKeys.shop_web3_chance_lucky_draw:
          "%s chance for lucky draw", //抽奖机会%s次
      LanguageConfigKeys.shop_web3_winning_list: "Winning List", //中奖名单
      LanguageConfigKeys.shop_web3_received_prizes: "Received prizes", //已中奖
      LanguageConfigKeys.shop_web3_winning_draws_hint:
          "Congratulations on winning the %s with three draws, worth %s", //恭喜 %s 抽中%s，价值 %s
      LanguageConfigKeys.shop_web3_start_lottery: "Start lottery", //开始抽奖
      LanguageConfigKeys.shop_web3_winning_following_prizes:
          "Congratulations on winning the following prizes", //恭喜抽中以下奖品
      LanguageConfigKeys.shop_web3_claim_prizes: "Claim prizes", //领取奖品
      LanguageConfigKeys.shop_web3_please_ensure_accurate_and_correct:
          "Please ensure that the %s you provided is accurate and correct", //请确保您提供的%s准确无误
      LanguageConfigKeys.shop_web3_email: "e-mail", //邮箱地址
      LanguageConfigKeys.shop_web3_transfer_out_address:
          "Transfer out address", //转出地址
      LanguageConfigKeys.Shop_web3_financial_losses:
          "Otherwise, it may cause financial losses", //否则可能会造成资金损失
      LanguageConfigKeys.Shop_web3_transfer_fee: "Transfer fee", //手续费
      LanguageConfigKeys.Shop_web3_free: "Free", //限免
      LanguageConfigKeys.Shop_web3_expected_credited:
          "Expected to be credited within <black> 24 hours </black>", //预计到账<black> 24小时 </black>
      LanguageConfigKeys.Shop_web3_slide_confirmation:
          "Slide confirmation", //滑动确认
      LanguageConfigKeys.Shop_web3_transfer_in: "Transfer in", //转入
      LanguageConfigKeys.Shop_web3_transfer_out: "Transfer out", //转出
      LanguageConfigKeys.Shop_web3_address: "Address", //地址
      LanguageConfigKeys.Shop_web3_assets: "Assets", //资产
      LanguageConfigKeys.Shop_web3_enter_receive_wallet_address:
          "Please enter the wallet address you want to receive", //请输入您要接收的钱包地址
      LanguageConfigKeys.Shop_web3_choose_transfer_assets:
          "Choose to transfer out assets", //选择转出资产
      LanguageConfigKeys.Shop_web3_user_confirm_tip1:
          "Users need to confirm and bear the risk of transfer on their own", //用户需自行确认并承担转出风险
      LanguageConfigKeys.Shop_web3_user_confirm_tip2:
          "The transfer operation cannot be revoked, beware of being deceived", //转出操作无法撤回，谨防受骗
      LanguageConfigKeys.Shop_web3_transfer: "Transfer", //互转
      LanguageConfigKeys.Shop_web3_account_email: "Account email", //账户邮箱
      LanguageConfigKeys.Shop_web3_enter_email:
          "Please enter the recipient's account email address", //请输入对方的账户邮箱
      LanguageConfigKeys.Shop_web3_selected: "Selected", //已选择
      LanguageConfigKeys.Shop_web3_select_asset_type:
          "Select asset type", //选择资产类型
      LanguageConfigKeys.Shop_web3_select_assets: "Select assets", //选择资产
      LanguageConfigKeys.Shop_web3_enter_your_email:
          "Please enter your email address", //请输入邮箱地址
      LanguageConfigKeys.Shop_web3_enter_email_code:
          "Please enter the email verification code", //请输入邮箱验证码
      LanguageConfigKeys.Shop_web3_agree_accept: "Agree and accept", //同意并接受
      LanguageConfigKeys.Shop_web3_mxcome_protocol:
          "MXCOME Digital Wallet Protocol", //《MXCOME数字钱包协议》
      LanguageConfigKeys.Shop_web3_activate_now: "Activate now", //立即开通
      LanguageConfigKeys.Shop_web3_wallet: "WEB3 Wallet", //WEB3钱包
      LanguageConfigKeys.Shop_web3_get: "Get", //获取
      LanguageConfigKeys.Shop_web3_stored_value: "Stored value", //储值
      LanguageConfigKeys.Shop_web3_did_assets: "DID assets", //DID资产
      LanguageConfigKeys.Shop_web3_not_config_adv:
          "Virtual product advertising has not been configured yet", //暂未配置虚拟商品广告
      LanguageConfigKeys.Shop_vip_agreement_title:
          "User Membership Agreement", //用户会员协议
      LanguageConfigKeys.Shop_full_read_agree:
          "I have fully read, understood, and agree", //我已完全阅读，理解并同意
      LanguageConfigKeys.Shop_please_check_agreement:
          "Please check the user membership agreement", //请勾线用户会员协议
      LanguageConfigKeys.Shop_modify_buy_quantity:
          "100% Brand genuine", //修改购买数量
      LanguageConfigKeys.Shop_rights_unlocked:
          "Rights not yet unlocked, please stay tuned for community updates.", //权益尚未解锁，敬请关注社区公告

      // 泰国政府推荐占位框
      LanguageConfigKeys.Gov_recommend_title:
          "Officially Recommended by Thai Government", //泰国政府官方推荐
      LanguageConfigKeys.Gov_recommend_subtitle:
          "Ministry of Tourism and Sports, Ministry of Culture, Tourism Authority of Thailand", //体育旅游部, 文化部, 国家旅游局
      LanguageConfigKeys.Featured_promotion_empty: "No featured deals",
      LanguageConfigKeys.Featured_promotion_discount_full: "฿%s off on ฿%s",
      LanguageConfigKeys.Featured_promotion_voucher: "฿%s Voucher",
      LanguageConfigKeys.Featured_promotion_use_now: "Use Now",
      LanguageConfigKeys.Featured_promotion_discount: "Discount",
      LanguageConfigKeys.Coupon_detail_show_code_tip:
          "Please show this code to the staff when paying",
      LanguageConfigKeys.Coupon_detail_select_address:
          "Please select a store address",
      LanguageConfigKeys.Coupon_detail_swipe_up_shop: "Swipe up to view shop",
      LanguageConfigKeys.Coupon_type_full_reduction: "Full Reduction",
      LanguageConfigKeys.Coupon_type_discount_coupon: "Discount Coupon",
      LanguageConfigKeys.Coupon_type_free_shipping: "Free Shipping",
      LanguageConfigKeys.Coupon_type_voucher: "Voucher",
      LanguageConfigKeys.Coupon_validity_period: "Valid until %s",
      LanguageConfigKeys.Coupon_select_store: "Select Store",
      LanguageConfigKeys.Coupon_destination: "Destination",
      LanguageConfigKeys.Map_google: "Google Maps",
      LanguageConfigKeys.Map_gaode: "Amap",
      LanguageConfigKeys.Map_baidu: "Baidu Maps",
      LanguageConfigKeys.Map_tencent: "Tencent Maps",
      LanguageConfigKeys.Coupon_copy_address: "Copy Address",
      LanguageConfigKeys.Coupon_navigate_to_store: "Navigate to Store",
      LanguageConfigKeys.Coupon_code_prefix: "Code: %s",
      LanguageConfigKeys.Shop_brand_load_failed: "Failed to load brand data",
      LanguageConfigKeys.Shop_brand_click_retry: "Click to retry",
      LanguageConfigKeys.Promotion_highlight_category_fallback: "Category",
    },

    //泰语
    LanguageType.TH: {
      LanguageConfigKeys.app_name: "MXCOME",
      LanguageConfigKeys.language: "ภาษา", //语言
      LanguageConfigKeys.search: "ค้นหา", //搜索
      LanguageConfigKeys.language_tip:
          "ภาษาจะปรับโดยอัตโนมัติตามภาษาของระบบ นอกจากนี้ คุณยังสามารถเลือกภาษาที่เหมาะกับคุณได้ด้วยตนเอง", //根据系统语言，我们将自动适配，你也可以手动选择适合自己的语言
      LanguageConfigKeys.Base_unknown_err:
          "อินเทอร์เน็ตเกิดข้อบกพร่อง โปรดลองอีกครั้งภายหลัง", //网络异常，请稍后再试
      LanguageConfigKeys.Base_coming_soon:
          "อยู่ระหว่างการพัฒนา โปรดรอติดตามความคืบหน้า", //正在开发中，敬请期待
      LanguageConfigKeys.Base_submit_hint: "การแจ้งเตือน", //提示
      LanguageConfigKeys.Base_submit_success: "ส่งสำเร็จ", //提交成功
      LanguageConfigKeys.Base_successfully_added: "เพิ่มสำเร็จ", //添加成功
      LanguageConfigKeys.Base_successfully_modified: "แก้ไขสำเร็จ", //修改成功
      LanguageConfigKeys.Base_operation_successful: "สำเร็จ", //操作成功
      LanguageConfigKeys.Base_operation_tips: "เคล็ดลับการทำงาน", //操作提示
      LanguageConfigKeys.Base_set_successful: "ตั้งค่าสำเร็จ", //设置成功
      LanguageConfigKeys.Base_copy_success: "คัดลอกสำเร็จ", //复制成功
      LanguageConfigKeys.Base_clean_up: "ล้าง", //清除
      LanguageConfigKeys.Base_delete: "ลบ", //删除
      LanguageConfigKeys.Shop_submit: "ส่ง", //提交
      LanguageConfigKeys.Base_view_image: "ดูรูปภาพ", //查看图片
      LanguageConfigKeys.Login_welcome_world_of_gold:
          "ต้อนรับเข้าสู่โลกของ MXCOME", //欢迎移民淘金世界
      LanguageConfigKeys.Login_select_country:
          "เลือกประเทศหรือภูมิภาค", //选择国家或地区
      LanguageConfigKeys.Login_register: "ลงทะเบียน", //注册
      LanguageConfigKeys.Login_register_new: "ลงทะเบียนผู้ใช้งานใหม่", //新用户注册
      LanguageConfigKeys.Login_duplicate_register_tip:
          "เบอร์นี้ถูกผูกไว้กับหมายเลขบัญชีอื่นแล้ว โปรดกลับไปยังหน้าเข้าสู่ระบบ", //该手机号已被其他账号绑定，将为您跳转至登录页
      LanguageConfigKeys.Login_skip: "ข้าม", //跳过
      LanguageConfigKeys.Login_country_th: "ประเทศไทย", //泰国
      LanguageConfigKeys.Login_country_en: "สหรัฐอเมริกา", //美国
      LanguageConfigKeys.Login_country_zh: "ประเทศจีน", //中国
      LanguageConfigKeys.Login_register_success:
          "ลงทะเบียนสำเร็จ กรุณาตั้งรหัสผ่าน", //注册成功，请设置登录密码
      LanguageConfigKeys.Login_reset_password: "รีเซ็ตรหัสผ่าน", //重设密码
      LanguageConfigKeys.Login_sms_code: "ข้อความรหัส OTP", //短信验证码
      LanguageConfigKeys.Login_sms_code_error: "รหัสOTPไม่ถูกต้อง", //验证码错误
      LanguageConfigKeys.Login_sms_code_timeout: "OTP หมดอายุ", //验证码超时
      LanguageConfigKeys.Login_password_or_confirm_password_error:
          "รหัสผ่านที่คุณกรอกไม่สอดคล้องกัน โปรดลองอีกครั้ง", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Login_password_tip: "กรุณาใส่รหัสผ่าน", //请输入密码
      LanguageConfigKeys.Login_password_first_tip:
          "กรุณาตั้งค่ารหัสผ่าน 8 ตัวขึ้นไป", //请输入8位及以上密码
      LanguageConfigKeys.Login_password_again_tip:
          "กรุณากรอกรหัสผ่านอีกครั้ง", //请再次输入密码
      LanguageConfigKeys.Login_password_format_error:
          "รหัสผ่านไม่ถูกต้อง กรุณากรอกตามเงื่อนไขด้านล่าง", //密码格式错误，请按照下面格式填写
      LanguageConfigKeys.Login_set_password_tip1:
          "รหัสผ่านจะต้องประกอบด้วยตัวอักษรและตัวเลข ตัวอักษรแรกต้องเป็นตัวพิมพ์ใหญ่ ความยาว 8-32 ตัว", //密码应字母加数字组成，首字母必须大写，长度最少8位
      LanguageConfigKeys.Login_set_password_tip2:
          "กรุณาเก็บรักษารหัสผ่านให้ปลอดภัย และหลีกเลี่ยงการตั้งรหัสผ่านที่คาดเดาได้ง่าย", //请妥善保管密码，并避免使用简单密码组合
      LanguageConfigKeys.Login_forgot_password_tip1:
          "กรุณาใส่เบอร์โทรศัพท์ที่ลงทะเบียนไว้กับบัญชี MXCOME", //请输入与MXCOME账号绑定的手机号
      LanguageConfigKeys.Login_forgot_password_tip2:
          "รับรหัส OTP เพื่อรีเซ็ตรหัสผ่าน", //获取验证码后可重设密码
      LanguageConfigKeys.Login_forgot_password_tip3:
          "หากเบอร์นี้ไม่ได้รับรหัส OTP คลิกเพื่อเปลี่ยนเบอร์โทรศัพท์ใหม่", //手机号无法收取验证码，可点击手机换绑
      LanguageConfigKeys.Login_welcome_login: "ยินดีต้อนรับเข้าสู่ระบบ", //欢迎登录
      LanguageConfigKeys.Login_mobile_tip: "กรุณาใส่เบอร์โทรศัพท์", //请输入手机号码
      LanguageConfigKeys.Login_mobile_error:
          "เบอร์โทรศัพท์ไม่ถูกต้อง", //手机号格式错误
      LanguageConfigKeys.Login_user_or_password_error:
          "เบอร์โทรศัพท์หรือรหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง", //手机号或密码错误，请重新输入
      LanguageConfigKeys.Login_forgot_password: "ลืมรหัสผ่าน", //忘记密码
      LanguageConfigKeys.Login_code_tip: "กรุณากรอกรหัส OTP", //请输入验证码
      LanguageConfigKeys.Login_login_app: "ลงชื่อเข้าใช้ MXCOME", //登录MXCOME
      LanguageConfigKeys.Login_send_code: "รับรหัส OTP", //获取验证码
      LanguageConfigKeys.Login_resend_code: "ส่งใหม่อีกครั้ง", //重新发送
      LanguageConfigKeys.Login_login: "ลงชื่อเข้าใช้", //登录
      LanguageConfigKeys.Login_verify_phone: "ตรวจสอบเบอร์โทรศัพท์", //验证手机
      LanguageConfigKeys.Login_other_login_type:
          "เข้าสู่ระบบด้วยวิธีอื่น", //第三方授权登录
      LanguageConfigKeys.Login_bind_phone: "ผูกเบอร์โทรศัพท์", //绑定手机号
      LanguageConfigKeys.Login_login_accept_tip:
          "ดำเนินการต่อหากคุณยอมรับ", //继续即表示您已同意
      LanguageConfigKeys.Login_service:
          "ข้อตกลงการใช้บริการของ MXCOME และนโยบายความเป็นส่วนตัว", //《MXCOME服务协议与隐私政策》
      LanguageConfigKeys.Login_input_invite_code:
          "กรุณากรอกรหัสเชิญ (ไม่จำเป็น)", //请输入邀请码（可选）
      LanguageConfigKeys.Login_input_invite_code_required:
          "กรุณาใส่รหัสเชิญ (จำเป็น)", //请输入邀请码（必填）
      LanguageConfigKeys.Login_input_invite_code_invalid:
          "รหัสเชิญไม่ถูกต้อง", //邀请码无效
      LanguageConfigKeys.Login_input_invite_code_title: "รหัสเชิญ", //邀请码
      LanguageConfigKeys.Login_input_invite_code_content:
          "รหัสเชิญแบ่งเป็นรหัสเชิญทดสอบสาธารณะและรหัสเชิญฝ่าด่านพิชิตอั่งเปา\nอำนาจการตัดสินขั้นสุดท้ายเป็นของแพลตฟอร์ม", //邀请码分为公测邀请码与红包闯关邀请码\n最新解释权归平台所有
      LanguageConfigKeys.Login_invite_code_error: "รหัสไม่ถูกต้อง", //邀请码错误
      LanguageConfigKeys.Login_invite_consent_agreement: "ยอมรับข้อตกลง", //同意协议
      LanguageConfigKeys.Login_password_set_success:
          "ตั้งค่ารหัสผ่านสำเร็จ", //密码设置成功
      LanguageConfigKeys.Login_password_modify_success:
          "แก้ไขรหัสผ่านสำเร็จ", //密码修改成功
      LanguageConfigKeys.Verify_code_tip:
          "ส่งข้อความไปยังเบอร์โทรศัพท์แล้ว", //短信已发送到手机
      LanguageConfigKeys.Verify_safe_verify: "การตรวจสอบความปลอดภัย", //安全验证
      LanguageConfigKeys.Verify_safe_verify_tip1:
          "เพื่อความปลอดภัยของบัญชีของคุณ การดำเนินการนี้จำเป็นต้องได้รับการตรวจสอบ", //为了你的账号安全，本次操作需要进行验证
      LanguageConfigKeys.Verify_safe_verify_tip2:
          "กรุณาย้ายไอคอนด้านล่างไปยังพื้นที่วงกลม", //请将下方的图标移动到圆形区域内
      LanguageConfigKeys.WebPage_click_reload:
          "คลิกเพื่อโหลดใหม่อีกครั้ง", //点击重新加载
      LanguageConfigKeys.ViewUtils_cancel: "ยกเลิก", //取消
      LanguageConfigKeys.ViewUtils_confirm: "ยืนยัน", //确定
      LanguageConfigKeys.ViewUtils_no_data: "ไม่พบข้อมูล", //暂无内容
      LanguageConfigKeys.ViewUtils_no_more: "ไม่มีข้อมูลเพิ่มเติม", //没有更多数据了
      LanguageConfigKeys.ViewUtils_retry: "ลองอีกครั้ง", //重试
      LanguageConfigKeys.Loading: "กำลังโหลด", //正在加载
      LanguageConfigKeys.Shop_home: "MXGET", //淘金
      LanguageConfigKeys.Shop_category: "ประเภท", //分类
      LanguageConfigKeys.Shop_cart: "รถเข็น", //购物车
      LanguageConfigKeys.Shop_grow: "การเติบโต", //成长
      LanguageConfigKeys.Shop_grow_continue_day:
          "ลงชื่อเข้าใช้ติดต่อกัน %s วัน", //已连续签到%s天
      LanguageConfigKeys.Shop_grow_this_month: "เดือนนี้", //本月
      LanguageConfigKeys.Shop_grow_countersign: "ลงชื่อชดเชย", //补签
      LanguageConfigKeys.Shop_grow_unsigned: "ยังไม่ได้ลงชื่อ", //未签到
      LanguageConfigKeys.Shop_grow_countersigned: "ลงชื่อชดเชยแล้ว", //已补签
      LanguageConfigKeys.Shop_grow_signed: "ลงชื่อแล้ว", //已签到
      LanguageConfigKeys.Shop_grow_growth_benefits: "สิทธิพิเศษ", //成长福利
      LanguageConfigKeys.Shop_grow_surprise: "เซอร์ไพร์ส", //惊喜
      LanguageConfigKeys.Shop_product_task_recommend: "แนะนำภารกิจ", //任务推荐
      LanguageConfigKeys.Shop_product_shop_stroll: "รวมร้านค้า", //店铺闲逛
      LanguageConfigKeys.Shop_product_shop_stroll_tip:
          "คุณสามารถสร้าง “รายการแนะนำ“ เองได้ขณะช้อปปิ้ง", //逛街时，可以DIY组合“推荐清单”哦
      LanguageConfigKeys.Shop_product_hot_activity: "กิจกรรมยอดนิยม", //热门活动
      LanguageConfigKeys.Shop_product_recommend: "อันดับสินค้าขายดี", //热销榜
      LanguageConfigKeys.Shop_product_profit: "อันดับภารกิจ", //淘金榜
      LanguageConfigKeys.Shop_product_best_seller: "อันดับร้านค้า", //持家榜
      LanguageConfigKeys.Shop_product_search:
          "ค้นหาภารกิจ/กิจกรรม/สินค้า", //搜任务/活动/商品
      LanguageConfigKeys.Shop_product_delivery: "การจัดส่ง", //配送
      LanguageConfigKeys.Shop_product_parameter:
          "รายละเอียดสินค้าเพิ่มเติม", //参数
      LanguageConfigKeys.Shop_product_spec: "ลักษณะสินค้า", //规格
      LanguageConfigKeys.Shop_product_spec_select: "เลือกแล้ว %s ชิ้น", //已选择%件
      LanguageConfigKeys.Shop_product_service: "การบริการ", //服务
      LanguageConfigKeys.Featured_promotion_title: "ข้อเสนอพิเศษ", //精选优惠
      LanguageConfigKeys.Featured_promotion_view_all: "ดูทั้งหมด", //查看所有
      LanguageConfigKeys.Featured_promotion_category_restaurant:
          "ร้านดัง", //网红餐厅
      LanguageConfigKeys.Featured_promotion_category_hotel:
          "โรงแรมที่พัก", //酒店住宿
      LanguageConfigKeys.Featured_promotion_category_car: "เช่ารถรับส่ง", //租车接机
      LanguageConfigKeys.Featured_promotion_category_ticket:
          "ตั๋วสถานที่ท่องเที่ยว", //景点门票
      LanguageConfigKeys.Featured_promotion_category_popular_thai:
          "สินค้าไทยยอดนิยม", //热门泰货
      LanguageConfigKeys.Featured_promotion_category_leisure:
          "พักผ่อนบันเทิง", //休闲娱乐
      LanguageConfigKeys.Shop_product_shop: "ร้านค้า", //店铺
      LanguageConfigKeys.Shop_product_consulting: "ให้คำปรึกษา", //咨询
      LanguageConfigKeys.Shop_product_join: "เข้าร่วม", //加入
      LanguageConfigKeys.Shop_product_rise: "ขึ้นไป", //起
      LanguageConfigKeys.Shop_product_join_cart:
          "เพิ่มลงในรถเข็นสินค้า", //加入购物车
      LanguageConfigKeys.Shop_product_cart_add_success:
          "เพิ่มลงในรถเข็นแล้ว", //已成功加入购物车
      LanguageConfigKeys.Shop_product_now_buy: "ซื้อทันที", //立即购买
      LanguageConfigKeys.Shop_product_goods: "ภาพรวม", //概述
      LanguageConfigKeys.Shop_product_detail: "รายละเอียด", //详情
      LanguageConfigKeys.Shop_product_select_spec: "เลือกลักษณะสินค้า", //选择规格
      LanguageConfigKeys.Shop_product_quantity: "จำนวน", //数量
      LanguageConfigKeys.Shop_product_money: "ได้รับ", //赚
      LanguageConfigKeys.Shop_product_mxget: "MXGET", //淘金赚
      LanguageConfigKeys.Shop_product_user_join_mxget:
          "มีผู้ใช้ | คนเข้าร่วม MXGET แล้ว", //已有|名用户参与“淘金赚”
      LanguageConfigKeys.Shop_product_view_list: "ดูรายการ", //查看榜单
      LanguageConfigKeys.Shop_product_see: "ดู", //查看
      LanguageConfigKeys.Shop_product_select: "เลือก", //选择
      LanguageConfigKeys.Shop_product_free_freight: "ค่าส่งฟรี", //免运费
      LanguageConfigKeys.Shop_product_nation_branding: "ประเทศ", //品牌国家
      LanguageConfigKeys.Shop_product_place: "ใช้ได้ที่: ", //场地
      LanguageConfigKeys.Shop_product_producer: "สถานที่ผลิต", //产地
      LanguageConfigKeys.Shop_product_free_charge_overtime_tip:
          "ได้รับสินค้าเกิน 7 วัน คืนเงินโดยไม่ต้องคืนสินค้า", //超过7天到货，直接免单
      LanguageConfigKeys.Shop_product_ship_to: "สถานที่จัดส่ง: %s", //发货地: %s
      LanguageConfigKeys.Shop_product_now_pay_tip:
          "ชำระเงินตอนนี้ คาดว่าจะจัดส่งภายใน 48 ชั่วโมง", //现在付款，品牌承诺48小时内发货
      LanguageConfigKeys.Shop_product_hot_category:
          "หมวดหมู่สินค้ายอดนิยม", //热门品类
      LanguageConfigKeys.Shop_product_hot_product: "สินค้าขายดี", //热销产品
      LanguageConfigKeys.Shop_brand_shop: "ร้านค้าแบรนด์", //品牌店铺
      LanguageConfigKeys.Shop_brand_subscribe: "ติดตาม", //订阅
      LanguageConfigKeys.Shop_brand_subscribed: "ติดตามแล้ว", //已订阅
      LanguageConfigKeys.Shop_brand_goto_shop: "ไปที่ร้านค้า", //进店铺
      LanguageConfigKeys.Shop_brand_receive: "ภารกิจที่สามารถรับได้", //可接任务
      LanguageConfigKeys.Shop_brand_family: "รักงานบ้าน", //爱持家
      LanguageConfigKeys.Shop_brand_period: "ผ่อนชำระ", //分期
      LanguageConfigKeys.Shop_brand_free_package: "รวมค่าส่ง", //包邮
      LanguageConfigKeys.Shop_brand_overtime_free: "การันตีเวลาจัดส่ง", //超时免单
      LanguageConfigKeys.Shop_brand_down_up: "จากต่ำไปสูง", //由低到高
      LanguageConfigKeys.Shop_brand_up_down: "จากสูงไปต่ำ", //由高到低
      LanguageConfigKeys.Shop_brand_choose: "เงื่อนไขการกรอง", //筛选条件
      LanguageConfigKeys.Shop_brand_enable: "สามารถเลือกได้", //可选
      LanguageConfigKeys.Shop_brand_price: "ราคา", //价格
      LanguageConfigKeys.Shop_cart_empty:
          "เลือกสินค้าที่คุณถูกใจลงในรถเข็น", //挑选喜欢的装进购物车
      LanguageConfigKeys.Shop_cart_select_all: "เลือกทั้งหมด", //全选
      LanguageConfigKeys.Shop_cart_total: "รวมทั้งหมด", //总计
      LanguageConfigKeys.Shop_cart_settlement: "คิดเงิน", //结算
      LanguageConfigKeys.Shop_cart_delete: "ลบ", //删除
      LanguageConfigKeys.Shop_cart_is_delete:
          "ต้องการลบสินค้าที่คุณเลือกไว้หรือไม่", //是否删除选择商品?
      LanguageConfigKeys.Shop_cart_select_goods:
          "กรุณาเลือกสินค้าก่อน", //请先选择商品
      LanguageConfigKeys.Shop_cart_select_goods_settlement:
          "กรุณาเลือกสินค้าก่อนชำระเงิน", //请先选择商品再结算
      LanguageConfigKeys.Shop_mine_adv: "ยิ่งเล่นยิ่งได้", //越玩越赚
      LanguageConfigKeys.Shop_mine_not_login: "ยังไม่ลงชื่อเข้าระบบ", //未登录
      LanguageConfigKeys.Shop_mine_member_service: "คูปอง", //优惠券
      LanguageConfigKeys.Shop_mine_shop_service: "จัดการการดำเนินการ", //运营管理
      LanguageConfigKeys.Shop_mine_member_service_tips:
          "ยิ่งแชร์ยิ่งได้", //多推多得
      LanguageConfigKeys.Shop_mine_shop_service_tips:
          "เปิดใช้งานเพื่อรับของขวัญ", //开通橱窗享好礼
      LanguageConfigKeys.Shop_mine_account_balance: "ยอดเงิน", //余额
      LanguageConfigKeys.Shop_mine_withdrawal_balance:
          "ยอดเงินที่สามารถถอนได้", //可提金额
      LanguageConfigKeys.Shop_mine_today_withdrawal_balance:
          "วันนี้ถอนได้", //今日可提
      LanguageConfigKeys.Shop_mine_confirm_withdrawal:
          "ยืนยันการถอนเงิน", //确认提现
      LanguageConfigKeys.Shop_mine_withdrawal_amount: "จำนวนเงินถอน", //提现金额
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip1:
          "ขั้นต่ำ 100 หรือทวีคูณของ 100 สูงสุด 10,000 บาท/วัน", //最低฿100或100的倍数，最高฿10000/天
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip2:
          "ค่าธรรมเนียมการถอนเงิน %s%", //提现费率3%
      LanguageConfigKeys.Shop_mine_gold_coin: "เหรียญ", //金币
      LanguageConfigKeys.Shop_mine_address_manage: "จัดการที่อยู่", //地址管理
      LanguageConfigKeys.Shop_mine_help: "ช่วยเหลือ", //帮助中心
      LanguageConfigKeys.Shop_mine_profit_study: "วิทยาลัย MXCOME", //淘金学院
      LanguageConfigKeys.Shop_mine_order: "คำสั่งซื้อ", //订单
      LanguageConfigKeys.Shop_mine_wallet: "กระเป๋าเงิน", //资产
      LanguageConfigKeys.Shop_mine_more: "เพิ่มเติม", //更多
      LanguageConfigKeys.Shop_mine_edit_member_info:
          "แก้ไขข้อมูลส่วนตัว", //编辑个人资料
      LanguageConfigKeys.Shop_mine_unknown: "ไม่เปิดเผย", //保密
      LanguageConfigKeys.Shop_mine_boy: "ชาย", //男
      LanguageConfigKeys.Shop_mine_girl: "หญิง", //女
      LanguageConfigKeys.Shop_mine_year_tip:
          "อายุของคุณต้องมากกว่า 14 ปีขึ้นไป", //您的年龄需要大于14周岁
      LanguageConfigKeys.Shop_mine_change_avatar: "เปลี่ยนรูปโปรไฟล์", //更换头像
      LanguageConfigKeys.Shop_mine_name: "ชื่อ-สกุล", //姓名
      LanguageConfigKeys.Shop_mine_account_id: "ไอดีบัญชี", //账号ID
      LanguageConfigKeys.Shop_mine_account_modify_once:
          "ไอดีบัญชีสามารถแก้ไขได้ปีละ 1 ครั้งเท่านั้น", //账号ID一年只能修改一次
      LanguageConfigKeys.Shop_mine_account_id_already_exists:
          "มีไอดีนี้อยู่แล้ว", //ID已存在
      LanguageConfigKeys.Shop_mine_change_account_id: "เปลี่ยน", //变更账号ID
      LanguageConfigKeys.Shop_mine_verifying: "อยู่ระหว่างการตรวจสอบ", //审核中
      LanguageConfigKeys.Shop_mine_passed: "ยืนยันแล้ว", //已实名
      LanguageConfigKeys.Shop_mine_real_name_auth: "ตรวจสอบชื่อ", //实名认证
      LanguageConfigKeys.Shop_mine_verify_status: "สถานะการตรวจสอบ", //审核状态
      LanguageConfigKeys.Shop_mine_verify_status_tip1:
          "การยืนยันตัวตนอยู่ระหว่างการตรวจสอบ", //身份认证正在审核中
      LanguageConfigKeys.Shop_mine_verify_status_tip2:
          "สามารถตรวจสอบได้ในภายหลัง คุณสามารถเข้าร่วมภารกิจMXWINNERได้ทันที", //请稍后查看，您可以继续参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip1:
          "ไม่สามารถตรวจสอบข้อมูลเอกสารได้", //证件信息无法核实
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip2:
          "กรุณาส่งภาพถ่ายและข้อมูลเอกสารที่ถูกต้องอีกครั้ง", //请重新提交正确的证件照片及信息
      LanguageConfigKeys.Shop_mine_verify_start_mxget:
          "เข้าร่วมภารกิจMXGET", //参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_reapply: "ส่งใหม่อีกครั้ง", //重新申请
      LanguageConfigKeys.Shop_mine_select_certificate:
          "กรุณาเลือกประเภทของเอกสาร", //请选择证件类型
      LanguageConfigKeys.Shop_mine_upload_positive:
          "กรุณาอัพโหลดด้านหน้าของเอกสาร", //请上传证件的正面
      LanguageConfigKeys.Shop_mine_re_upload: "อัพโหลดใหม่อีกครั้ง", //重新上传
      LanguageConfigKeys.Shop_mine_register_phone:
          "เบอร์โทรศัพท์ที่ลงทะเบียนไว้", // 注册手机
      LanguageConfigKeys.Shop_mine_id_card: "บัตรประชาชน", //身份证
      LanguageConfigKeys.Shop_mine_passport: "หนังสือเดินทาง", //护照
      LanguageConfigKeys.Shop_mine_id_number: "หมายเลขบัตรประชาชน", //身份证号
      LanguageConfigKeys.Shop_mine_passport_number:
          "หมายเลขหนังสือเดินทาง", //护照号
      LanguageConfigKeys.Shop_mine_validity: "วันหมดอายุ", //有效期
      LanguageConfigKeys.Shop_mine_select_bank: "เลือกธนาคาร", //选择银行
      LanguageConfigKeys.Shop_mine_first_name: "นามสกุล", //姓氏
      LanguageConfigKeys.Shop_mine_last_name: "ชื่อ", //名字
      LanguageConfigKeys.Shop_mine_color_pictures:
          "รองรับไฟล์ JPG, PNG, PDF ขนาดไม่เกิน 5M", //支持JPG、PNG、PDF 文件大小不超过5M
      LanguageConfigKeys.Shop_mine_upload_after_tip:
          "หลังจากอัปโหลดเอกสารแล้ว กรอกหมายเลข วันหมดอายุ ชื่อ-นามสกุลตามข้อมูลในเอกสาร", //证件上传后，根据证件信息补全证件号、有效期、姓名
      LanguageConfigKeys.Shop_mine_verify_tip1:
          "โปรดยืนยันประเภทของเอกสารของคุณ", //请确认您所持有的证件类型
      LanguageConfigKeys.Shop_mine_verify_tip2: "ต้องเป็นไฟล์สี", //需要彩色文件
      LanguageConfigKeys.Shop_mine_verify_tip3:
          "สามารถมองเห็นชื่อ-นามสกุล หมายเลขเอกสาร วันหมดอายุและที่อยู่โดยละเอียดได้อย่างชัดเจน", //姓名、证件号码，有效期和详细地址清晰可见
      LanguageConfigKeys.Shop_mine_verify_tip4:
          "เอกสารต้องยังไม่หมดอายุ", //证件必须在有效期内
      LanguageConfigKeys.Shop_mine_verify_confirm: "ยืนยัน", //确认提交
      LanguageConfigKeys.Shop_mine_verify_failed: "ไม่ผ่าน", //审核不通过
      LanguageConfigKeys.Shop_mine_verify_wait_time:
          "โปรดรออีกนิด คาดว่าการตรวจสอบจะแล้วเสร็จภายใน %s วันทำการ", //耐心等待，预计%s个工作日内完成认证审核
      LanguageConfigKeys.Shop_mine_unreal_name: "ยังไม่ยืนยันตัวตน", //未实名
      LanguageConfigKeys.Shop_mine_nickname: "ชื่อเล่น", //昵称
      LanguageConfigKeys.Shop_mine_describe: "เกี่ยวกับคุณ", //个性签名
      LanguageConfigKeys.Shop_mine_birthday: "วันเกิด", //生日
      LanguageConfigKeys.Shop_mine_gender: "เพศ", //性别
      LanguageConfigKeys.Shop_mine_select_gender: "เลือกเพศ", //选择性别
      LanguageConfigKeys.Shop_mine_take_picture: "ถ่ายรูป", //拍照
      LanguageConfigKeys.Shop_mine_photo_album: "เลือกจากอัลบั้มภาพ", //从手机选择
      LanguageConfigKeys.Shop_mine_canceled: "ยกเลิก", //取消
      LanguageConfigKeys.Shop_mine_member_level: "เลเวลสมาชิก", //会员等级
      LanguageConfigKeys.Shop_mine_not_opened: "ยังไม่ได้เปิดใช้งาน", //未开通
      LanguageConfigKeys.Shop_mine_bind_now: "ผูกทันที", //立即绑定
      LanguageConfigKeys.Shop_mine_get_center: "รับคูปอง", //领券中心
      LanguageConfigKeys.Shop_mine_promotion_rewards: "รางวัลการแชร์", //推广奖励
      LanguageConfigKeys.Shop_mine_voucher_center: "รับคูปอง", //领券中心
      LanguageConfigKeys.Shop_mine_valid_to: "ใช้ได้ถึง %s", //有效期至 %s
      LanguageConfigKeys.Shop_mine_usage_time: "ใช้เวลา %s", //使用时间 %s
      LanguageConfigKeys.Shop_mine_to_use: "ใช้เลย", //去使用
      LanguageConfigKeys.Shop_mine_to_be_use: "รอใช้งาน", //待使用
      LanguageConfigKeys.Shop_mine_used: "ใช้แล้ว", //已使用
      LanguageConfigKeys.Shop_mine_get_now: "รับทันที", //立即领取
      LanguageConfigKeys.Shop_mine_use_coupons: "ใช้คูปอง", //使用优惠券
      LanguageConfigKeys.Shop_mine_currently_available:
          "ตอนนี้สามารถใช้ได้ (%s)", //当前可用(%s)
      LanguageConfigKeys.Shop_mine_discount_deduction: "ส่วนลด", //优惠抵扣
      LanguageConfigKeys.Shop_mine_full_available:
          "ใช้ได้เมื่อครบ %s บาท", //满%s可用
      LanguageConfigKeys.Shop_mine_all_platforms:
          "สามารถใช้ได้ทั้งแพลตฟอร์ม", //全平台可用
      LanguageConfigKeys.Shop_mine_all_shops: "ใช้ได้ทั้งแพลตฟอร์ม", //全平台可用
      LanguageConfigKeys.Shop_mine_category_available:
          "สามารถใช้ได้เฉพาะประเภทที่กำหนด", //指定分类可用
      LanguageConfigKeys.Shop_mine_specific_product_available:
          "สามารถใช้ได้เฉพาะสินค้าที่กำหนด", //指定商品可用
      LanguageConfigKeys.Shop_mine_voucher: "บัตรกำนัล", //代金券
      LanguageConfigKeys.Shop_mine_coupon: "คูปอง", //优惠券
      LanguageConfigKeys.Shop_mine_platform_voucher: "แพลตฟอร์ม", //平台
      LanguageConfigKeys.Shop_mine_merchant_voucher: "แบรนด์", //品牌
      LanguageConfigKeys.Shop_mine_my_coupon: "คูปองของฉัน", //我的优惠券
      LanguageConfigKeys.Shop_mine_received_successfully: "รับสำเร็จ", //领取成功
      LanguageConfigKeys.Shop_mine_go_get_voucher: "ไปรับคูปอง", //去领券
      LanguageConfigKeys.Shop_mine_applicable_range: "การใช้คูปอง", //适用范围
      LanguageConfigKeys.Shop_mine_products_applicable_coupon:
          "สินค้าที่สามารถใช้คูปองนี้ได้", //该券适用的商品
      LanguageConfigKeys.Shop_mine_my_prize: "รางวัลของฉัน", //我的奖品
      LanguageConfigKeys.Shop_mine_red_title: "ฝ่าด่านพิชิตอั่งเปา", //红包闯关
      LanguageConfigKeys.Shop_mine_red_history_title:
          "ประวัติการฝ่าด่าน", //红包闯关第一季
      LanguageConfigKeys.Shop_mine_red_total_number:
          "จำนวนรอบทั้งหมด: %s", //总期数: %s
      LanguageConfigKeys.Shop_mine_red_no_data:
          "คุณยังไม่เคยเข้าร่วมฝ่าด่านพิชิตอั่งเปา ยังไม่มีข้อมูล", //您暂未参与过红包闯关，暂无数据
      LanguageConfigKeys.Shop_mine_red_sub_title:
          "แจกจริง อั่งเปามูลค่ากว่า 111,000 บาท ", //฿111,000真实巨额红包大派送
      LanguageConfigKeys.Shop_mine_number_promoters: "จำนวนการแนะนำ", //推广人数
      LanguageConfigKeys.Shop_mine_total_number_promoters: "จำนวนโปรโมท", //推广人数
      LanguageConfigKeys.Shop_mine_new_today: "เพิ่มใหม่วันนี้", //今日新增
      LanguageConfigKeys.Shop_mine_promotion_details:
          "รายละเอียดการแนะนำ", //推广明细
      LanguageConfigKeys.Shop_mine_Daily_direct_promotion_prizes:
          "รางวัลการแนะนำ", //每日直推奖品
      LanguageConfigKeys.Shop_mine_choose_prize: "เลือกรางวัล", //选择奖品
      LanguageConfigKeys.Shop_mine_promotion_rules: "กฎการแนะนำ", //推广规则
      LanguageConfigKeys.Shop_mine_promotion_rules_tip1:
          "1.'ผู้ใช้ใหม่' หมายถึง ผู้ใช้ที่ไม่ได้เข้าร่วมฝ่าด่านพิชิตอั่งเปา ท่านจะได้รับส่วนแบ่ง ก็ต่อเมื่อผู้ใช้ใหม่ทำการสั่งซื้อผลิตภัณฑ์", //1. 没有参加红包闯关资格的用户即为“新人”，纳入红包奖励范围，非新人购买，您仅得分润
      LanguageConfigKeys.Shop_mine_promotion_rules_tip2:
          "2.เมื่อท่านส่งต่อให้ผู้ใช้ใหม่ 3 ราย ท่านจะได้รับอั่งเปาขั้นที่ 1 จำนวน 1 ซอง; เมื่อเพื่อนของท่านส่งต่อให้ผู้ใช้ใหม่ 3 ราย ท่านจะได้รับอั่งเปาขั้นที่ 2 จำนวน 1 ซอง;เมื่อผู้ใช้ในขั้นที่ 2 ส่งต่อให้ผู้ใช้ใหม่อีก 3 ราย ท่านจะได้รับอั่งเปาขั้นที่ 3 จำนวน 1 ซอง ทั้งนี้ ไม่มีการจำกัดจำนวนอั่งเปาในแต่ละขั้น ยิ่งเล่นยิ่งได้! เมื่อทำยอดถึงเกณฑ์ของแต่ละด่านจะผ่านไปยังด่านต่อไปโดยอัตโนมัติ", //2. 您直推三位新人可获得第一层红包奖励的一个红包；您直推的新人也推荐了三位新人，您将获得第二层红包奖励的第二个红包；根据此原则，您还可得到第三层红包奖励的第三个红包奖励；每层红包不限个数，多推多得！
      LanguageConfigKeys.Shop_mine_promotion_rules_tip3:
          "3.ยอดส่วนแบ่งและรางวัลอั่งเปาที่ได้รับขึ้นอยู่กับมูลค่าของผลิตภัณฑ์ที่ส่งต่อ", //3. 推荐商品金额越高，分润及红包奖励金额越大
      LanguageConfigKeys.Shop_mine_promotion_rules_tip4:
          "4.คลิก 'รายละเอียดการแนะนำ' เพื่ออ่านรายละเอียด", //4. 满足红包关卡奖励金额，将自动转入余额并进入下一关，请开始新的推广
      LanguageConfigKeys.Shop_mine_promotion_rules_tip5:
          "5.คลิก 'แลกของรางวัล' เพื่อใช้ แต้มการแนะนำ แลกของรางวัลที่ท่านชื่นชอบ เมื่อแลกของรางวัลแล้ว คลิก 'ดูรางวัล' กรุณาใช้สิทธิ์ภายในระยะเวลาที่กำหนด", //5. 选择您喜欢的直推奖品，并完成指定直推人数，即可获得奖品券，奖品券将放入个人中心的优惠券中，请在有效期内使用
      LanguageConfigKeys.Shop_mine_promotion_rules_tip6:
          "6.อำนาจการตัดสินขั้นสุดท้ายในกิจกรรมการส่งต่อถือเป็นของแพลตฟอร์ม", //6. 推广活动最终解释权归属平台所有
      LanguageConfigKeys.Shop_mine_exchange_voucher: "ตั๋วแลก", //兑换券
      LanguageConfigKeys.Shop_mine_entity_prizes: "ของรางวัล", //实物奖品
      LanguageConfigKeys.Shop_mine_my_push: "แต้มการแนะนำของฉัน", //我的直推
      LanguageConfigKeys.Shop_mine_my_push_value: "แต้มการแนะนำของฉัน", //我的直推值
      LanguageConfigKeys.Shop_mine_second_level: "แนะนำขั้นที่ 2", //二级推荐
      LanguageConfigKeys.Shop_mine_third_level: "แนะนำขั้นที่ 3", //三级推荐
      LanguageConfigKeys.Shop_mine_processing: "กำลังดำเนินการ", //进行中
      LanguageConfigKeys.Shop_mine_issued: "แจกแล้ว", //已发放
      LanguageConfigKeys.Shop_mine_exchange_success_tip:
          "ขณะนี้มี | คนแลกสำเร็จแล้ว", // 当前已有|人兑换成功
      LanguageConfigKeys.Shop_mine_select_prizes: "เลือกของรางวัล", //挑选奖品
      LanguageConfigKeys.Shop_mine_now_use: "ใช้ทันที", //立即使用
      LanguageConfigKeys.Shop_mine_detail: "ดูรายละเอียด", //查看详情
      LanguageConfigKeys.Shop_mine_expired: "%s หมดอายุ", //%s 过期
      LanguageConfigKeys.Shop_mine_direct_push: "ใช้แต้ม %s", //直推值%s
      LanguageConfigKeys.Shop_mine_hot: "ยอดนิยม", //热门
      LanguageConfigKeys.Shop_mine_end_remain: "เหลือเวลาอีก", //距结束还剩
      LanguageConfigKeys.Shop_mine_exchange_prizes: "แลกของรางวัล", //兑换奖品
      LanguageConfigKeys.Shop_mine_store_consumption:
          "ใช้สิทธิ์ที่ร้านค้า", //门店消费
      LanguageConfigKeys.Shop_mine_express_delivery: "จัดส่งด่วน", //快递发货
      LanguageConfigKeys.Shop_mine_exchange_records: "ประวัติการแลก", //兑换记录
      LanguageConfigKeys.Shop_mine_value: "มูลค่า", //价值
      LanguageConfigKeys.Shop_mine_stock: "คลัง", //库存
      LanguageConfigKeys.Shop_mine_direct_push_value: "แต้มการแนะนำ", //直推值
      LanguageConfigKeys.Shop_mine_using_direct_push_value:
          "หักแต้มการแนะนำ", //消耗直推值
      LanguageConfigKeys.Shop_mine_enable: "สามารถแลกได้", //可兑
      LanguageConfigKeys.Shop_mine_exchange_successful: "แลกสำเร็จ", //兑换成功
      LanguageConfigKeys.Shop_mine_confirm_exchange: "ยืนยัน", //确定兑换
      LanguageConfigKeys.Shop_mine_confirm_use: "ยืนยัน", //确定使用
      LanguageConfigKeys.Shop_mine_confirm_use_tip:
          "คลิกยืนยัน เพื่อยืนยันการแลก โปรดตรวจสอบความถูกต้อง", //点击确定，表示兑换完成，请谨慎操作
      LanguageConfigKeys.Shop_mine_voucher_code_info: "ข้อมูลรหัสคูปอง", //券码信息
      LanguageConfigKeys.Shop_mine_prize_info: "ข้อมูลของรางวัล", //奖品信息
      LanguageConfigKeys.Shop_mine_exchange_number: "หมายเลขการแลก", //兑换单号
      LanguageConfigKeys.Shop_mine_exchange_time: "เวลาแลก", //兑换时间
      LanguageConfigKeys.Shop_mine_usage_rules: "กฎการใช้", //使用规则
      LanguageConfigKeys.Shop_mine_usage_rules_tip1:
          "1.คลิกใช้ทันที เพื่อแลก/จัดส่ง ไม่มีเงินทอน ไม่คืนสินค้า และไม่สามารถเปลี่ยนเป็นเงินสดได้", //1. 点击立即使用，即兑换/发货，不找零、不退换、不兑现金
      LanguageConfigKeys.Shop_mine_usage_rules_tip2:
          "2.กรุณาตรวจสอบระยะเวลาการใช้ ใช้งานโดยเร็วที่สุด หากหมดอายุแล้วจะไม่สามารถใช้งานได้", //2. 请注意礼品使用时间，请尽快使用，过期失效
      LanguageConfigKeys.Shop_mine_usage_rules_tip3:
          "3.อำนาจการตัดสินขั้นสุดท้ายถือเป็นของแพลตฟอร์มแต่เพียงผู้เดียว", //3. 最终解释权归属平台
      LanguageConfigKeys.Shop_mine_usage_expiration_time:
          "วันหมดอายุ %s", //过期时间 %s
      LanguageConfigKeys.Shop_mine_usage_total_sheets: "ทั้งหมด | ใบ", //共 | 张
      LanguageConfigKeys.Shop_mine_logistics_info: "ข้อมูลการขนส่ง", //物流信息
      LanguageConfigKeys.Shop_mine_receiving_time: "เวลาที่รับสินค้า", //收货时间
      LanguageConfigKeys.Shop_order_waiting_for_shipment: "รอจัดส่ง", //等待发货
      LanguageConfigKeys.Shop_mine_keep_working_hard:
          "ยินดีด้วย! พยามต่อไปนะ", //恭喜，请再接再厉
      LanguageConfigKeys.Shop_mine_obtain_red: "ได้รับอั่งเปา", //获得红包
      LanguageConfigKeys.Shop_mine_to_be_updated: "รออัปเดต", //待更新
      LanguageConfigKeys.Shop_mine_run_to_zero: "หมดอายุ", //过期失效
      LanguageConfigKeys.Shop_mine_select_option: "เลือกรอบ", //选择期数
      LanguageConfigKeys.Shop_order_all: "ทั้งหมด", //全部
      LanguageConfigKeys.Shop_order_received: "สามารถรับได้", //可接
      LanguageConfigKeys.Shop_order_changed: "สับเปลี่ยน", //更换
      LanguageConfigKeys.Shop_order_wait_pay: "รอการชำระเงิน", //待付款
      LanguageConfigKeys.Shop_order_wait_deliver: "รอจัดส่งสินค้า", //待发货
      LanguageConfigKeys.Shop_order_wait_receipt: "รอรับสินค้า", //待收货
      LanguageConfigKeys.Shop_order_shipped: "จัดส่งแล้ว", //已发货
      LanguageConfigKeys.Shop_order_completed: "เสร็จสิ้น", //已完成
      LanguageConfigKeys.Shop_order_receive_finish: "รับสินค้าแล้ว", //已收货
      LanguageConfigKeys.Shop_order_canceled: "ยกเลิก", //已取消
      LanguageConfigKeys.Shop_order_after_sales_order:
          "บริการหลังการขาย", //售后订单
      LanguageConfigKeys.Shop_order_delete_title:
          "ต้องการลบคำสั่งซื้อหรือไม่", //确认删除订单？
      LanguageConfigKeys.Shop_order_delete_content:
          "ประวัติคำสั่งซื้อนี้ไม่สามารถเรียกคืนได้หลังจากลบ", //删除后该订单记录无法找回
      LanguageConfigKeys.Shop_order_again_patronage:
          "หวังว่าจะมีโอกาสให้บริการคุณอีกครั้ง", //期待您再次惠顾
      LanguageConfigKeys.Shop_order_after_sales: "บริการหลังการขาย", //售后
      LanguageConfigKeys.Shop_order_confirm_order: "ยืนยันคำสั่งซื้อ", //确认订单
      LanguageConfigKeys.Shop_order_empty: "ไม่มีรายการสั่งซื้อ", //暂无订单
      LanguageConfigKeys.Shop_order_search: "ค้นหาคำสั่งซื้อ", //搜索订单
      LanguageConfigKeys.Shop_order_mine_order: "คำสั่งซื้อของฉัน", //我的订单
      LanguageConfigKeys.Shop_order_now_pay: "ชำระเงินทันที", //立即付款
      LanguageConfigKeys.Shop_order_confirm_pay: "ยืนยันการชำระเงิน", //确认支付
      LanguageConfigKeys.Shop_order_remain: "เหลือเวลาอีก", //剩余
      LanguageConfigKeys.Shop_order_pay: "ชำระเงิน", //支付
      LanguageConfigKeys.Shop_order_cancel_order: "ยกเลิกคำสั่งซื้อ", //取消订单
      LanguageConfigKeys.Shop_order_change_address: "เปลี่ยนที่อยู่", //更换地址
      LanguageConfigKeys.Shop_order_contact_customer_service:
          "ติดต่อฝ่ายบริการลูกค้า", //联系客服
      LanguageConfigKeys.Shop_order_confirm_receipt: "ยืนยันรับสินค้า", //确认收货
      LanguageConfigKeys.Shop_order_confirm_receipt_tip:
          "เพื่อป้องกันสิทธิ์ของคุณ กรุณายืนยืนหลังจากได้รับสินค้าแล้ว", //为保障您的权益，请收货后再确认
      LanguageConfigKeys.Shop_order_again_buy: "ซื้ออีกครั้ง", //再次购买
      LanguageConfigKeys.Shop_order_service1: "ปลอมปรับ 3 เท่า", //假一赔三
      LanguageConfigKeys.Shop_order_service2: "บริการหลังการขาย", //品牌售后
      LanguageConfigKeys.Shop_order_service3: "ตรวจสอบสินค้าย้อนกลับ", //正品溯源
      LanguageConfigKeys.Shop_order_service4: "การันตีเวลาจัดส่ง", //超时免单
      LanguageConfigKeys.Shop_order_service5: "จัดส่งรวดเร็ว", //快速发货
      LanguageConfigKeys.Shop_order_service6: "รวมค่าจัดส่ง", //商品包邮
      LanguageConfigKeys.Shop_order_service7: "รองรับการผ่อนชำระ", //支持分期
      LanguageConfigKeys.Shop_order_service8: "คืนเงินรวดเร็ว", //快速退款
      LanguageConfigKeys.Shop_order_delete_order: "ลบคำสั่งซื้อ", //删除订单
      LanguageConfigKeys.Shop_order_view_logistics: "ดูสถานะการจัดส่ง", //查看物流
      LanguageConfigKeys.Shop_order_apply_service: "บริการหลังการขาย", //申请售后
      LanguageConfigKeys.Shop_order_piece_in_total: "ทั้งหมด %s ชิ้น", //共%s件
      LanguageConfigKeys.Shop_order_coupons_ticket_available:
          "%s ใบที่สามารถใช้ได้", //%s张可用
      LanguageConfigKeys.Shop_order_coupons: "คูปอง", //优惠券
      LanguageConfigKeys.Shop_order_tax: "ภาษีมูลค่าเพิ่ม (7%)", //增值税 (7%)
      LanguageConfigKeys.Shop_order_tax_fee7:
          "ภาษีมูลค่าเพิ่ม (VAT7%)", //税费 (VAT7%)
      LanguageConfigKeys.Shop_order_select_delivery: "เลือกการจัดส่ง", //选择快递
      LanguageConfigKeys.Shop_order_logistics_company: "บริษัทขนส่ง", //物流公司
      LanguageConfigKeys.Shop_order_select_logistics_company:
          "เลือกบริษัทขนส่ง", //选择物流公司
      LanguageConfigKeys.Shop_order_delivery1: "ลงทะเบียน", //平邮
      LanguageConfigKeys.Shop_order_delivery2: "จัดส่งด่วน", //快递
      LanguageConfigKeys.Shop_order_delivery3: "ไปรษณีย์ไทย", //泰国邮政
      LanguageConfigKeys.Shop_order_freight_details:
          "รายละเอียดการจัดส่งสินค้า", //运费详情
      LanguageConfigKeys.Shop_order_goods_total: "สินค้าทั้งหมด", //商品总价
      LanguageConfigKeys.Shop_order_total: "ยอดสุทธิ", //合计
      LanguageConfigKeys.Shop_order_payment_required: "ต้องชำระเงิน", //需付款
      LanguageConfigKeys.Shop_order_total_discount: "ส่วนลดทั้งหมด", //共优惠
      LanguageConfigKeys.Shop_order_freight: "ค่าจัดส่ง", //运费
      LanguageConfigKeys.Shop_order_total_freight: "ยอดสุทธิค่าจัดส่ง", //合计运费
      LanguageConfigKeys.Shop_order_place_order: "ส่งคำสั่งซื้อ", //提交订单
      LanguageConfigKeys.Shop_order_select_receive_address:
          "กรุณาเพิ่มที่อยู่ในการจัดส่ง", //请添加收货地址
      LanguageConfigKeys.Shop_order_wait_for_payment: "รอชำระเงิน", //等待支付
      LanguageConfigKeys.Shop_order_order_sn: "เลขที่คำสั่งซื้อ", //订单编号
      LanguageConfigKeys.Shop_order_add_points: "รับแต้ม", //获取积分
      LanguageConfigKeys.Shop_order_payment_type: "วิธีการชำระเงิน", //支付方式
      LanguageConfigKeys.Shop_order_order_time: "เวลาที่สั่งซื้อ", //下单时间
      LanguageConfigKeys.Shop_order_payment_time: "เวลาที่ชำระเงิน", //支付时间
      LanguageConfigKeys.Shop_order_receive_address: "ข้อมูลในการจัดส่ง", //收货信息
      LanguageConfigKeys.Shop_order_delivery_type: "ประเภทการจัดส่ง", //配送方式
      LanguageConfigKeys.Shop_order_delivery_time: "เวลาส่งสินค้า", //发货时间
      LanguageConfigKeys.Shop_order_calc_delivery_time:
          "คาดการณ์เวลาจัดส่ง", //预计发货
      LanguageConfigKeys.Shop_order_delivering: "กำลังจัดส่ง", //配送中
      LanguageConfigKeys.Shop_order_signed_in: "รับสินค้าแล้ว", //已签收
      LanguageConfigKeys.Shop_order_to_be_settled: "กำลังคำนวณ", //待结算
      LanguageConfigKeys.Shop_order_be_careful: "ระวัง", //注意
      LanguageConfigKeys.Shop_order_rule_tips:
          "ตามกฎของกิจกรรมหลังจากสิ้นสุดกิจกรรมแพลตฟอร์มจะดำเนินการสรุปผลเป็นเวลา 7 วัน ในขั้นตอนนี้ อาจมีการเปลี่ยนแปลงอันดับและรางวัลที่เกิดจากการยกเลิกคำสั่งซื้อของผู้ใช้ โปรดทราบว่า การติดตามคำสั่งซื้อจะเพิ่มอัตราการสั่งซื้อได้อย่างมีประสิทธิภาพ หวังว่าคุณจะราบรื่น ยิ่งเล่นยิ่งได้", //根据活动规则，活动结束后，由平台进行为期7天的统计结算，此过程可能存在用户退单导致的排名及奖励变化，请谅解，跟单将有效提升成单率，祝您越来越顺，越玩越赚。
      LanguageConfigKeys.Shop_order_no_app_found:
          "ไม่พบแอปพลิเคชันที่ตรงกัน", //没有找到对应APP
      LanguageConfigKeys.Shop_order_pay_success: "ชำระเงินสำเร็จ", //支付成功
      LanguageConfigKeys.Shop_order_pay_success_winning:
          "ขอแสดงความยินดีกับโอกาสในการจับสลาก 100% Oh", //恭喜获得抽奖机会，100%中奖哦
      LanguageConfigKeys.Shop_order_pay_success_tip1:
          "รีบแชร์ให้เพื่อนกันเถอะ!", //快去分享好货给好友吧！
      LanguageConfigKeys.Shop_order_share_goods: "แชร์สินค้า", //分享好货
      LanguageConfigKeys.Shop_order_pay_success_tip2:
          "คำเตือนด้านความปลอดภัย: นอกเหนือจากการรับรองชื่อจริง MXCOME จะไม่ขอข้อมูลบัตรธนาคารหรือจ่ายเงินเพิ่มเติมด้วยเหตุผลใด ๆ โปรดระวังการเชื่อมโยงฟิชชิ่งหรือโทรศัพท์หลอกลวง!", //安全提醒：除实名认证外MXCOME不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话！
      LanguageConfigKeys.shop_order_card_email_title:
          "อีเมลสำหรับรับข้อมูล / Web3 Wallet ลงทะเบียนกล่องจดหมาย (จำเป็น)",
      LanguageConfigKeys.shop_order_card_email_hint:
          "กรุณากรอกอีเมลสำหรับรับข้อมูลคูปอง",
      LanguageConfigKeys.shop_order_card_email_not_empty: "ต้องกรอกอีเมล",
      LanguageConfigKeys.shop_order_card_email_error:
          "โปรดป้อนที่อยู่อีเมลที่ถูกต้อง", //请输入正确邮箱地址
      LanguageConfigKeys.shop_order_virtual_product_tip:
          "โปรดตรวจสอบและยืนยันที่อยู่อีเมลของท่านให้ถูกต้องก่อนที่จะชำระเงินเนื่องจากสินค้านี้ไม่สามารถคืนหรือเปลี่ยนได้ MXCOME ไม่รับผิดชอบตามกรณีดังกล่าว", //请确认输入正确邮箱地址后支付订单，虚拟商品一旦发货，不支持退换货，平台不承担责任。
      LanguageConfigKeys.Shop_order_delivery_to: "จัดส่งไปยัง", //商品配送至
      LanguageConfigKeys.Shop_order_coupons_disable: "ไม่ได้ใช้คูปอง", //未使用优惠券
      LanguageConfigKeys.Shop_order_status: "สถานะคำสั่งซื้อ", //订单状态
      LanguageConfigKeys.Shop_order_confirm_change: "ยืนยัน", //确认更换
      LanguageConfigKeys.Shop_order_user_pay: "ชำระเงิน", //用户付款
      LanguageConfigKeys.Shop_order_shop_deliver: "จัดส่งสินค้า", //店铺发货
      LanguageConfigKeys.Shop_order_express_delivery: "นำส่งสินค้า", //快递配送
      LanguageConfigKeys.Shop_order_user_receipt: "รับสินค้า", //用户收货
      LanguageConfigKeys.Shop_order_detail_tip1: "รอชำระเงิน", //等待支付
      LanguageConfigKeys.Shop_order_detail_tip2:
          "ชำระเงินสำเร็จ ร้านค้าจะต้องส่งสินค้าออกมาภายใน 48 ชั่วโมง", //支付完成，商家承诺在48小时内完成发货
      LanguageConfigKeys.Shop_order_detail_tip3:
          "ร้านค้ากำลังเตรียมสินค้า", //店铺备货中
      LanguageConfigKeys.Shop_order_detail_tip4:
          "กำลังส่งสินค้า โปรดอดใจรออีกนิด", //即将发货，敬请期待
      LanguageConfigKeys.Shop_order_delivery_detail:
          "รายละเอียดการจัดส่ง", //快递详情
      LanguageConfigKeys.Shop_order_order_completed:
          "คำสั่งซื้อเสร็จสิ้น", //订单已完成
      LanguageConfigKeys.Shop_order_order_canceled:
          "คำสั่งซื้อถูกยกเลิกแล้ว", //订单已取消
      LanguageConfigKeys.Shop_order_suggestions: "ความคิดเห็นจากผู้ใช้", //客户建议
      LanguageConfigKeys.Shop_order_invalid: "คำสั่งซื้อไม่ถูกต้อง", //无效订单
      LanguageConfigKeys.Shop_order_prompt_pay: "พร้อมเพย์ QR", //Promptpay QR
      LanguageConfigKeys.Shop_order_cashier: "แคชเชียร์", //收银台
      LanguageConfigKeys.Shop_order_pay_amount: "ชำระยอด (บาท)", //支付金额(฿)
      LanguageConfigKeys.Shop_order_pay_remaining_time:
          "เหลือเวลาชำระเงินอีก", //支付剩余时间
      LanguageConfigKeys.Shop_order_pay_qr_code:
          "กรุณาถ่ายภาพหน้าจอ เพื่อบันทึกคิวอาร์โค้ด", //请截图保存二维码
      LanguageConfigKeys.Shop_order_balance_pay: "ยอดชำระ", //余额支付
      LanguageConfigKeys.Shop_order_kbank_pay: "ธนาคารกสิกรไทย", //泰国开泰银行
      LanguageConfigKeys.Shop_order_scb_pay: "ธนาคารไทยพาณิชย์", //泰国汇商银行
      LanguageConfigKeys.Shop_order_bank_card_pay:
          "ชำระเงินด้วยบัตรธนาคาร", //银行卡支付
      LanguageConfigKeys.Shop_order_select_pay:
          "เลือกช่องทางการชำระเงิน", //请选择支付方式
      LanguageConfigKeys.Shop_order_official_pay: "ชำระเงินผ่าน MXCOME", //官方支付
      LanguageConfigKeys.Shop_order_third_party_pay:
          "ชำระเงินผ่านบุคคลที่สาม", //第三方支付
      LanguageConfigKeys.Shop_order_delivery_collect:
          "รับสินค้าเข้าระบบ", //快递揽收
      LanguageConfigKeys.Shop_order_brand_commitment:
          "รับประกันจากแบรนด์", //品牌承诺
      LanguageConfigKeys.Shop_order_platform_policy:
          "นโยบายของแพลตฟอร์ม", //平台政策
      LanguageConfigKeys.Shop_order_brand: "แบรนด์", //品牌
      LanguageConfigKeys.Shop_order_delivery: "ขนส่ง", //物流
      LanguageConfigKeys.Shop_order_user: "ผู้ใช้", //用户
      LanguageConfigKeys.Shop_order_sender_max_time:
          "จัดส่งสินค้า/ใน48ชั่วโมง", //发货/48小时内
      LanguageConfigKeys.Shop_order_delivery_max_time:
          "นำส่งสินค้า/ใน72ชั่วโมง", //配送/72小时内
      LanguageConfigKeys.Shop_order_receipt_max_time:
          "รับสินค้า/ใน48ชั่วโมง", //收货/48小时内"
      LanguageConfigKeys.Shop_order_consume: "ใช้เวลาทั้งหมด", //共耗时
      LanguageConfigKeys.Shop_order_promise: "ผิดสัญญา", //违约
      LanguageConfigKeys.Shop_order_platform_in: "แพลตฟอร์มดำเนินการ", //平台介入
      LanguageConfigKeys.Shop_order_eligible:
          "คำสั่งซื้อปัจจุบันสอดคล้องกับ「%s」เงื่อนไข", //当前订单符合「%s」条件
      LanguageConfigKeys.Shop_order_responsibility_division:
          "การแบ่งหน้าที่ความรับผิดชอบ", //责任划分
      LanguageConfigKeys.Shop_order_platform_tip1:
          "หลักการในการจัดการแพลตฟอร์ม คือ ผู้ใดเป็นฝ่ายผิดสัญญา ผู้นั้นจะเป็นผู้รับผิดชอบ โดยฝ่ายผิดสัญญาจะเป็นฝ่ายรับผิดชอบค่าจัดส่ง", //平台处理原则，谁违约，谁担责；违约方承担对应邮费
      LanguageConfigKeys.Shop_order_result: "ผลการจัดการ", //处理结果
      LanguageConfigKeys.Shop_order_bear_the_postage:
          "%sเป็นผู้รับภาระค่าจัดส่ง", //由%s承担邮费
      LanguageConfigKeys.Shop_order_phone_verify: "ยืนยันตัวตน", //手机验证
      LanguageConfigKeys.Shop_order_set_pay_pwd:
          "ตั้งรหัสผ่านสำหรับชำระเงิน", //设置支付密码
      LanguageConfigKeys.Shop_order_confirm_pay_pwd: "ยืนยันรหัสผ่าน", //确认支付密码
      LanguageConfigKeys.Shop_order_pay_pwd_error:
          "รหัสผ่านสำหรับชำระเงินไม่ถูกต้อง โปรดลองอีกครั้ง", //支付密码错误，请重新输入
      LanguageConfigKeys.Shop_order_id_verify: "ยืนยันตัวตน", //身份验证
      LanguageConfigKeys.Shop_order_set_pay_pwd_tip:
          "โปรดตั้งรหัสผ่านสำหรับชำระเงิน เพื่อยืนยันการชำระเงิน", //请设置支付密码，用于支付验证
      LanguageConfigKeys.Shop_order_confirm_pay_pwd_tip:
          "กรุณากรอกอีกครั้ง", //请再次输入
      LanguageConfigKeys.Shop_order_password_error:
          "รหัสผ่านไม่สอดคล้องกัน โปรดลองอีกครั้ง", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Shop_order_please_enter_pwd:
          "กรุณากรอกรหัสผ่านสำหรับชำระเงิน", //请输入支付密码
      LanguageConfigKeys.Shop_order_prompt_pay_tip1:
          "กรุณาถ่ายภาพหน้าจอ เพื่อบันทึกคิวอาร์โค้ด", //截图保存二维码
      LanguageConfigKeys.Shop_order_prompt_pay_tip2:
          "กรุณาเปิดแอปพลิเคชันธนาคารบนมือถือ เพื่อแสกนและชำระเงิน", //请打开您的任何手机银行应用进行扫码支付
      LanguageConfigKeys.Shop_order_prompt_pay_tip3:
          "กรุณายืนยันยอดการสั่งซื้อ", //请确认订单支付金额
      LanguageConfigKeys.Shop_order_prompt_pay_tip4:
          "พร้อมเพย์ไม่รองรับการคืนเงิน หากเกิดการคืนเงิน เงินจะคืนเข้าบัญชีของคุณ", //PromptPay不支持原路退款，产生退款，款项将退入您的账户余额
      LanguageConfigKeys.Shop_order_prompt_pay_tip5:
          "หลังจากการชำระเงินสำเร็จ โปรดรอสักครู่ในหน้านี้ คลิกที่ปุ่มด้านล่างเพื่อสอบถามสถานะการชำระเงิน", //付款成功后，请在此页面耐心等待片刻 点击下方按钮，查询付款状态
      LanguageConfigKeys.Shop_order_timeout: "หมดเวลาชำระเงิน", //支付超时
      LanguageConfigKeys.Shop_order_place_new_order:
          "คำสั่งซื้อหมดเวลา โปรดสั่งซื้อใหม่อีกครั้ง", //订单已取消，请重新下单
      LanguageConfigKeys.Shop_order_got_it: "เข้าใจแล้ว", //明白了
      LanguageConfigKeys.Shop_order_iknow: "รู้แล้ว", //知道了
      LanguageConfigKeys.Shop_order_cancel_payment:
          "คุณยกเลิกการชำระเงินแล้ว", //您已取消了支付
      LanguageConfigKeys.Shop_order_after_pay_query:
          "หลังจากชำระเงินแล้ว คลิกปุ่มสอบถาม", //付款后，点击查询
      LanguageConfigKeys.Shop_order_not_pay:
          "หากยังไม่ได้ชำระเงิน โปรดชำระเงินก่อน", //订单未支付，请先付款
      LanguageConfigKeys.Shop_order_paying:
          "อยู่ระหว่างการดำเนินการสั่งซื้อ โปรดลองอีกครั้งในภายหลัง", //订单处理中，请稍后再试
      LanguageConfigKeys.Shop_order_pay_failed: "ชำระเงินล้มเหลว", //支付失败
      LanguageConfigKeys.Shop_order_install_scb:
          "กรุณาติดตั้ง SCB EASY", //请安装SCB EASY
      LanguageConfigKeys.Shop_order_download_tip:
          "คุณยังไม่ได้ดาวน์โหลดแอปพลิเคชันของธนาคาร กรุณาดาวน์โหลดก่อน", //您还未下载银行APP，请先下载!
      LanguageConfigKeys.Shop_order_confirm_close_title:
          "ยืนยันจะออกจากแคชเชียร์", //确认要离开收银台?
      LanguageConfigKeys.Shop_order_confirm_close_message:
          "คำสั่งซื้อของคุณยังไม่ได้ชำระเงิน กรุณาชำระเงินโดยเร็วที่สุด!", //您的订单还未完成支付 请尽快支付!
      LanguageConfigKeys.Shop_order_confirm_close: "ยืนยันออก", //确认离开
      LanguageConfigKeys.Shop_order_confirm_continue:
          "ดำเนินการชำระเงินต่อ", //继续支付
      LanguageConfigKeys.Shop_order_not_support_pay:
          "ไม่สามารถชำระเงินผ่านช่องทางนี้ชั่วคราว", //暂不支持该支付方式
      LanguageConfigKeys.Shop_order_insufficient_balance:
          "ยอดคงเหลือไม่เพียงพอ โปรดเลือกวิธีการชำระเงินอื่น", //余额不足，请选择其它支付方式
      LanguageConfigKeys.Shop_order_package: "พัสดุ", //包裹
      LanguageConfigKeys.Shop_order_selected: "เลือกแล้ว %s ใบ", //已选%s张
      LanguageConfigKeys.Shop_order_total_baby: "ทั้งหมด %s ชิ้น", //共%s件宝贝
      LanguageConfigKeys.Shop_order_return_coupon: "คืนคูปอง", //退回优惠券
      LanguageConfigKeys.Shop_order_return_coupon_tip:
          "คืนคูปองแล้ว สามารถใช้ได้อีกครั้ง", //优惠券已退回，您可再次使用
      LanguageConfigKeys.Shop_order_detail_address_nav: "ค้นหาที่อยู่", //地址导航
      LanguageConfigKeys.Shop_order_detail_address_nav_tip:
          "หลังจากสั่งซื้อ โค้ดจะถูกส่งไปยังอีเมลของคุณ / Web3 Wallet ลงทะเบียนกล่องจดหมาย", //购买后，券码将发送至邮箱 / Web3钱包注册邮箱
      LanguageConfigKeys.Shop_sales_status: "สถานะหลังการขาย", //售后状态
      LanguageConfigKeys.Shop_sales_policy: "นโยบายหลังการขาย", //售后政策
      LanguageConfigKeys.Shop_sales_refund:
          "คืนเงินเนื่องจากสินค้ายังไม่ถูกจัดส่ง", //未发货退款
      LanguageConfigKeys.Shop_sales_refund_success: "คืนเงินสำเร็จ", //退款成功
      LanguageConfigKeys.Shop_sales_refund_item1: "สั่งซื้อผิด", //买错了
      LanguageConfigKeys.Shop_sales_refund_item2:
          "เพื่อนไม่แนะนำสินค้านี้", //朋友不推荐此商品
      LanguageConfigKeys.Shop_sales_refund_item3: "ไม่มีเหตุผล", //没有理由
      LanguageConfigKeys.Shop_sales_return_refund: "คืนของและคืนเงิน", //退货退款
      LanguageConfigKeys.Shop_sales_return_refund_item1:
          "สอดคล้องกับเงื่อนไขคืนของและคืนเงิน", //符合退货退款条件
      LanguageConfigKeys.Shop_sales_overtime: "การันตีเวลาจัดส่ง", //超时免单
      LanguageConfigKeys.Shop_sales_overtime_item1:
          "สอดคล้องกับเงื่อนไขการันตีเวลาจัดส่ง", //符合超时免单条件
      LanguageConfigKeys.Shop_sales_submit_order: "ส่งคำสั่งซื้อ", //提交订单
      LanguageConfigKeys.Shop_sales_merchant_verify: "ตรวจสอบร้านค้า", //商家审核
      LanguageConfigKeys.Shop_sales_serivce_score: "คะแนนบริการ", //服务评分
      LanguageConfigKeys.Shop_sales_delivery_serive: "บริการจัดส่ง", //快递服务
      LanguageConfigKeys.Shop_sales_verify_product: "ตรวจสอบสินค้า", //审核商品
      LanguageConfigKeys.Shop_sales_detail: "รายละเอียดบริการหลังการขาย", //售后详情
      LanguageConfigKeys.Shop_sales_pending_refunded: "รอคืนเงิน", //售后详情
      LanguageConfigKeys.Shop_sales_refunded: "คืนเงินแล้ว", //已退款
      LanguageConfigKeys.Shop_sales_refunded_reason:
          "เหตุผลการขอคืนเงิน", //退款原因
      LanguageConfigKeys.Shop_sales_number: "หมายเลขคำร้องขอ", //售后单号
      LanguageConfigKeys.Shop_sales_apply_time: "เวลายื่นคำร้องขอ", //申请时间
      LanguageConfigKeys.Shop_sales_apply_type: "ประเภทคำขอ", //售后类型
      LanguageConfigKeys.Shop_sales_apply_reason: "เหตุผลคำขอ", //申请原因
      LanguageConfigKeys.Shop_sales_take_info: "ที่อยู่เข้ารับสินค้า", //取件信息
      LanguageConfigKeys.Shop_sales_after_sales:
          "เสร็จสิ้นบริการหลังการขาย", //完成售后
      LanguageConfigKeys.Shop_sales_refund_time: "เวลาคืนเงิน", //退款时间
      LanguageConfigKeys.Shop_sales_return_balance:
          "หลังจากการบริการเสร็จสิ้นจะทำการคืนเงินเข้าบัญชี", //完成售后将退款至账户余额
      LanguageConfigKeys.Shop_sales_return_amount: "ยอดเงินคืน", //退款金额
      LanguageConfigKeys.Shop_sales_platform_in:
          "ยื่นคำร้องถึงแพลตฟอร์ม", //申请平台介入
      LanguageConfigKeys.Shop_sales_cancel_apply: "ยกเลิกคำร้องขอ", //取消申请
      LanguageConfigKeys.Shop_sales_cancel_success: "ยกเลิกคำขอสำเร็จ", //取消申请成功
      LanguageConfigKeys.Shop_sales_least_two_pictures:
          "อัพโหลดรูปภาพอย่างน้อย 2 ภาพ", // 至少上传两张图片
      LanguageConfigKeys.Shop_sales_apply: "คำร้องขอ", //售后申请
      LanguageConfigKeys.Shop_sales_processing: "กำลังดำเนินการ", //处理中
      LanguageConfigKeys.Shop_sales_completed: "เสร็จสิ้น", //售后完成
      LanguageConfigKeys.Shop_sales_application_record: "ประวัติการยื่น", //申请记录
      LanguageConfigKeys.Shop_sales_service: "บริการหลังการขาย", //售后服务
      LanguageConfigKeys.Shop_sales_service_tip1:
          "กรุณาเลือกตามสถานการณ์จริง", //请根据实际情况进行选择
      LanguageConfigKeys.Shop_sales_service_tip2:
          "หากมีเจตนาที่ไม่พึงประสงค์ในการยื่นคำร้องการบริการหลังการขายอาจส่งผลให้ถูกแบนเป็นเวลา 30 วัน", //若恶意售后，可能导致违规封禁30天
      LanguageConfigKeys.Shop_sales_order_elapsed:
          "คำสั่งซื้อนี้เกินเวลาแล้ว", //订单已耗时
      LanguageConfigKeys.Shop_sales_overtime_tip1:
          "ตามนโยบายของแพลตฟอร์ม คุณสามารถยื่นคำร้องจัดส่งเกินเวลาได้หากจัดส่งเกิน 7 วัน", //根据平台政策，超过7天未完成配送可申请超时免单
      LanguageConfigKeys.Shop_sales_overtime_tip2:
          "หากคุณได้รับสินค้าหลังจากดำเนินการหลังการขายเสร็จสิ้นแล้ว สินค้าจะไม่สามารถส่งคืนได้", //售后处理完毕后收到商品，可不予退回
      LanguageConfigKeys.Shop_sales_overtime_tip3:
          "การคืนเงินจะดำเนินการตามช่องทางการรับเงินคืนที่คุณเลือกไว้", //退款将根据选择的退款方式退回
      LanguageConfigKeys.Shop_sales_service_detail:
          "รายละเอียดค่าบริการ", //服务费明细
      LanguageConfigKeys.Shop_sales_total_service_fee:
          "ค่าบริการทั้งหมด", //总服务费
      LanguageConfigKeys.Shop_sales_finish_route:
          "หลังจากบริการเสร็จสิ้น รับเงินคืนผ่านช่องทาง", //售后完成退款路径
      LanguageConfigKeys.Shop_sales_balance: "ยอดเงินในบัญชี", //账号余额
      LanguageConfigKeys.Shop_sales_apply_submit: "ส่งคำร้องขอ", //提交申请
      LanguageConfigKeys.Shop_sales_verify_tip1:
          "โปรดรอการตรวจสอบร้านค้าและคืนเงินภายใน 24 ชั่วโมงหลังจากการตรวจสอบเสร็จสิ้น", //请耐心等待商家审核，审核完成后24小时退款
      LanguageConfigKeys.Shop_sales_verify_tip2:
          "โปรดรอการตรวจสอบร้านค้า", //请耐心等待商家审核
      LanguageConfigKeys.Shop_sales_verify_tip3:
          "ส่งคำขอบริการหลังการขายสำเร็จ รอร้านค้าตรวจสอบ ตรวจสอบเสร็จสิ้นภายใน %s ชั่วโมง!", //售后申请已提交成功，待商家审核，将在12小时内处理完毕
      LanguageConfigKeys.Shop_sales_refund_tip1:
          "แก้ไขที่อยู่และยื่นคำร้องขอคืนเงินได้ภายใน 24 ชั่วโมงหลังจากทำการสั่งซื้อ", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_refund_tip2:
          "ค่าธรรมเนียมที่เกิดขึ้นในการสั่งซื้อและคูปองที่ใช้ไปแล้ว ไม่สามารถนำกลับคืนมาได้", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_return_refund_tip1:
          "แก้ไขที่อยู่และยื่นคำร้องขอคืนเงินได้ภายใน 24 ชั่วโมงหลังจากทำการสั่งซื้อ", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_return_refund_tip2:
          "ค่าธรรมเนียมที่เกิดขึ้นในการสั่งซื้อและคูปองที่ใช้ไปแล้ว ไม่สามารถนำกลับคืนมาได้", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_upload_photo:
          "อัพโหลดรูปภาพสินค้า", // 上传商品图片
      LanguageConfigKeys.Shop_sales_upload_photo_tip1:
          "กรุณาอัพโหลดรูปภาพของสินค้า ในกรณีที่เกิดความเสียหายโดยการกระทำของมนุษย์จะไม่รับคืนสินค้า", //请上传商品照片，若人为造成损坏，不支持退换货
      LanguageConfigKeys.Shop_sales_upload_photo_tip2:
          "โปรดรักษาความสมบูรณ์ของบรรจุภัณฑ์ของสินค้า ร้านค้าจะดำเนินการตรวจสอบหลังจากได้รับสินค้า", //请保持商品包装完整性，店铺收货后将进行审核
      LanguageConfigKeys.Shop_address_add: "เพิ่ม", //新增
      LanguageConfigKeys.Shop_address_select_change:
          "โปรดเลือกที่อยู่", //请选择更换地址
      LanguageConfigKeys.Shop_address_receipt_address:
          "ที่อยู่ในการจัดส่ง", //收货地址
      LanguageConfigKeys.Shop_address_receipt_address_empty:
          "ไม่มีที่อยู่", //暂无收货地址
      LanguageConfigKeys.Shop_address_add_receipt_info:
          "เพิ่มที่อยู่ใหม่", //新增收货信息
      LanguageConfigKeys.Shop_address_add_receipt_address:
          "เพิ่มที่อยู่ใหม่", //添加收货地址
      LanguageConfigKeys.Shop_address_edit_receipt_address:
          "แก้ไขที่อยู่", //编辑收货地址
      LanguageConfigKeys.Shop_address_postcode_select:
          "เลือกรหัสไปรษณีย์", //选择邮编
      LanguageConfigKeys.Shop_address_set_as_default_address:
          "ตั้งเป็นค่าเริ่มต้น", //设为默认
      LanguageConfigKeys.Shop_address_default: "ค่าเริ่มต้น", //默认
      LanguageConfigKeys.Shop_address_consignee: "ผู้รับ", //收货人
      LanguageConfigKeys.Shop_address_phone: "เบอร์โทรศัพท์", //手机号
      LanguageConfigKeys.Shop_address_location: "พื้นที่", //所在地区
      LanguageConfigKeys.Shop_address_my_location: "วางตำแหน่ง", //定位
      LanguageConfigKeys.Shop_address_Locating: "กำลังวางตำแหน่ง", //正在定位
      LanguageConfigKeys.Shop_address_detail_address:
          "รายละเอียดที่อยู่", //详细地址
      LanguageConfigKeys.Shop_address_post_code: "รหัสไปรษณีย์", //邮编
      LanguageConfigKeys.Shop_address_consignee_empty:
          "กรุณาระบุชื่อผู้รับ", //请输入收货人姓名
      LanguageConfigKeys.Shop_address_phone_empty:
          "กรุณาระบุเบอร์โทรศัพท์", //请输入收货人手机号
      LanguageConfigKeys.Shop_address_location_empty:
          "กรุณาเลือกภูมิภาค", //请选择收货人所在地区
      LanguageConfigKeys.Shop_address_detail_address_empty:
          "กรุณาระบุรายละเอียดที่อยู่", //请输入详细收货地址
      LanguageConfigKeys.Shop_address_detail_address_hint:
          "กรุณากรอกข้อมูลที่อยู่อย่างละเอียด รวมถึงระบุเลขที่บ้านหรืออาคาร", //请输入详细收货地址，精确到门牌号
      LanguageConfigKeys.Shop_address_post_code_empty:
          "กรุณากรอกรหัสไปรษณีย์", //请输入邮编
      LanguageConfigKeys.Shop_address_save: "บันทึก", //保存
      LanguageConfigKeys.Shop_address_is_delete:
          "ต้องการลบที่อยู่หรือไม่", //是否删除收货地址?
      LanguageConfigKeys.Shop_address_select: "เลือก", //选择
      LanguageConfigKeys.Shop_address_please_select: "กรุณาเลือก", //请选择
      LanguageConfigKeys.Shop_address_please_enter: "กรุณากรอก", //请输入
      LanguageConfigKeys.Shop_address_street_address:
          "ถนนและบ้านเลขที่", //街道及门牌
      LanguageConfigKeys.Shop_address_assist_enter: "ผู้ช่วย", //辅助
      LanguageConfigKeys.Shop_address_confirm_detail_address:
          "กรุณากรอกรายละเอียดที่อยู่ให้ถูกต้อง", //请确定详细地址
      LanguageConfigKeys.Shop_address_contact_info: "ข้อมูลการติดต่อ", //联络信息
      LanguageConfigKeys.Shop_address_address_info: "ข้อมูลที่อยู่", //地址信息
      LanguageConfigKeys.Shop_address_please_select_region:
          "กรุณาเลือกพื้นที่", //请选择区域
      LanguageConfigKeys.Shop_address_get_current_location:
          "ใช้ตำแหน่งปัจจุบัน", //获取当前定位
      LanguageConfigKeys.Shop_address_found_for_you: "พบแล้ว", //已为您找到
      LanguageConfigKeys.Shop_address_government: "จังหวัด", //府
      LanguageConfigKeys.Shop_address_county: "อำเภอ/เขต", //县
      LanguageConfigKeys.Shop_address_village: "ตำบล/แขวง", //镇
      LanguageConfigKeys.Shop_address_keywords:
          "กรุณาใส่คำหลักที่อยู่", //请输入地址关键词
      LanguageConfigKeys.Shop_address_finish: "เสร็จสิ้น", //完成
      LanguageConfigKeys.Shop_address_confirm_delivery_correct:
          "โปรดยืนยันข้อมูลการรับสินค้าที่ถูกต้องและหลีกเลี่ยงความล่าช้าในการรับสินค้า", //请确认正确收件信息，避免收件延迟
      LanguageConfigKeys.Shop_setting_title: "ตั้งค่า", //设置
      LanguageConfigKeys.Shop_setting_subscribe_follow:
          "สมัครสมาชิกและติดตาม", //订阅与关注
      LanguageConfigKeys.Shop_setting_subscribe_follow_detail:
          "จัดการการสมัครสมาชิกและการติดตามของคุณ", //管理你的订阅与关注
      LanguageConfigKeys.Shop_setting_notification_manage:
          "จัดการการแจ้งเตือน", //通知管理
      LanguageConfigKeys.Shop_setting_notification_manage_detail:
          "ต้องการรับข้อความแนะนำและข่าวสารหรือไม่", //是否接受推荐和关注的消息
      LanguageConfigKeys.Shop_setting_privacy_setting:
          "การตั้งค่าความเป็นส่วนตัว", //隐私设置
      LanguageConfigKeys.Shop_setting_privacy_setting_detail:
          "จัดการเนื้อหาที่คนอื่นสามารถมองเห็นได้", //管理其他人看到的信息内容
      LanguageConfigKeys.Shop_setting_account_safe:
          "บัญชีและความปลอดภัย", //账号与安全
      LanguageConfigKeys.Shop_setting_account_safe_detail:
          "เปลี่ยนหมายเลขโทรศัพท์มือถือ รหัสผ่าน ผูกบัญชี", //更改手机号、密码与账号绑定
      LanguageConfigKeys.Shop_setting_Language_change: "เปลี่ยนภาษา", //语言切换
      LanguageConfigKeys.Shop_setting_Language_change_detail:
          "เปลี่ยนภาษาอินเทอร์เฟซเริ่มต้น ค่าเริ่มต้นคือภาษาของระบบปัจจุบัน", //切换默认界面语言，默认为当前系统语言
      LanguageConfigKeys.Shop_setting_user_agreement:
          "ข้อตกลงการใช้บริการ", //用户协议
      LanguageConfigKeys.Shop_setting_user_agreement_detail:
          "ลงนามและปฏิบัติตามกฎหมายและข้อบังคับที่เกี่ยวข้อง", //根据相关法律法规签署并遵照执行
      LanguageConfigKeys.Shop_setting_about: "เกี่ยวกับ", //关于
      LanguageConfigKeys.Shop_setting_about_detail:
          "เกี่ยวกับ MXCOME", //关于MXCOME
      LanguageConfigKeys.Shop_setting_about_version: "เวอร์ชัน", //版本号
      LanguageConfigKeys.Shop_setting_about_new_version: "เวอร์ชันล่าสุด", //新版本
      LanguageConfigKeys.Shop_setting_last_version:
          "อัปเดตเป็นเวอร์ชันล่าสุดแล้ว", //已是最新版本
      LanguageConfigKeys.Shop_setting_update_new_version:
          "มีเวอร์ชันใหม่แล้ว", //有新版本啦!
      LanguageConfigKeys.Shop_setting_update_time: "เวลาที่อัปเดต", //更新时间
      LanguageConfigKeys.Shop_setting_now_update: "อัปเดตตอนนี้", //立即更新
      LanguageConfigKeys.Shop_setting_account_cancellation: "ระงับบัญชี", //注销账号
      LanguageConfigKeys.Shop_setting_account_cancellation_detail:
          "ลบข้อมูลทั้งหมด ลบบัญชีถาวร", //删除所有数据，永久注销
      LanguageConfigKeys.Shop_setting_account_cancel_tip1:
          "นี่จะเป็นการลบบัญชีของคุณ", //这将注销你的账号
      LanguageConfigKeys.Shop_setting_account_cancel_tip2:
          "โปรดทราบว่าบัญชี MXCOME ของคุณ (รวมถึงไอดีผู้ใช้ ชื่อเล่น ข้อมูลส่วนตัว ยอดคงเหลือในสินทรัพย์ ฯลฯ ) จะถูกลบอย่างถาวรออกจาก MXCOME และไม่สามารถกู้คืนได้", //必须注意，你的MXCOME账号（包括你的用户ID、昵称、个人资料、资产余额等）将在MXCOME永久删除，无法找回。
      LanguageConfigKeys.Shop_setting_account_delete: "ระงับ", //注销
      LanguageConfigKeys.Shop_setting_account_confirm_delete:
          "ยืนยันการระงับบัญชี", //确认注销账号
      LanguageConfigKeys.Shop_setting_account_confirm_tip1:
          "ยอดคงเหลือในบัญชี %s และจะหมดอายุอย่างถาวร", //账户余额%s，将永久失效
      LanguageConfigKeys.Shop_setting_account_confirm_tip2:
          "ข้อมูลบัญชีและประวัติรายได้ต่าง ๆ ไม่สามารถกู้คืนได้", //账号信息及收益记录等数据无法恢复
      LanguageConfigKeys.Shop_setting_account_not_delete: "คงไว้", //暂不注销
      LanguageConfigKeys.Shop_setting_account_now_delete: "ระงับทันที", //立即注销
      LanguageConfigKeys.Shop_setting_change_login: "เปลี่ยนบัญชี", //切换账号
      LanguageConfigKeys.Shop_setting_exit_login: "ออกจากระบบ", //退出登录
      LanguageConfigKeys.Shop_setting_phone: "เบอร์โทรศัพท์", //手机号
      LanguageConfigKeys.Shop_setting_phone_detail:
          "แก้ไขหมายเลขโทรศัพท์มือถือ", //修改手机号
      LanguageConfigKeys.Shop_setting_update: "แก้ไข", //修改
      LanguageConfigKeys.Shop_setting_update_pwd: "แก้ไขรหัสผ่าน", //修改密码
      LanguageConfigKeys.Shop_setting_update_pwd_detail:
          "แก้ไขรหัสผ่านของคุณได้ตลอดเวลา", //随时修改你的密码
      LanguageConfigKeys.Shop_setting_pay_pwd: "รหัสผ่านการชำระเงิน", //支付密码
      LanguageConfigKeys.Shop_setting_set_pay_pwd:
          "ตั้งรหัสผ่านการชำระเงิน", //设置支付密码
      LanguageConfigKeys.Shop_setting_change_pay_pwd:
          "แก้ไขรหัสผ่านการชำระเงิน", //修改支付密码
      LanguageConfigKeys.Shop_setting_pay_pwd_detail:
          "ตั้งค่าและแก้ไขรหัสผ่านการชำระเงิน", //设置与修改支付密码
      LanguageConfigKeys.Shop_setting_third_auth:
          "การอนุญาตจากบุคคลที่สาม", //第三方授权
      LanguageConfigKeys.Shop_setting_facebook: "Facebook", //Facebook
      LanguageConfigKeys.Shop_setting_google: "Google", //Google
      LanguageConfigKeys.Shop_setting_apple: "Apple", //Apple
      LanguageConfigKeys.Shop_setting_bind: "ผูกบัญชี", //绑定
      LanguageConfigKeys.Shop_setting_unbind: "ยกเลิกการผูกบัญชี", //解绑
      LanguageConfigKeys.Shop_activity: "กิจกรรม", //活动
      LanguageConfigKeys.Shop_activity_sponsor: "สปอนเซอร์", //主办方
      LanguageConfigKeys.Shop_activity_time: "ระยะเวลากิจกรรม", //活动时间
      LanguageConfigKeys.Shop_activity_complete_task:
          "ทำภารกิจเสร็จสิ้น", //完成淘金任务
      LanguageConfigKeys.Shop_activity_obtain_goods_profit:
          "รับส่วนแบ่งกำไรสินค้า", //获得商品分润
      LanguageConfigKeys.Shop_activity_obtain_level_prize:
          "รับรางวัลด่าน", //获得关卡奖励
      LanguageConfigKeys.Shop_activity_obtain_top_prize:
          "รับรางวัลใหญ่ประจำอันดับ", //获得排名大奖
      LanguageConfigKeys.Shop_activity_obtain_top_prize_tips:
          "รางวัลใหญ่อันดับ", //排名大奖
      LanguageConfigKeys.Shop_activity_now_start: "ท้าทายทันที", //立即挑战
      LanguageConfigKeys.Shop_activity_quick_understand: "ดูรายละเอียด", //快速了解
      LanguageConfigKeys.Shop_activity_top: "%s รายชื่อ", //%名
      LanguageConfigKeys.Shop_activity_count_down: "นับถอยหลัง", //倒计时
      LanguageConfigKeys.Shop_activity_level_count: "ด่านตอนนี้", //当前关卡
      LanguageConfigKeys.Shop_activity_level_prize: "รางวัลด่าน", //关卡奖
      LanguageConfigKeys.Shop_activity_this_task: "ภารกิจด่านนี้", //本关任务
      LanguageConfigKeys.Shop_activity_closed: "สิ้นสุดแล้ว", //已结束
      LanguageConfigKeys.Shop_activity_not_exist:
          "กิจกรรมสิ้นสุดลงแล้ว", //活动已结束
      LanguageConfigKeys.Shop_activity_current_top: "อันดับตอนนี้", //当前排名
      LanguageConfigKeys.Shop_activity_activity_top: "จัดอันดับกิจกรรม", //活动排名
      LanguageConfigKeys.Shop_activity_not_listed: "ไม่ติดอันดับ", //未上榜
      LanguageConfigKeys.Shop_activity_top_big_prize:
          "รางวัลใหญ่ประจำอันดับ", //排名大奖
      LanguageConfigKeys.Shop_activity_get_gold: "ได้รับแล้ว", //已淘金
      LanguageConfigKeys.Shop_activity_for_the_level: "ด่านที่ %s", //第%s关
      LanguageConfigKeys.Shop_activity_st_place: "รางวัลที่ %s", //%s等奖
      LanguageConfigKeys.Shop_activity_random_level_prize:
          "สุ่มรางวัลด่าน 1 ชิ้น ได้รับเมื่อท้าทายกิจกรรมสำเร็จ", //关卡奖励随机分配1件，完成活动挑战领取
      LanguageConfigKeys.Shop_activity_details: "กิจกรรมฝ่าด่าน", //活动闯关
      LanguageConfigKeys.Shop_activity_over_status: "สถานะผ่านด่าน", //通关状态
      LanguageConfigKeys.Shop_activity_after_the_prize:
          "ได้รับรางวัลหลังจากแข่งขันสิ้นสุด", //完赛后领取奖励
      LanguageConfigKeys.Shop_activity_over_all_level: "ผ่านด่านแล้ว", //已通关
      LanguageConfigKeys.Shop_activity_failed: "ตกรอบ", //淘汰
      LanguageConfigKeys.Shop_activity_not_start: "ยังไม่เริ่ม", //未开始
      LanguageConfigKeys.Shop_activity_doing: "กำลังดำเนินการ", //进行中
      LanguageConfigKeys.Shop_activity_prize: "รางวัลกิจกรรม", //活动奖品
      LanguageConfigKeys.Shop_activity_view_prize: "ดูรางวัล", //查看奖品
      LanguageConfigKeys.Shop_activity_enter_activity: "ดูกิจกรรม", //查看活动
      LanguageConfigKeys.Shop_activity_now_break_barrier: "เริ่มฝ่าด่าน", //立即闯关
      LanguageConfigKeys.Shop_activity_continue_break_barrier:
          "ฝ่าด่านต่อไป", //继续闯关
      LanguageConfigKeys.Shop_activity_podium: "เวทีรับรางวัล", //领奖台
      LanguageConfigKeys.Shop_activity_completed_game: "จบการแข่งขัน", //完赛
      LanguageConfigKeys.Shop_activity_mine_prize: "รางวัลของฉัน", //我的奖励
      LanguageConfigKeys.Shop_activity_dispatched: "ส่งเสร็จแล้ว", //已派完
      LanguageConfigKeys.Shop_activity_task_progressing:
          "ภารกิจกำลังดำเนินการอยู่", //任务进行中
      LanguageConfigKeys.Shop_activity_activity_progressing:
          "กิจกรรมกำลังดำเนินการอยู่", //活动进行中
      LanguageConfigKeys.Shop_activity_task_randomly_prize:
          "ระบบจะสุ่มแจกรางวัลหลังจากภารกิจเสร็จสิ้น", //待任务完成后系统将随机发放任务奖励
      LanguageConfigKeys.Shop_activity_activity_randomly_prize:
          "ระบบจะสุ่มแจกรางวัลหลังจากกิจกรรมเสร็จสิ้น", //待活动完成后系统将随机发放关卡奖励
      LanguageConfigKeys.Shop_activity_for_the_level_prize:
          "รางวัลด่านที่ %s ", //第%s关奖励
      LanguageConfigKeys.Shop_activity_top_prize: "รางวัลอันดับ", //排名奖
      LanguageConfigKeys.Shop_activity_task_prize: "รางวัลภารกิจ", //任务奖品
      LanguageConfigKeys.Shop_activity_congratulation_complete_activity:
          "ยินดีด้วย คุณทำกิจกรรมสำเร็จแล้ว", //恭喜，完成活动任务
      LanguageConfigKeys.Shop_activity_congratulation_complete_task:
          "ยินดีด้วย คุณทำภารกิจสำเร็จแล้ว", //恭喜，完成活任务
      LanguageConfigKeys.Shop_activity_get: "รับ", //领取
      LanguageConfigKeys.Shop_activity_received: "ได้รับแล้ว", //已领取
      LanguageConfigKeys.Shop_activity_expired: "หมดอายุ", //已过期
      LanguageConfigKeys.Shop_activity_lottery_draw: "จับฉลาก", //抽奖
      LanguageConfigKeys.Shop_activity_get_prize: "รับรางวัล", //领奖
      LanguageConfigKeys.Shop_activity_get_prize_stop:
          "สิ้นสุดการรับรางวัล", //领奖截止
      LanguageConfigKeys.Shop_activity_available: "สามารถรับได้", //可领取
      LanguageConfigKeys.Shop_activity_item_level_prize:
          "ชิ้น รางวัลด่าน", //件关卡奖励
      LanguageConfigKeys.Shop_activity_item_top_prize:
          "ชิ้น รางวัลอันดับ", //件排名奖励
      LanguageConfigKeys.Shop_activity_item_task_prize:
          "ชิ้น รางวัลภารกิจ", //件任务奖励
      LanguageConfigKeys.Shop_activity_no_prize_available:
          "ไม่มีรางวัลที่คุณสามารถรับได้", //暂无可领取奖励
      LanguageConfigKeys.Shop_activity_please_select_prize:
          "กรุณาเลือกรางวัล", //请选择奖励
      LanguageConfigKeys.Shop_activity_history_activities:
          "ประวัติกิจกรรม", //历史活动
      LanguageConfigKeys.Shop_activity_history_tasks: "ประวัติภารกิจ", //历史任务
      LanguageConfigKeys.Shop_activity_draw_now: "จับฉลากทันที", //立即抽奖
      LanguageConfigKeys.Shop_activity_continue_draw: "จับฉลากต่อ", //继续抽奖
      LanguageConfigKeys.Shop_activity_total_mxget:
          "ยอดรวม MXGET ของกิจกรรมนี้", //本次活动共计淘金
      LanguageConfigKeys.Shop_activity_mxget_detail: "รายละเอียด MXGET", //淘金明细
      LanguageConfigKeys.Shop_activity_view_details: "ดูรายละเอียด", //查看明细
      LanguageConfigKeys.Shop_activity_activity_achievements:
          "ความสำเร็จของกิจกรรม", //活动成就
      LanguageConfigKeys.Shop_activity_level_draw_now_tip:
          "สามารถจับฉลากได้หลังจากสรุปผลของกิจกรรมเสร็จสิ้น ขอให้โชคดี", //活动统计完成后可抽奖，祝您好运
      LanguageConfigKeys.Shop_activity_top_rewards_tip:
          "กิจกรรมสิ้นสุดลงและได้รับการจัดอันดับกิจกรรม สรุปผลสิ้นสุดจึงจะสามารถรับรางวัลได้", //活动结束并获得活动排名，统计结束可领奖
      LanguageConfigKeys.Shop_activity_statistics_completed:
          "สรุปผลเสร็จสิ้น", //距离统计完成
      LanguageConfigKeys.Shop_activity_countdown_drawing_receiving_prize:
          "นับถอยหลังสู่การจับ/รับรางวัล", //抽/领奖倒计时
      LanguageConfigKeys.Shop_activity_no_level_reward_tip:
          "ไม่ได้รับรางวัลด่าน พยายามต่อไป", //未获得关卡奖励，再接再厉
      LanguageConfigKeys.Shop_activity_no_rank_reward_tip:
          "ไม่ติดอันดับ พยายามต่อไป", //排名未入围，再接再厉
      LanguageConfigKeys.Shop_activity_success_get_level_reward_tip:
          "ยินดีด้วย คุณได้รับรางวัลด่าน", //恭喜获取关卡奖
      LanguageConfigKeys.Shop_activity_success_get_rank_reward_tip:
          "ยินดีด้วย คุณได้รับรางวัลอันดับ", //恭喜获取排名奖
      LanguageConfigKeys.Shop_activity_no_prizes_level:
          "ด่านนี้ไม่มีรางวัล", //该关卡没有奖品
      LanguageConfigKeys.Shop_activity_lottery_complete: "เสร็จสิ้น", //完成
      LanguageConfigKeys.Shop_activity_lottery_tip1:
          "คลิกที่ปุ่ม“จับฉลากทันที“ เพื่อเริ่มการจับฉลาก", //点击“立即抽奖”按钮开始抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip2:
          "มีโอกาสจับฉลากเพียง 1 ครั้งต่อด่านเท่านั้น ลำดับการจับฉลากตามลำดับการทำสำเร็จ", //每关仅有1次抽奖机会，按顺序完成抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip3:
          "สินค้าบางชิ้นมีค่าใช้จ่ายส่วนต่างเพิ่มเติม", //部分商品需要支付差额
      LanguageConfigKeys.Shop_activity_lottery_tip4:
          "อำนาจการตัดสินขั้นสุดท้ายของกิจกรรมนี้เป็นของแพลตฟอร์ม", //本活动最终解释权归平台所有
      LanguageConfigKeys.Shop_activity_click_challenge:
          "เริ่มต้นความท้าทายเพียงคลิกครั้งเดียว", //点击即可开始挑战
      LanguageConfigKeys.Shop_activity_challenge_failed_profit:
          "ถึงแม้จะท้าทายล้มเหลวก็ยังคงคำนวณส่วนแบ่งกำไรอยู่", //挑战失败，仍可计算成交分润
      LanguageConfigKeys.Shop_activity_abandoning: "สละสิทธิ์", //放弃活动
      LanguageConfigKeys.Shop_activity_rules: "กฎกิจกรรม", //活动规则
      LanguageConfigKeys.Shop_activity_complete_level_lock_new_level:
          "เมื่อด่านนี้เสร็จสมบูรณ์จึงจะสามารถปลดล็อคด่านใหม่ได้", //完成本关，即可解锁新关
      LanguageConfigKeys.Shop_activity_ranking_information:
          "แสดงข้อมูลการจัดอันดับหลังจากเข้าร่วม", //参与后展示排名信息
      LanguageConfigKeys.Shop_activity_rule_tip1:
          "ปิดการขายให้ได้ 1 รายการต่อด่านจึงจะสามารถปลดล็อกด่านใหม่ได้", //每关任意成交1单，即可解锁新关卡
      LanguageConfigKeys.Shop_activity_rule_tip2:
          "ท้าทายด่านสำเร็จ รับรางวัลด่านบนแท่นรับรางวัลได้", //关卡挑战成功，在领奖台抽取关卡奖
      LanguageConfigKeys.Shop_activity_rule_tip3:
          "ท้าทายกิจกรรมสำเร็จ รับรางวัลอันดับตามการจัดอันดับ", //活动挑战成功，根据排名获得排名奖
      LanguageConfigKeys.Shop_activity_rule_tip4:
          "ยิ่งคำสั่งซื้อสำเร็จมากเท่าไร ก็ยิ่งเสร็จสิ้นได้เร็วขึ้นและอันดับยิ่งสูงขึ้นเท่านั้น", //成交越多，完成速度越快，排名越高
      LanguageConfigKeys.Shop_activity_abandoning_tip:
          "ในระหว่างกิจกรรมห้ามเข้าร่วมซ้ำในกิจกรรมนี้อีก\nสินค้าที่ขายไปแล้วจะถูกแบ่งกำไรหลังจากสรุปผล", //活动期间不得再次参与本次活动\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_success_participated:
          "เข้าร่วมแล้ว", //参与成功
      LanguageConfigKeys.Shop_activity_success_participated_tip1:
          "ยินดีด้วย! เข้าร่วมกิจกรรมสำเร็จ", //恭喜，成功参与淘金活动
      LanguageConfigKeys.Shop_activity_success_participated_tip2:
          "พยายามฝ่าด่านเข้านะ คุณจะได้รับส่วนแบ่งและของรางวัลมากมาย", //努力闯关，获得属于你的丰厚利润与奖品
      LanguageConfigKeys.Shop_activity_confirm_abandonment:
          "ยืนยันสละสิทธิ์", //确定放弃
      LanguageConfigKeys.Shop_activity_arbitrary_deal:
          "ปิดการขาย 1 รายการ", //任意成交1单
      LanguageConfigKeys.Shop_activity_deal: "ปิดการขาย", //成交
      LanguageConfigKeys.Shop_activity_one_step_success:
          "ก้าวสู่ความสำเร็จ", //距成功一步之遥
      LanguageConfigKeys.Shop_activity_continue_recommend:
          "ก่อนที่กิจกรรมจะสิ้นสุดลง ยังสามารถแนะนำต่อไปได้", //活动结束前，可以继续推荐
      LanguageConfigKeys.Shop_activity_wait_statistics_completed:
          "ยินดีด้วย! รอสรุปผล โปรดอดใจรอ", //恭喜，请耐心等待统计完成
      LanguageConfigKeys.Shop_activity_congratulations_get_prize:
          "ยินดีด้วย คุณทำสำเร็จ คลิกเพื่อรับรางวัล", //恭喜完成，点击领奖
      LanguageConfigKeys.Shop_activity_successfully_crossed:
          "ฝ่าด่านได้สำเร็จ", //闯关成功
      LanguageConfigKeys.Shop_activity_successfully_crossed_tip:
          "ยินดีด้วย คุณฝ่าด่านสำเร็จ การเริ่มต้นที่ดีเท่ากับว่ามาได้ครึ่งทางแล้ว! \nในระหว่างกิจกรรมคุณสามารถเลือกด่านที่ปลดล็อคแล้วเพื่อแนะนำต่อได้", //恭喜，闯关成功，好的开始是成功的一半！\n活动期间，您可选择任意已解锁关卡继续推荐
      LanguageConfigKeys.Shop_activity_enter_next_level:
          "ไปยังด่านถัดไป", //进入下一关
      LanguageConfigKeys.Shop_activity_all_level_success: "ผ่านด่านแล้ว", //恭喜通关
      LanguageConfigKeys.Shop_activity_all_level_success_tip:
          "ยินดีด้วย! คุณผ่านด่านทั้งหมดแล้ว\nขณะนี้ยังมีเวลา แนะนำต่อเพื่อไต่อันดับกันเถอะ", //恭喜您顺利完成所有活动关卡\n当前仍有时间，继续推荐冲刺排名大奖
      LanguageConfigKeys.Shop_activity_all_level_success_tip2:
          "ยินดีด้วย! คุณผ่านด่านทั้งหมดแล้ว", //恭喜您顺利完成所有活动关卡
      LanguageConfigKeys.Shop_activity_obsolete: "ตกรอบ", //已淘汰
      LanguageConfigKeys.Shop_activity_obsolete_tip:
          "ความล้มเหลวเป็นบทเรียนของความสำเร็จ คุณสามารถเริ่มต้นท้าทายได้อีกครั้ง! \nสินค้าที่ขายไปแล้วจะถูกแบ่งกำไรหลังจากสรุปผล", //失败乃成功之母，您可以再次发起挑战！\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_homepage: "กลับหน้าหลัก", //返回首页
      LanguageConfigKeys.Shop_activity_remaining_collection_time:
          "เหลือเวลารับได้อีก", //截止领奖时间
      LanguageConfigKeys.Shop_activity_waiting_statistics: "รอสรุปผล", //等待统计完成
      LanguageConfigKeys.Shop_activity_get_prize_finish:
          "สิ้นสุดระยะเวลารับรางวัล", //领奖时间已结束
      LanguageConfigKeys.Shop_activity_selected: "ได้รางวัลแล้ว", //已抽中
      LanguageConfigKeys.Shop_activity_total_prizes: "รางวัลทั้งหมด", //奖品总计
      LanguageConfigKeys.Shop_activity_after_receiving_check_order:
          "หลังจากรับรางวัลแล้วสามารถดูได้ในคำสั่งซื้อ", //领奖后请在订单查看
      LanguageConfigKeys.Shop_activity_no_lottery: "ไม่จับฉลาก", //未抽奖
      LanguageConfigKeys.Shop_activity_not_counted: "ไม่คำนวณ", //未统计
      LanguageConfigKeys.Shop_activity_mxget_activity: "กิจกรรม", //淘金活动
      LanguageConfigKeys.Shop_activity_48_hours:
          "เหลือเวลาอีกไม่ถึง 48 ชั่วโมง", //距活动结束不足48小时
      LanguageConfigKeys.Shop_activity_soon_timeout:
          "เมื่อรับกิจกรรมแล้ว รีบทำให้สำเร็จนะ ", //接受活动后请尽快完成
      LanguageConfigKeys.Shop_pocket: "กระเป๋า", //口袋
      LanguageConfigKeys.Shop_pocket_task: "ภารกิจ", //任务
      LanguageConfigKeys.Shop_pocket_late_task_over:
          "มาช้าไปนิดเดียว ภารกิจจบแล้ว", //来晚了，任务已结束
      LanguageConfigKeys.Shop_pocket_select_product: "เลือกสินค้า", //选择商品
      LanguageConfigKeys.Shop_pocket_task_over: "ภารกิจสิ้นสุดลงแล้ว", //任务已结束
      LanguageConfigKeys.Shop_pocket_completed_profit:
          "เสร็จสิ้นการแบ่งกำไร", //完成分润
      LanguageConfigKeys.Shop_pocket_obsolete: "ตกรอบ", //已淘汰
      LanguageConfigKeys.Shop_pocket_share_profit: "แบ่งกำไร", //分润
      LanguageConfigKeys.Shop_pocket_profit: "กำไร", //利润
      LanguageConfigKeys.Shop_pocket_task_stock: "คลังภารกิจ", //任务库存
      LanguageConfigKeys.Shop_pocket_task_start_time:
          "เวลาเริ่มภารกิจ", //任务开始时间
      LanguageConfigKeys.Shop_pocket_level: "เลเวลกระเป๋า", //口袋
      LanguageConfigKeys.Shop_pocket_more_orders_to_level:
          "เลื่อนเป็น %s ได้ต้องปิดการขายให้ได้อีก %s รายการจึงจะสำเร็จ", //距%s还需要完成%s单
      LanguageConfigKeys.Shop_pocket_detail: "รายละเอียดกระเป๋า", //口袋详情
      LanguageConfigKeys.Shop_pocket_see_rules: "ดูกฎระเบียบ", //查看规则
      LanguageConfigKeys.Shop_pocket_activity_rules: "กฎกิจกรรม", //活动规则
      LanguageConfigKeys.Shop_pocket_mine_pocket: "กระเป๋าของฉัน", //我的口袋
      LanguageConfigKeys.Shop_pocket_task_volume: "ความจุของงาน", //任务容量
      LanguageConfigKeys.Shop_pocket_activity_volume: "ความจุกิจกรรม", //活动容量
      LanguageConfigKeys.Shop_pocket_pocket_upgrade: "อัพเกรดกระเป๋า", //口袋升级
      LanguageConfigKeys.Shop_pocket_accept_share_profit:
          "แบ่งกำไรสูงสุด", //最大分润
      LanguageConfigKeys.Shop_pocket_mine_income: "รายได้ของฉัน", //我的收益
      LanguageConfigKeys.Shop_pocket_history_income: "ประวัติรายได้", //历史收益
      LanguageConfigKeys.Shop_pocket_this_month_income: "รายได้เดือนนี้", //本月收益
      LanguageConfigKeys.Shop_pocket_today_income: "รายได้วันนี้", //今日收益
      LanguageConfigKeys.Shop_pocket_like: "สิ่งที่ฉันถูกใจ", //点赞
      LanguageConfigKeys.Shop_pocket_like_empty_tip:
          "กดถูกใจสินค้า\nเราจะแนะนำสินค้าและภารกิจที่ตรงกับความชอบของคุณ", //点赞心仪的商品\n我们将根据您的喜好进行商品及任务推荐
      LanguageConfigKeys.Shop_pocket_go_stroll: "เริ่มช้อปปิ้ง", //去逛逛
      LanguageConfigKeys.Shop_pocket_tasking: "กำลังดำเนินการ", //正在进行
      LanguageConfigKeys.Shop_pocket_mxget_history: "ประวัติMXGET", //淘金历史
      LanguageConfigKeys.Shop_pocket_task_completion_degree:
          "เสร็จสิ้น %s", //完成%s
      LanguageConfigKeys.Shop_pocket_days: "วัน", //天
      LanguageConfigKeys.Shop_pocket_hours: "ชม.", //更多精彩活动,敬请期待
      LanguageConfigKeys.Shop_pocket_copy_link: "คัดลอกลิงก์", //复制链接
      LanguageConfigKeys.Shop_pocket_add: "เพิ่ม", //添加
      LanguageConfigKeys.Shop_pocket_incomplete: "ยังไม่เสร็จสิ้น", //未完成
      LanguageConfigKeys.Shop_pocket_completed: "เสร็จสิ้นแล้ว", //已完成
      LanguageConfigKeys.Shop_pocket_time: "เวลาภารกิจ", //任务时间
      LanguageConfigKeys.Shop_pocket_lock_stock: "ล็อคสต็อก", //锁定库存
      LanguageConfigKeys.Shop_pocket_maximum_profit_sharing:
          "ส่วนแบ่งกำไรสูงสุด", //最大分润
      LanguageConfigKeys.Shop_pocket_piece: "ชิ้น", //件
      LanguageConfigKeys.Shop_pocket_accept_task: "รับภารกิจ", //接受任务
      LanguageConfigKeys.Shop_pocket_space: "พื้นที่ว่างในกระเป๋า", //口袋空间
      LanguageConfigKeys.Shop_pocket_order_received_success:
          "ยินดีด้วย คุณรับคำสั่งซื้อสำเร็จ", //恭喜，接单成功
      LanguageConfigKeys.Shop_pocket_order_receiving_failed:
          "เสียใจด้วย คุณรับคำสั่งซื้อล้มเหลว", //抱歉，接单失败
      LanguageConfigKeys.Shop_pocket_rule_title: "กฎการรับคำสั่งซื้อ", //接单规则
      LanguageConfigKeys.Shop_pocket_rule_tip1:
          "ร้านค้าทุกแบรนด์เป็นแบบจัดการด้วยตนเอง ",
      LanguageConfigKeys.Shop_pocket_rule_tip2:
          "เป็น MXWINNER ได้โดยไม่ต้องลงทุนใดๆ ",
      LanguageConfigKeys.Shop_pocket_rule_tip3:
          "ผู้ใช้สามารถแนะนำสินค้าให้เพื่อนได้  ",
      LanguageConfigKeys.Shop_pocket_rule_tip4: "เมื่อเพื่อนได้รับสินค้า ",
      LanguageConfigKeys.Shop_pocket_rule_tip5: "ยิ่งแนะนำมากยิ่งได้เงินมาก ",
      LanguageConfigKeys.Shop_pocket_rule_tip6:
          "ความจุกระเป๋าภารกิจของ MXWINNER ขึ้นอยู่กับเลเวลของกระเป๋า ",
      LanguageConfigKeys.Shop_pocket_rule_tip7:
          "เมื่อภารกิจหรือกิจกรรมครบกำหนด ",
      LanguageConfigKeys.Shop_pocket_rule_tip8: "หากผู้ใช้ต้องการถอนเงินออก ",
      LanguageConfigKeys.Shop_pocket_rule_tip9:
          "ไม่สามารถละเมิดข้อบังคับในการคลิกฟาร์มได้ ",
      LanguageConfigKeys.Shop_pocket_rule_tip10: "ผู้ใช้จะต้องเคารพกฎหมาย ",
      LanguageConfigKeys.Shop_pocket_rule_value_tip1:
          "สินค้าแท้ 100% และมีการรับรองหลังการขายโดย MXCOME",
      LanguageConfigKeys.Shop_pocket_rule_value_tip2:
          "ใช้เพียงแค่โทรศัพท์มือถือเครื่องเดียว",
      LanguageConfigKeys.Shop_pocket_rule_value_tip3:
          "หากปิดการขายได้ ท่านจะได้รับรายได้",
      LanguageConfigKeys.Shop_pocket_rule_value_tip4:
          "รายได้จะถูกโอนไปยังบัญชีของท่านโดยอัตโนมัติและถอนได้ทันที",
      LanguageConfigKeys.Shop_pocket_rule_value_tip5:
          "เมื่อเลเวลกระเป๋าสูงขึ้นก็จะสามารถรับภารกิจได้มากยิ่งขึ้นด้วย",
      LanguageConfigKeys.Shop_pocket_rule_value_tip6:
          "ยิ่งเลเวลสูงยิ่งรับได้เยอะ",
      LanguageConfigKeys.Shop_pocket_rule_value_tip7:
          "ภารกิจของ MXWINNER จะสิ้นสุดทันที",
      LanguageConfigKeys.Shop_pocket_rule_value_tip8:
          "จะต้องผ่านการยืนยันตัวตนและผูกบัตรธนาคารก่อน",
      LanguageConfigKeys.Shop_pocket_rule_value_tip9:
          "หากพิจารณาว่ามีการละเมิด ระบบจะระงับการรับคำสั่งซื้อชั่วคราว",
      LanguageConfigKeys.Shop_pocket_rule_value_tip10:
          "และชำระภาษีตามกฎหมายกำหนด",
      LanguageConfigKeys.Shop_pocket_simple_level: "เลเวล", //等级
      LanguageConfigKeys.Shop_pocket_simple_capacity: "ความจุ", //容量
      LanguageConfigKeys.Shop_pocket_simple_foul: "ละเมิดกฎ ", //违规
      LanguageConfigKeys.Shop_pocket_success_tips1:
          "อยากเพิ่มรายได้อย่างรวดเร็ว ติดตาม วิทยาลัย MXCOME เลย", //想快速提高收益，立即关注淘金学院
      LanguageConfigKeys.Shop_pocket_success_tips2:
          "โปรดทำภารกิจให้เสร็จภายใน 48 ชั่วโมง หลังจากนั้นจะปิดรับทันที", //请在48小时内完成该任务，超时关闭
      LanguageConfigKeys.Shop_pocket_success_tips3:
          "การรับคำสั่งซื้อตามความจุของกระเป๋าภารกิจ รองรับการสับเปลี่ยนภารกิจ", //接单将占用一个任务容量，支持更换
      LanguageConfigKeys.Shop_pocket_failed_level_tips:
          "กรุณาทำภารกิจที่มีอยู่ให้สำเร็จก่อน ไม่สามารถรับรายการซ้ำได้", //请继续完成现有任务，不可重复接单
      LanguageConfigKeys.Shop_pocket_failed_capacity_tips:
          "กรุณาอัพเกรดเลเวลกระเป๋าให้มีสิทธิ์รับรายการได้", //请提升任务口袋等级，达到接单资格
      LanguageConfigKeys.Shop_pocket_failed_foul_tips:
          "เมื่อระยะเวลาแบนสิ้นสุด จะสามารถกลับมารับรายการได้โดยอัตโนมัติ", //违规封禁时间结束后，自动恢复接单
      LanguageConfigKeys.Shop_pocket_view_pockets: "ดูกระเป๋า", //查看口袋
      LanguageConfigKeys.Shop_pocket_select_a_task:
          "กรุณาเลือก 1 ภารกิจ", //请选择一个任务
      LanguageConfigKeys.Shop_pocket_task_stock_insufficient:
          "สินค้าคงคลังของภารกิจไม่เพียงพอ", //任务库存不足
      LanguageConfigKeys.Shop_pocket_total_pieces: "จำนวน %s ชิ้น", //共计%s件
      LanguageConfigKeys.Shop_pocket_complete_orders:
          "เสร็จสิ้น 10 รายการ", //完成10单
      LanguageConfigKeys.Shop_pocket_task_prize: "รางวัลภารกิจ", //任务奖品
      LanguageConfigKeys.Shop_pocket_tip: "แจ้งเตือน", //友情提示
      LanguageConfigKeys.Shop_pocket_48_hours:
          "สิ้นสุดภารกิจในอีกไม่ถึง 48 ชั่วโมง", //距任务结束不足48小时
      LanguageConfigKeys.Shop_pocket_task_soon_timeout:
          "หลังจากได้รับภารกิจแล้ว รีบทำภารกิจให้เสร็จโดยเร็วที่สุด", //接受任务后请尽快完成
      LanguageConfigKeys.Shop_pocket_task_end_time: "เวลาสิ้นสุดภารกิจ", //任务截止
      LanguageConfigKeys.Shop_pocket_goods_sold: "ขายแล้ว", //商品已售
      LanguageConfigKeys.Shop_pocket_goods_stock: "คลังสินค้า", //商品库存
      LanguageConfigKeys.Shop_pocket_task_detail: "รายละเอียดภารกิจ", //任务详情
      LanguageConfigKeys.Shop_pocket_rule_policy: "กฎระเบียบ", //规则策略
      LanguageConfigKeys.Shop_pocket_number_to_be_completed:
          "จำนวนรายการที่สามารถทำได้", //完成单量
      LanguageConfigKeys.Shop_pocket_task_profit_sharing:
          "ส่วนแบ่งกำไรที่สามารถรับได้", //可接分润
      LanguageConfigKeys.Shop_pocket_upgrade: "หลังจากอัพเกรด", //升级后
      LanguageConfigKeys.Shop_pocket_current_level: "เลเวลตอนนี้", //当前等级
      LanguageConfigKeys.Shop_pocket_current_level_tip:
          "สินค้าภารกิจทั้งหมดสามารถรับส่วนแบ่งกำไรได้≤%s", //可接分润≤%s的所有任务商品
      LanguageConfigKeys.Shop_pocket_doing: "กำลังดำเนินการ", //进行中
      LanguageConfigKeys.Shop_pocket_counted: "รอสรุปผล", //待统计
      LanguageConfigKeys.Shop_pocket_challenge_now: "ท้าทายทันที", //立即挑战
      LanguageConfigKeys.Shop_pocket_continue_to_challenge:
          "ท้าทายต่อไป", //继续挑战
      LanguageConfigKeys.Shop_pocket_join_now: "เข้าร่วมทันที", //立即参与
      LanguageConfigKeys.Shop_pocket_participated: "เข้าร่วมแล้ว", //已参与
      LanguageConfigKeys.Shop_pocket_task_completed: "ปิดการขายแล้ว", //已成交
      LanguageConfigKeys.Shop_pocket_conversion_rate:
          "อัตราการเปรียบเทียบ", //转化率
      LanguageConfigKeys.Shop_pocket_remain: "เหลือเวลาอีก", //还剩
      LanguageConfigKeys.Shop_pocket_counted_shop: "สิ้นสุดการสรุปผล", //统计完成
      LanguageConfigKeys.Shop_pocket_completed_counted:
          "สรุปผลเสร็จสิ้น", //已完成统计
      LanguageConfigKeys.Shop_pocket_task_counted_tip:
          "1.สรุปผลหลังจากภารกิจสิ้นสุดเป็นระยะเวลา %s วัน\n2.เมื่อสรุปผลเสร็จสิ้น ยอดเงินจะเข้ากระเป๋าเงิน สามารถถอนเงินได้ หากมีการยกเลิกคำสั่งซื้อ รายได้จะถูกยกเลิก", //任务结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_activity_counted_tip:
          "1.สรุปผลหลังจากกิจกรรมสิ้นสุดเป็นระยะเวลา %s วัน\n2.เมื่อสรุปผลเสร็จสิ้น ยอดเงินจะเข้ากระเป๋าเงิน สามารถถอนเงินได้ หากมีการยกเลิกคำสั่งซื้อ รายได้จะถูกยกเลิก", //活动结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_task_finish: "เสร็จสิ้นแล้ว", //已完结
      LanguageConfigKeys.Shop_pocket_get_now: "รับทันที", //立即领取
      LanguageConfigKeys.Shop_pocket_upcoming_profits:
          "ส่วนแบ่งกำไรที่จะได้รับ", //即将分润
      LanguageConfigKeys.Shop_pocket_upcoming_award: "รางวัลที่จะได้รับ", //即将派奖
      LanguageConfigKeys.Shop_pocket_recommend_now: "แนะนำทันที", //立即推荐
      LanguageConfigKeys.Shop_pocket_buyer: "ผู้ซื้อ", //购买者
      LanguageConfigKeys.Shop_pocket_purchase_record: "บันทึกการซื้อขาย", //成交记录
      LanguageConfigKeys.Shop_pocket_purchase_users: "ผู้ใช้", //用户
      LanguageConfigKeys.Shop_pocket_purchase_time: "เวลาซื้อ", //购买时间
      LanguageConfigKeys.Shop_pocket_purchase_quantity: "จำนวน", //数量
      LanguageConfigKeys.Shop_pocket_chargeback_record:
          "ประวัติการยกเลิก", //退单记录
      LanguageConfigKeys.Shop_pocket_chargeback_time: "เวลาที่ยกเลิก", //退单时间
      LanguageConfigKeys.Shop_pocket_total_purchase:
          "กำไรจากการซื้อขายทั้งหมด", //总成交收益
      LanguageConfigKeys.Shop_pocket_total_chargeback:
          "รายได้จากการคืนเงินรวม", //总退单收益
      LanguageConfigKeys.Shop_pocket_sold_out: "หมดแล้ว", //已售罄
      LanguageConfigKeys.Shop_pocket_prize: "ของรางวัล", //奖品
      LanguageConfigKeys.Shop_pocket_promotion_center: "แชร์เซ็นเตอร์", //推广中心
      LanguageConfigKeys.Shop_pocket_promotion_qualification:
          "คุณสมบัติการแนะนำ", //推广资格
      LanguageConfigKeys.Shop_pocket_red_level: "ฝ่าด่านพิชิตอั่งเปา", //红包闯关
      LanguageConfigKeys.Shop_pocket_not_active: "ปิดใช้งาน", //未激活
      LanguageConfigKeys.Shop_pocket_activated: "เปิดใช้งาน", //已激活
      LanguageConfigKeys.Shop_pocket_not_red_level:
          "ยังไม่ได้รับคุณสมบัติฝ่าด่านพิชิตอั่งเปา", //未获得红包闯关资格
      LanguageConfigKeys.Shop_pocket_earned: "ได้รับแล้ว", //已赚到
      LanguageConfigKeys.Shop_pocket_period_validity: "วันหมดอายุ", //有效期
      LanguageConfigKeys.Shop_pocket_complete_task_tip:
          "โปรดทำภารกิจให้สำเร็จภายในระยะเวลา", //请于有效期内完成任意任务
      LanguageConfigKeys.Shop_pocket_mxget_task: "ภารกิจMXGET", //淘金任务
      LanguageConfigKeys.Shop_pocket_change_task: "สับเปลี่ยนภารกิจ", //更换任务
      LanguageConfigKeys.Shop_pocket_current_task: "ภารกิจขณะนี้", //当前任务
      LanguageConfigKeys.Shop_pocket_this_week: "สัปดาห์นี้", //本周
      LanguageConfigKeys.Shop_pocket_this_month: "เดือนนี้", //本月
      LanguageConfigKeys.Shop_pocket_last_month: "เดือนที่แล้ว", //上月
      LanguageConfigKeys.Shop_pocket_enable_prize: "สามารถรับรางวัลได้", //可领奖
      LanguageConfigKeys.Shop_pocket_winning_task_prize:
          "ได้รับรางวัลภารกิจ", //获得任务奖品
      LanguageConfigKeys.Shop_pocket_winning_task_prize_tip:
          "เมื่อรับรางวัลแล้ว สามารถตรวจสอบสถานะการจัดส่งได้ในคำสั่งซื้อ", //领奖后，可在订单中查看发货状态
      LanguageConfigKeys.Shop_pocket_change_record:
          "ประวัติการสับเปลี่ยน", //更换记录
      LanguageConfigKeys.Shop_pocket_sale: "ขาย", //销售
      LanguageConfigKeys.Shop_pocket_prize_price: "ราคาของรางวัล", //奖品价
      LanguageConfigKeys.Shop_bank_card: "บัญชีธนาคาร", //银行账户
      LanguageConfigKeys.Shop_bank_add_card: "เพิ่มบัญชีธนาคาร", //添加银行账户
      LanguageConfigKeys.Shop_bank_edit_card: "เพิ่มบัญชีธนาคาร", //修改银行账户
      LanguageConfigKeys.Shop_bank_id_card_user: "ผู้ใช้บัตรประชาชน", //身份证用户
      LanguageConfigKeys.Shop_bank_passport_user: "ผู้ใช้หนังสือเดินทาง", //护照用户
      LanguageConfigKeys.Shop_bank_only_en_th:
          "รองรับเฉพาะภาษาไทยและภาษาอังกฤษเท่านั้น", //仅支持英文及泰文
      LanguageConfigKeys.Shop_bank_add_card_tip1:
          "สำหรับผู้ใช้บัตรประชาชน ชื่อของบัญชีธนาคารจะต้องตรงกับชื่อที่ใช้ยืนยันตัวตน", //身份证用户，账户姓名必须与实名认证姓名保持一致
      LanguageConfigKeys.Shop_bank_add_card_tip2:
          "สำหรับผู้ใช้หนังสือเดินทาง จะต้องเป็นเจ้าของบัญชีธนาคารในประเทศไทย คุณสามารถเปลี่ยนชื่อได้หากมีความจำเป็น", //护照用户，必须是泰国银行账户持有人，如有必要可更改姓名
      LanguageConfigKeys.Shop_bank_add_card_tip3:
          "กรุณาตรวจสอบชื่อธนาคารและเลขบัญชีให้ถูกต้อง มิเช่นนั้นจะไม่สามารถถอนเงินได้", //请正确输入银行名称及银行帐号，否则将提现失败
      LanguageConfigKeys.Shop_bank_bank_name: "ชื่อธนาคาร", //银行名称
      LanguageConfigKeys.Shop_bank_card_number: "หมายเลขบัญชีธนาคาร", //银行账号
      LanguageConfigKeys.Shop_bank_next_step: "ต่อไป", //下一步
      LanguageConfigKeys.Shop_bank_unkown_open_bank:
          "ไม่รู้จักธนาคารดังกล่าว", //未知银行
      LanguageConfigKeys.Shop_bank_delete_card:
          "ยืนยันลบบัตรธนาคารหรือไม่", //是否删除银行卡?
      LanguageConfigKeys.Shop_bank_card_already_exist:
          "บัญชีธนาคารนี้ได้ผูกไว้กับบัญชีอื่นแล้ว กรุณาเปลี่ยนบัญชีธนาคารที่ต้องการผูกใหม่!", //该银行账号已被其他账号绑定，请更换绑定银行账号！
      LanguageConfigKeys.Shop_wallet_mxcome: "รับรองโดย MXCOME", //MXCOME安全保障中
      LanguageConfigKeys.Shop_wallet_mxget_income: "รายได้", //动态收益
      LanguageConfigKeys.Shop_wallet_transferred_balance: "ยอดโอน", //转入余额
      LanguageConfigKeys.Shop_wallet_chargeback: "ปฏิเสธการชำระเงิน", //退单
      LanguageConfigKeys.Shop_wallet_rebate: "รับโบนัส", //消费返利
      LanguageConfigKeys.Shop_wallet_daily_benefits:
          "สิทธิพิเศษประจำวัน", //消费返利
      LanguageConfigKeys.Shop_wallet_newcomer_join:
          "สิทธิพิเศษเมื่อลงทะเบียน", //注册福利
      LanguageConfigKeys.Shop_wallet_last_income: "ยอดล่าสุด", //最近一笔
      LanguageConfigKeys.Shop_wallet_income_detail: "รายละเอียดรายได้", //收益明细
      LanguageConfigKeys.Shop_wallet_pocket_money: "เงินติดกระเป๋า", //零花钱
      LanguageConfigKeys.Shop_wallet_now_apply: "ยื่นทันที", //立即申请
      LanguageConfigKeys.Shop_wallet_recharge: "เติมเงิน", //充值
      LanguageConfigKeys.Shop_wallet_withdrawal: "ถอน", //提现
      LanguageConfigKeys.Shop_wallet_withdrawal_finish: "ถอนเงินแล้ว", //已提现
      LanguageConfigKeys.Shop_wallet_withdrawal_fail: "(ถอนเงินล้มเหลว)", //提现失败
      LanguageConfigKeys.Shop_wallet_refund: "คืนเงิน", //退款
      LanguageConfigKeys.Shop_wallet_service_charges_fee:
          "ค่าธรรมเนียมการถอนเงิน", //提现手续费
      LanguageConfigKeys.Shop_wallet_service_fee:
          "ค่าธรรมเนียมการถอนเงิน", //手续费
      LanguageConfigKeys.Shop_wallet_fee_rate: "อัตรา", //费率
      LanguageConfigKeys.Shop_wallet_income: "รายได้", //收益
      LanguageConfigKeys.Shop_wallet_bank_card_bind: "ผูกบัตรธนาคาร", //已绑定银行卡
      LanguageConfigKeys.Shop_wallet_card_tip:
          "ค้นหาใบเสร็จ ถอนเงิน เติมเงิน", //查账单、提现、充值
      LanguageConfigKeys.Shop_wallet_withdrawal_tip:
          "ส่งคำขอถอนเงินเรียบร้อยแล้ว โปรดรอติดตามความคืบหน้า", //提现申请已提交成功，请耐心等待
      LanguageConfigKeys.Shop_wallet_withdrawal_amount_tip:
          "กรุณาใส่ยอดเงินที่ถูกต้อง", //请输入正确的金额
      LanguageConfigKeys.Shop_wallet_withdrawal_balance_tip:
          "ถอนเงินได้ไม่เกินจำนวนที่สามารถถอนได้", //提现金额不能超过可提现金额
      LanguageConfigKeys.Shop_wallet_today_withdrawal_balance_tip:
          "คุณถอนเงินเกินจำนวนที่สามารถถอนได้ในวันนี้แล้ว", //提现金额超过今日可提金额
      LanguageConfigKeys.Shop_wallet_withdrawal_time_tip:
          "เงินเข้าบัญชีภายใน 24 ชั่วโมง หากถอนเงินในช่วงวันหยุดนักขัตฤกษ์จะได้รับในวันทำการ", //提现打款周期为每周一次，每周五统一打款，如申请时间在打款时间之后，顺延到下个打款周期，请合理安排时间
      LanguageConfigKeys.Shop_wallet_cash_withdrawal_rules:
          "กฎการถอนเงิน", //提现规则
      LanguageConfigKeys.Shop_wallet_balance_detail:
          "รายละเอียดกระเป๋าเงิน", //资产明细
      LanguageConfigKeys.Shop_wallet_all: "ดูทั้งหมด", //查看所有
      LanguageConfigKeys.Shop_wallet_balance: "ยอดเงิน", //余额
      LanguageConfigKeys.Shop_wallet_task_profit_sharing:
          "ส่วนแบ่งภารกิจ", //任务分润
      LanguageConfigKeys.Shop_wallet_red_packet_withdrawal:
          "ถอนเงินอั่งเปา", //红包提现
      LanguageConfigKeys.Shop_wallet_mxget_profit: "ส่วนแบ่ง MXGET", //淘金分润
      LanguageConfigKeys.Shop_wallet_buy_goods: "ซื้อสินค้า", //购买商品
      LanguageConfigKeys.shop_wallet_expire_date: "วันหมดอายุของบัตร", //卡有效期
      LanguageConfigKeys.shop_wallet_change_name: "เปลี่ยนชื่อ", //更换姓名
      LanguageConfigKeys.shop_wallet_change_name_tip:
          "กรุณายืนยันความถูกต้อง หากบัญชีไม่ถูกต้องจะไม่สามารถถอนเงินได้", //请确认资料，账户错误将导致无法提现
      LanguageConfigKeys.Shop_search_everyone: "ทุกคนกำลังค้นหา", //大家都在搜
      LanguageConfigKeys.Shop_search_history: "ประวัติการค้นหา", //历史搜索
      LanguageConfigKeys.Shop_monday: "วันจันทร์", //周一
      LanguageConfigKeys.Shop_tuesday: "วันอังคาร", //周二
      LanguageConfigKeys.Shop_wednesday: "วันพุธ", //周三
      LanguageConfigKeys.Shop_thursday: "วันพฤหัสบดี", //周四
      LanguageConfigKeys.Shop_friday: "วันศุกร์", //周五
      LanguageConfigKeys.Shop_saturday: "วันเสาร์", //周六
      LanguageConfigKeys.Shop_sunday: "วันอาทิตย์", //周日
      LanguageConfigKeys.Shop_today: "วันนี้", //今天
      LanguageConfigKeys.Shop_notification: "ประกาศ", //通知
      LanguageConfigKeys.Shop_permission_denied: "ปฏิเสธ", //拒绝
      LanguageConfigKeys.Shop_permission_granted: "อนุญาต", //允许
      LanguageConfigKeys.Shop_permission_setting_cancel: "ยกเลิก", //取消
      LanguageConfigKeys.Shop_permission_setting_open: "ไปเปิด", //去打开
      LanguageConfigKeys.Shop_permission_camera_title:
          "“MXCOME” ต้องการเข้าถึงกล้องถ่ายรูปของคุณ", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_camera_content:
          "โปรดอนุญาตให้ MXCOME เข้าถึงกล้องของคุณสำหรับภาพโปรไฟล์ อัปโหลดภาพเอกสาร และฟังก์ชั่นอื่นๆ", //请允许MXCOME使用你的相机权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_camera_setting_title:
          "เปิดการเข้าถึงกล้อง", //开启相机权限
      LanguageConfigKeys.Shop_permission_camera_setting_content:
          "โปรดเปิดการเข้าถึงกล้องใน [ตั้งค่า - เปิดใช้งาน] หลังเปิดการเข้าถึงจึงจะสามารถใช้คุณสมบัติ เช่น ถ่ายรูป และฟังก์ชั่นอื่นๆ", //请在[设置-应用]中开启摄像头权限，开启后才可使用拍照等功能
      LanguageConfigKeys.Shop_permission_photos_title:
          "ขออนุญาตในการจัดเก็บ", //申请存储权限
      LanguageConfigKeys.Shop_permission_photos_content:
          "โปรดอนุญาตให้ MXCOME เข้าถึงการจัดเก็บสำหรับภาพโปรไฟล์ อัปโหลดภาพเอกสาร และฟังก์ชั่นอื่นๆ", //请允许MXCOME使用存储权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_photos_setting_title:
          "เปิดการเข้าถึงการจัดเก็บ", //开启存储权限
      LanguageConfigKeys.Shop_permission_photos_setting_content:
          "โปรดเปิดการเข้าถึงข้อมูลการจัดเก็บใน [ตั้งค่า - เปิดใช้งาน] หลังเปิดการเข้าถึงจึงจะสามารถใช้คุณสมบัติ เช่น ถ่ายรูป และฟังก์ชั่นอื่นๆ", //请在[设置-应用]中开启读写存储权限，开启后才可使用照片上传等功能
      LanguageConfigKeys.Shop_permission_location_title:
          "คำแนะนำในการเข้าถึงตำแหน่ง", //位置权限使用说明
      LanguageConfigKeys.Shop_permission_location_content:
          "MXCOME ต้องการที่จะเข้าถึงตำแหน่งของคุณ ที่อยู่จัดส่งที่ถูกต้องจะถูกระบุตามที่ตั้งของคุณ และคุณมีสิทธิ์ที่จะปฏิเสธหรือยกเลิกการอนุญาต ซึ่งจะไม่ส่งผลกระทบต่อการใช้บริการอื่นๆ ของคุณ", //MXCOME想访问您的地理位置，将根据您的地理位置提供准确的收货地址，您有权拒绝或取消授权，取消后不影响您使用其他服务
      LanguageConfigKeys.Shop_permission_location_setting_title:
          "เปิดการเข้าถึงตำแหน่ง", //开启位置权限
      LanguageConfigKeys.Shop_permission_location_setting_content:
          "โปรดเปิดการเข้าถึงตำแหน่งใน [ตั้งค่า - เปิดใช้งาน] หลังเปิดการเข้าถึงจึงจะสามารถเข้าถึง ตำแหน่งที่ตั้ง และฟังก์ชั่นอื่นๆ", //请在[设置-应用]中开启位置权限，开启后才可使用定位等功能
      LanguageConfigKeys.Shop_permission_scan_title:
          "“MXCOME” ต้องการเข้าถึงกล้องของคุณ", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_scan_content:
          "โปรดอนุญาตให้ MXCOME เข้าถึงกล้องของคุณสำหรับ การสแกนรหัสคิวอาร์โค้ด ระบุสินค้า และฟังก์ชั่นอื่นๆ", //请允许MXCOME获取你的相机，用于扫描二维码、识别商品等功能
      LanguageConfigKeys.Shop_permission_scan_setting_title:
          "เข้าถึงการเปิดกล้อง", //开相机权限
      LanguageConfigKeys.Shop_permission_scan_setting_content:
          "โปรดเปิดการเข้าถึงกล้องใน [ตั้งค่า - เปิดใช้งาน] หลังเปิดการเข้าถึงจึงจะสามารถเข้าถึง การแสกน และฟังก์ชั่นอื่นๆ", //请在[设置-应用]中开启相机权限，开启后才可使用扫描等功能
      LanguageConfigKeys.Shop_pocket_surplus_task:
          "เลเวลกระเป๋าขณะนี้สามารถรับได้อีก|ภารกิจ", //当前口袋等级还可领取%s个任务
      LanguageConfigKeys.Shop_pocket_view_task: "ดูภารกิจ", //查看任务
      LanguageConfigKeys.Shop_order_merge_cancel:
          "ยกเลิกคำสั่งซื้อพร้อมกันทั้งหมด", //以下订单需一起取消
      LanguageConfigKeys.Shop_order_merge_pay:
          "ชำระเงินพร้อมกันทั้งหมด", //以下订单需一起付款
      LanguageConfigKeys.Shop_order_cancel_back: "ย้อนกลับ", //返回
      LanguageConfigKeys.Shop_order_goods_limit:
          "ผู้ใช้แต่ละบัญชีสามารถซื้อได้ไม่เกิน | ชิ้น", //每个账号每次购买商品不能超过|个
      LanguageConfigKeys.Shop_product_red_pop_tip1:
          "กรุณาแนะนำและปิดการขายรายการแรกให้ได้ภายในวันดังกล่าว มิฉะนั้นจะสูญเสียคุณสมบัติฝ่าด่านพิชิตอั่งเปารอบนี้ไป", //请于%s天内完成首单推荐，否则此资格将永远丧失
      LanguageConfigKeys.Shop_product_red_pop_tip2:
          "เมื่อปิดการขายออร์เดอร์แรก จะขยายระยะเวลาคุณสมบัติทันที", //完成首单后，将自动获得有奖推广时间
      LanguageConfigKeys.Shop_product_obtaining_red_qualification:
          "ได้รับคุณสมบัติฝ่าด่านพิชิตอั่งเปา", //获得红包闯关资格
      LanguageConfigKeys.Shop_product_crossed_level_success_tip:
          "เยี่ยมไปเลย อั่งเปา %s ซองมาถึงมือคุณแล้ว ไปถอนออกมาได้เลย", //高手，%s红包已到手，欢迎随时提现
      LanguageConfigKeys.Shop_pocket_waiting_exciting_activities:
          "มีกิจกรรมสนุกๆ รออยู่อีกมากมาย อดใจรอกันหน่อยนะ", //更多精彩活动,敬请期待
      LanguageConfigKeys.Shop_pocket_change_task_tips1:
          "สามารถสับเปลี่ยนภารกิจในเลเวลเดียวกันได้", //支持更换口袋等级相对应的任务
      LanguageConfigKeys.Shop_pocket_change_task_tips2:
          "สามารถดูภารกิจที่สับเปลี่ยนและยังไม่หมดเวลาได้ในเมนู “ประวัติการสับเปลี่ยน”", //原任务结束前，可在“更换记录”中查看
      LanguageConfigKeys.Shop_mine_passing_levels: "กำลังฝ่าด่าน", //正在闯关
      LanguageConfigKeys.Shop_mine_direct_push_tips:
          "ยิ่งส่งเยอะ ยิ่งผ่านด่านเร็ว", //直推越多，闯关越快
      LanguageConfigKeys.Shop_mine_total_gains: "ยอดสะสมที่ได้รับ", //累计获得
      LanguageConfigKeys.Shop_mine_date_to: "ถึง", //至
      LanguageConfigKeys.Shop_pocket_super_wednesday:
          "Super Wednesday", //Super Wednesday
      LanguageConfigKeys.Shop_pocket_category_super_wednesday:
          "Super\nWednesday", //Super\nWednesday
      LanguageConfigKeys.Login_create_mine_link: "สร้างลิงก์ของตนเอง", //创建专属链接
      LanguageConfigKeys.Login_nickname_exists:
          "มีชื่อนี้อยู่แล้ว กรุณากรอกใหม่อีกครั้ง", //该名称已存在，请重新输入
      LanguageConfigKeys.Login_link_create_success:
          "สร้างลิงก์ของคุณสำเร็จแล้ว", //恭喜，您的专属链接已创建
      LanguageConfigKeys.Login_copy_link:
          "คัดลอกลิงก์และวางบน TikTok หรือช่องทางอื่นๆ ได้เลย", //复制链接，粘贴至TikTok等社交应用
      LanguageConfigKeys.Login_kol_name_hint:
          "ชื่อเล่นอย่างน้อย 1 ตัวอักษร", //昵称至少1位
      LanguageConfigKeys.Login_kol_name_tip:
          "ชื่อลิงก์ส่วนตัวรองรับเฉพาะภาษาอังกฤษและตัวเลข ไม่สามารถแก้ไขได้ภายหลัง เพื่อให้แฟนคลับจดจำได้ง่าย\nรูปโปรไฟล์และชื่อเล่นจะแสดงบนลิงก์ส่วนตัวและหน้าจัดอันดับ สามารถแก้ไขได้ในเมนูข้อมูลส่วนตัวบนแอปพลิเคชัน\nตัวอย่างลิงก์",
      LanguageConfigKeys.Login_input_kol_name:
          "กรุณาใส่ชื่อลิงก์ส่วนตัว", //请输入专属名称
      LanguageConfigKeys.Login_input_kol_share:
          "สร้างลิงก์ส่วนตัวของคุณเอง เพื่อให้ง่ายต่อการโปรโมท", //立即创建专属链接，便于推广
      LanguageConfigKeys.Login_input_kol_recommend:
          "โปรโมทลิงก์ส่วนตัวของคุณทันที", //快速推广您的专属链接
      LanguageConfigKeys.shop_mine_receive_discount: "รับสิทธิพิเศษ", //领取优惠
      LanguageConfigKeys.shop_mine_platform_coupon_tips:
          "MXCOME แพลตฟอร์ม Brand Self-Operation รับประกันของแท้ 100%", //MXCOME 品牌自营平台，100%正品保证
      LanguageConfigKeys.shop_mine_platform_coupon_hint:
          "คูปองแพลตฟอร์มนี้จะมีการแจกเป็นครั้งคราว", //平台优惠券将不定期发放
      LanguageConfigKeys.shop_mine_rebate_status_hint_1:
          "โปรดรอคำนวณ คนในทีมยิ่งสั่งซื้อมากยิ่งได้โบนัสมาก", //等待统计，下级购买越多返利越多
      LanguageConfigKeys.shop_mine_rebate_status_hint_2:
          "โปรดรอสรุปผล โดยจะไม่นำคำสั่งซื้อที่ยังไม่เสร็จสิ้นมาสรุปผล", //等待结算，订单未完成将不计算返利
      LanguageConfigKeys.shop_mine_rebate_status_hint_3:
          "สรุปผลเสร็จสิ้น ยอดโบนัสทั้งหมดโอนไปยัง", //结算完成，总返利已自动转入
      LanguageConfigKeys.shop_mine_rebate_status_hint_4:
          "ขาดอีก | คำสั่งซื้อ ถึงจะได้เลื่อนขั้น", //还差 | 单，即可升级
      LanguageConfigKeys.shop_mine_rebate_rules_1:
          "สรุปผลยอดคำสั่งซื้อทั้งหมดและคาดการณ์ผลกำไรในวันอาทิตย์", //第7天统计总单量及预期收益
      LanguageConfigKeys.shop_mine_rebate_rules_2:
          "หลังจากสรุปผลเสร็จสิ้น 7 วันจะคำนวณโบนัส โดยจะไม่รวมคำสั่งซื้อที่ยังไม่ได้ยืนยัน", //统计结束后第7天结算返利，超时确认的订单不再返利
      LanguageConfigKeys.shop_mine_rebate_rules_3:
          "เมื่อมียอดคำสั่งซื้อเพิ่มขึ้น จะได้รับโบนัสเพิ่มขึ้น หากซื้อด้วยตนเองจะสามารถอัปเกรดระดับโบนัสได้ แต่จะไม่ถูกคำนวณเป็นโบนัส", //增加单量可升级返利，本人购买支持升级，但不计算返利
      LanguageConfigKeys.shop_mine_rebate_current_order: "คำสั่งซื้อสัปดาห์นี้",
      LanguageConfigKeys.shop_mine_rebate_condition:
          "ทำถึง 8 รายการ จะได้รับโบนัสสูงสุด",
      LanguageConfigKeys.shop_mine_rebate_order: "รายการ",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate: "ทีมของฉัน",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate_nums: "จำนวนทั้งหมด",
      LanguageConfigKeys.shop_mine_rebate_bind_time: "วันและเวลาที่เข้าร่วม",
      LanguageConfigKeys.shop_mine_rebate_view_subordinate: "ดูทั้งหมด",
      LanguageConfigKeys.shop_mine_rebate_my_profits: "โบนัสของฉัน",
      LanguageConfigKeys.shop_mine_rebate_expect_total_rebate:
          "คาดการณ์ยอดโบนัสทั้งหมด",
      LanguageConfigKeys.shop_mine_rebate_total_rebate: "ยอดโบนัสทั้งหมด",
      LanguageConfigKeys.shop_mine_rebate_order_num: "จำนวนคำสั่งซื้อ",
      LanguageConfigKeys.shop_mine_rebate_to_be_counted: "รอคำนวณ",
      LanguageConfigKeys.shop_mine_rebate_already_counted: "คำนวณเสร็จสิ้น",
      LanguageConfigKeys.shop_mine_rebate_pending_settlement: "รอสรุปผล",
      LanguageConfigKeys.shop_mine_rebate_settled: "สรุปผลเสร็จสิ้น",
      LanguageConfigKeys.shop_mine_rebate_period_range: "สัปดาห์ที่ %s",
      LanguageConfigKeys.shop_mine_rebate_calculate_order: "คำนวณคำสั่งซื้อ",
      LanguageConfigKeys.shop_mine_rebate_settlement_order: "สรุปยอดโบนัส",
      LanguageConfigKeys.shop_mine_rebate_my_rebate: "โบนัส",
      LanguageConfigKeys.shop_mine_rebate_my_expect_rebate: "คาดการณ์ยอดโบนัส",
      LanguageConfigKeys.shop_mine_rebate_exclusive_qr_code:
          "คิวอาร์โค้ดของฉัน",
      LanguageConfigKeys.shop_mine_rebate_my_superior: "หัวหน้าทีมของฉัน",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips1:
          "เพื่อนของคุณแสกนเพื่อเข้าร่วมทีม",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips2:
          "คุณจะได้รับโบนัส เมื่อสมาชิกทีมของคุณซื้อสินค้าในช่วงกิจกรรม",
      LanguageConfigKeys.shop_mine_rebate_save: "บันทึก",
      LanguageConfigKeys.shop_mine_rebate_recommend: "แชร์",
      LanguageConfigKeys.shop_mine_rebate_no_superior: "ยังไม่มีหัวหน้าทีม",
      LanguageConfigKeys.shop_mine_rebate_bind_superior: "เข้าร่วมทีมของ",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_tips:
          "กดยืนยันเพื่อเข้าร่วม",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_confirm: "ยืนยัน",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_success:
          "เข้าร่วมทีมแล้ว",
      LanguageConfigKeys.shop_mine_rebate_save_success: "บันทึกเรียบร้อยแล้ว",
      LanguageConfigKeys.shop_mine_rebate_album: "อัลบั้มรูปภาพ",
      LanguageConfigKeys.shop_mine_rebate_recognition_error:
          "ข้อผิดพลาดในการรับรู้",
      LanguageConfigKeys.shop_home_monthly_benefits_tip:
          "สั่งซื้อเพื่อได้รับการสนับสนุนจากแพลตฟอร์ม ส่งต่อเพื่อรับภารกิจและยังทำเงินได้ด้วย!",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_1:
          "ซื้อสินค้าใดๆ ก็ได้ที่คัดสรรมาในแต่ละเดือน",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_2:
          "คุณจะได้รับคุณสมบัติอั่งเปา มูลค่า",
      LanguageConfigKeys.shop_home_load_more: "ดูเพิ่มเติม",
      LanguageConfigKeys.shop_home_balance_window_tip_1:
          "ยินดีด้วย คุณได้รับ|รางวัลเงินสด",
      LanguageConfigKeys.shop_home_balance_window_tip_2:
          "โอนเงินไปยัง|กระเป๋าเงินของคุณแล้ว",
      LanguageConfigKeys.shop_home_rebate_close_tip:
          "บริการนี้ยังไม่เปิดให้บริการ",
      LanguageConfigKeys.shop_home_rebate_order_unfinished_tip:
          "คำสั่งซื้อยังไม่เสร็จสิ้น",
      LanguageConfigKeys.shop_web3_email_sent: "จดหมายถูกส่งแล้ว", //邮件已发送
      LanguageConfigKeys.shop_web3_format_incorrect:
          "รูปแบบจดหมายไม่ถูกต้อง", //邮件格式不正确
      LanguageConfigKeys.shop_web3_luck_draw: "การจับสลาก", //抽奖
      LanguageConfigKeys.shop_web3_chance_lucky_draw:
          "โอกาสในการจับสลาก %s ครั้ง", //抽奖机会%s次
      LanguageConfigKeys.shop_web3_winning_list: "รายชื่อผู้ชนะ", //中奖名单
      LanguageConfigKeys.shop_web3_received_prizes: "ชนะแล้ว", //已中奖
      LanguageConfigKeys.shop_web3_winning_draws_hint:
          "ขอแสดงความยินดีด้วย %s ในการสูบ %s, มูลค่า %s", //恭喜 %s 抽中%s，价值 %s
      LanguageConfigKeys.shop_web3_start_lottery: "เริ่มการจับสลาก", //开始抽奖
      LanguageConfigKeys.shop_web3_winning_following_prizes:
          "ขอแสดงความยินดีกับการจับรางวัลต่อไปนี้", //恭喜抽中以下奖品
      LanguageConfigKeys.shop_web3_claim_prizes: "รับของรางวัล", //领取奖品
      LanguageConfigKeys.shop_web3_please_ensure_accurate_and_correct:
          "โปรดตรวจสอบให้แน่ใจว่า %s ที่คุณให้ไว้ถูกต้อง", //请确保您提供的%s准确无误
      LanguageConfigKeys.shop_web3_email: "ที่อยู่อีเมล", //邮箱地址
      LanguageConfigKeys.shop_web3_transfer_out_address:
          "โอนย้ายที่อยู่", //转出地址
      LanguageConfigKeys.Shop_web3_financial_losses:
          "ไม่เช่นนั้นอาจสูญเสียเงินทุน", //否则可能会造成资金损失
      LanguageConfigKeys.Shop_web3_transfer_fee: "ค่าธรรมเนียมการโอนเงิน", //手续费
      LanguageConfigKeys.Shop_web3_free: "ฟรี", //限免
      LanguageConfigKeys.Shop_web3_expected_credited:
          "คาดว่าจะเข้าบัญชี <black> 24 ชั่วโมง </black>", //预计到账<black> 24小时 </black>
      LanguageConfigKeys.Shop_web3_slide_confirmation: "ยืนยันการเลื่อน", //滑动确认
      LanguageConfigKeys.Shop_web3_transfer_in: "โอนเข้า", //转入
      LanguageConfigKeys.Shop_web3_transfer_out: "ถอนออก", //转出
      LanguageConfigKeys.Shop_web3_address: "ที่อยู่", //地址
      LanguageConfigKeys.Shop_web3_assets: "สินทรัพย์", //资产
      LanguageConfigKeys.Shop_web3_enter_receive_wallet_address:
          "โปรดป้อนที่อยู่กระเป๋าสตางค์ที่คุณต้องการรับ", //请输入您要接收的钱包地址
      LanguageConfigKeys.Shop_web3_choose_transfer_assets:
          "เลือกโอนสินทรัพย์", //选择转出资产
      LanguageConfigKeys.Shop_web3_user_confirm_tip1:
          "ผู้ใช้จะต้องยืนยันและยอมรับความเสี่ยงในการโอนออกด้วยตัวเอง", //用户需自行确认并承担转出风险
      LanguageConfigKeys.Shop_web3_user_confirm_tip2:
          "การดำเนินการโอนออกไม่สามารถเบิกถอนได้,ระวังถูกหลอก", //转出操作无法撤回，谨防受骗
      LanguageConfigKeys.Shop_web3_transfer: "โอนระหว่างกัน", //互转
      LanguageConfigKeys.Shop_web3_account_email:
          "กล่องจดหมายสำหรับบัญชี", //账户邮箱
      LanguageConfigKeys.Shop_web3_enter_email:
          "โปรดป้อนกล่องจดหมายของบัญชีของอีกฝ่าย", //请输入对方的账户邮箱
      LanguageConfigKeys.Shop_web3_selected: "เลือกแล้ว", //已选择
      LanguageConfigKeys.Shop_web3_select_asset_type:
          "เลือกประเภทสินทรัพย์", //选择资产类型
      LanguageConfigKeys.Shop_web3_select_assets: "เลือกสินทรัพย์", //选择资产
      LanguageConfigKeys.Shop_web3_enter_your_email:
          "โปรดป้อนที่อยู่อีเมล", //请输入邮箱地址
      LanguageConfigKeys.Shop_web3_enter_email_code:
          "โปรดป้อนรหัสยืนยันกล่องจดหมาย", //请输入邮箱验证码
      LanguageConfigKeys.Shop_web3_agree_accept: "เห็นด้วยและยอมรับ", //同意并接受
      LanguageConfigKeys.Shop_web3_mxcome_protocol:
          "โปรโตคอลกระเป๋าเงินดิจิตอล MXCOME", //《MXCOME数字钱包协议》
      LanguageConfigKeys.Shop_web3_activate_now: "เปิดทันที", //立即开通
      LanguageConfigKeys.Shop_web3_wallet: "กระเป๋าสตางค์ WEB3", //WEB3钱包
      LanguageConfigKeys.Shop_web3_get: "รับ", //获取
      LanguageConfigKeys.Shop_web3_stored_value: "เติมเงิน", //储值
      LanguageConfigKeys.Shop_web3_did_assets: "สินทรัพย์ DID", //DID资产
      LanguageConfigKeys.Shop_web3_not_config_adv:
          "ยังไม่ได้กำหนดค่าโฆษณาสินค้าเสมือนจริง", //暂未配置虚拟商品广告
      LanguageConfigKeys.Shop_vip_agreement_title:
          "ข้อตกลงการเป็นสมาชิกของผู้ใช้", //用户会员协议
      LanguageConfigKeys.Shop_full_read_agree:
          "ฉันได้อ่านและเข้าใจและเห็นด้วย", //我已完全阅读，理解并同意
      LanguageConfigKeys.Shop_please_check_agreement:
          "กรุณา Tick Line ข้อตกลงการเป็นสมาชิก", //请勾线用户会员协议
      LanguageConfigKeys.Shop_modify_buy_quantity:
          "ของแท้ 100% จากแบรนด์", //修改购买数量
      LanguageConfigKeys.Shop_rights_unlocked:
          "สิทธิ์ยังไม่ถูกปลดล็อก โปรดติดตามประกาศจากชุมชน", //权益尚未解锁，敬请关注社区公告

      // 泰国政府推荐占位框
      LanguageConfigKeys.Gov_recommend_title: "แนะนำโดยรัฐบาลไทย", //泰国政府官方推荐
      LanguageConfigKeys.Gov_recommend_subtitle:
          "กระทรวงการท่องเที่ยวและกีฬา, กระทรวงวัฒนธรรม, การท่องเที่ยวแห่งประเทศไทย", //体育旅游部, 文化部, 国家旅游局
      LanguageConfigKeys.Featured_promotion_empty: "ไม่มีโปรโมชั่นแนะนำ",
      LanguageConfigKeys.Featured_promotion_discount_full:
          "ลด ฿%s เมื่อซื้อครบ ฿%s",
      LanguageConfigKeys.Featured_promotion_voucher: "คูปอง ฿%s",
      LanguageConfigKeys.Featured_promotion_use_now: "ใช้ตอนนี้",
      LanguageConfigKeys.Featured_promotion_discount: "ส่วนลด",
      LanguageConfigKeys.Coupon_detail_show_code_tip:
          "โปรดแสดงรหัสนี้แก่พนักงานเมื่อชำระเงิน",
      LanguageConfigKeys.Coupon_detail_select_address:
          "กรุณาเลือกที่อยู่ร้านค้า",
      LanguageConfigKeys.Coupon_detail_swipe_up_shop: "ปัดขึ้นเพื่อดูร้านค้า",
      LanguageConfigKeys.Coupon_type_full_reduction: "ลดเต็มจำนวน",
      LanguageConfigKeys.Coupon_type_discount_coupon: "คูปองส่วนลด",
      LanguageConfigKeys.Coupon_type_free_shipping: "ส่งฟรี",
      LanguageConfigKeys.Coupon_type_voucher: "คูปองเงินสด",
      LanguageConfigKeys.Coupon_validity_period: "ใช้ได้ถึง %s",
      LanguageConfigKeys.Coupon_select_store: "เลือกร้านค้า",
      LanguageConfigKeys.Coupon_destination: "จุดหมายปลายทาง",
      LanguageConfigKeys.Map_google: "Google Maps",
      LanguageConfigKeys.Map_gaode: "Amap",
      LanguageConfigKeys.Map_baidu: "Baidu Maps",
      LanguageConfigKeys.Map_tencent: "Tencent Maps",
      LanguageConfigKeys.Coupon_copy_address: "คัดลอกที่อยู่",
      LanguageConfigKeys.Coupon_navigate_to_store: "นำทางไปร้านค้า",
      LanguageConfigKeys.Coupon_code_prefix: "รหัส: %s",
      LanguageConfigKeys.Shop_brand_load_failed: "โหลดข้อมูลแบรนด์ล้มเหลว",
      LanguageConfigKeys.Shop_brand_click_retry: "คลิกเพื่อลองใหม่",
      LanguageConfigKeys.Promotion_highlight_category_fallback: "หมวดหมู่",
    },

    //简体中文
    LanguageType.ZH: {
      LanguageConfigKeys.app_name: "MXCOME", //MXCOME
      LanguageConfigKeys.language: "语言", //语言
      LanguageConfigKeys.search: "搜索", //搜索
      LanguageConfigKeys.language_tip:
          "根据系统语言，我们将自动适配，你也可以手动选择适合自己的语言", //根据系统语言，我们将自动适配，你也可以手动选择适合自己的语言
      LanguageConfigKeys.Base_unknown_err: "网络异常，请稍后再试", //网络异常，请稍后再试
      LanguageConfigKeys.Base_coming_soon: "正在开发中，敬请期待", //正在开发中，敬请期待
      LanguageConfigKeys.Base_submit_hint: "提示", //提示
      LanguageConfigKeys.Base_submit_success: "提交成功", //提交成功
      LanguageConfigKeys.Base_successfully_added: "添加成功", //添加成功
      LanguageConfigKeys.Base_successfully_modified: "修改成功", //修改成功
      LanguageConfigKeys.Base_operation_successful: "操作成功", //操作成功
      LanguageConfigKeys.Base_operation_tips: "操作提示", //操作提示
      LanguageConfigKeys.Base_set_successful: "设置成功", //设置成功
      LanguageConfigKeys.Base_copy_success: "复制成功", //复制成功
      LanguageConfigKeys.Base_clean_up: "清除", //清除
      LanguageConfigKeys.Base_delete: "删除", //删除
      LanguageConfigKeys.Shop_submit: "提交", //提交
      LanguageConfigKeys.Base_view_image: "查看图片", //查看图片
      LanguageConfigKeys.Login_welcome_world_of_gold: "欢迎移民淘金世界", //欢迎移民淘金世界
      LanguageConfigKeys.Login_select_country: "选择国家或地区", //选择国家或地区
      LanguageConfigKeys.Login_register: "注册", //注册
      LanguageConfigKeys.Login_register_new: "新用户注册", //新用户注册
      LanguageConfigKeys.Login_duplicate_register_tip:
          "该手机号已被其他账号绑定，将为您跳转至登录页", //该手机号已被其他账号绑定，将为您跳转至登录页
      LanguageConfigKeys.Login_skip: "跳过", //跳过
      LanguageConfigKeys.Login_country_th: "泰国", //泰国
      LanguageConfigKeys.Login_country_en: "美国", //美国
      LanguageConfigKeys.Login_country_zh: "中国", //中国
      LanguageConfigKeys.Login_register_success: "注册成功，请设置登录密码", //注册成功，请设置登录密码
      LanguageConfigKeys.Login_reset_password: "重设密码", //重设密码
      LanguageConfigKeys.Login_sms_code: "短信验证码: ", //短信验证码
      LanguageConfigKeys.Login_sms_code_error: "验证码错误", //验证码错误
      LanguageConfigKeys.Login_sms_code_timeout: "验证码超时", //验证码错误
      LanguageConfigKeys.Login_password_or_confirm_password_error:
          "您输入的密码不一致，请重新输入", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Login_password_tip: "请输入密码", //请输入密码
      LanguageConfigKeys.Login_password_first_tip: "请输入8位及以上密码", //请输入8位及以上密码
      LanguageConfigKeys.Login_password_again_tip: "请再次输入密码", //请再次输入密码
      LanguageConfigKeys.Login_password_format_error:
          "密码格式错误，请按照下面格式填写", //密码格式错误，请按照下面格式填写
      LanguageConfigKeys.Login_set_password_tip1:
          "密码由字母加数字组成，首字母必须大写，长度8-32位", //密码由字母加数字组成，首字母必须大写，长度最少8位
      LanguageConfigKeys.Login_set_password_tip2:
          "请妥善保管密码，并避免使用简单密码组合", //请妥善保管密码，并避免使用简单密码组合
      LanguageConfigKeys.Login_forgot_password_tip1:
          "请输入与MXCOME账号绑定的手机号", //请输入与MXCOME账号绑定的手机号
      LanguageConfigKeys.Login_forgot_password_tip2:
          "获取验证码后可重设密码", //获取验证码后可重设密码
      LanguageConfigKeys.Login_forgot_password_tip3:
          "手机号无法收取验证码，可点击手机换绑", //手机号无法收取验证码，可点击手机换绑
      LanguageConfigKeys.Login_welcome_login: "欢迎登录", //欢迎登录
      LanguageConfigKeys.Login_mobile_tip: "请输入手机号码", //请输入手机号码
      LanguageConfigKeys.Login_mobile_error: "手机号格式错误", //手机号格式错误
      LanguageConfigKeys.Login_user_or_password_error:
          "手机号或密码错误，请重新输入", //手机号或密码错误，请重新输入
      LanguageConfigKeys.Login_forgot_password: "忘记密码", //忘记密码
      LanguageConfigKeys.Login_code_tip: "请输入验证码", //请输入验证码
      LanguageConfigKeys.Login_login_app: "登录MXCOME", //登录MXCOME
      LanguageConfigKeys.Login_send_code: "获取验证码", //获取验证码
      LanguageConfigKeys.Login_resend_code: "重新发送", //重新发送
      LanguageConfigKeys.Login_login: "登录", //登录
      LanguageConfigKeys.Login_verify_phone: "验证手机", //验证手机
      LanguageConfigKeys.Login_other_login_type: "第三方授权登录", //第三方授权登录
      LanguageConfigKeys.Login_bind_phone: "绑定手机号", //绑定手机号
      LanguageConfigKeys.Login_login_accept_tip: "继续即表示您已同意", //继续即表示您已同意
      LanguageConfigKeys.Login_service: "《MXCOME服务协议与隐私政策》", //《MXCOME服务协议与隐私政策》
      LanguageConfigKeys.Login_input_invite_code: "请输入邀请码（可选）", //请输入邀请码（可选）
      LanguageConfigKeys.Login_input_invite_code_required:
          "请输入邀请码（必填）", //请输入邀请码（必填）
      LanguageConfigKeys.Login_input_invite_code_invalid: "邀请码无效", //邀请码无效
      LanguageConfigKeys.Login_input_invite_code_title: "邀请码", //邀请码
      LanguageConfigKeys.Login_input_invite_code_content:
          "邀请码分为公测邀请码与红包闯关邀请码\n最新解释权归平台所有", //邀请码分为公测邀请码与红包闯关邀请码\n最新解释权归平台所有
      LanguageConfigKeys.Login_invite_code_error: "邀请码错误", //邀请码错误
      LanguageConfigKeys.Login_invite_consent_agreement: "同意协议", //同意协议
      LanguageConfigKeys.Login_password_set_success: "密码设置成功", //密码设置成功
      LanguageConfigKeys.Login_password_modify_success: "密码修改成功", //密码修改成功
      LanguageConfigKeys.Verify_code_tip: "短信已发送到手机", //短信已发送到手机
      LanguageConfigKeys.Verify_safe_verify: "安全验证", //安全验证
      LanguageConfigKeys.Verify_safe_verify_tip1:
          "为了你的账号安全，本次操作需要进行验证", //为了你的账号安全，本次操作需要进行验证
      LanguageConfigKeys.Verify_safe_verify_tip2:
          "请将下方的图标移动到圆形区域内", //请将下方的图标移动到圆形区域内
      LanguageConfigKeys.WebPage_click_reload: "点击重新加载", //点击重新加载
      LanguageConfigKeys.ViewUtils_cancel: "取消", //取消
      LanguageConfigKeys.ViewUtils_confirm: "确定", //确定
      LanguageConfigKeys.ViewUtils_no_data: "暂无内容", //暂无内容
      LanguageConfigKeys.ViewUtils_no_more: "没有更多数据了", //没有更多数据了
      LanguageConfigKeys.ViewUtils_retry: "重试", //重试
      LanguageConfigKeys.Loading: "正在加载", //正在加载
      LanguageConfigKeys.Shop_home: "淘金", //淘金
      LanguageConfigKeys.Shop_category: "分类", //分类
      LanguageConfigKeys.Shop_cart: "购物车", //购物车
      LanguageConfigKeys.Shop_grow: "成长", //成长
      LanguageConfigKeys.Shop_grow_continue_day: "已连续签到|天", //已连续签到|天
      LanguageConfigKeys.Shop_grow_this_month: "本月", //本月
      LanguageConfigKeys.Shop_grow_countersign: "补签", //补签
      LanguageConfigKeys.Shop_grow_unsigned: "未签到", //未签到
      LanguageConfigKeys.Shop_grow_countersigned: "已补签", //已补签
      LanguageConfigKeys.Shop_grow_signed: "已签到", //已签到
      LanguageConfigKeys.Shop_grow_growth_benefits: "成长福利", //成长福利
      LanguageConfigKeys.Shop_grow_surprise: "惊喜", //惊喜
      LanguageConfigKeys.Shop_product_task_recommend: "任务推荐", //任务推荐
      LanguageConfigKeys.Shop_product_shop_stroll: "店铺闲逛", //店铺闲逛
      LanguageConfigKeys.Shop_product_shop_stroll_tip:
          "逛街时，可以DIY组合“推荐清单”哦", //逛街时，可以DIY组合“推荐清单”哦
      LanguageConfigKeys.Shop_product_hot_activity: "热门活动", //热门活动
      LanguageConfigKeys.Shop_product_recommend: "热销榜", //热销榜
      LanguageConfigKeys.Shop_product_profit: "淘金榜", //淘金榜
      LanguageConfigKeys.Shop_product_best_seller: "持家榜", //持家榜
      LanguageConfigKeys.Shop_product_search: "搜任务/活动/商品", //搜任务/活动/商品
      LanguageConfigKeys.Shop_product_delivery: "配送", //配送
      LanguageConfigKeys.Shop_product_parameter: "参数", //参数
      LanguageConfigKeys.Shop_product_spec: "规格", //规格
      LanguageConfigKeys.Shop_product_spec_select: "已选择%s件", //已选择%s件
      LanguageConfigKeys.Shop_product_service: "服务", //服务
      LanguageConfigKeys.Featured_promotion_title: "精选优惠", //精选优惠
      LanguageConfigKeys.Featured_promotion_view_all: "查看所有", //查看所有
      LanguageConfigKeys.Featured_promotion_category_restaurant: "网红餐厅", //网红餐厅
      LanguageConfigKeys.Featured_promotion_category_hotel: "酒店住宿", //酒店住宿
      LanguageConfigKeys.Featured_promotion_category_car: "租车接机", //租车接机
      LanguageConfigKeys.Featured_promotion_category_ticket: "景点门票", //景点门票
      LanguageConfigKeys.Featured_promotion_category_popular_thai:
          "热门泰货", //热门泰货
      LanguageConfigKeys.Featured_promotion_category_leisure: "休闲娱乐", //休闲娱乐
      LanguageConfigKeys.Shop_product_shop: "店铺", //店铺
      LanguageConfigKeys.Shop_product_consulting: "咨询", //咨询
      LanguageConfigKeys.Shop_product_join: "加入", //加入
      LanguageConfigKeys.Shop_product_rise: "起", //起
      LanguageConfigKeys.Shop_product_join_cart: "加入购物车", //加入购物车
      LanguageConfigKeys.Shop_product_cart_add_success: "已成功加入购物车", //已成功加入购物车
      LanguageConfigKeys.Shop_product_now_buy: "立即购买", //立即购买
      LanguageConfigKeys.Shop_product_goods: "简介", //概述
      LanguageConfigKeys.Shop_product_detail: "详情", //详情
      LanguageConfigKeys.Shop_product_select_spec: "选择规格", //选择规格
      LanguageConfigKeys.Shop_product_quantity: "数量", //数量
      LanguageConfigKeys.Shop_product_money: "赚", //赚
      LanguageConfigKeys.Shop_product_mxget: "淘金赚", //淘金赚
      LanguageConfigKeys.Shop_product_user_join_mxget:
          "已有 | 名用户参与“淘金赚”", //已有|名用户参与“淘金赚”
      LanguageConfigKeys.Shop_product_view_list: "查看榜单", //查看榜单
      LanguageConfigKeys.Shop_product_see: "查看", //查看
      LanguageConfigKeys.Shop_product_select: "选择", //选择
      LanguageConfigKeys.Shop_product_free_freight: "免运费", //免运费
      LanguageConfigKeys.Shop_product_nation_branding: "品牌国家: ", //品牌国家
      LanguageConfigKeys.Shop_product_place: "场地: ", //场地
      LanguageConfigKeys.Shop_product_producer: "产地: ", //产地
      LanguageConfigKeys.Shop_product_free_charge_overtime_tip:
          "超过7天到货，直接免单", //超过7天到货，直接免单
      LanguageConfigKeys.Shop_product_ship_to: "发货地: %s", //发货地: %s
      LanguageConfigKeys.Shop_product_now_pay_tip:
          "现在付款，品牌承诺48小时内发货", //现在付款，品牌承诺48小时内发货
      LanguageConfigKeys.Shop_product_hot_category: "热门品类", //热门品类
      LanguageConfigKeys.Shop_product_hot_product: "热销产品", //热销产品
      LanguageConfigKeys.Shop_brand_shop: "品牌店铺", //品牌店铺
      LanguageConfigKeys.Shop_brand_subscribe: "订阅", //订阅
      LanguageConfigKeys.Shop_brand_subscribed: "已订阅", //已订阅
      LanguageConfigKeys.Shop_brand_goto_shop: "进店铺", //进店铺
      LanguageConfigKeys.Shop_brand_receive: "可接任务", //可接任务
      LanguageConfigKeys.Shop_brand_family: "爱持家", //爱持家
      LanguageConfigKeys.Shop_brand_period: "分期", //分期
      LanguageConfigKeys.Shop_brand_free_package: "包邮", //包邮
      LanguageConfigKeys.Shop_brand_overtime_free: "超时免单", //超时免单
      LanguageConfigKeys.Shop_brand_down_up: "由低到高", //由低到高
      LanguageConfigKeys.Shop_brand_up_down: "由高到低", //由高到低
      LanguageConfigKeys.Shop_brand_choose: "筛选条件", //筛选条件
      LanguageConfigKeys.Shop_brand_enable: "可选", //可选
      LanguageConfigKeys.Shop_brand_price: "价格", //价格
      LanguageConfigKeys.Shop_cart_empty: "挑选喜欢的装进购物车", //挑选喜欢的装进购物车
      LanguageConfigKeys.Shop_cart_select_all: "全选", //全选
      LanguageConfigKeys.Shop_cart_total: "总计", //总计
      LanguageConfigKeys.Shop_cart_settlement: "结算", //结算
      LanguageConfigKeys.Shop_cart_delete: "删除", //删除
      LanguageConfigKeys.Shop_cart_is_delete: "是否删除选择商品?", //是否删除选择商品?
      LanguageConfigKeys.Shop_cart_select_goods: "请先选择商品", //请先选择商品
      LanguageConfigKeys.Shop_cart_select_goods_settlement:
          "请先选择商品再结算", //请先选择商品再结算
      LanguageConfigKeys.Shop_mine_adv: "越玩越赚", //越玩越赚
      LanguageConfigKeys.Shop_mine_not_login: "未登录", //未登录
      LanguageConfigKeys.Shop_mine_member_service: "优惠券", //优惠券
      LanguageConfigKeys.Shop_mine_shop_service: "运营管理", //运营管理
      LanguageConfigKeys.Shop_mine_member_service_tips: "多推多得", //多推多得
      LanguageConfigKeys.Shop_mine_shop_service_tips: "开通橱窗享好礼", //开通橱窗享好礼
      LanguageConfigKeys.Shop_mine_account_balance: "余额", //余额
      LanguageConfigKeys.Shop_mine_withdrawal_balance: "可提金额", //可提金额
      LanguageConfigKeys.Shop_mine_today_withdrawal_balance: "今日可提", //今日可提
      LanguageConfigKeys.Shop_mine_confirm_withdrawal: "确认提现", //确认提现
      LanguageConfigKeys.Shop_mine_withdrawal_amount: "提现金额", //提现金额
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip1:
          "最低฿100或100的倍数，最高฿10000/天", //最低฿100或100的倍数，最高฿10000/天
      LanguageConfigKeys.Shop_mine_withdrawal_amount_tip2: "提现费率%s%", //提现费率3%
      LanguageConfigKeys.Shop_mine_gold_coin: "金币", //金币
      LanguageConfigKeys.Shop_mine_address_manage: "地址管理", //地址管理
      LanguageConfigKeys.Shop_mine_help: "帮助中心", //帮助中心
      LanguageConfigKeys.Shop_mine_profit_study: "淘金学院", //淘金学院
      LanguageConfigKeys.Shop_mine_order: "订单", //订单
      LanguageConfigKeys.Shop_mine_wallet: "资产", //资产
      LanguageConfigKeys.Shop_mine_more: "更多", //更多
      LanguageConfigKeys.Shop_mine_edit_member_info: "编辑个人资料", //编辑个人资料
      LanguageConfigKeys.Shop_mine_unknown: "保密", //保密
      LanguageConfigKeys.Shop_mine_boy: "男", //男
      LanguageConfigKeys.Shop_mine_girl: "女", //女
      LanguageConfigKeys.Shop_mine_year_tip: "您的年龄需要大于14周岁", //您的年龄需要大于14周岁
      LanguageConfigKeys.Shop_mine_change_avatar: "更换头像", //更换头像
      LanguageConfigKeys.Shop_mine_name: "姓名", //姓名
      LanguageConfigKeys.Shop_mine_account_id: "账号ID", //账号ID
      LanguageConfigKeys.Shop_mine_account_modify_once:
          "账号ID一年只能修改一次", //账号ID一年只能修改一次
      LanguageConfigKeys.Shop_mine_account_id_already_exists: "ID已存在", //ID已存在
      LanguageConfigKeys.Shop_mine_change_account_id: "变更账号ID", //变更账号ID
      LanguageConfigKeys.Shop_mine_verifying: "审核中", //审核中
      LanguageConfigKeys.Shop_mine_passed: "已实名", //已实名
      LanguageConfigKeys.Shop_mine_real_name_auth: "实名认证", //实名认证
      LanguageConfigKeys.Shop_mine_verify_status: "审核状态", //审核状态
      LanguageConfigKeys.Shop_mine_verify_status_tip1: "身份认证正在审核中", //身份认证正在审核中
      LanguageConfigKeys.Shop_mine_verify_status_tip2:
          "请稍后查看，您可以继续参与淘金任务", //请稍后查看，您可以继续参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip1:
          "证件信息无法核实", //证件信息无法核实
      LanguageConfigKeys.Shop_mine_verify_failed_status_tip2:
          "请重新提交正确的证件照片及信息", //请重新提交正确的证件照片及信息
      LanguageConfigKeys.Shop_mine_verify_start_mxget: "参与淘金任务", //参与淘金任务
      LanguageConfigKeys.Shop_mine_verify_reapply: "重新申请", //重新申请
      LanguageConfigKeys.Shop_mine_select_certificate: "请选择证件类型", //请选择证件类型
      LanguageConfigKeys.Shop_mine_upload_positive: "请上传证件的正面", //请上传证件的正面
      LanguageConfigKeys.Shop_mine_re_upload: "重新上传", //重新上传
      LanguageConfigKeys.Shop_mine_register_phone: "注册手机", //注册手机
      LanguageConfigKeys.Shop_mine_id_card: "身份证", //身份证
      LanguageConfigKeys.Shop_mine_passport: "护照", //护照
      LanguageConfigKeys.Shop_mine_id_number: "身份证号", //身份证号
      LanguageConfigKeys.Shop_mine_passport_number: "护照号", //护照号
      LanguageConfigKeys.Shop_mine_validity: "有效期", //有效期
      LanguageConfigKeys.Shop_mine_select_bank: "选择银行", //选择银行
      LanguageConfigKeys.Shop_mine_first_name: "姓氏", //姓氏
      LanguageConfigKeys.Shop_mine_last_name: "名字", //名字
      LanguageConfigKeys.Shop_mine_color_pictures:
          "支持JPG、PNG、PDF 文件大小不超过5M", //支持JPG、PNG、PDF 文件大小不超过5M
      LanguageConfigKeys.Shop_mine_upload_after_tip:
          "证件上传后，根据证件信息补全证件号、有效期、姓名", //证件上传后，根据证件信息补全证件号、有效期、姓名
      LanguageConfigKeys.Shop_mine_verify_tip1: "请确认您所持有的证件类型", //请确认您所持有的证件类型
      LanguageConfigKeys.Shop_mine_verify_tip2: "需要彩色文件", //需要彩色文件
      LanguageConfigKeys.Shop_mine_verify_tip3:
          "姓名、证件号码，有效期和详细地址清晰可见", //姓名、证件号码，有效期和详细地址清晰可见
      LanguageConfigKeys.Shop_mine_verify_tip4: "证件必须在有效期内", //证件必须在有效期内
      LanguageConfigKeys.Shop_mine_verify_confirm: "确认提交", //确认提交
      LanguageConfigKeys.Shop_mine_verify_failed: "审核不通过", //审核不通过
      LanguageConfigKeys.Shop_mine_verify_wait_time:
          "耐心等待，预计|个工作日内完成认证审核", //耐心等待，预计|个工作日内完成认证审核
      LanguageConfigKeys.Shop_mine_unreal_name: "未实名", //未实名
      LanguageConfigKeys.Shop_mine_nickname: "昵称", //昵称
      LanguageConfigKeys.Shop_mine_describe: "个性签名", //个性签名
      LanguageConfigKeys.Shop_mine_birthday: "生日", //生日
      LanguageConfigKeys.Shop_mine_gender: "性别", //性别
      LanguageConfigKeys.Shop_mine_select_gender: "选择性别", //选择性别
      LanguageConfigKeys.Shop_mine_take_picture: "拍照", //拍照
      LanguageConfigKeys.Shop_mine_photo_album: "从手机选择", //从手机选择
      LanguageConfigKeys.Shop_mine_canceled: "取消", //取消
      LanguageConfigKeys.Shop_mine_member_level: "会员等级", //会员等级
      LanguageConfigKeys.Shop_mine_not_opened: "未开通", //未开通
      LanguageConfigKeys.Shop_mine_bind_now: "立即绑定", //立即绑定
      LanguageConfigKeys.Shop_mine_get_center: "领券中心", //领券中心
      LanguageConfigKeys.Shop_mine_promotion_rewards: "推广奖励", //推广奖励
      LanguageConfigKeys.Shop_mine_voucher_center: "领券中心", //领券中心
      LanguageConfigKeys.Shop_mine_valid_to: "有效期至 %s", //有效期至 %s
      LanguageConfigKeys.Shop_mine_usage_time: "使用时间 %s", //使用时间 %s
      LanguageConfigKeys.Shop_mine_to_use: "去使用", //去使用
      LanguageConfigKeys.Shop_mine_to_be_use: "待使用", //待使用
      LanguageConfigKeys.Shop_mine_used: "已使用", //已使用
      LanguageConfigKeys.Shop_mine_get_now: "立即领取", //立即领取
      LanguageConfigKeys.Shop_mine_use_coupons: "使用优惠券", //使用优惠券
      LanguageConfigKeys.Shop_mine_currently_available: "当前可用(%s)", //当前可用(%s)
      LanguageConfigKeys.Shop_mine_discount_deduction: "优惠抵扣", //优惠抵扣
      LanguageConfigKeys.Shop_mine_full_available: "满%s铢可用", //满%s可用
      LanguageConfigKeys.Shop_mine_all_platforms: "全平台通用", //全平台可用
      LanguageConfigKeys.Shop_mine_all_shops: "店铺全场可用", //全平台可用
      LanguageConfigKeys.Shop_mine_category_available: "指定分类可用", //指定分类可用
      LanguageConfigKeys.Shop_mine_specific_product_available:
          "指定商品可用", //指定商品可用
      LanguageConfigKeys.Shop_mine_voucher: "代金券", //代金券
      LanguageConfigKeys.Shop_mine_coupon: "优惠券", //优惠券
      LanguageConfigKeys.Shop_mine_platform_voucher: "平台", //平台
      LanguageConfigKeys.Shop_mine_merchant_voucher: "品牌", //品牌
      LanguageConfigKeys.Shop_mine_my_coupon: "我的优惠券", //我的优惠券
      LanguageConfigKeys.Shop_mine_received_successfully: "领取成功", //领取成功
      LanguageConfigKeys.Shop_mine_go_get_voucher: "去领券", //去领券
      LanguageConfigKeys.Shop_mine_applicable_range: "适用范围", //适用范围
      LanguageConfigKeys.Shop_mine_products_applicable_coupon:
          "该券适用的商品", //该券适用的商品
      LanguageConfigKeys.Shop_mine_my_prize: "我的奖品", //我的奖品
      LanguageConfigKeys.Shop_mine_red_title: "红包闯关", //红包闯关第一季
      LanguageConfigKeys.Shop_mine_red_history_title: "闯关历史", //红包闯关第一季
      LanguageConfigKeys.Shop_mine_red_total_number: "总期数: %s", //总期数: %s
      LanguageConfigKeys.Shop_mine_red_no_data:
          "您暂未参与过红包闯关，暂无数据", //您暂未参与过红包闯关，暂无数据
      LanguageConfigKeys.Shop_mine_red_sub_title:
          "฿111,000真实巨额红包大派送", //฿111,000真实巨额红包大派送
      LanguageConfigKeys.Shop_mine_number_promoters: "推广人数", //推广人数
      LanguageConfigKeys.Shop_mine_total_number_promoters: "推广总数", //推广总数
      LanguageConfigKeys.Shop_mine_new_today: "今日新增", //今日新增
      LanguageConfigKeys.Shop_mine_promotion_details: "推广明细", //推广明细
      LanguageConfigKeys.Shop_mine_Daily_direct_promotion_prizes:
          "每日直推奖品", //每日直推奖品
      LanguageConfigKeys.Shop_mine_choose_prize: "选择奖品", //选择奖品
      LanguageConfigKeys.Shop_mine_promotion_rules: "推广规则", //推广规则
      LanguageConfigKeys.Shop_mine_promotion_rules_tip1:
          "1. 没有参加红包闯关资格的用户即为“新人”，纳入红包奖励范围，非新人购买，您仅得分润", //1. 没有参加红包闯关资格的用户即为“新人”，纳入红包奖励范围，非新人购买，您仅得分润
      LanguageConfigKeys.Shop_mine_promotion_rules_tip2:
          "2. 您直推三位新人获得第一层红包 x 1；您好友也推荐了三位新人，您将获得第二层红包 x 1；根据此原则，您可得到第三层红包 x 1；每层红包不限个数，多推多得！满足关卡金额自动进入下一关", //2. 您直推三位新人可获得第一层红包奖励的一个红包；您直推的新人也推荐了三位新人，您将获得第二层红包奖励的第二个红包；根据此原则，您还可得到第三层红包奖励的第三个红包奖励；每层红包不限个数，多推多得！
      LanguageConfigKeys.Shop_mine_promotion_rules_tip3:
          "3. 推荐商品金额越高，分润及红包奖励金额越大", //3. 推荐商品金额越高，分润及红包奖励金额越大
      LanguageConfigKeys.Shop_mine_promotion_rules_tip4:
          "4. 点击“推广明细”可以查看推广详情", //4. 满足红包关卡奖励金额，将自动转入余额并进入下一关，请开始新的推广
      LanguageConfigKeys.Shop_mine_promotion_rules_tip5:
          "5. 点击“兑换奖品”可以根据“直推值”兑换您喜欢的奖品，已兑奖品可点击“查看奖品”，请在有效期内使用", //5. 选择您喜欢的直推奖品，并完成指定直推人数，即可获得奖品券，奖品券将放入个人中心的优惠券中，请在有效期内使用
      LanguageConfigKeys.Shop_mine_promotion_rules_tip6:
          "6. 推广活动最终解释权归属平台所有", //6. 推广活动最终解释权归属平台所有
      LanguageConfigKeys.Shop_mine_exchange_voucher: "兑换券", //兑换券
      LanguageConfigKeys.Shop_mine_entity_prizes: "实物奖品", //实物奖品
      LanguageConfigKeys.Shop_mine_my_push: "我的直推", //我的直推
      LanguageConfigKeys.Shop_mine_my_push_value: "我的直推值", //我的直推
      LanguageConfigKeys.Shop_mine_second_level: "二级推荐", //二级推荐
      LanguageConfigKeys.Shop_mine_third_level: "三级推荐", //三级推荐
      LanguageConfigKeys.Shop_mine_processing: "进行中", //进行中
      LanguageConfigKeys.Shop_mine_issued: "已发放", //已发放
      LanguageConfigKeys.Shop_mine_exchange_success_tip:
          "当前已有|人兑换成功", // 当前已有|人兑换成功
      LanguageConfigKeys.Shop_mine_select_prizes: "挑选奖品", //挑选奖品
      LanguageConfigKeys.Shop_mine_now_use: "立即使用", //立即使用
      LanguageConfigKeys.Shop_mine_detail: "查看详情", //查看详情
      LanguageConfigKeys.Shop_mine_expired: "%s 过期", //%s 过期
      LanguageConfigKeys.Shop_mine_direct_push: "直推值%s", //直推%s人
      LanguageConfigKeys.Shop_mine_hot: "热门", //热门
      LanguageConfigKeys.Shop_mine_end_remain: "距结束还剩", //距结束还剩
      LanguageConfigKeys.Shop_mine_exchange_prizes: "兑换奖品", //兑换奖品
      LanguageConfigKeys.Shop_mine_store_consumption: "门店消费", //门店消费
      LanguageConfigKeys.Shop_mine_express_delivery: "快递发货", //快递发货
      LanguageConfigKeys.Shop_mine_exchange_records: "兑换记录", //兑换记录
      LanguageConfigKeys.Shop_mine_value: "价值", //价值
      LanguageConfigKeys.Shop_mine_stock: "库存", //库存
      LanguageConfigKeys.Shop_mine_direct_push_value: "消耗直推值", //直推值
      LanguageConfigKeys.Shop_mine_using_direct_push_value: "消耗直推值", //消耗直推值
      LanguageConfigKeys.Shop_mine_enable: "可兑", //可兑
      LanguageConfigKeys.Shop_mine_exchange_successful: "兑换成功", //兑换成功
      LanguageConfigKeys.Shop_mine_confirm_exchange: "确定兑换", //确定兑换
      LanguageConfigKeys.Shop_mine_confirm_use: "确定使用", //确定使用
      LanguageConfigKeys.Shop_mine_confirm_use_tip:
          "点击确定，表示兑换完成，请谨慎操作", //点击确定，表示兑换完成，请谨慎操作
      LanguageConfigKeys.Shop_mine_voucher_code_info: "券码信息", //券码信息
      LanguageConfigKeys.Shop_mine_prize_info: "奖品信息", //奖品信息
      LanguageConfigKeys.Shop_mine_exchange_number: "兑换单号", //兑换单号
      LanguageConfigKeys.Shop_mine_exchange_time: "兑换时间", //兑换时间
      LanguageConfigKeys.Shop_mine_usage_rules: "使用规则", //使用规则
      LanguageConfigKeys.Shop_mine_usage_rules_tip1:
          "1. 点击立即使用，即兑换/发货，不找零、不退换、不兑现金", //1. 点击立即使用，即兑换/发货，不找零、不退换、不兑现金
      LanguageConfigKeys.Shop_mine_usage_rules_tip2:
          "2. 请注意礼品使用时间，请尽快使用，过期失效", //2. 请注意礼品使用时间，请尽快使用，过期失效
      LanguageConfigKeys.Shop_mine_usage_rules_tip3:
          "3. 最终解释权归属平台", //3. 最终解释权归属平台
      LanguageConfigKeys.Shop_mine_usage_expiration_time: "过期时间 %s", //过期时间 %s
      LanguageConfigKeys.Shop_mine_usage_total_sheets: "共 | 张", //共 | 张
      LanguageConfigKeys.Shop_mine_logistics_info: "物流信息", //物流信息
      LanguageConfigKeys.Shop_mine_receiving_time: "收货时间", //收货时间
      LanguageConfigKeys.Shop_order_waiting_for_shipment: "等待发货", //等待发货
      LanguageConfigKeys.Shop_mine_keep_working_hard: "恭喜，请再接再厉", //恭喜，请再接再厉
      LanguageConfigKeys.Shop_mine_obtain_red: "获得红包", //获得红包
      LanguageConfigKeys.Shop_mine_to_be_updated: "待更新", //待更新
      LanguageConfigKeys.Shop_mine_run_to_zero: "过期失效", //过期失效
      LanguageConfigKeys.Shop_mine_select_option: "选择期数", //选择期数
      LanguageConfigKeys.Shop_order_all: "全部", //全部
      LanguageConfigKeys.Shop_order_received: "可接", //可接
      LanguageConfigKeys.Shop_order_changed: "更换", //可接
      LanguageConfigKeys.Shop_order_wait_pay: "待付款", //待付款
      LanguageConfigKeys.Shop_order_wait_deliver: "待发货", //待发货
      LanguageConfigKeys.Shop_order_wait_receipt: "待收货", //待收货
      LanguageConfigKeys.Shop_order_shipped: "已发货", //已发货
      LanguageConfigKeys.Shop_order_completed: "已完成", //已完成
      LanguageConfigKeys.Shop_order_receive_finish: "已收货", //已收货
      LanguageConfigKeys.Shop_order_canceled: "已取消", //已取消
      LanguageConfigKeys.Shop_order_after_sales_order: "售后订单", //售后订单
      LanguageConfigKeys.Shop_order_delete_title: "确认删除订单？", //确认删除订单？
      LanguageConfigKeys.Shop_order_delete_content:
          "删除后该订单记录无法找回", //删除后该订单记录无法找回
      LanguageConfigKeys.Shop_order_again_patronage: "期待您再次惠顾", //期待您再次惠顾
      LanguageConfigKeys.Shop_order_after_sales: "售后", //售后
      LanguageConfigKeys.Shop_order_confirm_order: "确认订单", //确认订单
      LanguageConfigKeys.Shop_order_empty: "暂无订单", //暂无订单
      LanguageConfigKeys.Shop_order_search: "搜索订单", //搜索订单
      LanguageConfigKeys.Shop_order_mine_order: "我的订单", //我的订单
      LanguageConfigKeys.Shop_order_now_pay: "立即付款", //立即付款
      LanguageConfigKeys.Shop_order_confirm_pay: "确认支付", //确认支付
      LanguageConfigKeys.Shop_order_remain: "剩余", //剩余
      LanguageConfigKeys.Shop_order_pay: "支付", //支付
      LanguageConfigKeys.Shop_order_cancel_order: "取消订单", //取消订单
      LanguageConfigKeys.Shop_order_change_address: "更换地址", //更换地址
      LanguageConfigKeys.Shop_order_contact_customer_service: "联系客服", //联系客服
      LanguageConfigKeys.Shop_order_confirm_receipt: "确认收货", //确认收货
      LanguageConfigKeys.Shop_order_confirm_receipt_tip:
          "为保障您的权益，请收货后再确认", //为保障您的权益，请收货后再确认
      LanguageConfigKeys.Shop_order_again_buy: "再次购买", //再次购买
      LanguageConfigKeys.Shop_order_service1: "假一赔三", //假一赔三
      LanguageConfigKeys.Shop_order_service2: "品牌售后", //品牌售后
      LanguageConfigKeys.Shop_order_service3: "正品溯源", //正品溯源
      LanguageConfigKeys.Shop_order_service4: "超时免单", //超时免单
      LanguageConfigKeys.Shop_order_service5: "快速发货", //快速发货
      LanguageConfigKeys.Shop_order_service6: "商品包邮", //商品包邮
      LanguageConfigKeys.Shop_order_service7: "支持分期", //支持分期
      LanguageConfigKeys.Shop_order_service8: "快速退款", //快速退款
      LanguageConfigKeys.Shop_order_delete_order: "删除订单", //删除订单
      LanguageConfigKeys.Shop_order_view_logistics: "查看物流", //查看物流
      LanguageConfigKeys.Shop_order_apply_service: "申请售后", //申请售后
      LanguageConfigKeys.Shop_order_piece_in_total: "共%s件", //共%s件
      LanguageConfigKeys.Shop_order_coupons_ticket_available: "%s张可用", //%s张可用
      LanguageConfigKeys.Shop_order_coupons: "优惠券", //优惠券
      LanguageConfigKeys.Shop_order_tax: "增值税 (7%)", //增值税 (7%)
      LanguageConfigKeys.Shop_order_tax_fee7: "税费 (VAT7%)", //税费 (VAT7%)
      LanguageConfigKeys.Shop_order_select_delivery: "选择快递", //选择快递
      LanguageConfigKeys.Shop_order_logistics_company: "物流公司", //物流公司
      LanguageConfigKeys.Shop_order_select_logistics_company: "选择物流公司", //选择物流公司
      LanguageConfigKeys.Shop_order_delivery1: "平邮", //平邮
      LanguageConfigKeys.Shop_order_delivery2: "快递", //快递
      LanguageConfigKeys.Shop_order_delivery3: "泰国邮政", //泰国邮政
      LanguageConfigKeys.Shop_order_freight_details: "运费详情", //运费详情
      LanguageConfigKeys.Shop_order_goods_total: "商品总价", //商品总价
      LanguageConfigKeys.Shop_order_total: "合计", //合计
      LanguageConfigKeys.Shop_order_payment_required: "需付款", //需付款
      LanguageConfigKeys.Shop_order_total_discount: "共优惠", //共优惠
      LanguageConfigKeys.Shop_order_freight: "运费", //运费
      LanguageConfigKeys.Shop_order_total_freight: "合计运费", //合计运费
      LanguageConfigKeys.Shop_order_place_order: "提交订单", //提交订单
      LanguageConfigKeys.Shop_order_select_receive_address: "请添加收货地址", //请添加收货地址
      LanguageConfigKeys.Shop_order_wait_for_payment: "等待支付", //等待支付
      LanguageConfigKeys.Shop_order_order_sn: "订单编号", //订单编号
      LanguageConfigKeys.Shop_order_add_points: "获取积分", //获取积分
      LanguageConfigKeys.Shop_order_payment_type: "支付方式", //支付方式
      LanguageConfigKeys.Shop_order_order_time: "下单时间", //下单时间
      LanguageConfigKeys.Shop_order_payment_time: "支付时间", //支付时间
      LanguageConfigKeys.Shop_order_receive_address: "收货信息", //收货信息
      LanguageConfigKeys.Shop_order_delivery_type: "配送方式", //配送方式
      LanguageConfigKeys.Shop_order_delivery_time: "发货时间", //发货时间
      LanguageConfigKeys.Shop_order_calc_delivery_time: "预计发货", //预计发货
      LanguageConfigKeys.Shop_order_delivering: "配送中", //配送中
      LanguageConfigKeys.Shop_order_signed_in: "已签收", //已签收
      LanguageConfigKeys.Shop_order_to_be_settled: "待结算", //待结算
      LanguageConfigKeys.Shop_order_be_careful: "注意", //注意
      LanguageConfigKeys.Shop_order_rule_tips:
          "根据活动规则，活动结束后，由平台进行为期7天的统计结算，此过程可能存在用户退单导致的排名及奖励变化，请谅解，跟单将有效提升成单率，祝您越来越顺，越玩越赚。", //根据活动规则，活动结束后，由平台进行为期7天的统计结算，此过程可能存在用户退单导致的排名及奖励变化，请谅解，跟单将有效提升成单率，祝您越来越顺，越玩越赚。
      LanguageConfigKeys.Shop_order_no_app_found: "没有找到对应APP", //没有找到对应APP
      LanguageConfigKeys.Shop_order_pay_success: "支付成功", //支付成功
      LanguageConfigKeys.Shop_order_pay_success_winning:
          "恭喜获得抽奖机会，100%中奖哦", //恭喜获得抽奖机会，100%中奖哦
      LanguageConfigKeys.Shop_order_pay_success_tip1:
          "快去分享好货给好友吧！", //快去分享好货给好友吧！
      LanguageConfigKeys.Shop_order_share_goods: "分享好货", //分享好货
      LanguageConfigKeys.Shop_order_pay_success_tip2:
          "安全提醒：除实名认证外MXCOME不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话！", //安全提醒：除实名认证外MXCOME不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话！
      LanguageConfigKeys.shop_order_card_email_title: "接收邮箱 / Web3钱包注册邮箱（必填)",
      LanguageConfigKeys.shop_order_card_email_hint: "请填写邮箱地址，以便接收卡券信息",
      LanguageConfigKeys.shop_order_card_email_not_empty: "邮箱不能为空",
      LanguageConfigKeys.shop_order_card_email_error: "请输入正确的邮箱地址", //请输入正确邮箱地址
      LanguageConfigKeys.shop_order_virtual_product_tip:
          "此商品为虚拟商品，商家发货后不支持退换", //请确认输入正确邮箱地址后支付订单，虚拟商品一旦发货，不支持退换货，平台不承担责任。
      LanguageConfigKeys.Shop_order_delivery_to: "商品配送至", //商品配送至
      LanguageConfigKeys.Shop_order_coupons_disable: "未使用优惠券", //未使用优惠券
      LanguageConfigKeys.Shop_order_status: "订单状态", //订单状态
      LanguageConfigKeys.Shop_order_confirm_change: "确定更换", //确认更换
      LanguageConfigKeys.Shop_order_user_pay: "用户付款", //用户付款
      LanguageConfigKeys.Shop_order_shop_deliver: "店铺发货", //店铺发货
      LanguageConfigKeys.Shop_order_express_delivery: "快递配送", //快递配送
      LanguageConfigKeys.Shop_order_user_receipt: "用户收货", //用户收货
      LanguageConfigKeys.Shop_order_detail_tip1: "等待支付", //等待支付
      LanguageConfigKeys.Shop_order_detail_tip2:
          "支付完成，商家承诺在48小时内完成发货", //支付完成，商家承诺在48小时内完成发货
      LanguageConfigKeys.Shop_order_detail_tip3: "店铺备货中", //店铺备货中
      LanguageConfigKeys.Shop_order_detail_tip4: "即将发货，敬请期待", //即将发货，敬请期待
      LanguageConfigKeys.Shop_order_delivery_detail: "快递详情", //快递详情
      LanguageConfigKeys.Shop_order_order_completed: "订单已完成", //订单已完成
      LanguageConfigKeys.Shop_order_order_canceled: "订单已取消", //订单已取消
      LanguageConfigKeys.Shop_order_suggestions: "客户建议", //客户建议
      LanguageConfigKeys.Shop_order_invalid: "无效订单", //无效订单
      LanguageConfigKeys.Shop_order_prompt_pay: "Promptpay QR", //Promptpay QR
      LanguageConfigKeys.Shop_order_cashier: "收银台", //收银台
      LanguageConfigKeys.Shop_order_pay_amount: "支付金额(฿)", //支付金额(฿)
      LanguageConfigKeys.Shop_order_pay_remaining_time: " 支付剩余时间", //支付剩余时间
      LanguageConfigKeys.Shop_order_pay_qr_code: "请截图保存二维码", //请截图保存二维码
      LanguageConfigKeys.Shop_order_balance_pay: "余额支付", //余额支付
      LanguageConfigKeys.Shop_order_kbank_pay: "泰国开泰银行", //泰国开泰银行
      LanguageConfigKeys.Shop_order_scb_pay: "泰国汇商银行", //泰国汇商银行
      LanguageConfigKeys.Shop_order_bank_card_pay: "银行卡支付", //银行卡支付
      LanguageConfigKeys.Shop_order_select_pay: "请选择支付方式", //请选择支付方式
      LanguageConfigKeys.Shop_order_official_pay: "官方支付", //官方支付
      LanguageConfigKeys.Shop_order_third_party_pay: "第三方支付", //第三方支付
      LanguageConfigKeys.Shop_order_delivery_collect: "快递揽收", //快递揽收
      LanguageConfigKeys.Shop_order_brand_commitment: "品牌承诺", //品牌承诺
      LanguageConfigKeys.Shop_order_platform_policy: "平台政策", //平台政策
      LanguageConfigKeys.Shop_order_brand: "品牌", //品牌
      LanguageConfigKeys.Shop_order_delivery: "物流", //物流
      LanguageConfigKeys.Shop_order_user: "用户", //用户
      LanguageConfigKeys.Shop_order_sender_max_time: "发货/48小时内", //发货/48小时内
      LanguageConfigKeys.Shop_order_delivery_max_time: "配送/72小时内", //配送/72小时内
      LanguageConfigKeys.Shop_order_receipt_max_time: "收货/48小时内", //收货/48小时内"
      LanguageConfigKeys.Shop_order_consume: "共耗时", //共耗时
      LanguageConfigKeys.Shop_order_promise: "违约", //违约
      LanguageConfigKeys.Shop_order_platform_in: "平台介入", //平台介入
      LanguageConfigKeys.Shop_order_eligible: "当前订单符合「%s」条件", //当前订单符合「%s」条件
      LanguageConfigKeys.Shop_order_responsibility_division: "责任划分", //责任划分
      LanguageConfigKeys.Shop_order_platform_tip1:
          "平台处理原则，谁违约，谁担责；违约方承担对应邮费", //平台处理原则，谁违约，谁担责；违约方承担对应邮费
      LanguageConfigKeys.Shop_order_result: "处理结果", //处理结果
      LanguageConfigKeys.Shop_order_bear_the_postage: "由%s承担邮费", //由%s承担邮费
      LanguageConfigKeys.Shop_order_phone_verify: "手机验证", //手机验证
      LanguageConfigKeys.Shop_order_set_pay_pwd: "设置支付密码", //设置支付密码
      LanguageConfigKeys.Shop_order_confirm_pay_pwd: "确认支付密码", //确认支付密码
      LanguageConfigKeys.Shop_order_pay_pwd_error:
          "支付密码错误，请重新输入", //支付密码错误，请重新输入
      LanguageConfigKeys.Shop_order_id_verify: "身份验证", //身份验证
      LanguageConfigKeys.Shop_order_set_pay_pwd_tip:
          "请设置支付密码，用于支付验证", //请设置支付密码，用于支付验证
      LanguageConfigKeys.Shop_order_confirm_pay_pwd_tip: "请再次输入", //请再次输入
      LanguageConfigKeys.Shop_order_password_error:
          "您输入的密码不一致，请重新输入", //您输入的密码不一致，请重新输入
      LanguageConfigKeys.Shop_order_please_enter_pwd: "请输入支付密码", //请输入支付密码
      LanguageConfigKeys.Shop_order_prompt_pay_tip1: "截图保存二维码", //截图保存二维码
      LanguageConfigKeys.Shop_order_prompt_pay_tip2:
          "请打开您的任何手机银行应用进行扫码支付", //请打开您的任何手机银行应用进行扫码支付
      LanguageConfigKeys.Shop_order_prompt_pay_tip3: "请确认订单支付金额", //请确认订单支付金额
      LanguageConfigKeys.Shop_order_prompt_pay_tip4:
          "PromptPay不支持原路退款，产生退款，款项将退入您的账户余额", //PromptPay不支持原路退款，产生退款，款项将退入您的账户余额
      LanguageConfigKeys.Shop_order_prompt_pay_tip5:
          "付款成功后，请在此页面耐心等待片刻 点击下方按钮，查询付款状态", //付款成功后，请在此页面耐心等待片刻 点击下方按钮，查询付款状态
      LanguageConfigKeys.Shop_order_timeout: "支付超时", //支付超时
      LanguageConfigKeys.Shop_order_place_new_order:
          "订单已取消，请重新下单", //订单已取消，请重新下单
      LanguageConfigKeys.Shop_order_got_it: "明白了", //明白了
      LanguageConfigKeys.Shop_order_iknow: "知道了", //知道了
      LanguageConfigKeys.Shop_order_cancel_payment: "您已取消了支付", //您已取消了支付
      LanguageConfigKeys.Shop_order_after_pay_query: "付款后，点击查询", //付款后，点击查询
      LanguageConfigKeys.Shop_order_not_pay: "订单未支付，请先付款", //订单未支付，请先付款
      LanguageConfigKeys.Shop_order_paying: "订单处理中，请稍后再试", //订单处理中，请稍后再试
      LanguageConfigKeys.Shop_order_pay_failed: "支付失败", //支付失败
      LanguageConfigKeys.Shop_order_install_scb: "请安装SCB EASY", //请安装SCB EASY
      LanguageConfigKeys.Shop_order_download_tip:
          "您还未下载银行APP，请先下载!", //您还未下载银行APP，请先下载!
      LanguageConfigKeys.Shop_order_confirm_close_title:
          "确认要离开收银台?", //确认要离开收银台?
      LanguageConfigKeys.Shop_order_confirm_close_message:
          "您的订单还未完成支付\n请尽快支付!", //您的订单还未完成支付 请尽快支付!
      LanguageConfigKeys.Shop_order_confirm_close: "确认离开", //确认离开
      LanguageConfigKeys.Shop_order_confirm_continue: "继续支付", //继续支付
      LanguageConfigKeys.Shop_order_not_support_pay: "暂不支持该支付方式", //暂不支持该支付方式
      LanguageConfigKeys.Shop_order_insufficient_balance:
          "余额不足，请选择其它支付方式", //余额不足，请选择其它支付方式
      LanguageConfigKeys.Shop_order_package: "包裹", //包裹
      LanguageConfigKeys.Shop_order_selected: "已选%s张", //已选%s张
      LanguageConfigKeys.Shop_order_total_baby: "共%s件宝贝", //共%s件宝贝
      LanguageConfigKeys.Shop_order_return_coupon: "退回优惠券", //退回优惠券
      LanguageConfigKeys.Shop_order_return_coupon_tip:
          "优惠券已退回，您可再次使用", //优惠券已退回，您可再次使用
      LanguageConfigKeys.Shop_order_detail_address_nav: "地址导航", //地址导航
      LanguageConfigKeys.Shop_order_detail_address_nav_tip:
          "购买后，券码将发送至邮箱 / Web3钱包注册邮箱", //购买后，券码将发送至邮箱 / Web3钱包注册邮箱
      LanguageConfigKeys.Shop_sales_status: "售后状态", //售后状态
      LanguageConfigKeys.Shop_sales_policy: "售后政策", //售后政策
      LanguageConfigKeys.Shop_sales_refund: "未发货退款", //未发货退款
      LanguageConfigKeys.Shop_sales_refund_success: "退款成功", //退款成功
      LanguageConfigKeys.Shop_sales_refund_item1: "买错了", //买错了
      LanguageConfigKeys.Shop_sales_refund_item2: "朋友不推荐此商品", //朋友不推荐此商品
      LanguageConfigKeys.Shop_sales_refund_item3: "没有理由", //没有理由
      LanguageConfigKeys.Shop_sales_return_refund: "退货退款", //退货退款
      LanguageConfigKeys.Shop_sales_return_refund_item1: "符合退货退款条件", //符合退货退款条件
      LanguageConfigKeys.Shop_sales_overtime: "超时免单", //超时免单
      LanguageConfigKeys.Shop_sales_overtime_item1: "符合超时免单条件", //符合超时免单条件
      LanguageConfigKeys.Shop_sales_submit_order: "提交订单", //提交订单
      LanguageConfigKeys.Shop_sales_merchant_verify: "商家审核", //商家审核
      LanguageConfigKeys.Shop_sales_serivce_score: "服务评分", //服务评分
      LanguageConfigKeys.Shop_sales_delivery_serive: "快递服务", //快递服务
      LanguageConfigKeys.Shop_sales_verify_product: "审核商品", //审核商品
      LanguageConfigKeys.Shop_sales_detail: "售后详情", //售后详情
      LanguageConfigKeys.Shop_sales_pending_refunded: "待退款", //售后详情
      LanguageConfigKeys.Shop_sales_refunded: "已退款", //已退款
      LanguageConfigKeys.Shop_sales_refunded_reason: "退款原因", //退款原因
      LanguageConfigKeys.Shop_sales_number: "售后单号", //售后单号
      LanguageConfigKeys.Shop_sales_apply_time: "申请时间", //申请时间
      LanguageConfigKeys.Shop_sales_apply_type: "售后类型", //售后类型
      LanguageConfigKeys.Shop_sales_apply_reason: "申请原因", //申请原因
      LanguageConfigKeys.Shop_sales_take_info: "取件信息", //取件信息
      LanguageConfigKeys.Shop_sales_after_sales: "完成售后", //完成售后
      LanguageConfigKeys.Shop_sales_refund_time: "退款时间", //退款时间
      LanguageConfigKeys.Shop_sales_return_balance:
          "完成售后将退款至账户余额", //完成售后将退款至账户余额
      LanguageConfigKeys.Shop_sales_return_amount: "退款金额", //退款金额
      LanguageConfigKeys.Shop_sales_platform_in: "申请平台介入", //申请平台介入
      LanguageConfigKeys.Shop_sales_cancel_apply: "取消申请", //取消申请
      LanguageConfigKeys.Shop_sales_cancel_success: "取消申请成功", //取消申请成功
      LanguageConfigKeys.Shop_sales_least_two_pictures: "至少上传两张图片", // 至少上传两张图片
      LanguageConfigKeys.Shop_sales_apply: "售后申请", //售后申请
      LanguageConfigKeys.Shop_sales_processing: "处理中", //处理中
      LanguageConfigKeys.Shop_sales_completed: "售后完成", //售后完成
      LanguageConfigKeys.Shop_sales_application_record: "申请记录", //申请记录
      LanguageConfigKeys.Shop_sales_service: "售后服务", //售后服务
      LanguageConfigKeys.Shop_sales_service_tip1: "请根据实际情况进行选择", //请根据实际情况进行选择
      LanguageConfigKeys.Shop_sales_service_tip2:
          "若恶意售后，可能导致违规封禁30天", //若恶意售后，可能导致违规封禁30天
      LanguageConfigKeys.Shop_sales_order_elapsed: "订单已耗时", //订单已耗时
      LanguageConfigKeys.Shop_sales_overtime_tip1:
          "根据平台政策，超过7天未完成配送可申请超时免单", //根据平台政策，超过7天未完成配送可申请超时免单
      LanguageConfigKeys.Shop_sales_overtime_tip2:
          "售后处理完毕后收到商品，可不予退回", //售后处理完毕后收到商品，可不予退回
      LanguageConfigKeys.Shop_sales_overtime_tip3:
          "退款将根据选择的退款方式退回", //退款将根据选择的退款方式退回
      LanguageConfigKeys.Shop_sales_service_detail: "服务费明细", //服务费明细
      LanguageConfigKeys.Shop_sales_total_service_fee: "总服务费", //总服务费
      LanguageConfigKeys.Shop_sales_finish_route: "售后完成退款路径", //售后完成退款路径
      LanguageConfigKeys.Shop_sales_balance: "账号余额", //账号余额
      LanguageConfigKeys.Shop_sales_apply_submit: "提交申请", //提交申请
      LanguageConfigKeys.Shop_sales_verify_tip1:
          "请耐心等待商家审核，审核完成后24小时退款", //请耐心等待商家审核，审核完成后24小时退款
      LanguageConfigKeys.Shop_sales_verify_tip2: "请耐心等待商家审核", //请耐心等待商家审核
      LanguageConfigKeys.Shop_sales_verify_tip3:
          "售后申请已提交成功，待商家审核，将在%s小时内处理完毕!", //售后申请已提交成功，待商家审核，将在12小时内处理完毕
      LanguageConfigKeys.Shop_sales_refund_tip1:
          "仅限下单后24小时内更改地址及退款申请", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_refund_tip2:
          "订单产生的服务费及已使用的优惠券不予退还", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_return_refund_tip1:
          "仅限下单后24小时内更改地址及退款申请", //仅限下单后24小时内更改地址及退款申请
      LanguageConfigKeys.Shop_sales_return_refund_tip2:
          "订单产生的服务费及已使用的优惠券不予退还", //订单产生的服务费及已使用的优惠券不予退还
      LanguageConfigKeys.Shop_sales_upload_photo: "上传商品图片", //上传商品图片
      LanguageConfigKeys.Shop_sales_upload_photo_tip1:
          "请上传商品照片，若人为造成损坏，不支持退换货", //请上传商品照片，若人为造成损坏，不支持退换货
      LanguageConfigKeys.Shop_sales_upload_photo_tip2:
          "请保持商品包装完整性，店铺收货后将进行审核", //请保持商品包装完整性，店铺收货后将进行审核
      LanguageConfigKeys.Shop_address_add: "新增", //新增
      LanguageConfigKeys.Shop_address_select_change: "请选择更换地址", //请选择更换地址
      LanguageConfigKeys.Shop_address_receipt_address: "收货地址", //收货地址
      LanguageConfigKeys.Shop_address_receipt_address_empty: "暂无收货地址", //暂无收货地址
      LanguageConfigKeys.Shop_address_add_receipt_info: "新增收货信息", //新增收货信息
      LanguageConfigKeys.Shop_address_add_receipt_address: "添加收货地址", //添加收货地址
      LanguageConfigKeys.Shop_address_edit_receipt_address: "编辑收货地址", //编辑收货地址
      LanguageConfigKeys.Shop_address_postcode_select: "选择邮编", //选择邮编
      LanguageConfigKeys.Shop_address_set_as_default_address: "设为默认", //设为默认
      LanguageConfigKeys.Shop_address_default: "默认", //默认
      LanguageConfigKeys.Shop_address_consignee: "收货人", //收货人
      LanguageConfigKeys.Shop_address_phone: "手机号", //手机号
      LanguageConfigKeys.Shop_address_location: "所在地区", //所在地区
      LanguageConfigKeys.Shop_address_my_location: "定位", //定位
      LanguageConfigKeys.Shop_address_Locating: "正在定位", //正在定位
      LanguageConfigKeys.Shop_address_detail_address: "详细地址", //详细地址
      LanguageConfigKeys.Shop_address_post_code: "邮编", //邮编
      LanguageConfigKeys.Shop_address_consignee_empty: "请输入收货人姓名", //请输入收货人姓名
      LanguageConfigKeys.Shop_address_phone_empty: "请输入收货人手机号", //请输入收货人手机号
      LanguageConfigKeys.Shop_address_location_empty: "请选择收货人所在地区", //请选择收货人所在地区
      LanguageConfigKeys.Shop_address_detail_address_empty:
          "请输入详细收货地址", //请输入详细收货地址
      LanguageConfigKeys.Shop_address_detail_address_hint:
          "请输入详细收货地址，精确到门牌号", //请输入详细收货地址，精确到门牌号
      LanguageConfigKeys.Shop_address_post_code_empty: "请输入邮编", //请输入邮编
      LanguageConfigKeys.Shop_address_save: "保存", //保存
      LanguageConfigKeys.Shop_address_is_delete: "是否删除收货地址?", //是否删除收货地址?
      LanguageConfigKeys.Shop_address_select: "选择", //选择
      LanguageConfigKeys.Shop_address_please_select: "请选择", //请选择
      LanguageConfigKeys.Shop_address_please_enter: "请输入", //请输入
      LanguageConfigKeys.Shop_address_street_address: "街道及门牌", //街道及门牌
      LanguageConfigKeys.Shop_address_assist_enter: "辅助", //辅助
      LanguageConfigKeys.Shop_address_confirm_detail_address:
          "请确定详细地址", //请确定详细地址
      LanguageConfigKeys.Shop_address_contact_info: "联络信息", //联络信息
      LanguageConfigKeys.Shop_address_address_info: "地址信息", //地址信息
      LanguageConfigKeys.Shop_address_please_select_region: "请选择区域", //请选择区域
      LanguageConfigKeys.Shop_address_get_current_location: "获取当前定位", //获取当前定位
      LanguageConfigKeys.Shop_address_found_for_you: "已为您找到", //已为您找到
      LanguageConfigKeys.Shop_address_government: "府", //府
      LanguageConfigKeys.Shop_address_county: "县", //县
      LanguageConfigKeys.Shop_address_village: "镇", //镇
      LanguageConfigKeys.Shop_address_keywords: "请输入地址关键词", //请输入地址关键词
      LanguageConfigKeys.Shop_address_finish: "完成", //完成
      LanguageConfigKeys.Shop_address_confirm_delivery_correct:
          "请确认正确收件信息，避免收件延迟", //请确认正确收件信息，避免收件延迟
      LanguageConfigKeys.Shop_setting_title: "设置", //设置
      LanguageConfigKeys.Shop_setting_subscribe_follow: "订阅与关注", //订阅与关注
      LanguageConfigKeys.Shop_setting_subscribe_follow_detail:
          "管理你的订阅与关注", //管理你的订阅与关注
      LanguageConfigKeys.Shop_setting_notification_manage: "通知管理", //通知管理
      LanguageConfigKeys.Shop_setting_notification_manage_detail:
          "是否接受推荐和关注的消息", //是否接受推荐和关注的消息
      LanguageConfigKeys.Shop_setting_privacy_setting: "隐私设置", //隐私设置
      LanguageConfigKeys.Shop_setting_privacy_setting_detail:
          "管理其他人看到的信息内容", //管理其他人看到的信息内容
      LanguageConfigKeys.Shop_setting_account_safe: "账号与安全", //账号与安全
      LanguageConfigKeys.Shop_setting_account_safe_detail:
          "更改手机号、密码与账号绑定", //更改手机号、密码与账号绑定
      LanguageConfigKeys.Shop_setting_Language_change: "语言切换", //语言切换
      LanguageConfigKeys.Shop_setting_Language_change_detail:
          "切换默认界面语言，默认为当前系统语言", //切换默认界面语言，默认为当前系统语言
      LanguageConfigKeys.Shop_setting_user_agreement: "用户协议", //用户协议
      LanguageConfigKeys.Shop_setting_user_agreement_detail:
          "根据相关法律法规签署并遵照执行", //根据相关法律法规签署并遵照执行
      LanguageConfigKeys.Shop_setting_about: "关于", //关于
      LanguageConfigKeys.Shop_setting_about_detail: "关于MXCOME", //关于MXCOME
      LanguageConfigKeys.Shop_setting_about_version: "版本号", //版本号
      LanguageConfigKeys.Shop_setting_about_new_version: "新版本", //新版本
      LanguageConfigKeys.Shop_setting_last_version: "已是最新版本", // 已是最新版本
      LanguageConfigKeys.Shop_setting_update_new_version: "有新版本啦!", //有新版本啦!
      LanguageConfigKeys.Shop_setting_update_time: "更新时间", //更新时间
      LanguageConfigKeys.Shop_setting_now_update: "立即更新", //立即更新
      LanguageConfigKeys.Shop_setting_account_cancellation: "注销账号", //注销账号
      LanguageConfigKeys.Shop_setting_account_cancellation_detail:
          "删除所有数据，永久注销", //删除所有数据，永久注销
      LanguageConfigKeys.Shop_setting_account_cancel_tip1:
          "这将注销你的账号", //这将注销你的账号
      LanguageConfigKeys.Shop_setting_account_cancel_tip2:
          "必须注意，你的MXCOME账号（包括你的用户ID、昵称、个人资料、资产余额等）将在MXCOME永久删除，无法找回。", //必须注意，你的MXCOME账号（包括你的用户ID、昵称、个人资料、资产余额等）将在MXCOME永久删除，无法找回。
      LanguageConfigKeys.Shop_setting_account_delete: "注销", //注销
      LanguageConfigKeys.Shop_setting_account_confirm_delete: "确认注销账号", //确认注销账号
      LanguageConfigKeys.Shop_setting_account_confirm_tip1:
          "账户余额%s，将永久失效", //账户余额%s，将永久失效
      LanguageConfigKeys.Shop_setting_account_confirm_tip2:
          "账号信息及收益记录等数据无法恢复", //账号信息及收益记录等数据无法恢复
      LanguageConfigKeys.Shop_setting_account_not_delete: "暂不注销", //暂不注销
      LanguageConfigKeys.Shop_setting_account_now_delete: "立即注销", //立即注销
      LanguageConfigKeys.Shop_setting_change_login: "切换账号", //切换账号
      LanguageConfigKeys.Shop_setting_exit_login: "退出登录", //退出登录
      LanguageConfigKeys.Shop_setting_phone: "手机号", //手机号
      LanguageConfigKeys.Shop_setting_phone_detail: "修改手机号", //修改手机号
      LanguageConfigKeys.Shop_setting_update: "修改", //修改
      LanguageConfigKeys.Shop_setting_update_pwd: "修改密码", //修改密码
      LanguageConfigKeys.Shop_setting_update_pwd_detail: "随时修改你的密码", //随时修改你的密码
      LanguageConfigKeys.Shop_setting_pay_pwd: "支付密码", //支付密码
      LanguageConfigKeys.Shop_setting_set_pay_pwd: "设置支付密码", //设置支付密码
      LanguageConfigKeys.Shop_setting_change_pay_pwd: "修改支付密码", //修改支付密码
      LanguageConfigKeys.Shop_setting_pay_pwd_detail: "设置与修改支付密码", //设置与修改支付密码
      LanguageConfigKeys.Shop_setting_third_auth: "第三方授权", //第三方授权
      LanguageConfigKeys.Shop_setting_facebook: "Facebook", //Facebook
      LanguageConfigKeys.Shop_setting_google: "Google", //Google
      LanguageConfigKeys.Shop_setting_apple: "Apple", //Apple
      LanguageConfigKeys.Shop_setting_bind: "绑定", //绑定
      LanguageConfigKeys.Shop_setting_unbind: "解绑", //解绑
      LanguageConfigKeys.Shop_activity: "活动", //活动
      LanguageConfigKeys.Shop_activity_sponsor: "主办方", //主办方
      LanguageConfigKeys.Shop_activity_time: "活动时间", //活动时间
      LanguageConfigKeys.Shop_activity_complete_task: "完成淘金任务", //完成淘金任务
      LanguageConfigKeys.Shop_activity_obtain_goods_profit: "获得商品分润", //获得商品分润
      LanguageConfigKeys.Shop_activity_obtain_level_prize: "获得关卡奖励", //获得关卡奖励
      LanguageConfigKeys.Shop_activity_obtain_top_prize: "获得排名大奖", //获得排名大奖
      LanguageConfigKeys.Shop_activity_obtain_top_prize_tips: "排名大奖", //排名大奖
      LanguageConfigKeys.Shop_activity_now_start: "立即挑战", //立即挑战
      LanguageConfigKeys.Shop_activity_quick_understand: "快速了解", //快速了解
      LanguageConfigKeys.Shop_activity_top: "%s名", //%名
      LanguageConfigKeys.Shop_activity_count_down: "倒计时", //倒计时
      LanguageConfigKeys.Shop_activity_level_count: "当前关卡", //当前关卡
      LanguageConfigKeys.Shop_activity_level_prize: "关卡奖", //关卡奖
      LanguageConfigKeys.Shop_activity_this_task: "本关任务", //本关任务
      LanguageConfigKeys.Shop_activity_closed: "已结束", //已结束
      LanguageConfigKeys.Shop_activity_not_exist: "活动已结束", //活动已结束
      LanguageConfigKeys.Shop_activity_current_top: "当前排名", //当前排名
      LanguageConfigKeys.Shop_activity_activity_top: "活动排名", //活动排名
      LanguageConfigKeys.Shop_activity_not_listed: "未上榜", //未上榜
      LanguageConfigKeys.Shop_activity_top_big_prize: "排名大奖", //排名大奖
      LanguageConfigKeys.Shop_activity_get_gold: "已淘金", //已淘金
      LanguageConfigKeys.Shop_activity_for_the_level: "第%s关", //第%s关
      LanguageConfigKeys.Shop_activity_st_place: "%s等奖", //%s等奖
      LanguageConfigKeys.Shop_activity_random_level_prize:
          "关卡奖励随机分配1件，完成活动挑战领取", //关卡奖励随机分配1件，完成活动挑战领取
      LanguageConfigKeys.Shop_activity_details: "活动闯关", //活动闯关
      LanguageConfigKeys.Shop_activity_over_status: "通关状态", //通关状态
      LanguageConfigKeys.Shop_activity_after_the_prize: "完赛后领取奖励", //完赛后领取奖励
      LanguageConfigKeys.Shop_activity_over_all_level: "已通关", //已通关
      LanguageConfigKeys.Shop_activity_failed: "淘汰", //淘汰
      LanguageConfigKeys.Shop_activity_not_start: "未开始", //未开始
      LanguageConfigKeys.Shop_activity_doing: "进行中", //进行中
      LanguageConfigKeys.Shop_activity_prize: "活动奖品", //活动奖品
      LanguageConfigKeys.Shop_activity_view_prize: "查看奖品", //查看奖品
      LanguageConfigKeys.Shop_activity_enter_activity: "查看活动", //查看活动
      LanguageConfigKeys.Shop_activity_now_break_barrier: "立即闯关", //立即闯关
      LanguageConfigKeys.Shop_activity_continue_break_barrier: "继续闯关", //继续闯关
      LanguageConfigKeys.Shop_activity_podium: "领奖台", //领奖台
      LanguageConfigKeys.Shop_activity_completed_game: "完赛", //完赛
      LanguageConfigKeys.Shop_activity_mine_prize: "我的奖励", //我的奖励
      LanguageConfigKeys.Shop_activity_dispatched: "已派完", //已派完
      LanguageConfigKeys.Shop_activity_task_progressing: "任务进行中", //任务进行中
      LanguageConfigKeys.Shop_activity_activity_progressing: "活动进行中", //活动进行中
      LanguageConfigKeys.Shop_activity_task_randomly_prize:
          "待任务完成后系统将随机发放任务奖励", //待任务完成后系统将随机发放任务奖励
      LanguageConfigKeys.Shop_activity_activity_randomly_prize:
          "待活动完成后系统将随机发放关卡奖励", //待活动完成后系统将随机发放关卡奖励
      LanguageConfigKeys.Shop_activity_for_the_level_prize: "第%s关奖励", //第%s关奖励
      LanguageConfigKeys.Shop_activity_top_prize: "排名奖", //排名奖
      LanguageConfigKeys.Shop_activity_task_prize: "任务奖品", //任务奖品
      LanguageConfigKeys.Shop_activity_congratulation_complete_activity:
          "恭喜，完成活动任务", //恭喜，完成活动任务
      LanguageConfigKeys.Shop_activity_congratulation_complete_task:
          "恭喜，完成任务", //恭喜，完成任务
      LanguageConfigKeys.Shop_activity_get: "领取", //领取
      LanguageConfigKeys.Shop_activity_received: "已领取", //已领取
      LanguageConfigKeys.Shop_activity_expired: "已过期", //已过期
      LanguageConfigKeys.Shop_activity_lottery_draw: "抽奖", //抽奖
      LanguageConfigKeys.Shop_activity_get_prize: "领奖", //领奖
      LanguageConfigKeys.Shop_activity_get_prize_stop: "领奖截止", //领奖
      LanguageConfigKeys.Shop_activity_available: "可领取", //可领取
      LanguageConfigKeys.Shop_activity_item_level_prize: "件关卡奖励", //件关卡奖励
      LanguageConfigKeys.Shop_activity_item_top_prize: "件排名奖励", //件排名奖励
      LanguageConfigKeys.Shop_activity_item_task_prize: "件任务奖励", //件任务奖励
      LanguageConfigKeys.Shop_activity_no_prize_available: "暂无可领取奖励", //暂无可领取奖励
      LanguageConfigKeys.Shop_activity_please_select_prize: "请选择奖励", //请选择奖励
      LanguageConfigKeys.Shop_activity_history_activities: "历史活动", //历史活动
      LanguageConfigKeys.Shop_activity_history_tasks: "历史任务", //历史任务
      LanguageConfigKeys.Shop_activity_draw_now: "立即抽奖", //立即抽奖
      LanguageConfigKeys.Shop_activity_continue_draw: "继续抽奖", //继续抽奖
      LanguageConfigKeys.Shop_activity_total_mxget: "本次活动共计淘金", //本次活动共计淘金
      LanguageConfigKeys.Shop_activity_mxget_detail: "淘金明细", //淘金明细
      LanguageConfigKeys.Shop_activity_view_details: "查看明细", //查看明细
      LanguageConfigKeys.Shop_activity_activity_achievements: "活动成就", //活动成就
      LanguageConfigKeys.Shop_activity_level_draw_now_tip:
          "活动统计完成后可抽奖，祝您好运", //活动统计完成后可抽奖，祝您好运
      LanguageConfigKeys.Shop_activity_top_rewards_tip:
          "活动结束并获得活动排名，统计结束可领奖", //活动结束并获得活动排名，统计结束可领奖
      LanguageConfigKeys.Shop_activity_statistics_completed: "距离统计完成", //距离统计完成
      LanguageConfigKeys.Shop_activity_countdown_drawing_receiving_prize:
          "抽/领奖倒计时", //抽/领奖倒计时
      LanguageConfigKeys.Shop_activity_no_level_reward_tip:
          "未获得关卡奖励，再接再厉", //未获得关卡奖励，再接再厉
      LanguageConfigKeys.Shop_activity_no_rank_reward_tip:
          "排名未入围，再接再厉", //排名未入围，再接再厉
      LanguageConfigKeys.Shop_activity_success_get_level_reward_tip:
          "恭喜获取关卡奖", //恭喜获取关卡奖
      LanguageConfigKeys.Shop_activity_success_get_rank_reward_tip:
          "恭喜获取排名奖", //恭喜获取排名奖
      LanguageConfigKeys.Shop_activity_no_prizes_level: "该关卡没有奖品", //该关卡没有奖品
      LanguageConfigKeys.Shop_activity_lottery_complete: "完成", //完成
      LanguageConfigKeys.Shop_activity_lottery_tip1:
          "点击“立即抽奖”按钮开始抽奖", //点击“立即抽奖”按钮开始抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip2:
          "每关仅有1次抽奖机会，按顺序完成抽奖", //每关仅有1次抽奖机会，按顺序完成抽奖
      LanguageConfigKeys.Shop_activity_lottery_tip3: "部分商品需要支付差额", //部分商品需要支付差额
      LanguageConfigKeys.Shop_activity_lottery_tip4:
          "本活动最终解释权归平台所有", //本活动最终解释权归平台所有
      LanguageConfigKeys.Shop_activity_click_challenge: "点击即可开始挑战", //点击即可开始挑战
      LanguageConfigKeys.Shop_activity_challenge_failed_profit:
          "挑战失败，仍可计算成交分润", //挑战失败，仍可计算成交分润
      LanguageConfigKeys.Shop_activity_abandoning: "放弃活动", //放弃活动
      LanguageConfigKeys.Shop_activity_rules: "活动规则", //活动规则
      LanguageConfigKeys.Shop_activity_complete_level_lock_new_level:
          "完成本关，即可解锁新关", //完成本关，即可解锁新关
      LanguageConfigKeys.Shop_activity_ranking_information:
          "参与后展示排名信息", //参与后展示排名信息
      LanguageConfigKeys.Shop_activity_rule_tip1:
          "每关任意成交1单，即可解锁新关卡", //每关任意成交1单，即可解锁新关卡
      LanguageConfigKeys.Shop_activity_rule_tip2:
          "关卡挑战成功，在领奖台抽取关卡奖", //关卡挑战成功，在领奖台抽取关卡奖
      LanguageConfigKeys.Shop_activity_rule_tip3:
          "活动挑战成功，根据排名获得排名奖", //活动挑战成功，根据排名获得排名奖
      LanguageConfigKeys.Shop_activity_rule_tip4:
          "成交越多，完成速度越快，排名越高", //成交越多，完成速度越快，排名越高
      LanguageConfigKeys.Shop_activity_abandoning_tip:
          "活动期间不得再次参与本次活动\n已成交的商品将在统计期后分润", //活动期间不得再次参与本次活动\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_success_participated: "参与成功", //参与成功
      LanguageConfigKeys.Shop_activity_success_participated_tip1:
          "恭喜，成功参与淘金活动", //恭喜，成功参与淘金活动
      LanguageConfigKeys.Shop_activity_success_participated_tip2:
          "努力闯关，获得属于你的丰厚利润与奖品", //努力闯关，获得属于你的丰厚利润与奖品
      LanguageConfigKeys.Shop_activity_confirm_abandonment: "确定放弃", //确定放弃
      LanguageConfigKeys.Shop_activity_arbitrary_deal: "任意成交1单", //任意成交1单
      LanguageConfigKeys.Shop_activity_deal: "成交", //成交
      LanguageConfigKeys.Shop_activity_one_step_success: "距成功一步之遥", //距成功一步之遥
      LanguageConfigKeys.Shop_activity_continue_recommend:
          "活动结束前，可以继续推荐", //活动结束前，可以继续推荐
      LanguageConfigKeys.Shop_activity_wait_statistics_completed:
          "恭喜，请耐心等待统计完成", //恭喜，请耐心等待统计完成
      LanguageConfigKeys.Shop_activity_congratulations_get_prize:
          "恭喜完成，点击领奖", //恭喜完成，点击领奖
      LanguageConfigKeys.Shop_activity_successfully_crossed: "闯关成功", //闯关成功
      LanguageConfigKeys.Shop_activity_successfully_crossed_tip:
          "恭喜，闯关成功，好的开始是成功的一半！\n活动期间，您可选择任意已解锁关卡继续推荐", //恭喜，闯关成功，好的开始是成功的一半！\n活动期间，您可选择任意已解锁关卡继续推荐
      LanguageConfigKeys.Shop_activity_enter_next_level: "进入下一关", //进入下一关
      LanguageConfigKeys.Shop_activity_all_level_success: "恭喜通关", //恭喜通关
      LanguageConfigKeys.Shop_activity_all_level_success_tip:
          "恭喜您顺利完成所有活动关卡\n当前仍有时间，继续推荐冲刺排名大奖", //恭喜您顺利完成所有活动关卡\n当前仍有时间，继续推荐冲刺排名大奖
      LanguageConfigKeys.Shop_activity_all_level_success_tip2:
          "恭喜您顺利完成所有活动关卡", //恭喜您顺利完成所有活动关卡
      LanguageConfigKeys.Shop_activity_obsolete: "已淘汰", //已淘汰
      LanguageConfigKeys.Shop_activity_obsolete_tip:
          "失败乃成功之母，您可以再次发起挑战！\n已成交的商品将在统计期后分润", //失败乃成功之母，您可以再次发起挑战！\n已成交的商品将在统计期后分润
      LanguageConfigKeys.Shop_activity_homepage: "返回首页", //返回首页
      LanguageConfigKeys.Shop_activity_remaining_collection_time:
          "截止领奖时间", //截止领奖时间
      LanguageConfigKeys.Shop_activity_waiting_statistics: "等待统计完成", //等待统计完成
      LanguageConfigKeys.Shop_activity_get_prize_finish: "领奖时间已结束", //领奖时间已结束
      LanguageConfigKeys.Shop_activity_selected: "已抽中", //已抽中
      LanguageConfigKeys.Shop_activity_total_prizes: "奖品总计", //奖品总计
      LanguageConfigKeys.Shop_activity_after_receiving_check_order:
          "领奖后请在订单查看", //领奖后请在订单查看
      LanguageConfigKeys.Shop_activity_no_lottery: "未抽奖", //未抽奖
      LanguageConfigKeys.Shop_activity_not_counted: "未统计", //未统计
      LanguageConfigKeys.Shop_activity_mxget_activity: "淘金活动", //淘金活动
      LanguageConfigKeys.Shop_activity_48_hours: "距活动结束不足48小时", //距活动结束不足48小时
      LanguageConfigKeys.Shop_activity_soon_timeout: "接受活动后请尽快完成", //接受活动后请尽快完成
      LanguageConfigKeys.Shop_pocket: "口袋", //口袋
      LanguageConfigKeys.Shop_pocket_task: "任务", //任务
      LanguageConfigKeys.Shop_pocket_late_task_over: "来晚了，任务已结束", //来晚了，任务已结束
      LanguageConfigKeys.Shop_pocket_select_product: "选择商品", //选择商品
      LanguageConfigKeys.Shop_pocket_task_over: "任务已结束", //任务已结束
      LanguageConfigKeys.Shop_pocket_completed_profit: "完成分润", //完成分润
      LanguageConfigKeys.Shop_pocket_obsolete: "已淘汰", //已淘汰
      LanguageConfigKeys.Shop_pocket_share_profit: "分润", //分润
      LanguageConfigKeys.Shop_pocket_profit: "利润", //利润
      LanguageConfigKeys.Shop_pocket_task_stock: "任务库存", //任务库存
      LanguageConfigKeys.Shop_pocket_task_start_time: "任务开始时间", //任务开始时间
      LanguageConfigKeys.Shop_pocket_level: "口袋", //口袋
      LanguageConfigKeys.Shop_pocket_more_orders_to_level:
          "距%s还需要完成%s单", //距%s还需要完成%s单
      LanguageConfigKeys.Shop_pocket_detail: "口袋详情", //口袋详情
      LanguageConfigKeys.Shop_pocket_see_rules: "查看规则", //查看规则
      LanguageConfigKeys.Shop_pocket_activity_rules: "活动规则", //活动规则
      LanguageConfigKeys.Shop_pocket_mine_pocket: "我的口袋", //我的口袋
      LanguageConfigKeys.Shop_pocket_task_volume: "任务容量", //任务容量
      LanguageConfigKeys.Shop_pocket_activity_volume: "活动容量", //活动容量
      LanguageConfigKeys.Shop_pocket_pocket_upgrade: "口袋升级", //口袋升级
      LanguageConfigKeys.Shop_pocket_accept_share_profit: "最大分润", //最大分润
      LanguageConfigKeys.Shop_pocket_mine_income: "我的收益", //我的收益
      LanguageConfigKeys.Shop_pocket_history_income: "历史收益", //历史收益
      LanguageConfigKeys.Shop_pocket_this_month_income: "本月收益", //本月收益
      LanguageConfigKeys.Shop_pocket_today_income: "今日收益", //今日收益
      LanguageConfigKeys.Shop_pocket_like: "点赞", //点赞
      LanguageConfigKeys.Shop_pocket_like_empty_tip:
          "点赞心仪的商品\n我们将根据您的喜好进行商品及任务推荐", //点赞心仪的商品\n我们将根据您的喜好进行商品及任务推荐
      LanguageConfigKeys.Shop_pocket_go_stroll: "去逛逛", //去逛逛
      LanguageConfigKeys.Shop_pocket_tasking: "正在进行", //正在进行
      LanguageConfigKeys.Shop_pocket_mxget_history: "淘金历史", //淘金历史
      LanguageConfigKeys.Shop_pocket_task_completion_degree: "完成%s", //完成%s
      LanguageConfigKeys.Shop_pocket_days: "天", //天
      LanguageConfigKeys.Shop_pocket_hours: "时", //时
      LanguageConfigKeys.Shop_pocket_copy_link: "复制链接", //复制链接
      LanguageConfigKeys.Shop_pocket_add: "添加", //添加
      LanguageConfigKeys.Shop_pocket_incomplete: "未完成", //未完成
      LanguageConfigKeys.Shop_pocket_completed: "已完成", //已完成
      LanguageConfigKeys.Shop_pocket_time: "任务时间", //任务时间
      LanguageConfigKeys.Shop_pocket_lock_stock: "锁定库存", //锁定库存
      LanguageConfigKeys.Shop_pocket_maximum_profit_sharing: "最大分润", //最大分润
      LanguageConfigKeys.Shop_pocket_piece: "件", //件
      LanguageConfigKeys.Shop_pocket_accept_task: "接受任务", //接受任务
      LanguageConfigKeys.Shop_pocket_space: "口袋空间", //口袋空间
      LanguageConfigKeys.Shop_pocket_order_received_success:
          "恭喜，接单成功", //恭喜，接单成功
      LanguageConfigKeys.Shop_pocket_order_receiving_failed:
          "抱歉，接单失败", //抱歉，接单失败
      LanguageConfigKeys.Shop_pocket_rule_title: "接单规则", //接单规则
      LanguageConfigKeys.Shop_pocket_rule_tip1: "店铺全部品牌自营 ",
      LanguageConfigKeys.Shop_pocket_rule_tip2: "淘金达人 0 资金投入 ",
      LanguageConfigKeys.Shop_pocket_rule_tip3: "用户向好友推荐商品 ",
      LanguageConfigKeys.Shop_pocket_rule_tip4: "好友确认收货 ",
      LanguageConfigKeys.Shop_pocket_rule_tip5: "多推多赚 ",
      LanguageConfigKeys.Shop_pocket_rule_tip6: "达人可接任务数量取决于口袋等级 ",
      LanguageConfigKeys.Shop_pocket_rule_tip7: "任务及活动时间结束 ",
      LanguageConfigKeys.Shop_pocket_rule_tip8: "用户提现  ",
      LanguageConfigKeys.Shop_pocket_rule_tip9: "不可违规刷单 ",
      LanguageConfigKeys.Shop_pocket_rule_tip10: "用户自觉遵守国家法律规定 ",
      LanguageConfigKeys.Shop_pocket_rule_value_tip1: "100%正品及官方售后保障",
      LanguageConfigKeys.Shop_pocket_rule_value_tip2: "一台手机轻松接单赚钱",
      LanguageConfigKeys.Shop_pocket_rule_value_tip3: "好友成交即可获得收益",
      LanguageConfigKeys.Shop_pocket_rule_value_tip4: "收益自动转入余额，随时提现",
      LanguageConfigKeys.Shop_pocket_rule_value_tip5: "口袋等级越高，可接任务分润越高",
      LanguageConfigKeys.Shop_pocket_rule_value_tip6: "越高越多",
      LanguageConfigKeys.Shop_pocket_rule_value_tip7: "淘金达人任务自然中止",
      LanguageConfigKeys.Shop_pocket_rule_value_tip8: "必须要完成实名认证及银行卡绑定",
      LanguageConfigKeys.Shop_pocket_rule_value_tip9: "系统若判定违规，将暂停接单",
      LanguageConfigKeys.Shop_pocket_rule_value_tip10: "对收入依法纳税",
      LanguageConfigKeys.Shop_pocket_simple_level: "等级", //等级
      LanguageConfigKeys.Shop_pocket_simple_capacity: "容量", //容量
      LanguageConfigKeys.Shop_pocket_simple_foul: "违规", //违规
      LanguageConfigKeys.Shop_pocket_success_tips1:
          "想快速提高收益，立即关注淘金学院", //想快速提高收益，立即关注淘金学院
      LanguageConfigKeys.Shop_pocket_success_tips2:
          "请在任务时间内完成，多推多得", //请在任务时间内完成，多推多得
      LanguageConfigKeys.Shop_pocket_success_tips3:
          "接单将占用一个任务容量，支持更换", //接单将占用一个任务容量，支持更换
      LanguageConfigKeys.Shop_pocket_failed_level_tips:
          "请继续完成现有任务，不可重复接单", //请继续完成现有任务，不可重复接单
      LanguageConfigKeys.Shop_pocket_failed_capacity_tips:
          "请提升任务口袋等级，达到接单资格", //请提升任务口袋等级，达到接单资格
      LanguageConfigKeys.Shop_pocket_failed_foul_tips:
          "违规封禁时间结束后，自动恢复接单", //违规封禁时间结束后，自动恢复接单
      LanguageConfigKeys.Shop_pocket_view_pockets: "查看口袋", //查看口袋
      LanguageConfigKeys.Shop_pocket_select_a_task: "请选择一个任务", //请选择一个任务
      LanguageConfigKeys.Shop_pocket_task_stock_insufficient: "任务库存不足", //任务库存不足
      LanguageConfigKeys.Shop_pocket_total_pieces: "共计%s件", //共计%s件
      LanguageConfigKeys.Shop_pocket_complete_orders: "完成10单", //完成10单
      LanguageConfigKeys.Shop_pocket_task_prize: "任务奖品", //任务奖品
      LanguageConfigKeys.Shop_pocket_tip: "友情提示", //友情提示
      LanguageConfigKeys.Shop_pocket_48_hours: "距任务结束不足48小时", //距任务结束不足48小时
      LanguageConfigKeys.Shop_pocket_task_soon_timeout:
          "接受任务后请尽快完成", //接受任务后请尽快完成
      LanguageConfigKeys.Shop_pocket_task_end_time: "任务截止: ", //任务截止
      LanguageConfigKeys.Shop_pocket_goods_sold: "商品已售", //商品已售
      LanguageConfigKeys.Shop_pocket_goods_stock: "商品库存: ", //商品库存
      LanguageConfigKeys.Shop_pocket_task_detail: "任务详情", //任务详情
      LanguageConfigKeys.Shop_pocket_rule_policy: "规则策略", //规则策略
      LanguageConfigKeys.Shop_pocket_number_to_be_completed: "完成单量", //完成单量
      LanguageConfigKeys.Shop_pocket_task_profit_sharing: "可接分润", //可接分润
      LanguageConfigKeys.Shop_pocket_upgrade: "升级后", //升级后
      LanguageConfigKeys.Shop_pocket_current_level: "当前等级", //当前等级
      LanguageConfigKeys.Shop_pocket_current_level_tip:
          "可接分润≤%s的所有任务商品", //可接分润≤%s的所有任务商品
      LanguageConfigKeys.Shop_pocket_doing: "进行中", //进行中
      LanguageConfigKeys.Shop_pocket_counted: "待统计", //待统计
      LanguageConfigKeys.Shop_pocket_challenge_now: "立即挑战", //立即挑战
      LanguageConfigKeys.Shop_pocket_continue_to_challenge: "继续挑战", //继续挑战
      LanguageConfigKeys.Shop_pocket_join_now: "立即参与", //立即参与
      LanguageConfigKeys.Shop_pocket_participated: "已参与", //已参与
      LanguageConfigKeys.Shop_pocket_task_completed: "已成交", //已成交
      LanguageConfigKeys.Shop_pocket_conversion_rate: "转化率", //转化率
      LanguageConfigKeys.Shop_pocket_remain: "还剩", //还剩
      LanguageConfigKeys.Shop_pocket_counted_shop: "统计完成", //统计完成
      LanguageConfigKeys.Shop_pocket_completed_counted: "已完成统计", //已完成统计
      LanguageConfigKeys.Shop_pocket_task_counted_tip:
          "1.任务结束进入%s天统计期\n2.统计完成，动态收益转入余额，可提现，用户退单将取消收益", //任务结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_activity_counted_tip:
          "1.活动结束进入%s天统计期\n2.统计完成，动态收益转入余额，可提现，用户退单将取消收益", //活动结束后%s天，动态收益自动入账至账户余额，可提现
      LanguageConfigKeys.Shop_pocket_task_finish: "已完结", //已完结
      LanguageConfigKeys.Shop_pocket_get_now: "立即领取", //立即领取
      LanguageConfigKeys.Shop_pocket_upcoming_profits: "即将分润", //即将分润
      LanguageConfigKeys.Shop_pocket_upcoming_award: "即将派奖", //即将派奖
      LanguageConfigKeys.Shop_pocket_recommend_now: "立即推荐", //立即推荐
      LanguageConfigKeys.Shop_pocket_buyer: "购买者", //购买者
      LanguageConfigKeys.Shop_pocket_purchase_record: "成交记录", //成交记录
      LanguageConfigKeys.Shop_pocket_purchase_users: "用户", //用户
      LanguageConfigKeys.Shop_pocket_purchase_time: "购买时间", //购买时间
      LanguageConfigKeys.Shop_pocket_purchase_quantity: "数量", //数量
      LanguageConfigKeys.Shop_pocket_chargeback_record: "退单记录", //退单记录
      LanguageConfigKeys.Shop_pocket_chargeback_time: "退单时间", //退单时间
      LanguageConfigKeys.Shop_pocket_total_purchase: "总成交收益", //总成交收益
      LanguageConfigKeys.Shop_pocket_total_chargeback: "总退单收益", //总退单收益
      LanguageConfigKeys.Shop_pocket_sold_out: "已售罄", //已售罄
      LanguageConfigKeys.Shop_pocket_prize: "奖品", //奖品
      LanguageConfigKeys.Shop_pocket_promotion_center: "推广中心", //推广中心
      LanguageConfigKeys.Shop_pocket_promotion_qualification: "推广资格", //推广资格
      LanguageConfigKeys.Shop_pocket_red_level: "红包闯关 ", //红包闯关
      LanguageConfigKeys.Shop_pocket_not_active: "未激活", //未激活
      LanguageConfigKeys.Shop_pocket_activated: "已激活", //已激活
      LanguageConfigKeys.Shop_pocket_not_red_level: "未获得红包闯关资格", //未获得红包闯关资格
      LanguageConfigKeys.Shop_pocket_earned: "已赚到", //已赚到
      LanguageConfigKeys.Shop_pocket_period_validity: "有效期", //有效期
      LanguageConfigKeys.Shop_pocket_complete_task_tip:
          "请于有效期内完成任意任务", //请于有效期内完成任意任务
      LanguageConfigKeys.Shop_pocket_mxget_task: "淘金任务", //淘金任务
      LanguageConfigKeys.Shop_pocket_change_task: "更换任务", //更换任务
      LanguageConfigKeys.Shop_pocket_current_task: "当前任务", //当前任务
      LanguageConfigKeys.Shop_pocket_this_week: "本周", //本周
      LanguageConfigKeys.Shop_pocket_this_month: "本月", //本月
      LanguageConfigKeys.Shop_pocket_last_month: "上月", //上月
      LanguageConfigKeys.Shop_pocket_enable_prize: "可领奖", //可领奖
      LanguageConfigKeys.Shop_pocket_winning_task_prize: "获得任务奖品", //获得任务奖品
      LanguageConfigKeys.Shop_pocket_winning_task_prize_tip:
          "领奖后，可在订单中查看发货状态", //领奖后，可在订单中查看发货状态
      LanguageConfigKeys.Shop_pocket_sale: "销量", //销量
      LanguageConfigKeys.Shop_pocket_prize_price: "奖品价", //奖品价
      LanguageConfigKeys.Shop_bank_card: "银行账户", //银行账户
      LanguageConfigKeys.Shop_bank_add_card: "添加银行账户", //添加银行账户
      LanguageConfigKeys.Shop_bank_edit_card: "修改银行账户", //修改银行账户
      LanguageConfigKeys.Shop_bank_id_card_user: "身份证用户", //身份证用户
      LanguageConfigKeys.Shop_bank_passport_user: "护照用户", //护照用户
      LanguageConfigKeys.Shop_bank_only_en_th: "仅支持英文及泰文", //仅支持英文及泰文
      LanguageConfigKeys.Shop_bank_add_card_tip1:
          "身份证用户，账户姓名必须与实名认证姓名保持一致", //身份证用户，账户姓名必须与实名认证姓名保持一致
      LanguageConfigKeys.Shop_bank_add_card_tip2:
          "护照用户，必须是泰国银行账户持有人，如有必要可更改姓名", //护照用户，必须是泰国银行账户持有人，如有必要可更改姓名
      LanguageConfigKeys.Shop_bank_add_card_tip3:
          "请正确输入银行名称及银行账号，否则将提现失败", //请正确输入银行名称及银行帐号，否则将提现失败
      LanguageConfigKeys.Shop_bank_bank_name: "银行名称", //银行名称
      LanguageConfigKeys.Shop_bank_card_number: "银行账号", //银行账号
      LanguageConfigKeys.Shop_bank_next_step: "下一步", //下一步
      LanguageConfigKeys.Shop_bank_unkown_open_bank: "未知银行", //未知银行
      LanguageConfigKeys.Shop_bank_delete_card: "是否删除银行卡?", //是否删除银行卡?
      LanguageConfigKeys.Shop_bank_card_already_exist:
          "该银行账号已被其他账号绑定，请更换绑定银行账号！", //该银行账号已被其他账号绑定，请更换绑定银行账号！
      LanguageConfigKeys.Shop_wallet_mxcome: "MXCOME安全保障中", //MXCOME安全保障中
      LanguageConfigKeys.Shop_wallet_mxget_income: "动态收益", //动态收益
      LanguageConfigKeys.Shop_wallet_transferred_balance: "转入余额", //转入余额
      LanguageConfigKeys.Shop_wallet_chargeback: "退单", //退单
      LanguageConfigKeys.Shop_wallet_rebate: "消费返利", //消费返利
      LanguageConfigKeys.Shop_wallet_daily_benefits: "每日福利", //每日福利
      LanguageConfigKeys.Shop_wallet_newcomer_join: "注册福利", //注册福利
      LanguageConfigKeys.Shop_wallet_last_income: "最近一笔", //最近一笔
      LanguageConfigKeys.Shop_wallet_income_detail: "收益明细", //收益明细
      LanguageConfigKeys.Shop_wallet_pocket_money: "零花钱", //零花钱
      LanguageConfigKeys.Shop_wallet_now_apply: "立即申请", //立即申请
      LanguageConfigKeys.Shop_wallet_recharge: "充值", //充值
      LanguageConfigKeys.Shop_wallet_withdrawal: "提现", //提现
      LanguageConfigKeys.Shop_wallet_withdrawal_finish: "已提现", //提现
      LanguageConfigKeys.Shop_wallet_withdrawal_fail: "(提现失败)", //提现失败
      LanguageConfigKeys.Shop_wallet_refund: "退款", //退款
      LanguageConfigKeys.Shop_wallet_service_charges_fee: "提现手续费", //提现手续费
      LanguageConfigKeys.Shop_wallet_service_fee: "手续费", //手续费
      LanguageConfigKeys.Shop_wallet_fee_rate: "费率", //费率
      LanguageConfigKeys.Shop_wallet_income: "收益", //收益
      LanguageConfigKeys.Shop_wallet_bank_card_bind: "已绑定银行卡", //已绑定银行卡
      LanguageConfigKeys.Shop_wallet_card_tip: "查账单、提现、充值", //查账单、提现、充值
      LanguageConfigKeys.Shop_wallet_withdrawal_tip:
          "提现申请已提交成功，请耐心等待", //提现申请已提交成功，请耐心等待
      LanguageConfigKeys.Shop_wallet_withdrawal_amount_tip:
          "请输入正确的金额", //请输入正确的金额
      LanguageConfigKeys.Shop_wallet_withdrawal_balance_tip:
          "提现金额不能超过可提现金额", //提现金额不能超过可提现金额
      LanguageConfigKeys.Shop_wallet_today_withdrawal_balance_tip:
          "提现金额超过今日可提金额", //提现金额超过今日可提金额
      LanguageConfigKeys.Shop_wallet_withdrawal_time_tip:
          "24小时内到账，法定节假日提现自动顺延至工作日", //提现打款周期为每周一次，每周五统一打款，如申请时间在打款时间之后，顺延到下个打款周期，请合理安排时间
      LanguageConfigKeys.Shop_wallet_cash_withdrawal_rules: "提现规则", //提现规则
      LanguageConfigKeys.Shop_wallet_balance_detail: "资产明细", //资产明细
      LanguageConfigKeys.Shop_wallet_all: "查看所有", //查看所有
      LanguageConfigKeys.Shop_wallet_balance: "余额", //余额
      LanguageConfigKeys.Shop_wallet_task_profit_sharing: "任务分润", //任务分润
      LanguageConfigKeys.Shop_wallet_red_packet_withdrawal: "红包提现",
      LanguageConfigKeys.Shop_wallet_mxget_profit: "淘金分润", //淘金分润
      LanguageConfigKeys.Shop_wallet_buy_goods: "购买商品", //购买商品
      LanguageConfigKeys.shop_wallet_expire_date: "卡有效期", //卡有效期
      LanguageConfigKeys.shop_wallet_change_name: "更换姓名", //更换姓名
      LanguageConfigKeys.shop_wallet_change_name_tip:
          "请确认资料，账户错误将导致无法提现", //请确认资料，账户错误将导致无法提现
      LanguageConfigKeys.Shop_search_everyone: "大家都在搜", //大家都在搜
      LanguageConfigKeys.Shop_search_history: "历史搜索", //历史搜索
      LanguageConfigKeys.Shop_monday: "周一", //周一
      LanguageConfigKeys.Shop_tuesday: "周二", //周二
      LanguageConfigKeys.Shop_wednesday: "周三", //周三
      LanguageConfigKeys.Shop_thursday: "周四", //周四
      LanguageConfigKeys.Shop_friday: "周五", //周五
      LanguageConfigKeys.Shop_saturday: "周六", //周六
      LanguageConfigKeys.Shop_sunday: "周日", //周日
      LanguageConfigKeys.Shop_today: "今天", //今天
      LanguageConfigKeys.Shop_notification: "通知", //通知
      LanguageConfigKeys.Shop_permission_denied: "拒绝", //拒绝
      LanguageConfigKeys.Shop_permission_granted: "允许", //允许
      LanguageConfigKeys.Shop_permission_setting_cancel: "取消", //取消
      LanguageConfigKeys.Shop_permission_setting_open: "去打开", //去打开
      LanguageConfigKeys.Shop_permission_camera_title:
          "“MXCOME”想访问你的相机", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_camera_content:
          "请允许MXCOME使用你的相机权限，用于头像、证件照片上传等功能", //请允许MXCOME使用你的相机权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_camera_setting_title:
          "开启相机权限", //开启相机权限
      LanguageConfigKeys.Shop_permission_camera_setting_content:
          "请在[设置-应用]中开启摄像头权限，开启后才可使用拍照等功能", //请在[设置-应用]中开启摄像头权限，开启后才可使用拍照等功能
      LanguageConfigKeys.Shop_permission_photos_title:
          "“MXCOME”申请存储权限", //“MXCOME”申请存储权限
      LanguageConfigKeys.Shop_permission_photos_content:
          "请允许MXCOME使用存储权限，用于头像、证件照片上传等功能", //请允许MXCOME使用存储权限，用于头像、证件照片上传等功能
      LanguageConfigKeys.Shop_permission_photos_setting_title:
          "开启存储权限", //开启存储权限
      LanguageConfigKeys.Shop_permission_photos_setting_content:
          "请在[设置-应用]中开启读写存储权限，开启后才可使用照片上传等功能", //请在[设置-应用]中开启读写存储权限，开启后才可使用照片上传等功能
      LanguageConfigKeys.Shop_permission_location_title: "位置权限使用说明", //位置权限使用说明
      LanguageConfigKeys.Shop_permission_location_content:
          "MXCOME想访问您的地理位置，将根据您的地理位置提供准确的收货地址，您有权拒绝或取消授权，取消后不影响您使用其他服务", //MXCOME想访问您的地理位置，将根据您的地理位置提供准确的收货地址，您有权拒绝或取消授权，取消后不影响您使用其他服务
      LanguageConfigKeys.Shop_permission_location_setting_title:
          "开启位置权限", //开启位置权限
      LanguageConfigKeys.Shop_permission_location_setting_content:
          "请在[设置-应用]中开启位置权限，开启后才可使用定位等功能", //请在[设置-应用]中开启位置权限，开启后才可使用定位等功能
      LanguageConfigKeys.Shop_permission_scan_title:
          "“MXCOME”想访问你的相机", //“MXCOME”想访问你的相机
      LanguageConfigKeys.Shop_permission_scan_content:
          "请允许MXCOME获取你的相机，用于扫描二维码、识别商品等功能", //请允许MXCOME获取你的相机，用于扫描二维码、识别商品等功能
      LanguageConfigKeys.Shop_permission_scan_setting_title: "开相机权限", //开相机权限
      LanguageConfigKeys.Shop_permission_scan_setting_content:
          "请在[设置-应用]中开启摄像头权限，开启后才可使用扫描等功能", //请在[设置-应用]中开启摄像头权限，开启后才可使用扫描等功能
      LanguageConfigKeys.Shop_pocket_change_record: "更换记录",
      LanguageConfigKeys.Shop_pocket_surplus_task:
          "当前口袋等级还可领取|个任务", //当前口袋等级还可领取%s个任务
      LanguageConfigKeys.Shop_pocket_view_task: "查看任务", //查看任务
      LanguageConfigKeys.Shop_order_merge_cancel: "以下订单需一起取消",
      LanguageConfigKeys.Shop_order_merge_pay: "以下订单需一起付款",
      LanguageConfigKeys.Shop_order_cancel_back: "返回", //返回
      LanguageConfigKeys.Shop_order_goods_limit:
          "每个账号每次购买商品不能超过|个", //优惠券已退回，您可再次使用
      LanguageConfigKeys.Shop_product_red_pop_tip1:
          "请于当天内完成首单推荐，否则将失去当期红包闯关资格", //请于%s天内完成首单推荐，否则此资格将永远丧失
      LanguageConfigKeys.Shop_product_red_pop_tip2:
          "完成首单后，将自动获得有奖推广时间", //完成首单后，将自动获得有奖推广时间
      LanguageConfigKeys.Shop_product_obtaining_red_qualification:
          "获得红包闯关资格", //获得红包闯关资格
      LanguageConfigKeys.Shop_product_crossed_level_success_tip:
          "高手，%s红包已到手，欢迎随时提现", //高手，%s红包已到手，欢迎随时提现
      LanguageConfigKeys.Shop_pocket_waiting_exciting_activities:
          "更多精彩活动,敬请期待", //更多精彩活动,敬请期待
      LanguageConfigKeys.Shop_pocket_change_task_tips1:
          "支持更换口袋等级相对应的任务", //支持更换口袋等级相对应的任务
      LanguageConfigKeys.Shop_pocket_change_task_tips2:
          "原任务结束前，可在“更换记录”中查看", //原任务结束前，可在“更换记录”中查看
      LanguageConfigKeys.Shop_mine_passing_levels: "正在闯关", //正在闯关
      LanguageConfigKeys.Shop_mine_direct_push_tips: "直推越多，闯关越快", //直推越多，闯关越快
      LanguageConfigKeys.Shop_mine_total_gains: "累计获得", //累计获得
      LanguageConfigKeys.Shop_mine_date_to: "至", //至
      LanguageConfigKeys.Shop_pocket_super_wednesday: "超级星期三", //超级星期三
      LanguageConfigKeys.Shop_pocket_category_super_wednesday:
          "超级\n星期三", //超级\n星期三
      LanguageConfigKeys.Login_create_mine_link: "创建专属链接", //创建专属链接
      LanguageConfigKeys.Login_nickname_exists: "该名称已存在，请重新输入", //该昵称已存在，请重新输入
      LanguageConfigKeys.Login_link_create_success:
          "恭喜，您的专属链接已创建", //恭喜，您的专属链接已创建
      LanguageConfigKeys.Login_copy_link:
          "复制链接，粘贴至TikTok等社交应用", //复制链接，粘贴至TikTok等社交应用
      LanguageConfigKeys.Login_kol_name_hint: "昵称至少1位", //昵称至少3个位
      LanguageConfigKeys.Login_kol_name_tip:
          "专属名称仅支持英文及数字，不可修改，便于粉丝识别身份\n头像与昵称将显示在分享链接与排名中，APP个人中心可修改\n专属链接示例:",
      LanguageConfigKeys.Login_input_kol_name: "请输入专属名称", //请输入专属名称
      LanguageConfigKeys.Login_input_kol_share: "立即创建专属链接，便于推广", //立即创建专属链接，便于推广
      LanguageConfigKeys.Login_input_kol_recommend: "快速推广您的专属链接", //快速推广您的专属链接
      LanguageConfigKeys.shop_mine_receive_discount: "领取优惠", //领取优惠
      LanguageConfigKeys.shop_mine_platform_coupon_tips:
          "MXCOME 品牌自营平台，100%正品保证", //MXCOME 品牌自营平台，100%正品保证
      LanguageConfigKeys.shop_mine_platform_coupon_hint:
          "平台优惠券将不定期发放", //平台优惠券将不定期发放
      LanguageConfigKeys.shop_mine_rebate_status_hint_1:
          "等待统计，下级购买越多返利越多", //等待统计，下级购买越多返利越多
      LanguageConfigKeys.shop_mine_rebate_status_hint_2:
          "等待结算，订单未完成将不计算返利", //等待结算，订单未完成将不计算返利
      LanguageConfigKeys.shop_mine_rebate_status_hint_3:
          "结算完成，总返利已自动转入", //结算完成，总返利已自动转入
      LanguageConfigKeys.shop_mine_rebate_status_hint_4:
          "还差 | 单，即可升级", //还差 | 单，即可升级
      LanguageConfigKeys.shop_mine_rebate_rules_1:
          "第7天统计总单量及预期收益", //第7天统计总单量及预期收益
      LanguageConfigKeys.shop_mine_rebate_rules_2:
          "统计结束后第7天结算返利，超时确认的订单不再返利", //统计结束后第7天结算返利，超时确认的订单不再返利
      LanguageConfigKeys.shop_mine_rebate_rules_3:
          "增加单量可升级返利，本人购买支持升级，但不计算返利", //增加单量可升级返利，本人购买支持升级，但不计算返利
      LanguageConfigKeys.shop_mine_rebate_current_order: "本期单量",
      LanguageConfigKeys.shop_mine_rebate_condition: "8单升级最高返利",
      LanguageConfigKeys.shop_mine_rebate_order: "单",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate: "我的下级",
      LanguageConfigKeys.shop_mine_rebate_my_subordinate_nums: "下级人数",
      LanguageConfigKeys.shop_mine_rebate_bind_time: "绑定时间",
      LanguageConfigKeys.shop_mine_rebate_view_subordinate: "查看下级",
      LanguageConfigKeys.shop_mine_rebate_my_profits: "我的返利",
      LanguageConfigKeys.shop_mine_rebate_expect_total_rebate: "预期总返利",
      LanguageConfigKeys.shop_mine_rebate_total_rebate: "总返利",
      LanguageConfigKeys.shop_mine_rebate_order_num: "单量",
      LanguageConfigKeys.shop_mine_rebate_to_be_counted: "待统计",
      LanguageConfigKeys.shop_mine_rebate_already_counted: "已统计",
      LanguageConfigKeys.shop_mine_rebate_pending_settlement: "待结算",
      LanguageConfigKeys.shop_mine_rebate_settled: "已结算",
      LanguageConfigKeys.shop_mine_rebate_period_range: "第%s周",
      LanguageConfigKeys.shop_mine_rebate_calculate_order: "统计订单",
      LanguageConfigKeys.shop_mine_rebate_settlement_order: "结算返利",
      LanguageConfigKeys.shop_mine_rebate_my_rebate: "返利",
      LanguageConfigKeys.shop_mine_rebate_my_expect_rebate: "预期返利",
      LanguageConfigKeys.shop_mine_rebate_exclusive_qr_code: "专属二维码",
      LanguageConfigKeys.shop_mine_rebate_my_superior: "我的上级",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips1: "好友扫码即可成为下级",
      LanguageConfigKeys.shop_mine_rebate_my_superior_tips2:
          "活动期间，下级购买任意商品，您都能得到消费返利",
      LanguageConfigKeys.shop_mine_rebate_save: "保存本地",
      LanguageConfigKeys.shop_mine_rebate_recommend: "推广下级",
      LanguageConfigKeys.shop_mine_rebate_no_superior: "暂无上级",
      LanguageConfigKeys.shop_mine_rebate_bind_superior: "绑定上级",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_tips: "点击确认即可绑定",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_confirm: "确认",
      LanguageConfigKeys.shop_mine_rebate_bind_superior_success: "绑定上级成功",
      LanguageConfigKeys.shop_mine_rebate_save_success: "保存成功",
      LanguageConfigKeys.shop_mine_rebate_album: "相册",
      LanguageConfigKeys.shop_mine_rebate_recognition_error: "识别错误",
      LanguageConfigKeys.shop_home_monthly_benefits_tip: "下单即得平台补贴，接力推荐即可赚钱!",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_1: "每月购买任意甄选商品!",
      LanguageConfigKeys.shop_home_monthly_benefits_tip_2: "即可获得 | ‘红包闯关’推广福利",
      LanguageConfigKeys.shop_home_load_more: "查看更多",
      LanguageConfigKeys.shop_home_balance_window_tip_1: "恭喜获得|现金奖励",
      LanguageConfigKeys.shop_home_balance_window_tip_2: "已发放至|账户余额",
      LanguageConfigKeys.shop_home_rebate_close_tip: "当前服务暂不可用",
      LanguageConfigKeys.shop_home_rebate_order_unfinished_tip: "订单未完成",
      LanguageConfigKeys.shop_web3_email_sent: "邮件已发送", //邮件已发送
      LanguageConfigKeys.shop_web3_format_incorrect: "邮件格式不正确", //邮件格式不正确
      LanguageConfigKeys.shop_web3_luck_draw: "抽奖", //抽奖
      LanguageConfigKeys.shop_web3_chance_lucky_draw: "抽奖机会%s次", //抽奖机会%s次
      LanguageConfigKeys.shop_web3_winning_list: "中奖名单", //中奖名单
      LanguageConfigKeys.shop_web3_received_prizes: "已中奖", //已中奖
      LanguageConfigKeys.shop_web3_winning_draws_hint:
          "恭喜 %s 抽中%s，价值 %s", //恭喜 %s 抽中%s，价值 %s
      LanguageConfigKeys.shop_web3_start_lottery: "开始抽奖", //开始抽奖
      LanguageConfigKeys.shop_web3_winning_following_prizes:
          "恭喜抽中以下奖品", //恭喜抽中以下奖品
      LanguageConfigKeys.shop_web3_claim_prizes: "领取奖品", //领取奖品
      LanguageConfigKeys.shop_web3_please_ensure_accurate_and_correct:
          "请确保您提供的%s准确无误", //请确保您提供的%s准确无误
      LanguageConfigKeys.shop_web3_email: "邮箱地址", //邮箱地址
      LanguageConfigKeys.shop_web3_transfer_out_address: "转出地址", //转出地址
      LanguageConfigKeys.Shop_web3_financial_losses:
          "否则可能会造成资金损失", //否则可能会造成资金损失
      LanguageConfigKeys.Shop_web3_transfer_fee: "手续费", //手续费
      LanguageConfigKeys.Shop_web3_free: "限免", //限免
      LanguageConfigKeys.Shop_web3_expected_credited:
          "预计到账<black> 24小时 </black>", //预计到账<black> 24小时 </black>
      LanguageConfigKeys.Shop_web3_slide_confirmation: "滑动确认", //滑动确认
      LanguageConfigKeys.Shop_web3_transfer_in: "转入", //转入
      LanguageConfigKeys.Shop_web3_transfer_out: "转出", //转出
      LanguageConfigKeys.Shop_web3_address: "地址", //地址
      LanguageConfigKeys.Shop_web3_assets: "资产", //资产
      LanguageConfigKeys.Shop_web3_enter_receive_wallet_address:
          "请输入您要接收的钱包地址", //请输入您要接收的钱包地址
      LanguageConfigKeys.Shop_web3_choose_transfer_assets: "选择转出资产", //选择转出资产
      LanguageConfigKeys.Shop_web3_user_confirm_tip1:
          "用户需自行确认并承担转出风险", //用户需自行确认并承担转出风险
      LanguageConfigKeys.Shop_web3_user_confirm_tip2:
          "转出操作无法撤回，谨防受骗", //转出操作无法撤回，谨防受骗
      LanguageConfigKeys.Shop_web3_transfer: "互转", //互转
      LanguageConfigKeys.Shop_web3_account_email: "账户邮箱", //账户邮箱
      LanguageConfigKeys.Shop_web3_enter_email: "请输入对方的账户邮箱", //请输入对方的账户邮箱
      LanguageConfigKeys.Shop_web3_selected: "已选择", //已选择
      LanguageConfigKeys.Shop_web3_select_asset_type: "选择资产类型", //选择资产类型
      LanguageConfigKeys.Shop_web3_select_assets: "选择资产", //选择资产
      LanguageConfigKeys.Shop_web3_enter_your_email: "请输入邮箱地址", //请输入邮箱地址
      LanguageConfigKeys.Shop_web3_enter_email_code: "请输入邮箱验证码", //请输入邮箱验证码
      LanguageConfigKeys.Shop_web3_agree_accept: "同意并接受", //同意并接受
      LanguageConfigKeys.Shop_web3_mxcome_protocol:
          "《MXCOME数字钱包协议》", //《MXCOME数字钱包协议》
      LanguageConfigKeys.Shop_web3_activate_now: "立即开通", //立即开通
      LanguageConfigKeys.Shop_web3_wallet: "WEB3钱包", //WEB3钱包
      LanguageConfigKeys.Shop_web3_get: "获取", //获取
      LanguageConfigKeys.Shop_web3_stored_value: "储值", //储值
      LanguageConfigKeys.Shop_web3_did_assets: "DID资产", //DID资产
      LanguageConfigKeys.Shop_web3_not_config_adv: "暂未配置虚拟商品广告", //暂未配置虚拟商品广告
      LanguageConfigKeys.Shop_vip_agreement_title: "用户会员协议", //用户会员协议
      LanguageConfigKeys.Shop_full_read_agree: "我已完全阅读，理解并同意", //我已完全阅读，理解并同意
      LanguageConfigKeys.Shop_please_check_agreement: "请勾线用户会员协议", //请勾线用户会员协议
      LanguageConfigKeys.Shop_modify_buy_quantity: "100% 品牌自营正品", //修改购买数量
      LanguageConfigKeys.Shop_rights_unlocked:
          "权益尚未解锁，敬请关注社区公告", //权益尚未解锁，敬请关注社区公告

      // 泰国政府推荐占位框
      LanguageConfigKeys.Gov_recommend_title: "泰国政府官方推荐", //泰国政府官方推荐
      LanguageConfigKeys.Gov_recommend_subtitle:
          "体育旅游部, 文化部, 国家旅游局", //体育旅游部, 文化部, 国家旅游局
      LanguageConfigKeys.Featured_promotion_empty: "暂无精选优惠",
      LanguageConfigKeys.Featured_promotion_discount_full: "满 ฿%s 减 ฿%s",
      LanguageConfigKeys.Featured_promotion_voucher: "฿%s 代金券",
      LanguageConfigKeys.Featured_promotion_use_now: "立即使用",
      LanguageConfigKeys.Featured_promotion_discount: "优惠",
      LanguageConfigKeys.Coupon_detail_show_code_tip: "买单时请向店员出示此券码核销",
      LanguageConfigKeys.Coupon_detail_select_address: "请选择门店地址",
      LanguageConfigKeys.Coupon_detail_swipe_up_shop: "上滑查看店铺",
      LanguageConfigKeys.Coupon_type_full_reduction: "满减券",
      LanguageConfigKeys.Coupon_type_discount_coupon: "折扣券",
      LanguageConfigKeys.Coupon_type_free_shipping: "免邮券",
      LanguageConfigKeys.Coupon_type_voucher: "代金券",
      LanguageConfigKeys.Coupon_validity_period: "有效期 %s",
      LanguageConfigKeys.Coupon_select_store: "选择门店",
      LanguageConfigKeys.Coupon_destination: "目的地",
      LanguageConfigKeys.Map_google: "Google 地图",
      LanguageConfigKeys.Map_gaode: "高德地图",
      LanguageConfigKeys.Map_baidu: "百度地图",
      LanguageConfigKeys.Map_tencent: "腾讯地图",
      LanguageConfigKeys.Coupon_copy_address: "复制地址",
      LanguageConfigKeys.Coupon_navigate_to_store: "导航到店",
      LanguageConfigKeys.Coupon_code_prefix: "券码: %s",
      LanguageConfigKeys.Shop_brand_load_failed: "加载品牌数据失败",
      LanguageConfigKeys.Shop_brand_click_retry: "点击重试",
      LanguageConfigKeys.Promotion_highlight_category_fallback: "分类",
    },
  };
}

class LanguageConfigKeys {
  static const app_name = "app_name";
  static const language = "language";
  static const search = "search";
  static const language_tip = "language_tip";
  static const Base_unknown_err = "Base_unknown_err";
  static const Base_coming_soon = "Base_coming_soon";
  static const Base_submit_hint = "Base_submit_hint";
  static const Base_submit_success = "Base_submit_success";
  static const Base_successfully_added = "Base_successfully_added";
  static const Base_successfully_modified = "Base_successfully_modified";
  static const Base_operation_successful = "Base_operation_successful";
  static const Base_operation_tips = "Base_operation_tips";
  static const Base_set_successful = "Base_set_successful";
  static const Base_copy_success = "Base_copy_success";
  static const Base_clean_up = "Base_clean_up";
  static const Base_delete = "Base_delete";
  static const Shop_submit = "Shop_submit";
  static const Base_view_image = "Base_view_image";
  static const Login_welcome_world_of_gold = "Login_welcome_world_of_gold";
  static const Login_select_country = "Login_select_country";
  static const Login_register = "Login_register";
  static const Login_register_new = "Login_register_new";
  static const Login_duplicate_register_tip = "Login_duplicate_register_tip";
  static const Login_skip = "Login_skip";
  static const Login_country_th = "Login_country_th";
  static const Login_country_en = "Login_country_en";
  static const Login_country_zh = "Login_country_zh";
  static const Login_register_success = "Login_register_success";
  static const Login_reset_password = "Login_reset_password";
  static const Login_sms_code = "Login_sms_code";
  static const Login_sms_code_error = "Login_sms_code_error";
  static const Login_sms_code_timeout = "Login_sms_code_timeout";
  static const Login_password_or_confirm_password_error =
      "Login_password_or_confirm_password_error";
  static const Login_password_tip = "Login_password_tip";
  static const Login_password_first_tip = "Login_password_first_tip";
  static const Login_password_again_tip = "Login_password_again_tip";
  static const Login_password_format_error = "Login_password_format_error";
  static const Login_set_password_tip1 = "Login_set_password_tip1";
  static const Login_set_password_tip2 = "Login_set_password_tip2";
  static const Login_forgot_password_tip1 = "Login_forgot_password_tip1";
  static const Login_forgot_password_tip2 = "Login_forgot_password_tip2";
  static const Login_forgot_password_tip3 = "Login_forgot_password_tip3";
  static const Login_welcome_login = "Login_welcome_login";
  static const Login_mobile_tip = "Login_mobile_tip";
  static const Login_mobile_error = "Login_mobile_error";
  static const Login_user_or_password_error = "Login_user_or_password_error";
  static const Login_forgot_password = "Login_forgot_password";
  static const Login_code_tip = "Login_code_tip";
  static const Login_login_app = "Login_login_app";
  static const Login_send_code = "Login_send_code";
  static const Login_resend_code = "Login_resend_code";
  static const Login_login = "Login_login";
  static const Login_verify_phone = "Login_verify_phone";
  static const Login_other_login_type = "Login_other_login_type";
  static const Login_bind_phone = "Login_bind_phone";
  static const Login_login_accept_tip = "Login_login_accept_tip";
  static const Login_service = "Login_service";
  static const Login_input_invite_code = "Login_input_invite_code";
  static const Login_input_invite_code_required =
      "Login_input_invite_code_required";
  static const Login_input_invite_code_invalid =
      "Login_input_invite_code_invalid";
  static const Login_input_invite_code_title = "Login_input_invite_code_title";
  static const Login_input_invite_code_content =
      "Login_input_invite_code_content";
  static const Login_invite_code_error = "Login_invite_code_error";
  static const Login_invite_consent_agreement =
      "Login_invite_consent_agreement";
  static const Login_password_set_success = "Login_password_set_success";
  static const Login_password_modify_success = "Login_password_modify_success";
  static const Verify_code_tip = "Verify_code_tip";
  static const Verify_safe_verify = "Verify_safe_verify";
  static const Verify_safe_verify_tip1 = "Verify_safe_verify_tip1";
  static const Verify_safe_verify_tip2 = "Verify_safe_verify_tip2";
  static const WebPage_click_reload = "WebPage_click_reload";
  static const ViewUtils_cancel = "ViewUtils_cancel";
  static const ViewUtils_confirm = "ViewUtils_confirm";
  static const ViewUtils_no_data = "ViewUtils_no_data";
  static const ViewUtils_no_more = "ViewUtils_no_more";
  static const ViewUtils_retry = "ViewUtils_retry";
  static const Loading = "Loading";
  static const Shop_home = "Shop_home";
  static const Shop_category = "Shop_category";
  static const Shop_cart = "Shop_cart";
  static const Shop_grow = "Shop_grow";
  static const Shop_grow_continue_day = "Shop_grow_continue_day";
  static const Shop_grow_this_month = "Shop_grow_this_month";
  static const Shop_grow_countersign = "Shop_grow_countersign";
  static const Shop_grow_unsigned = "Shop_grow_unsigned";
  static const Shop_grow_countersigned = "Shop_grow_countersigned";
  static const Shop_grow_signed = "Shop_grow_signed";
  static const Shop_grow_growth_benefits = "Shop_grow_growth_benefits";
  static const Shop_grow_surprise = "Shop_grow_surprise";
  static const Shop_product_task_recommend = "Shop_product_task_recommend";
  static const Shop_product_shop_stroll = "Shop_product_shop_stroll";
  static const Shop_product_shop_stroll_tip = "Shop_product_shop_stroll_tip";
  static const Shop_product_hot_activity = "Shop_product_hot_activity";
  static const Shop_product_recommend = "Shop_product_recommend";
  static const Shop_product_profit = "Shop_product_profit";
  static const Shop_product_best_seller = "Shop_product_best_seller";
  static const Shop_product_search = "Shop_product_search";
  static const Shop_product_delivery = "Shop_product_delivery";
  static const Shop_product_parameter = "Shop_product_parameter";
  static const Shop_product_spec = "Shop_product_spec";
  static const Shop_product_spec_select = "Shop_product_spec_select";
  static const Shop_product_service = "Shop_product_service";
  static const Featured_promotion_title = "Featured_promotion_title";
  static const Featured_promotion_view_all = "Featured_promotion_view_all";
  static const Featured_promotion_category_restaurant =
      "Featured_promotion_category_restaurant";
  static const Featured_promotion_category_hotel =
      "Featured_promotion_category_hotel";
  static const Featured_promotion_category_car =
      "Featured_promotion_category_car";
  static const Featured_promotion_category_ticket =
      "Featured_promotion_category_ticket";
  static const Featured_promotion_category_popular_thai =
      "Featured_promotion_category_popular_thai";
  static const Featured_promotion_empty = "Featured_promotion_empty";
  static const Featured_promotion_discount_full =
      "Featured_promotion_discount_full";
  static const Featured_promotion_voucher = "Featured_promotion_voucher";
  static const Featured_promotion_use_now = "Featured_promotion_use_now";
  static const Featured_promotion_discount = "Featured_promotion_discount";
  static const Coupon_detail_show_code_tip = "Coupon_detail_show_code_tip";
  static const Coupon_detail_select_address = "Coupon_detail_select_address";
  static const Coupon_detail_swipe_up_shop = "Coupon_detail_swipe_up_shop";
  static const Coupon_type_full_reduction = "Coupon_type_full_reduction";
  static const Coupon_type_discount_coupon = "Coupon_type_discount_coupon";
  static const Coupon_type_free_shipping = "Coupon_type_free_shipping";
  static const Coupon_type_voucher = "Coupon_type_voucher";
  static const Coupon_validity_period = "Coupon_validity_period";
  static const Coupon_select_store = "Coupon_select_store";
  static const Coupon_destination = "Coupon_destination";
  static const Map_google = "Map_google";
  static const Map_gaode = "Map_gaode";
  static const Map_baidu = "Map_baidu";
  static const Map_tencent = "Map_tencent";
  static const Coupon_copy_address = "Coupon_copy_address";
  static const Coupon_navigate_to_store = "Coupon_navigate_to_store";
  static const Coupon_code_prefix = "Coupon_code_prefix";
  static const Shop_brand_load_failed = "Shop_brand_load_failed";
  static const Shop_brand_click_retry = "Shop_brand_click_retry";
  static const Featured_promotion_category_leisure =
      "Featured_promotion_category_leisure";
  static const Shop_product_shop = "Shop_product_shop";
  static const Shop_product_consulting = "Shop_product_consulting";
  static const Shop_product_join = "Shop_product_join";
  static const Shop_product_rise = "Shop_product_rise";
  static const Shop_product_join_cart = "Shop_product_join_cart";
  static const Shop_product_cart_add_success = "Shop_product_cart_add_success";
  static const Shop_product_now_buy = "Shop_product_now_buy";
  static const Shop_product_goods = "Shop_product_goods";
  static const Shop_product_detail = "Shop_product_detail";
  static const Shop_product_select_spec = "Shop_product_select_spec";
  static const Shop_product_quantity = "Shop_product_quantity";
  static const Shop_product_money = "Shop_product_money";
  static const Shop_product_mxget = "Shop_product_mxget";
  static const Shop_product_user_join_mxget = "Shop_product_user_join_mxget";
  static const Shop_product_view_list = "Shop_product_view_list";
  static const Shop_product_see = "Shop_product_see";
  static const Shop_product_select = "Shop_product_select";
  static const Shop_product_free_freight = "Shop_product_free_freight";
  static const Shop_product_nation_branding = "Shop_product_nation_branding";
  static const Shop_product_place = "Shop_product_place";
  static const Shop_product_producer = "Shop_product_producer";
  static const Shop_product_free_charge_overtime_tip =
      "Shop_product_free_charge_overtime_tip";
  static const Shop_product_ship_to = "Shop_product_ship_to";
  static const Shop_product_now_pay_tip = "Shop_product_now_pay_tip";
  static const Shop_product_hot_category = "Shop_product_hot_category";
  static const Shop_product_hot_product = "Shop_product_hot_product";
  static const Shop_brand_shop = "Shop_brand_shop";
  static const Shop_brand_subscribe = "Shop_brand_subscribe";
  static const Shop_brand_subscribed = "Shop_brand_subscribed";
  static const Shop_brand_goto_shop = "Shop_brand_goto_shop";
  static const Shop_brand_receive = "Shop_brand_receive";
  static const Shop_brand_family = "Shop_brand_family";
  static const Shop_brand_period = "Shop_brand_period";
  static const Shop_brand_free_package = "Shop_brand_free_package";
  static const Shop_brand_overtime_free = "Shop_brand_overtime_free";
  static const Shop_brand_down_up = "Shop_brand_down_up";
  static const Shop_brand_up_down = "Shop_brand_up_down";
  static const Shop_brand_choose = "Shop_brand_choose";
  static const Shop_brand_enable = "Shop_brand_enable";
  static const Shop_brand_price = "Shop_brand_price";
  static const Shop_cart_empty = "Shop_cart_empty";
  static const Shop_cart_select_all = "Shop_cart_select_all";
  static const Shop_cart_total = "Shop_cart_total";
  static const Shop_cart_settlement = "Shop_cart_settlement";
  static const Shop_cart_delete = "Shop_cart_delete";
  static const Shop_cart_is_delete = "Shop_cart_is_delete";
  static const Shop_cart_select_goods = "Shop_cart_select_goods";
  static const Shop_cart_select_goods_settlement =
      "Shop_cart_select_goods_settlement";
  static const Shop_mine_adv = "Shop_mine_adv";
  static const Shop_mine_not_login = "Shop_mine_not_login";
  static const Shop_mine_member_service = "Shop_mine_member_service";
  static const Shop_mine_shop_service = "Shop_mine_shop_service";
  static const Shop_mine_member_service_tips = "Shop_mine_member_service_tips";
  static const Shop_mine_shop_service_tips = "Shop_mine_shop_service_tips";
  static const Shop_mine_account_balance = "Shop_mine_account_balance";
  static const Shop_mine_withdrawal_balance = "Shop_mine_withdrawal_balance";
  static const Shop_mine_today_withdrawal_balance =
      "Shop_mine_today_withdrawal_balance";
  static const Shop_mine_confirm_withdrawal = "Shop_mine_confirm_withdrawal";
  static const Shop_mine_withdrawal_amount = "Shop_mine_withdrawal_amount";
  static const Shop_mine_withdrawal_amount_tip1 =
      "Shop_mine_withdrawal_amount_tip1";
  static const Shop_mine_withdrawal_amount_tip2 =
      "Shop_mine_withdrawal_amount_tip2";
  static const Shop_mine_gold_coin = "Shop_mine_gold_coin";
  static const Shop_mine_address_manage = "Shop_mine_address_manage";
  static const Shop_mine_help = "Shop_mine_help";
  static const Shop_mine_profit_study = "Shop_mine_profit_study";
  static const Shop_mine_order = "Shop_mine_order";
  static const Shop_mine_wallet = "Shop_mine_wallet";
  static const Shop_mine_more = "Shop_mine_more";
  static const Shop_mine_edit_member_info = "Shop_mine_edit_member_info";
  static const Shop_mine_unknown = "Shop_mine_unknown";
  static const Shop_mine_boy = "Shop_mine_boy";
  static const Shop_mine_girl = "Shop_mine_girl";
  static const Shop_mine_year_tip = "Shop_mine_year_tip";
  static const Shop_mine_change_avatar = "Shop_mine_change_avatar";
  static const Shop_mine_name = "Shop_mine_name";
  static const Shop_mine_account_id = "Shop_mine_account_id";
  static const Shop_mine_account_modify_once = "Shop_mine_account_modify_once";
  static const Shop_mine_account_id_already_exists =
      "Shop_mine_account_id_already_exists";
  static const Shop_mine_change_account_id = "Shop_mine_change_account_id";
  static const Shop_mine_verifying = "Shop_mine_verifying";
  static const Shop_mine_passed = "Shop_mine_passed";
  static const Shop_mine_real_name_auth = "Shop_mine_real_name_auth";
  static const Shop_mine_verify_status = "Shop_mine_verify_status";
  static const Shop_mine_verify_status_tip1 = "Shop_mine_verify_status_tip1";
  static const Shop_mine_verify_status_tip2 = "Shop_mine_verify_status_tip2";
  static const Shop_mine_verify_failed_status_tip1 =
      "Shop_mine_verify_failed_status_tip1";
  static const Shop_mine_verify_failed_status_tip2 =
      "Shop_mine_verify_failed_status_tip2";
  static const Shop_mine_verify_start_mxget = "Shop_mine_verify_start_mxget";
  static const Shop_mine_verify_reapply = "Shop_mine_verify_reapply";
  static const Shop_mine_select_certificate = "Shop_mine_select_certificate";
  static const Shop_mine_upload_positive = "Shop_mine_upload_positive";
  static const Shop_mine_re_upload = "Shop_mine_re_upload";
  static const Shop_mine_register_phone = "Shop_mine_register_phone";
  static const Shop_mine_id_card = "Shop_mine_id_card";
  static const Shop_mine_passport = "Shop_mine_passport";
  static const Shop_mine_id_number = "Shop_mine_id_number";
  static const Shop_mine_passport_number = "Shop_mine_passport_number";
  static const Shop_mine_validity = "Shop_mine_validity";
  static const Shop_mine_select_bank = "Shop_mine_select_bank";
  static const Shop_mine_first_name = "Shop_mine_first_name";
  static const Shop_mine_last_name = "Shop_mine_last_name";
  static const Shop_mine_color_pictures = "Shop_mine_color_pictures";
  static const Shop_mine_upload_after_tip = "Shop_mine_upload_after_tip";
  static const Shop_mine_verify_tip1 = "Shop_mine_verify_tip1";
  static const Shop_mine_verify_tip2 = "Shop_mine_verify_tip2";
  static const Shop_mine_verify_tip3 = "Shop_mine_verify_tip3";
  static const Shop_mine_verify_tip4 = "Shop_mine_verify_tip4";
  static const Shop_mine_verify_confirm = "Shop_mine_verify_confirm";
  static const Shop_mine_verify_failed = "Shop_mine_verify_failed";
  static const Shop_mine_verify_wait_time = "Shop_mine_verify_wait_time";
  static const Shop_mine_unreal_name = "Shop_mine_unreal_name";
  static const Shop_mine_nickname = "Shop_mine_nickname";
  static const Shop_mine_describe = "Shop_mine_describe";
  static const Shop_mine_birthday = "Shop_mine_birthday";
  static const Shop_mine_gender = "Shop_mine_gender";
  static const Shop_mine_select_gender = "Shop_mine_select_gender";
  static const Shop_mine_take_picture = "Shop_mine_take_picture";
  static const Shop_mine_photo_album = "Shop_mine_photo_album";
  static const Shop_mine_canceled = "Shop_mine_canceled";
  static const Shop_mine_member_level = "Shop_mine_member_level";
  static const Shop_mine_not_opened = "Shop_mine_not_opened";
  static const Shop_mine_bind_now = "Shop_mine_bind_now";
  static const Shop_mine_get_center = "Shop_mine_get_center";
  static const Shop_mine_promotion_rewards = "Shop_mine_promotion_rewards";
  static const Shop_mine_voucher_center = "Shop_mine_voucher_center";
  static const Shop_mine_valid_to = "Shop_mine_valid_to";
  static const Shop_mine_usage_time = "Shop_mine_usage_time";
  static const Shop_mine_to_use = "Shop_mine_to_use";
  static const Shop_mine_to_be_use = "Shop_mine_to_be_use";
  static const Shop_mine_used = "Shop_mine_used";
  static const Shop_mine_get_now = "Shop_mine_get_now";
  static const Shop_mine_use_coupons = "Shop_mine_use_coupons";
  static const Shop_mine_currently_available = "Shop_mine_currently_available";
  static const Shop_mine_discount_deduction = "Shop_mine_discount_deduction";
  static const Shop_mine_full_available = "Shop_mine_full_available";
  static const Shop_mine_all_platforms = "Shop_mine_all_platforms";
  static const Shop_mine_all_shops = "Shop_mine_all_shops";
  static const Shop_mine_category_available = "Shop_mine_category_available";
  static const Shop_mine_specific_product_available =
      "Shop_mine_specific_product_available";
  static const Shop_mine_voucher = "Shop_mine_voucher";
  static const Shop_mine_coupon = "Shop_mine_coupon";
  static const Shop_mine_platform_voucher = "Shop_mine_platform_voucher";
  static const Shop_mine_merchant_voucher = "Shop_mine_merchant_voucher";
  static const Shop_mine_my_coupon = "Shop_mine_my_coupon";
  static const Shop_mine_received_successfully =
      "Shop_mine_received_successfully";
  static const Shop_mine_go_get_voucher = "Shop_mine_go_get_voucher";
  static const Shop_mine_applicable_range = "Shop_mine_applicable_range";
  static const Shop_mine_products_applicable_coupon =
      "Shop_mine_products_applicable_coupon";
  static const Shop_mine_my_prize = "Shop_mine_my_prize";
  static const Shop_mine_red_title = "Shop_mine_red_title";
  static const Shop_mine_red_history_title = "Shop_mine_red_history_title";
  static const Shop_mine_red_total_number = "Shop_mine_red_total_number";
  static const Shop_mine_red_no_data = "Shop_mine_red_no_data";
  static const Shop_mine_red_sub_title = "Shop_mine_red_sub_title";
  static const Shop_mine_number_promoters = "Shop_mine_number_promoters";
  static const Shop_mine_total_number_promoters =
      "Shop_mine_total_number_promoters";
  static const Shop_mine_new_today = "Shop_mine_new_today";
  static const Shop_mine_promotion_details = "Shop_mine_promotion_details";
  static const Shop_mine_Daily_direct_promotion_prizes =
      "Shop_mine_Daily_direct_promotion_prizes";
  static const Shop_mine_choose_prize = "Shop_mine_choose_prize";
  static const Shop_mine_promotion_rules = "Shop_mine_promotion_rules";
  static const Shop_mine_promotion_rules_tip1 =
      "Shop_mine_promotion_rules_tip1";
  static const Shop_mine_promotion_rules_tip2 =
      "Shop_mine_promotion_rules_tip2";
  static const Shop_mine_promotion_rules_tip3 =
      "Shop_mine_promotion_rules_tip3";
  static const Shop_mine_promotion_rules_tip4 =
      "Shop_mine_promotion_rules_tip4";
  static const Shop_mine_promotion_rules_tip5 =
      "Shop_mine_promotion_rules_tip5";
  static const Shop_mine_promotion_rules_tip6 =
      "Shop_mine_promotion_rules_tip6";
  static const Shop_mine_exchange_voucher = "Shop_mine_exchange_voucher";
  static const Shop_mine_entity_prizes = "Shop_mine_entity_prizes";
  static const Shop_mine_my_push = "Shop_mine_my_push";
  static const Shop_mine_my_push_value = "Shop_mine_my_push_value";
  static const Shop_mine_second_level = "Shop_mine_second_level";
  static const Shop_mine_third_level = "Shop_mine_third_level";
  static const Shop_mine_processing = "Shop_mine_processing";
  static const Shop_mine_issued = "Shop_mine_issued";
  static const Shop_mine_exchange_success_tip =
      "Shop_mine_exchange_success_tip";
  static const Shop_mine_select_prizes = "Shop_mine_select_prizes";
  static const Shop_mine_now_use = "Shop_mine_now_use";
  static const Shop_mine_detail = "Shop_mine_detail";
  static const Shop_mine_expired = "Shop_mine_expired";
  static const Shop_mine_direct_push = "Shop_mine_direct_push";
  static const Shop_mine_hot = "Shop_mine_hot";
  static const Shop_mine_end_remain = "Shop_mine_end_remain";
  static const Shop_mine_exchange_prizes = "Shop_mine_exchange_prizes";
  static const Shop_mine_store_consumption = "Shop_mine_store_consumption";
  static const Shop_mine_express_delivery = "Shop_mine_express_delivery";
  static const Shop_mine_exchange_records = "Shop_mine_exchange_records";
  static const Shop_mine_value = "Shop_mine_value";
  static const Shop_mine_stock = "Shop_mine_stock";
  static const Shop_mine_direct_push_value = "Shop_mine_direct_push_value";
  static const Shop_mine_using_direct_push_value =
      "Shop_mine_using_direct_push_value";
  static const Shop_mine_enable = "Shop_mine_enable";
  static const Shop_mine_exchange_successful = "Shop_mine_exchange_successful";
  static const Shop_mine_confirm_exchange = "Shop_mine_confirm_exchange";
  static const Shop_mine_confirm_use = "Shop_mine_confirm_use";
  static const Shop_mine_confirm_use_tip = "Shop_mine_confirm_use_tip";
  static const Shop_mine_voucher_code_info = "Shop_mine_voucher_code_info";
  static const Shop_mine_prize_info = "Shop_mine_prize_info";
  static const Shop_mine_exchange_number = "Shop_mine_exchange_number";
  static const Shop_mine_exchange_time = "Shop_mine_exchange_time";
  static const Shop_mine_usage_rules = "Shop_mine_usage_rules";
  static const Shop_mine_usage_rules_tip1 = "Shop_mine_usage_rules_tip1";
  static const Shop_mine_usage_rules_tip2 = "Shop_mine_usage_rules_tip2";
  static const Shop_mine_usage_rules_tip3 = "Shop_mine_usage_rules_tip3";
  static const Shop_mine_usage_expiration_time =
      "Shop_mine_usage_expiration_time";
  static const Shop_mine_usage_total_sheets = "Shop_mine_usage_total_sheets";
  static const Shop_mine_logistics_info = "Shop_mine_logistics_info";
  static const Shop_mine_receiving_time = "Shop_mine_receiving_time";
  static const Shop_order_waiting_for_shipment =
      "Shop_order_waiting_for_shipment";
  static const Shop_mine_keep_working_hard = "Shop_mine_keep_working_hard";
  static const Shop_mine_obtain_red = "Shop_mine_obtain_red";
  static const Shop_mine_to_be_updated = "Shop_mine_to_be_updated";
  static const Shop_mine_run_to_zero = "Shop_mine_run_to_zero";
  static const Shop_mine_select_option = "Shop_mine_select_option";
  static const Shop_order_all = "Shop_order_all";
  static const Shop_order_received = "Shop_order_received";
  static const Shop_order_changed = "Shop_order_changed";
  static const Shop_order_wait_pay = "Shop_order_wait_pay";
  static const Shop_order_wait_deliver = "Shop_order_wait_deliver";
  static const Shop_order_wait_receipt = "Shop_order_wait_receipt";
  static const Shop_order_shipped = "Shop_order_shipped";
  static const Shop_order_completed = "Shop_order_completed";
  static const Shop_order_receive_finish = "Shop_order_receive_finish";
  static const Shop_order_canceled = "Shop_order_canceled";
  static const Shop_order_after_sales_order = "Shop_order_after_sales_order";
  static const Shop_order_delete_title = "Shop_order_delete_title";
  static const Shop_order_delete_content = "Shop_order_delete_content";
  static const Shop_order_again_patronage = "Shop_order_again_patronage";
  static const Shop_order_after_sales = "Shop_order_after_sales";
  static const Shop_order_confirm_order = "Shop_order_confirm_order";
  static const Shop_order_empty = "Shop_order_empty";
  static const Shop_order_search = "Shop_order_search";
  static const Shop_order_mine_order = "Shop_order_mine_order";
  static const Shop_order_now_pay = "Shop_order_now_pay";
  static const Shop_order_confirm_pay = "Shop_order_confirm_pay";
  static const Shop_order_remain = "Shop_order_remain";
  static const Shop_order_pay = "Shop_order_pay";
  static const Shop_order_cancel_order = "Shop_order_cancel_order";
  static const Shop_order_change_address = "Shop_order_change_address";
  static const Shop_order_contact_customer_service =
      "Shop_order_contact_customer_service";
  static const Shop_order_confirm_receipt = "Shop_order_confirm_receipt";
  static const Shop_order_confirm_receipt_tip =
      "Shop_order_confirm_receipt_tip";
  static const Shop_order_again_buy = "Shop_order_again_buy";
  static const Shop_order_service1 = "Shop_order_service1";
  static const Shop_order_service2 = "Shop_order_service2";
  static const Shop_order_service3 = "Shop_order_service3";
  static const Shop_order_service4 = "Shop_order_service4";
  static const Shop_order_service5 = "Shop_order_service5";
  static const Shop_order_service6 = "Shop_order_service6";
  static const Shop_order_service7 = "Shop_order_service7";
  static const Shop_order_service8 = "Shop_order_service8";
  static const Shop_order_delete_order = "Shop_order_delete_order";
  static const Shop_order_view_logistics = "Shop_order_view_logistics";
  static const Shop_order_apply_service = "Shop_order_apply_service";
  static const Shop_order_piece_in_total = "Shop_order_piece_in_total";
  static const Shop_order_coupons_ticket_available =
      "Shop_order_coupons_ticket_available";
  static const Shop_order_coupons = "Shop_order_coupons";
  static const Shop_order_tax = "Shop_order_tax";
  static const Shop_order_tax_fee7 = "Shop_order_tax_fee7";
  static const Shop_order_select_delivery = "Shop_order_select_delivery";
  static const Shop_order_logistics_company = "Shop_order_logistics_company";
  static const Shop_order_select_logistics_company =
      "Shop_order_select_logistics_company";
  static const Shop_order_delivery1 = "Shop_order_delivery1";
  static const Shop_order_delivery2 = "Shop_order_delivery2";
  static const Shop_order_delivery3 = "Shop_order_delivery3";
  static const Shop_order_freight_details = "Shop_order_freight_details";
  static const Shop_order_goods_total = "Shop_order_goods_total";
  static const Shop_order_total = "Shop_order_total";
  static const Shop_order_payment_required = "Shop_order_payment_required";
  static const Shop_order_total_discount = "Shop_order_total_discount";
  static const Shop_order_freight = "Shop_order_freight";
  static const Shop_order_total_freight = "Shop_order_total_freight";
  static const Shop_order_place_order = "Shop_order_place_order";
  static const Shop_order_select_receive_address =
      "Shop_order_select_receive_address";
  static const Shop_order_wait_for_payment = "Shop_order_wait_for_payment";
  static const Shop_order_order_sn = "Shop_order_order_sn";
  static const Shop_order_add_points = "Shop_order_add_points";
  static const Shop_order_payment_type = "Shop_order_payment_type";
  static const Shop_order_order_time = "Shop_order_order_time";
  static const Shop_order_payment_time = "Shop_order_payment_time";
  static const Shop_order_receive_address = "Shop_order_receive_address";
  static const Shop_order_delivery_type = "Shop_order_delivery_type";
  static const Shop_order_delivery_time = "Shop_order_delivery_time";
  static const Shop_order_calc_delivery_time = "Shop_order_calc_delivery_time";
  static const Shop_order_delivering = "Shop_order_delivering";
  static const Shop_order_signed_in = "Shop_order_signed_in";
  static const Shop_order_to_be_settled = "Shop_order_to_be_settled";
  static const Shop_order_be_careful = "Shop_order_be_careful";
  static const Shop_order_rule_tips = "Shop_order_rule_tips";
  static const Shop_order_no_app_found = "Shop_order_no_app_found";
  static const Shop_order_pay_success = "Shop_order_pay_success";
  static const Shop_order_pay_success_tip1 = "Shop_order_pay_success_tip1";
  static const Shop_order_pay_success_winning =
      "Shop_order_pay_success_winning";
  static const Shop_order_share_goods = "Shop_order_share_goods";
  static const Shop_order_pay_success_tip2 = "Shop_order_pay_success_tip2";
  static const shop_order_card_email_title = "shop_order_card_email_title";
  static const shop_order_card_email_hint = "shop_order_card_email_hint";
  static const shop_order_card_email_not_empty =
      "shop_order_card_email_not_empty";
  static const shop_order_card_email_error = "shop_order_card_email_error";
  static const shop_order_virtual_product_tip =
      "shop_order_virtual_product_tip";
  static const Shop_order_delivery_to = "Shop_order_delivery_to";
  static const Shop_order_coupons_disable = "Shop_order_coupons_disable";
  static const Shop_order_status = "Shop_order_status";
  static const Shop_order_confirm_change = "Shop_order_confirm_change";
  static const Shop_order_user_pay = "Shop_order_user_pay";
  static const Shop_order_shop_deliver = "Shop_order_shop_deliver";
  static const Shop_order_express_delivery = "Shop_order_express_delivery";
  static const Shop_order_user_receipt = "Shop_order_user_receipt";
  static const Shop_order_detail_tip1 = "Shop_order_detail_tip1";
  static const Shop_order_detail_tip2 = "Shop_order_detail_tip2";
  static const Shop_order_detail_tip3 = "Shop_order_detail_tip3";
  static const Shop_order_detail_tip4 = "Shop_order_detail_tip4";
  static const Shop_order_delivery_detail = "Shop_order_delivery_detail";
  static const Shop_order_order_completed = "Shop_order_order_completed";
  static const Shop_order_order_canceled = "Shop_order_order_canceled";
  static const Shop_order_suggestions = "Shop_order_suggestions";
  static const Shop_order_invalid = "Shop_order_invalid";
  static const Shop_order_prompt_pay = "Shop_order_prompt_pay";
  static const Shop_order_cashier = "Shop_order_cashier";
  static const Shop_order_pay_amount = "Shop_order_pay_amount";
  static const Shop_order_pay_remaining_time = "Shop_order_pay_remaining_time";
  static const Shop_order_pay_qr_code = "Shop_order_pay_qr_code";
  static const Shop_order_balance_pay = "Shop_order_balance_pay";
  static const Shop_order_kbank_pay = "Shop_order_kbank_pay";
  static const Shop_order_scb_pay = "Shop_order_scb_pay";
  static const Shop_order_bank_card_pay = "Shop_order_bank_card_pay";
  static const Shop_order_select_pay = "Shop_order_select_pay";
  static const Shop_order_official_pay = "Shop_order_official_pay";
  static const Shop_order_third_party_pay = "Shop_order_third_party_pay";
  static const Shop_order_delivery_collect = "Shop_order_delivery_collect";
  static const Shop_order_brand_commitment = "Shop_order_brand_commitment";
  static const Shop_order_platform_policy = "Shop_order_platform_policy";
  static const Shop_order_brand = "Shop_order_brand";
  static const Shop_order_delivery = "Shop_order_delivery";
  static const Shop_order_user = "Shop_order_user";
  static const Shop_order_sender_max_time = "Shop_order_sender_max_time";
  static const Shop_order_delivery_max_time = "Shop_order_delivery_max_time";
  static const Shop_order_receipt_max_time = "Shop_order_receipt_max_time";
  static const Shop_order_consume = "Shop_order_consume";
  static const Shop_order_promise = "Shop_order_promise";
  static const Shop_order_platform_in = "Shop_order_platform_in";
  static const Shop_order_eligible = "Shop_order_eligible";
  static const Shop_order_responsibility_division = "shop";
  static const Shop_order_platform_tip1 = "Shop_order_responsibility_division";
  static const Shop_order_result = "Shop_order_result";
  static const Shop_order_bear_the_postage = "Shop_order_bear_the_postage";
  static const Shop_order_phone_verify = "Shop_order_phone_verify";
  static const Shop_order_set_pay_pwd = "Shop_order_set_pay_pwd";
  static const Shop_order_confirm_pay_pwd = "Shop_order_confirm_pay_pwd";
  static const Shop_order_pay_pwd_error = "Shop_order_pay_pwd_error";
  static const Shop_order_id_verify = "Shop_order_id_verify";
  static const Shop_order_set_pay_pwd_tip = "Shop_order_set_pay_pwd_tip";
  static const Shop_order_confirm_pay_pwd_tip =
      "Shop_order_confirm_pay_pwd_tip";
  static const Shop_order_password_error = "Shop_order_password_error";
  static const Shop_order_please_enter_pwd = "Shop_order_please_enter_pwd";
  static const Shop_order_prompt_pay_tip1 = "Shop_order_prompt_pay_tip1";
  static const Shop_order_prompt_pay_tip2 = "Shop_order_prompt_pay_tip2";
  static const Shop_order_prompt_pay_tip3 = "Shop_order_prompt_pay_tip3";
  static const Shop_order_prompt_pay_tip4 = "Shop_order_prompt_pay_tip4";
  static const Shop_order_prompt_pay_tip5 = "Shop_order_prompt_pay_tip5";
  static const Shop_order_timeout = "Shop_order_timeout";
  static const Shop_order_place_new_order = "Shop_order_place_new_order";
  static const Shop_order_got_it = "Shop_order_got_it";
  static const Shop_order_iknow = "Shop_order_iknow";
  static const Shop_order_cancel_payment = "Shop_order_cancel_payment";
  static const Shop_order_after_pay_query = "Shop_order_after_pay_query";
  static const Shop_order_not_pay = "Shop_order_not_pay";
  static const Shop_order_paying = "Shop_order_paying";
  static const Shop_order_pay_failed = "Shop_order_pay_failed";
  static const Shop_order_install_scb = "Shop_order_install_scb";
  static const Shop_order_download_tip = "Shop_order_download_tip";
  static const Shop_order_confirm_close_title =
      "Shop_order_confirm_close_title";
  static const Shop_order_confirm_close_message =
      "Shop_order_confirm_close_message";
  static const Shop_order_confirm_close = "Shop_order_confirm_close";
  static const Shop_order_confirm_continue = "Shop_order_confirm_continue";
  static const Shop_order_not_support_pay = "Shop_order_not_support_pay";
  static const Shop_order_insufficient_balance =
      "Shop_order_insufficient_balance";
  static const Shop_order_package = "Shop_order_package";
  static const Shop_order_selected = "Shop_order_selected";
  static const Shop_order_total_baby = "Shop_order_total_baby";
  static const Shop_order_return_coupon = "Shop_order_return_coupon";
  static const Shop_order_return_coupon_tip = "Shop_order_return_coupon_tip";
  static const Shop_order_detail_address_nav = "Shop_order_detail_address_nav";
  static const Shop_order_detail_address_nav_tip =
      "Shop_order_detail_address_nav_tip";
  static const Shop_sales_status = "Shop_sales_status";
  static const Shop_sales_policy = "Shop_sales_policy";
  static const Shop_sales_refund = "Shop_sales_refund";
  static const Shop_sales_refund_success = "Shop_sales_refund_success";
  static const Shop_sales_refund_item1 = "Shop_sales_refund_item1";
  static const Shop_sales_refund_item2 = "Shop_sales_refund_item2";
  static const Shop_sales_refund_item3 = "Shop_sales_refund_item3";
  static const Shop_sales_return_refund = "Shop_sales_return_refund";
  static const Shop_sales_return_refund_item1 =
      "Shop_sales_return_refund_item1";
  static const Shop_sales_overtime = "Shop_sales_overtime";
  static const Shop_sales_overtime_item1 = "Shop_sales_overtime_item1";
  static const Shop_sales_submit_order = "Shop_sales_submit_order";
  static const Shop_sales_merchant_verify = "Shop_sales_merchant_verify";
  static const Shop_sales_serivce_score = "Shop_sales_serivce_score";
  static const Shop_sales_delivery_serive = "Shop_sales_delivery_serive";
  static const Shop_sales_verify_product = "Shop_sales_verify_product";
  static const Shop_sales_detail = "Shop_sales_detail";
  static const Shop_sales_pending_refunded = "Shop_sales_pending_refunded";
  static const Shop_sales_refunded = "Shop_sales_refunded";
  static const Shop_sales_refunded_reason = "Shop_sales_refunded_reason";
  static const Shop_sales_number = "Shop_sales_number";
  static const Shop_sales_apply_time = "Shop_sales_apply_time";
  static const Shop_sales_apply_type = "Shop_sales_apply_type";
  static const Shop_sales_apply_reason = "Shop_sales_apply_reason";
  static const Shop_sales_take_info = "Shop_sales_take_info";
  static const Shop_sales_after_sales = "Shop_sales_after_sales";
  static const Shop_sales_refund_time = "Shop_sales_refund_time";
  static const Shop_sales_return_balance = "Shop_sales_return_balance";
  static const Shop_sales_return_amount = "Shop_sales_return_amount";
  static const Shop_sales_platform_in = "Shop_sales_platform_in";
  static const Shop_sales_cancel_apply = "Shop_sales_cancel_apply";
  static const Shop_sales_cancel_success = "Shop_sales_cancel_success";
  static const Shop_sales_least_two_pictures = "Shop_sales_least_two_pictures";
  static const Shop_sales_apply = "Shop_sales_apply";
  static const Shop_sales_processing = "Shop_sales_processing";
  static const Shop_sales_completed = "Shop_sales_completed";
  static const Shop_sales_application_record = "Shop_sales_application_record";
  static const Shop_sales_service = "Shop_sales_service";
  static const Shop_sales_service_tip1 = "Shop_sales_service_tip1";
  static const Shop_sales_service_tip2 = "Shop_sales_service_tip2";
  static const Shop_sales_order_elapsed = "Shop_sales_order_elapsed";
  static const Shop_sales_overtime_tip1 = "Shop_sales_overtime_tip11";
  static const Shop_sales_overtime_tip2 = "Shop_sales_overtime_tip2";
  static const Shop_sales_overtime_tip3 = "Shop_sales_overtime_tip3";
  static const Shop_sales_service_detail = "Shop_sales_service_detail";
  static const Shop_sales_total_service_fee = "Shop_sales_total_service_fee";
  static const Shop_sales_finish_route = "Shop_sales_finish_route";
  static const Shop_sales_balance = "Shop_sales_balance";
  static const Shop_sales_apply_submit = "Shop_sales_apply_submit";
  static const Shop_sales_verify_tip1 = "Shop_sales_verify_tip1";
  static const Shop_sales_verify_tip2 = "Shop_sales_verify_tip2";
  static const Shop_sales_verify_tip3 = "Shop_sales_verify_tip3";
  static const Shop_sales_refund_tip1 = "Shop_sales_refund_tip1";
  static const Shop_sales_refund_tip2 = "Shop_sales_refund_tip2";
  static const Shop_sales_return_refund_tip1 = "Shop_sales_return_refund_tip1";
  static const Shop_sales_return_refund_tip2 = "Shop_sales_return_refund_tip2";
  static const Shop_sales_upload_photo = "Shop_sales_upload_photo";
  static const Shop_sales_upload_photo_tip1 = "Shop_sales_upload_photo_tip1";
  static const Shop_sales_upload_photo_tip2 = "Shop_sales_upload_photo_tip2";
  static const Shop_address_add = "Shop_address_add";
  static const Shop_address_select_change = "Shop_address_select_change";
  static const Shop_address_receipt_address = "Shop_address_receipt_address";
  static const Shop_address_receipt_address_empty =
      "Shop_address_receipt_address_empty";
  static const Shop_address_add_receipt_info = "Shop_address_add_receipt_info";
  static const Shop_address_add_receipt_address =
      "Shop_address_add_receipt_address";
  static const Shop_address_edit_receipt_address =
      "Shop_address_edit_receipt_address";
  static const Shop_address_postcode_select = "Shop_address_postcode_select";
  static const Shop_address_set_as_default_address =
      "Shop_address_set_as_default_address";
  static const Shop_address_default = "Shop_address_default";
  static const Shop_address_consignee = "Shop_address_consignee";
  static const Shop_address_phone = "Shop_address_phone";
  static const Shop_address_location = "Shop_address_location";
  static const Shop_address_my_location = "Shop_address_my_location";
  static const Shop_address_Locating = "Shop_address_Locating";
  static const Shop_address_detail_address = "Shop_address_detail_address";
  static const Shop_address_post_code = "Shop_address_post_code";
  static const Shop_address_consignee_empty = "Shop_address_consignee_empty";
  static const Shop_address_phone_empty = "Shop_address_phone_empty";
  static const Shop_address_location_empty = "Shop_address_location_empty";
  static const Shop_address_detail_address_empty =
      "Shop_address_detail_address_empty";
  static const Shop_address_detail_address_hint =
      "Shop_address_detail_address_hint";
  static const Shop_address_post_code_empty = "Shop_address_post_code_empty";
  static const Shop_address_save = "Shop_address_save";
  static const Shop_address_is_delete = "Shop_address_is_delete";
  static const Shop_address_select = "Shop_address_select";
  static const Shop_address_please_select = "Shop_address_please_select";
  static const Shop_address_please_enter = "Shop_address_please_enter";
  static const Shop_address_street_address = "Shop_address_street_address";
  static const Shop_address_assist_enter = "Shop_address_assist_enter";
  static const Shop_address_confirm_detail_address =
      "Shop_address_confirm_detail_address";
  static const Shop_address_contact_info = "Shop_address_contact_info";
  static const Shop_address_address_info = "Shop_address_address_info";
  static const Shop_address_please_select_region =
      "Shop_address_please_select_region";
  static const Shop_address_get_current_location =
      "Shop_address_get_current_location";
  static const Shop_address_found_for_you = "Shop_address_found_for_you";
  static const Shop_address_government = "Shop_address_government";
  static const Shop_address_county = "Shop_address_county";
  static const Shop_address_village = "Shop_address_village";
  static const Shop_address_keywords = "Shop_address_keywords";
  static const Shop_address_finish = "Shop_address_finish";
  static const Shop_address_confirm_delivery_correct =
      "Shop_address_confirm_delivery_correct";
  static const Shop_setting_title = "Shop_setting_title";
  static const Shop_setting_subscribe_follow = "Shop_setting_subscribe_follow";
  static const Shop_setting_subscribe_follow_detail =
      "Shop_setting_subscribe_follow_detail";
  static const Shop_setting_notification_manage =
      "Shop_setting_notification_manage";
  static const Shop_setting_notification_manage_detail =
      "Shop_setting_notification_manage_detail";
  static const Shop_setting_privacy_setting = "Shop_setting_privacy_setting";
  static const Shop_setting_privacy_setting_detail =
      "Shop_setting_privacy_setting_detail";
  static const Shop_setting_account_safe = "Shop_setting_account_safe";
  static const Shop_setting_account_safe_detail =
      "Shop_setting_account_safe_detail";
  static const Shop_setting_Language_change = "Shop_setting_Language_change";
  static const Shop_setting_Language_change_detail =
      "Shop_setting_Language_change_detail";
  static const Shop_setting_user_agreement = "Shop_setting_user_agreement";
  static const Shop_setting_user_agreement_detail =
      "Shop_setting_user_agreement_detail";
  static const Shop_setting_about = "Shop_setting_about";
  static const Shop_setting_about_detail = "Shop_setting_about_detail";
  static const Shop_setting_about_version = "Shop_setting_about_version";
  static const Shop_setting_about_new_version =
      "Shop_setting_about_new_version";
  static const Shop_setting_last_version = "Shop_setting_last_version";
  static const Shop_setting_update_new_version =
      "Shop_setting_update_new_version";
  static const Shop_setting_update_time = "Shop_setting_update_time";
  static const Shop_setting_now_update = "Shop_setting_now_update";
  static const Shop_setting_account_cancellation =
      "Shop_setting_account_cancellation";
  static const Shop_setting_account_cancellation_detail =
      "Shop_setting_account_cancellation_detail";
  static const Shop_setting_account_cancel_tip1 =
      "Shop_setting_account_cancel_tip1";
  static const Shop_setting_account_cancel_tip2 =
      "Shop_setting_account_cancel_tip2";
  static const Shop_setting_account_delete = "Shop_setting_account_delete";
  static const Shop_setting_account_confirm_delete =
      "Shop_setting_account_confirm_delete";
  static const Shop_setting_account_confirm_tip1 =
      "Shop_setting_account_confirm_tip1";
  static const Shop_setting_account_confirm_tip2 =
      "Shop_setting_account_confirm_tip2";
  static const Shop_setting_account_not_delete =
      "Shop_setting_account_not_delete";
  static const Shop_setting_account_now_delete =
      "Shop_setting_account_now_delete";
  static const Shop_setting_change_login = "Shop_setting_change_login";
  static const Shop_setting_exit_login = "Shop_setting_exit_login";
  static const Shop_setting_phone = "Shop_setting_phone";
  static const Shop_setting_phone_detail = "Shop_setting_phone_detail";
  static const Shop_setting_update = "Shop_setting_update";
  static const Shop_setting_update_pwd = "Shop_setting_update_pwd";
  static const Shop_setting_update_pwd_detail =
      "Shop_setting_update_pwd_detail";
  static const Shop_setting_pay_pwd = "Shop_setting_pay_pwd";
  static const Shop_setting_set_pay_pwd = "Shop_setting_set_pay_pwd";
  static const Shop_setting_change_pay_pwd = "Shop_setting_change_pay_pwd";
  static const Shop_setting_pay_pwd_detail = "Shop_setting_pay_pwd_detail";
  static const Shop_setting_third_auth = "Shop_setting_third_auth";
  static const Shop_setting_facebook = "Shop_setting_facebook";
  static const Shop_setting_google = "Shop_setting_google";
  static const Shop_setting_apple = "Shop_setting_apple";
  static const Shop_setting_bind = "Shop_setting_bind";
  static const Shop_setting_unbind = "Shop_setting_unbind";
  static const Shop_activity = "Shop_activity";
  static const Shop_activity_sponsor = "Shop_activity_sponsor";
  static const Shop_activity_time = "Shop_activity_time";
  static const Shop_activity_complete_task = "Shop_activity_complete_task";
  static const Shop_activity_obtain_goods_profit =
      "Shop_activity_obtain_goods_profit";
  static const Shop_activity_obtain_level_prize =
      "Shop_activity_obtain_level_prize";
  static const Shop_activity_obtain_top_prize =
      "Shop_activity_obtain_top_prize";
  static const Shop_activity_obtain_top_prize_tips =
      "Shop_activity_obtain_top_prize_tips";
  static const Shop_activity_now_start = "Shop_activity_now_start";
  static const Shop_activity_quick_understand =
      "Shop_activity_quick_understand";
  static const Shop_activity_top = "Shop_activity_top";
  static const Shop_activity_count_down = "Shop_activity_count_down";
  static const Shop_activity_level_count = "Shop_activity_level_count";
  static const Shop_activity_level_prize = "Shop_activity_level_prize";
  static const Shop_activity_this_task = "Shop_activity_this_task";
  static const Shop_activity_closed = "Shop_activity_closed";
  static const Shop_activity_not_exist = "Shop_activity_not_exist";
  static const Shop_activity_current_top = "Shop_activity_current_top";
  static const Shop_activity_activity_top = "Shop_activity_activity_top";
  static const Shop_activity_not_listed = "Shop_activity_not_listed";
  static const Shop_activity_top_big_prize = "Shop_activity_top_big_prize";
  static const Shop_activity_get_gold = "Shop_activity_get_gold";
  static const Shop_activity_for_the_level = "Shop_activity_for_the_level";
  static const Shop_activity_st_place = "Shop_activity_st_place";
  static const Shop_activity_random_level_prize =
      "Shop_activity_random_level_prize";
  static const Shop_activity_details = "Shop_activity_details";
  static const Shop_activity_over_status = "Shop_activity_over_status";
  static const Shop_activity_after_the_prize = "Shop_activity_after_the_prize";
  static const Shop_activity_over_all_level = "Shop_activity_over_all_level";
  static const Shop_activity_failed = "Shop_activity_failed";
  static const Shop_activity_not_start = "Shop_activity_not_start";
  static const Shop_activity_doing = "Shop_activity_doing";
  static const Shop_activity_prize = "Shop_activity_prize";
  static const Shop_activity_view_prize = "Shop_activity_view_prize";
  static const Shop_activity_enter_activity = "Shop_activity_enter_activity";
  static const Shop_activity_now_break_barrier =
      "Shop_activity_now_break_barrier";
  static const Shop_activity_continue_break_barrier =
      "Shop_activity_continue_break_barrier";
  static const Shop_activity_podium = "Shop_activity_podium";
  static const Shop_activity_completed_game = "Shop_activity_completed_game";
  static const Shop_activity_mine_prize = "Shop_activity_mine_prize";
  static const Shop_activity_dispatched = "Shop_activity_dispatched";
  static const Shop_activity_task_progressing =
      "Shop_activity_task_progressing";
  static const Shop_activity_activity_progressing =
      "Shop_activity_activity_progressing";
  static const Shop_activity_task_randomly_prize =
      "Shop_activity_task_randomly_prize";
  static const Shop_activity_activity_randomly_prize =
      "Shop_activity_activity_randomly_prize";
  static const Shop_activity_for_the_level_prize =
      "Shop_activity_for_the_level_prize";
  static const Shop_activity_top_prize = "Shop_activity_top_prize";
  static const Shop_activity_task_prize = "Shop_activity_task_prize";
  static const Shop_activity_congratulation_complete_activity =
      "Shop_activity_congratulation_complete_activity";
  static const Shop_activity_congratulation_complete_task =
      "Shop_activity_congratulation_complete_task";
  static const Shop_activity_get = "Shop_activity_get";
  static const Shop_activity_received = "Shop_activity_received";
  static const Shop_activity_expired = "Shop_activity_expired";
  static const Shop_activity_lottery_draw = "Shop_activity_lottery_draw";
  static const Shop_activity_get_prize = "Shop_activity_get_prize";
  static const Shop_activity_get_prize_stop = "Shop_activity_get_prize_stop";
  static const Shop_activity_available = "Shop_activity_available";
  static const Shop_activity_item_level_prize =
      "Shop_activity_item_level_prize";
  static const Shop_activity_item_top_prize = "Shop_activity_item_top_prize";
  static const Shop_activity_item_task_prize = "Shop_activity_item_task_prize";
  static const Shop_activity_no_prize_available =
      "Shop_activity_no_prize_available";
  static const Shop_activity_please_select_prize =
      "Shop_activity_please_select_prize";
  static const Shop_activity_history_activities =
      "Shop_activity_history_activities";
  static const Shop_activity_history_tasks = "Shop_activity_history_tasks";
  static const Shop_activity_draw_now = "Shop_activity_draw_now";
  static const Shop_activity_continue_draw = "Shop_activity_continue_draw";
  static const Shop_activity_total_mxget = "Shop_activity_total_mxget";
  static const Shop_activity_mxget_detail = "Shop_activity_mxget_detail";
  static const Shop_activity_view_details = "Shop_activity_view_details";
  static const Shop_activity_activity_achievements =
      "Shop_activity_activity_achievements";
  static const Shop_activity_level_draw_now_tip =
      "Shop_activity_level_draw_now_tip";
  static const Shop_activity_top_rewards_tip = "Shop_activity_top_rewards_tip";
  static const Shop_activity_statistics_completed =
      "Shop_activity_statistics_completed";
  static const Shop_activity_countdown_drawing_receiving_prize =
      "Shop_activity_countdown_drawing_receiving_prize";
  static const Shop_activity_no_level_reward_tip =
      "Shop_activity_no_level_reward_tip";
  static const Shop_activity_no_rank_reward_tip =
      "Shop_activity_no_rank_reward_tip";
  static const Shop_activity_success_get_level_reward_tip =
      "Shop_activity_success_get_level_reward_tip";
  static const Shop_activity_success_get_rank_reward_tip =
      "Shop_activity_success_get_rank_reward_tip";
  static const Shop_activity_no_prizes_level = "Shop_activity_no_prizes_level";
  static const Shop_activity_lottery_complete =
      "Shop_activity_lottery_complete";
  static const Shop_activity_lottery_tip1 = "Shop_activity_lottery_tip1";
  static const Shop_activity_lottery_tip2 = "Shop_activity_lottery_tip2";
  static const Shop_activity_lottery_tip3 = "Shop_activity_lottery_tip3";
  static const Shop_activity_lottery_tip4 = "Shop_activity_lottery_tip4";
  static const Shop_activity_click_challenge = "Shop_activity_click_challenge";
  static const Shop_activity_challenge_failed_profit =
      "Shop_activity_challenge_failed_profit";
  static const Shop_activity_abandoning = "Shop_activity_abandoning";
  static const Shop_activity_rules = "Shop_activity_rules";
  static const Shop_activity_complete_level_lock_new_level =
      "Shop_activity_complete_level_lock_new_level";
  static const Shop_activity_ranking_information =
      "Shop_activity_ranking_information";
  static const Shop_activity_rule_tip1 = "Shop_activity_rule_tip1";
  static const Shop_activity_rule_tip2 = "Shop_activity_rule_tip2";
  static const Shop_activity_rule_tip3 = "Shop_activity_rule_tip3";
  static const Shop_activity_rule_tip4 = "Shop_activity_rule_tip4";
  static const Shop_activity_abandoning_tip = "Shop_activity_abandoning_tip";
  static const Shop_activity_success_participated =
      "Shop_activity_success_participated";
  static const Shop_activity_success_participated_tip1 =
      "Shop_activity_success_participated_tip1";
  static const Shop_activity_success_participated_tip2 =
      "Shop_activity_success_participated_tip2";
  static const Shop_activity_confirm_abandonment =
      "Shop_activity_confirm_abandonment";
  static const Shop_activity_arbitrary_deal = "Shop_activity_arbitrary_deal";
  static const Shop_activity_deal = "Shop_activity_deal";
  static const Shop_activity_one_step_success =
      "Shop_activity_one_step_success";
  static const Shop_activity_continue_recommend =
      "Shop_activity_continue_recommend";
  static const Shop_activity_wait_statistics_completed =
      "Shop_activity_wait_statistics_completed";
  static const Shop_activity_congratulations_get_prize =
      "Shop_activity_congratulations_get_prize";
  static const Shop_activity_successfully_crossed =
      "Shop_activity_successfully_crossed";
  static const Shop_activity_successfully_crossed_tip =
      "Shop_activity_successfully_crossed_tip";
  static const Shop_activity_enter_next_level =
      "Shop_activity_enter_next_level";
  static const Shop_activity_all_level_success =
      "Shop_activity_all_level_success";
  static const Shop_activity_all_level_success_tip =
      "Shop_activity_all_level_success_tip";
  static const Shop_activity_all_level_success_tip2 =
      "Shop_activity_all_level_success_tip2";
  static const Shop_activity_obsolete = "Shop_activity_obsolete";
  static const Shop_activity_obsolete_tip = "Shop_activity_obsolete_tip";
  static const Shop_activity_homepage = "Shop_activity_homepage";
  static const Shop_activity_remaining_collection_time =
      "Shop_activity_remaining_collection_time";
  static const Shop_activity_waiting_statistics =
      "Shop_activity_waiting_statistics";
  static const Shop_activity_get_prize_finish =
      "Shop_activity_get_prize_finish";
  static const Shop_activity_selected = "Shop_activity_selected";
  static const Shop_activity_total_prizes = "Shop_activity_total_prizes";
  static const Shop_activity_after_receiving_check_order =
      "Shop_activity_after_receiving_check_order";
  static const Shop_activity_no_lottery = "Shop_activity_no_lottery";
  static const Shop_activity_not_counted = "Shop_activity_not_counted";
  static const Shop_activity_mxget_activity = "Shop_activity_mxget_activity";
  static const Shop_activity_48_hours = "Shop_activity_48_hours";
  static const Shop_activity_soon_timeout = "Shop_activity_soon_timeout";
  static const Shop_pocket = "Shop_pocket";
  static const Shop_pocket_task = "Shop_pocket_task";
  static const Shop_pocket_late_task_over = "Shop_pocket_late_task_over";
  static const Shop_pocket_select_product = "Shop_pocket_select_product";
  static const Shop_pocket_task_over = "Shop_pocket_task_over";
  static const Shop_pocket_completed_profit = "Shop_pocket_completed_profit";
  static const Shop_pocket_obsolete = "Shop_pocket_obsolete";
  static const Shop_pocket_share_profit = "Shop_pocket_share_profit";
  static const Shop_pocket_profit = "Shop_pocket_profit";
  static const Shop_pocket_task_stock = "Shop_pocket_task_stock";
  static const Shop_pocket_task_start_time = "Shop_pocket_task_start_time";
  static const Shop_pocket_level = "Shop_pocket_level";
  static const Shop_pocket_more_orders_to_level =
      "Shop_pocket_more_orders_to_next_level";
  static const Shop_pocket_detail = "Shop_pocket_detail";
  static const Shop_pocket_see_rules = "Shop_pocket_see_rules";
  static const Shop_pocket_activity_rules = "Shop_pocket_activity_rules";
  static const Shop_pocket_mine_pocket = "Shop_pocket_mine_pocket";
  static const Shop_pocket_task_volume = "Shop_pocket_task_volume";
  static const Shop_pocket_activity_volume = "Shop_pocket_activity_volume";
  static const Shop_pocket_pocket_upgrade = "Shop_pocket_pocket_upgrade";
  static const Shop_pocket_accept_share_profit =
      "Shop_pocket_accept_share_profit";
  static const Shop_pocket_mine_income = "Shop_pocket_mine_income";
  static const Shop_pocket_history_income = "Shop_pocket_history_income";
  static const Shop_pocket_this_month_income = "Shop_pocket_this_month_income";
  static const Shop_pocket_today_income = "Shop_pocket_today_income";
  static const Shop_pocket_like = "Shop_pocket_like";
  static const Shop_pocket_like_empty_tip = "Shop_pocket_like_empty_tip";
  static const Shop_pocket_go_stroll = "Shop_pocket_go_stroll";
  static const Shop_pocket_tasking = "Shop_pocket_tasking";
  static const Shop_pocket_mxget_history = "Shop_pocket_mxget_history";
  static const Shop_pocket_task_completion_degree =
      "Shop_pocket_task_completion_degree";
  static const Shop_pocket_days = "Shop_pocket_days";
  static const Shop_pocket_hours = "Shop_pocket_hours";
  static const Shop_pocket_copy_link = "Shop_pocket_copy_link";
  static const Shop_pocket_add = "Shop_pocket_add";
  static const Shop_pocket_incomplete = "Shop_pocket_incomplete";
  static const Shop_pocket_completed = "Shop_pocket_completed";
  static const Shop_pocket_time = "Shop_pocket_time";
  static const Shop_pocket_lock_stock = "Shop_pocket_lock_stock";
  static const Shop_pocket_maximum_profit_sharing =
      "Shop_pocket_maximum_profit_sharing";
  static const Shop_pocket_piece = "Shop_pocket_piece";
  static const Shop_pocket_accept_task = "Shop_pocket_accept_task";
  static const Shop_pocket_space = "Shop_pocket_space";
  static const Shop_pocket_order_received_success =
      "Shop_pocket_order_received_success";
  static const Shop_pocket_order_receiving_failed =
      "Shop_pocket_order_receiving_failed";
  static const Shop_pocket_rule_title = "Shop_pocket_rule_title";
  static const Shop_pocket_rule_tip1 = "Shop_pocket_rule_tip1";
  static const Shop_pocket_rule_tip2 = "Shop_pocket_rule_tip2";
  static const Shop_pocket_rule_tip3 = "Shop_pocket_rule_tip3";
  static const Shop_pocket_rule_tip4 = "Shop_pocket_rule_tip4";
  static const Shop_pocket_rule_tip5 = "Shop_pocket_rule_tip5";
  static const Shop_pocket_rule_tip6 = "Shop_pocket_rule_tip6";
  static const Shop_pocket_rule_tip7 = "Shop_pocket_rule_tip7";
  static const Shop_pocket_rule_tip8 = "Shop_pocket_rule_tip8";
  static const Shop_pocket_rule_tip9 = "Shop_pocket_rule_tip9";
  static const Shop_pocket_rule_tip10 = "Shop_pocket_rule_tip10";
  static const Shop_pocket_rule_value_tip1 = "Shop_pocket_rule_value_tip1";
  static const Shop_pocket_rule_value_tip2 = "Shop_pocket_rule_value_tip2";
  static const Shop_pocket_rule_value_tip3 = "Shop_pocket_rule_value_tip3";
  static const Shop_pocket_rule_value_tip4 = "Shop_pocket_rule_value_tip4";
  static const Shop_pocket_rule_value_tip5 = "Shop_pocket_rule_value_tip5";
  static const Shop_pocket_rule_value_tip6 = "Shop_pocket_rule_value_tip6";
  static const Shop_pocket_rule_value_tip7 = "Shop_pocket_rule_value_tip7";
  static const Shop_pocket_rule_value_tip8 = "Shop_pocket_rule_value_tip8";
  static const Shop_pocket_rule_value_tip9 = "Shop_pocket_rule_value_tip9";
  static const Shop_pocket_rule_value_tip10 = "Shop_pocket_rule_value_tip10";
  static const Shop_pocket_simple_level = "Shop_pocket_simple_level";
  static const Shop_pocket_simple_capacity = "Shop_pocket_simple_capacity";
  static const Shop_pocket_simple_foul = "Shop_pocket_simple_foul";
  static const Shop_pocket_success_tips1 = "Shop_pocket_success_tips1";
  static const Shop_pocket_success_tips2 = "Shop_pocket_success_tips2";
  static const Shop_pocket_success_tips3 = "Shop_pocket_success_tips3";
  static const Shop_pocket_failed_level_tips = "Shop_pocket_failed_level_tips";
  static const Shop_pocket_failed_capacity_tips =
      "Shop_pocket_failed_capacity_tips";
  static const Shop_pocket_failed_foul_tips = "Shop_pocket_failed_foul_tips";
  static const Shop_pocket_view_pockets = "Shop_pocket_view_pockets";
  static const Shop_pocket_select_a_task = "Shop_pocket_select_a_task";
  static const Shop_pocket_task_stock_insufficient =
      "Shop_pocket_task_stock_insufficient";
  static const Shop_pocket_total_pieces = "Shop_pocket_total_pieces";
  static const Shop_pocket_complete_orders = "Shop_pocket_complete_orders";
  static const Shop_pocket_task_prize = "Shop_pocket_task_prize";
  static const Shop_pocket_tip = "Shop_pocket_tip";
  static const Shop_pocket_48_hours = "Shop_pocket_48_hours";
  static const Shop_pocket_task_soon_timeout = "Shop_pocket_task_soon_timeout";
  static const Shop_pocket_task_end_time = "Shop_pocket_task_end_time";
  static const Shop_pocket_goods_sold = "Shop_pocket_goods_sold";
  static const Shop_pocket_goods_stock = "Shop_pocket_goods_stock";
  static const Shop_pocket_task_detail = "Shop_pocket_task_detail";
  static const Shop_pocket_rule_policy = "Shop_pocket_rule_policy";
  static const Shop_pocket_number_to_be_completed =
      "Shop_pocket_number_to_be_completed";
  static const Shop_pocket_task_profit_sharing =
      "Shop_pocket_task_profit_sharing";
  static const Shop_pocket_upgrade = "Shop_pocket_upgrade";
  static const Shop_pocket_current_level = "Shop_pocket_current_level";
  static const Shop_pocket_current_level_tip = "Shop_pocket_current_level_tip";
  static const Shop_pocket_doing = "Shop_pocket_doing";
  static const Shop_pocket_counted = "Shop_pocket_counted";
  static const Shop_pocket_challenge_now = "Shop_pocket_challenge_now";
  static const Shop_pocket_continue_to_challenge =
      "Shop_pocket_continue_to_challenge";
  static const Shop_pocket_join_now = "Shop_pocket_join_now";
  static const Shop_pocket_participated = "Shop_pocket_participated";
  static const Shop_pocket_task_completed = "Shop_pocket_task_completed";
  static const Shop_pocket_conversion_rate = "Shop_pocket_conversion_rate";
  static const Shop_pocket_remain = "Shop_pocket_remain";
  static const Shop_pocket_counted_shop = "Shop_pocket_counted_shop";
  static const Shop_pocket_completed_counted = "Shop_pocket_completed_counted";
  static const Shop_pocket_task_counted_tip = "Shop_pocket_task_counted_tip";
  static const Shop_pocket_activity_counted_tip =
      "Shop_pocket_activity_counted_tip";
  static const Shop_pocket_task_finish = "Shop_pocket_task_finish";
  static const Shop_pocket_get_now = "Shop_pocket_get_now";
  static const Shop_pocket_upcoming_profits = "Shop_pocket_upcoming_profits";
  static const Shop_pocket_upcoming_award = "Shop_pocket_upcoming_award";
  static const Shop_pocket_recommend_now = "Shop_pocket_recommend_now";
  static const Shop_pocket_buyer = "Shop_pocket_buyer";
  static const Shop_pocket_purchase_record = "Shop_pocket_purchase_record";
  static const Shop_pocket_purchase_users = "Shop_pocket_purchase_users";
  static const Shop_pocket_purchase_time = "Shop_pocket_purchase_time";
  static const Shop_pocket_purchase_quantity = "Shop_pocket_purchase_quantity";
  static const Shop_pocket_chargeback_record = "Shop_pocket_chargeback_record";
  static const Shop_pocket_chargeback_time = "Shop_pocket_chargeback_time";
  static const Shop_pocket_total_purchase = "Shop_pocket_total_purchase";
  static const Shop_pocket_total_chargeback = "Shop_pocket_total_chargeback";
  static const Shop_pocket_sold_out = "Shop_pocket_sold_out";
  static const Shop_pocket_prize = "Shop_pocket_prize";
  static const Shop_pocket_promotion_center = "Shop_pocket_promotion_center";
  static const Shop_pocket_promotion_qualification =
      "Shop_pocket_promotion_qualification";
  static const Shop_pocket_red_level = "Shop_pocket_red_level";
  static const Shop_pocket_not_active = "Shop_pocket_not_active";
  static const Shop_pocket_activated = "Shop_pocket_activated";
  static const Shop_pocket_not_red_level = "Shop_pocket_not_red_level";
  static const Shop_pocket_earned = "Shop_pocket_earned";
  static const Shop_pocket_period_validity = "Shop_pocket_period_validity";
  static const Shop_pocket_complete_task_tip = "Shop_pocket_complete_task_tip";
  static const Shop_pocket_mxget_task = "Shop_pocket_mxget_task";
  static const Shop_pocket_change_task = "Shop_pocket_change_task";
  static const Shop_pocket_current_task = "Shop_pocket_current_task";
  static const Shop_pocket_this_week = "Shop_pocket_this_week";
  static const Shop_pocket_this_month = "Shop_pocket_this_month";
  static const Shop_pocket_last_month = "Shop_pocket_last_month";
  static const Shop_pocket_enable_prize = "Shop_pocket_enable_prize";
  static const Shop_pocket_winning_task_prize =
      "Shop_pocket_winning_task_prize";
  static const Shop_pocket_winning_task_prize_tip =
      "Shop_pocket_winning_task_prize_tip";
  static const Shop_pocket_sale = "Shop_pocket_sale";
  static const Shop_pocket_prize_price = "Shop_pocket_prize_price";
  static const Shop_bank_card = "Shop_bank_card";
  static const Shop_bank_add_card = "Shop_bank_add_card";
  static const Shop_bank_edit_card = "Shop_bank_edit_card";
  static const Shop_bank_id_card_user = "Shop_bank_id_card_user";
  static const Shop_bank_passport_user = "Shop_bank_passport_user";
  static const Shop_bank_only_en_th = "Shop_bank_only_en_th";
  static const Shop_bank_add_card_tip1 = "Shop_bank_add_card_tip1";
  static const Shop_bank_add_card_tip2 = "Shop_bank_add_card_tip2";
  static const Shop_bank_add_card_tip3 = "Shop_bank_add_card_tip3";
  static const Shop_bank_bank_name = "Shop_bank_bank_name";
  static const Shop_bank_card_number = "Shop_bank_card_number";
  static const Shop_bank_next_step = "Shop_bank_next_step";
  static const Shop_bank_unkown_open_bank = "Shop_bank_unkown_open_bank";
  static const Shop_bank_delete_card = "Shop_bank_delete_card";
  static const Shop_bank_card_already_exist = "Shop_bank_card_already_exist";
  static const Shop_wallet_mxcome = "Shop_wallet_mxcome";
  static const Shop_wallet_mxget_income = "Shop_wallet_mxget_income";
  static const Shop_wallet_transferred_balance =
      "Shop_wallet_transferred_balance";
  static const Shop_wallet_chargeback = "Shop_wallet_chargeback";
  static const Shop_wallet_rebate = "Shop_wallet_rebate";
  static const Shop_wallet_daily_benefits = "Shop_wallet_daily_benefits";
  static const Shop_wallet_newcomer_join = "Shop_wallet_newcomer_join";
  static const Shop_wallet_last_income = "Shop_wallet_last_income";
  static const Shop_wallet_income_detail = "Shop_wallet_income_detail";
  static const Shop_wallet_pocket_money = "Shop_wallet_pocket_money";
  static const Shop_wallet_now_apply = "Shop_balance_now_apply";
  static const Shop_wallet_recharge = "Shop_wallet_recharge";
  static const Shop_wallet_withdrawal = "Shop_wallet_withdrawal";
  static const Shop_wallet_withdrawal_finish = "Shop_wallet_withdrawal_finish";
  static const Shop_wallet_withdrawal_fail = "Shop_wallet_withdrawal_fail";
  static const Shop_wallet_refund = "Shop_wallet_refund";
  static const Shop_wallet_service_charges_fee =
      "Shop_wallet_service_charges_fee";
  static const Shop_wallet_service_fee = "Shop_wallet_service_fee";
  static const Shop_wallet_fee_rate = "Shop_wallet_fee_rate";
  static const Shop_wallet_income = "Shop_wallet_income";
  static const Shop_wallet_bank_card_bind = "Shop_wallet_bank_card_bind";
  static const Shop_wallet_card_tip = "Shop_wallet_card_tip";
  static const Shop_wallet_withdrawal_tip = "Shop_wallet_withdrawal_tip";
  static const Shop_wallet_withdrawal_amount_tip =
      "Shop_wallet_withdrawal_amount_tip";
  static const Shop_wallet_withdrawal_balance_tip =
      "Shop_wallet_withdrawal_balance_tip";
  static const Shop_wallet_today_withdrawal_balance_tip =
      "Shop_wallet_today_withdrawal_balance_tip";
  static const Shop_wallet_withdrawal_time_tip =
      "Shop_wallet_withdrawal_time_tip";
  static const Shop_wallet_cash_withdrawal_rules =
      "Shop_wallet_cash_withdrawal_rules";
  static const Shop_wallet_balance_detail = "Shop_wallet_balance_detail";
  static const Shop_wallet_all = "Shop_wallet_all";
  static const Shop_wallet_balance = "Shop_wallet_balance";
  static const Shop_wallet_task_profit_sharing =
      "Shop_wallet_task_profit_sharing";
  static const Shop_wallet_red_packet_withdrawal =
      "Shop_wallet_red_packet_withdrawal";
  static const Shop_wallet_mxget_profit = "Shop_wallet_mxget_profit";
  static const Shop_wallet_buy_goods = "Shop_wallet_buy_goods";
  static const shop_wallet_expire_date = "shop_wallet_expire_date";
  static const shop_wallet_change_name = "shop_wallet_change_name";
  static const shop_wallet_change_name_tip = "shop_wallet_change_name_tip";
  static const Shop_search_everyone = "Shop_search_everyone";
  static const Shop_search_history = "Shop_search_history";
  static const Shop_monday = "Shop_monday";
  static const Shop_tuesday = "Shop_tuesday";
  static const Shop_wednesday = "Shop_wednesday";
  static const Shop_thursday = "Shop_thursday";
  static const Shop_friday = "Shop_friday";
  static const Shop_saturday = "Shop_saturday";
  static const Shop_sunday = "Shop_sunday";
  static const Shop_today = "Shop_today";
  static const Shop_notification = "Shop_notification";
  static const Shop_permission_denied = "Shop_permission_denied";
  static const Shop_permission_granted = "Shop_permission_granted";
  static const Shop_permission_setting_cancel =
      "Shop_permission_setting_cancel";
  static const Shop_permission_setting_open = "Shop_permission_setting_open";
  static const Shop_permission_camera_title = "Shop_permission_camera_title";
  static const Shop_permission_camera_content =
      "Shop_permission_camera_content";
  static const Shop_permission_camera_setting_title =
      "Shop_permission_camera_setting_title";
  static const Shop_permission_camera_setting_content =
      "Shop_permission_camera_setting_content";
  static const Shop_permission_photos_title = "Shop_permission_photos_title";
  static const Shop_permission_photos_content =
      "Shop_permission_photos_content";
  static const Shop_permission_photos_setting_title =
      "Shop_permission_photos_setting_title";
  static const Shop_permission_photos_setting_content =
      "Shop_permission_photos_setting_content";
  static const Shop_permission_location_title =
      "Shop_permission_location_title";
  static const Shop_permission_location_content =
      "Shop_permission_location_content";
  static const Shop_permission_location_setting_title =
      "Shop_permission_location_setting_title";
  static const Shop_permission_location_setting_content =
      "Shop_permission_location_setting_content";
  static const Shop_permission_scan_title = "Shop_permission_scan_title";
  static const Shop_permission_scan_content = "Shop_permission_scan_content";
  static const Shop_permission_scan_setting_title =
      "Shop_permission_scan_setting_title";
  static const Shop_permission_scan_setting_content =
      "Shop_permission_scan_setting_content";
  static const Shop_pocket_change_record = "Shop_pocket_change_record";
  static const Shop_pocket_surplus_task = "Shop_pocket_surplus_task";
  static const Shop_pocket_view_task = "Shop_pocket_view_task";
  static const Shop_order_merge_cancel = "Shop_oder_merge_cancel";
  static const Shop_order_merge_pay = "Shop_order_merge_pay";
  static const Shop_order_cancel_back = "Shop_order_cancel_back";
  static const Shop_order_goods_limit = "Shop_order_goods_limit";
  static const Shop_product_red_pop_tip1 = "Shop_product_red_pop_tip1";
  static const Shop_product_red_pop_tip2 = "Shop_product_red_pop_tip2";
  static const Shop_product_obtaining_red_qualification =
      "Shop_product_obtaining_red_qualification";
  static const Shop_product_crossed_level_success_tip =
      "Shop_product_crossed_level_success_tip";
  static const Shop_pocket_waiting_exciting_activities =
      "Shop_pocket_waiting_exciting_activities";
  static const Shop_pocket_change_task_tips1 = "Shop_pocket_change_task_tips1";
  static const Shop_pocket_change_task_tips2 = "Shop_pocket_change_task_tips2";
  static const Shop_mine_passing_levels = "Shop_mine_passing_levels";
  static const Shop_mine_direct_push_tips = "Shop_mine_direct_push_tips";
  static const Shop_mine_total_gains = "Shop_mine_total_gains";
  static const Shop_mine_date_to = "Shop_mine_date_to";
  static const Shop_pocket_super_wednesday = "Shop_pocket_super_wednesday";
  static const Shop_pocket_category_super_wednesday =
      "Shop_pocket_category_super_wednesday";
  static const Login_create_mine_link = "Login_create_mine_link";
  static const Login_nickname_exists = "Login_nickname_exists";
  static const Login_link_create_success = "Login_link_create_success";
  static const Login_copy_link = "Login_copy_link";
  static const Login_kol_name_hint = "Login_kol_name_hint";
  static const Login_kol_name_tip = "Login_kol_name_tip";
  static const Login_input_kol_name = "Login_input_kol_name";
  static const Login_input_kol_share = "Login_input_kol_share";
  static const Login_input_kol_recommend = "Login_input_kol_recommend";
  static const shop_mine_receive_discount = "Login_mine_receive_discount";
  static const shop_mine_platform_coupon_tips =
      "Login_mine_platform_coupon_tips";
  static const shop_mine_platform_coupon_hint =
      "Login_mine_platform_coupon_hint";
  static const shop_mine_rebate_status_hint_1 =
      "shop_mine_rebate_status_hint_1";
  static const shop_mine_rebate_status_hint_2 =
      "shop_mine_rebate_status_hint_2";
  static const shop_mine_rebate_status_hint_3 =
      "shop_mine_rebate_status_hint_3";
  static const shop_mine_rebate_status_hint_4 =
      "shop_mine_rebate_status_hint_4";
  static const shop_mine_rebate_rules_1 = "shop_mine_rebate_rules_1";
  static const shop_mine_rebate_rules_2 = "shop_mine_rebate_rules_2";
  static const shop_mine_rebate_rules_3 = "shop_mine_rebate_rules_3";
  static const shop_mine_rebate_current_order =
      "shop_mine_rebate_current_order";
  static const shop_mine_rebate_condition = "shop_mine_rebate_condition";
  static const shop_mine_rebate_order = "shop_mine_rebate_order";
  static const shop_mine_rebate_my_subordinate =
      "shop_mine_rebate_my_subordinate";
  static const shop_mine_rebate_my_subordinate_nums =
      "shop_mine_rebate_my_subordinate_nums";
  static const shop_mine_rebate_bind_time = "shop_mine_rebate_bind_time";
  static const shop_mine_rebate_view_subordinate =
      "shop_mine_rebate_view_subordinate";
  static const shop_mine_rebate_my_profits = "shop_mine_rebate_my_profits";
  static const shop_mine_rebate_expect_total_rebate =
      "shop_mine_rebate_expect_total_rebate";
  static const shop_mine_rebate_total_rebate = "shop_mine_rebate_total_rebate";
  static const shop_mine_rebate_order_num = "shop_mine_rebate_order_num";
  static const shop_mine_rebate_to_be_counted =
      "shop_mine_rebate_to_be_counted";
  static const shop_mine_rebate_already_counted =
      "shop_mine_rebate_already_counted";
  static const shop_mine_rebate_pending_settlement =
      "shop_mine_rebate_pending_settlement";
  static const shop_mine_rebate_settled = "shop_mine_rebate_settled";
  static const shop_mine_rebate_period_range = "shop_mine_rebate_period_range";
  static const shop_mine_rebate_calculate_order =
      "shop_mine_rebate_calculate_order";
  static const shop_mine_rebate_settlement_order =
      "shop_mine_rebate_settlement_order";
  static const shop_mine_rebate_my_rebate = "shop_mine_rebate_my_rebate";
  static const shop_mine_rebate_my_expect_rebate =
      "shop_mine_rebate_my_expect_rebate";
  static const shop_mine_rebate_exclusive_qr_code =
      "shop_mine_rebate_exclusive_qr_code";
  static const shop_mine_rebate_my_superior = "shop_mine_rebate_my_superior";
  static const shop_mine_rebate_my_superior_tips1 =
      "shop_mine_rebate_my_superior_tips1";
  static const shop_mine_rebate_my_superior_tips2 =
      "shop_mine_rebate_my_superior_tips2";
  static const shop_mine_rebate_save = "shop_mine_rebate_save";
  static const shop_mine_rebate_recommend = "shop_mine_rebate_recommend";
  static const shop_mine_rebate_no_superior = "shop_mine_rebate_no_superior";
  static const shop_mine_rebate_bind_superior =
      "shop_mine_rebate_bind_superior";
  static const shop_mine_rebate_bind_superior_tips =
      "shop_mine_rebate_bind_superior_tips";
  static const shop_mine_rebate_bind_superior_confirm =
      "shop_mine_rebate_bind_superior_confirm";
  static const shop_mine_rebate_bind_superior_success =
      "shop_mine_rebate_bind_superior_success";
  static const shop_mine_rebate_save_success = "shop_mine_rebate_save_success";
  static const shop_mine_rebate_album = "shop_mine_rebate_album";
  static const shop_mine_rebate_recognition_error =
      "shop_mine_rebate_recognition_error";
  static const shop_home_monthly_benefits_tip =
      "shop_home_monthly_benefits_tip";
  static const shop_home_monthly_benefits_tip_1 =
      "shop_home_monthly_benefits_tip_1";
  static const shop_home_monthly_benefits_tip_2 =
      "shop_home_monthly_benefits_tip_2";
  static const shop_home_load_more = "shop_home_load_more";
  static const shop_home_balance_window_tip_1 =
      "shop_home_balance_window_tip_1";
  static const shop_home_balance_window_tip_2 =
      "shop_home_balance_window_tip_2";
  static const shop_home_rebate_close_tip = "shop_home_rebate_close_tip";
  static const shop_home_rebate_order_unfinished_tip =
      "shop_home_rebate_order_unfinished_tip";
  static const shop_web3_email_sent = "shop_web3_email_sent";
  static const shop_web3_format_incorrect = "shop_web3_format_incorrect";
  static const shop_web3_luck_draw = "shop_web3_luck_draw";
  static const shop_web3_chance_lucky_draw = "shop_web3_chance_lucky_draw";
  static const shop_web3_winning_list = "shop_web3_winning_list";
  static const shop_web3_received_prizes = "shop_web3_received_prizes";
  static const shop_web3_winning_draws_hint = "shop_web3_winning_draws_hint";
  static const shop_web3_start_lottery = "shop_web3_start_lottery";
  static const shop_web3_winning_following_prizes =
      "shop_web3_winning_following_prizes";
  static const shop_web3_claim_prizes = "shop_web3_claim_prizes";
  static const shop_web3_please_ensure_accurate_and_correct =
      "shop_web3_please_ensure_accurate_and_correct";
  static const shop_web3_email = "shop_web3_email";
  static const shop_web3_transfer_out_address =
      "shop_web3_transfer_out_address";
  static const Shop_web3_financial_losses = "Shop_web3_financial_losses";
  static const Shop_web3_transfer_fee = "Shop_web3_transfer_fee";
  static const Shop_web3_free = "Shop_web3_free";
  static const Shop_web3_expected_credited = "Shop_web3_expected_credited";
  static const Shop_web3_slide_confirmation = "Shop_web3_slide_confirmation";
  static const Shop_web3_transfer_in = "Shop_web3_transfer_in";
  static const Shop_web3_transfer_out = "Shop_web3_transfer_out";
  static const Shop_web3_address = "Shop_web3_address";
  static const Shop_web3_assets = "Shop_web3_assets";
  static const Shop_web3_enter_receive_wallet_address =
      "Shop_web3_enter_receive_wallet_address";
  static const Shop_web3_choose_transfer_assets =
      "Shop_web3_choose_transfer_assets";
  static const Shop_web3_user_confirm_tip1 = "Shop_web3_user_confirm_tip1";
  static const Shop_web3_user_confirm_tip2 = "Shop_web3_user_confirm_tip2";
  static const Shop_web3_transfer = "Shop_web3_transfer";
  static const Shop_web3_account_email = "Shop_web3_account_email";
  static const Shop_web3_enter_email = "Shop_web3_enter_email";
  static const Shop_web3_selected = "Shop_web3_selected";
  static const Shop_web3_select_asset_type = "Shop_web3_select_asset_type";
  static const Shop_web3_select_assets = "Shop_web3_select_assets";
  static const Shop_web3_enter_your_email = "Shop_web3_enter_your_email";
  static const Shop_web3_enter_email_code = "Shop_web3_enter_email_code";
  static const Shop_web3_agree_accept = "Shop_web3_agree_accept";
  static const Shop_web3_mxcome_protocol = "Shop_web3_mxcome_protocol";
  static const Shop_web3_activate_now = "Shop_web3_activate_now";
  static const Shop_web3_wallet = "Shop_web3_wallet";
  static const Shop_web3_get = "Shop_web3_get";
  static const Shop_web3_stored_value = "Shop_web3_stored_value";
  static const Shop_web3_did_assets = "Shop_web3_did_assets";
  static const Shop_web3_not_config_adv = "Shop_web3_not_config_adv";
  static const Shop_vip_agreement_title = "Shop_vip_agreement_title";
  static const Shop_full_read_agree = "Shop_full_read_agree";
  static const Shop_please_check_agreement = "Shop_please_check_agreement";
  static const Shop_modify_buy_quantity = "Shop_modify_buy_quantity";
  static const Shop_rights_unlocked = "Shop_rights_unlocked";

  // 泰国政府推荐占位框
  static const Gov_recommend_title = "Gov_recommend_title";
  static const Gov_recommend_subtitle = "Gov_recommend_subtitle";
  static const Promotion_highlight_category_fallback =
      "Promotion_highlight_category_fallback";
}

class LanguageType {
  static const EN = "EN"; //英语
  static const TH = "TH"; //泰语
  static const ZH = "ZH"; //简体中文
}
