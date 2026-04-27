import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';

class HomeAdvertiseServer {
  // 获取快捷功能列表
  static featuredPromotionUrl() {
    return HttpUtils.post(IURLConstant.MALL_SHOP_FEATURED_PROMOTION, {});
  }

  // 获取快捷功能详情（根据快捷功能ID获取）
  static featuredPromotionDetailUrl(data) {
    return HttpUtils.post(IURLConstant.MALL_SHOP_FEATURED_PROMOTION_DETAIL, data);
  }
}