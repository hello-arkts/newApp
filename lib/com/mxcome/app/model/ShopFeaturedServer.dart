import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';

class ShopFeaturedServer {
  // 根据店铺ID获取商品列表
  static productByShopidUrl(data) {
    return HttpUtils.post(IURLConstant.MALL_COUPON_DETAIL_BY_ID_SHOP, data);
  }

  // 根据店铺ID获取店铺品牌详情
  static shopBrandByShopidUrl(data) {
    return HttpUtils.post(IURLConstant.MALL_PRODUCT_BY_SHOPID, data);
  }
}
