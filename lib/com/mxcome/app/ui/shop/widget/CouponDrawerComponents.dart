import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ClipboardUtil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 优惠券展示类型（用于券卡片/券类型选择）
enum CouponBenefitType {
  fullReduction,
  cashVoucher,
  discount,
  freeShipping,
}

/// 优惠券状态（用于券卡片的置灰/禁用等样式）
enum CouponBenefitStatus {
  unused,
  used,
  expired,
}

/// 抽屉顶部的分段切换按钮（使用优惠券 / 店铺）
/// - 用途：替代 TabBar 的轻量样式，支持滑块动效
/// - Props：labels/index/onChanged 等均可配置
class CouponSegmentedSwitch extends StatelessWidget {
  final double width;
  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;
  final double height;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color thumbColor;
  final TextStyle? activeTextStyle;
  final TextStyle? inactiveTextStyle;
  final BorderRadius borderRadius;

  const CouponSegmentedSwitch({
    super.key,
    this.width = double.infinity,
    required this.index,
    required this.labels,
    required this.onChanged,
    this.height = 36,
    this.padding = const EdgeInsets.all(2),
    Color? backgroundColor,
    Color? thumbColor,
    this.activeTextStyle,
    this.inactiveTextStyle,
    BorderRadius? borderRadius,
  })  : backgroundColor = backgroundColor ?? const Color(0xFFF4F4F4),
        thumbColor = thumbColor ?? Colors.white,
        borderRadius =
            borderRadius ?? const BorderRadius.all(Radius.circular(22));

  @override
  Widget build(BuildContext context) {
    final int safeIndex =
        index < 0 ? 0 : (index >= labels.length ? labels.length - 1 : index);

    final double resolvedWidth = width.isFinite ? width.w : double.infinity;

    return SizedBox(
      width: resolvedWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = constraints.maxWidth / labels.length;
          final TextStyle activeStyle = activeTextStyle ??
              TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: IConstant.title_color,
              );
          final TextStyle inactiveStyle = inactiveTextStyle ??
              TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: IConstant.grey_color,
              );

          return Container(
            height: height.w,
            padding: EdgeInsets.all(padding.left.w),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: itemWidth * safeIndex,
                  top: 0,
                  bottom: 0,
                  width: itemWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: thumbColor,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(labels.length, (i) {
                    final bool active = i == safeIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => onChanged(i),
                        borderRadius: borderRadius,
                        child: Center(
                          child: Text(
                            labels[i],
                            style: active ? activeStyle : inactiveStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 店铺 Tab 的头部区域（店铺信息 + 券类型横滑选择）
/// - 用途：抽屉“店铺”页顶部信息区
/// - 通过 activeCouponIdListenable 仅刷新券类型选择，不重建整块 Header
class CouponShopTabHeaderSection extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String address;
  final String phone;
  final VoidCallback onNavigateTap;
  final List<dynamic> couponList;
  final ValueListenable<String> activeCouponIdListenable;
  final ValueChanged<String> onSelectCouponId;

  const CouponShopTabHeaderSection({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.address,
    required this.phone,
    required this.onNavigateTap,
    required this.couponList,
    required this.activeCouponIdListenable,
    required this.onSelectCouponId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IConstant.grey_color.withOpacity(0.1),
                image: logoUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(logoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: logoUrl.isEmpty
                  ? Icon(Icons.store, size: 22.w, color: IConstant.grey_color)
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: IConstant.title_color,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  if (address.isNotEmpty)
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: IConstant.grey_color,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: phone.isEmpty
                  ? null
                  : () async {
                      final uri = Uri.parse('tel:$phone');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
              borderRadius: BorderRadius.circular(18.w),
              child: SizedBox(
                width: 36.w,
                height: 36.w,
                child: Center(
                  child: Icon(Icons.call,
                      size: 18.w, color: IConstant.title_color),
                ),
              ),
            ),
            InkWell(
              onTap: onNavigateTap,
              borderRadius: BorderRadius.circular(18.w),
              child: SizedBox(
                width: 36.w,
                height: 36.w,
                child: Center(
                  child: Icon(Icons.place,
                      size: 18.w, color: IConstant.title_color),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        if (couponList.isNotEmpty)
          ValueListenableBuilder<String>(
            valueListenable: activeCouponIdListenable,
            builder: (context, activeId, _) {
              return CouponTypeSelector(
                couponList: couponList,
                activeCouponId: activeId,
                onSelect: onSelectCouponId,
              );
            },
          ),
      ],
    );
  }
}

/// 抽屉顶部的拖拽把手
class CouponDrawerHandle extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets margin;
  final Color color;
  final BorderRadius borderRadius;

  const CouponDrawerHandle({
    super.key,
    this.width = 44,
    this.height = 6,
    this.margin = const EdgeInsets.only(top: 10, bottom: 10),
    Color? color,
    BorderRadius? borderRadius,
  })  : color = color ?? IConstant.grey_line_color,
        borderRadius =
            borderRadius ?? const BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.w,
      margin: EdgeInsets.only(
        top: margin.top.w,
        bottom: margin.bottom.w,
        left: margin.left.w,
        right: margin.right.w,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// 抽屉“使用优惠券”页的店铺头部（logo/店名/优惠文案/可选分享按钮）
class CouponShopHeader extends StatelessWidget {
  final String logoUrl;
  final String title;
  final String subtitle;
  final VoidCallback? onShareTap;
  final Widget? shareIcon;

  const CouponShopHeader({
    super.key,
    required this.logoUrl,
    required this.title,
    required this.subtitle,
    this.onShareTap,
    this.shareIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 61.w,
                  height: 61.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: IConstant.grey_color.withOpacity(0.1),
                    image: logoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(logoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: logoUrl.isEmpty
                      ? Icon(Icons.store,
                          size: 28.w, color: IConstant.grey_color)
                      : null,
                ),
                SizedBox(height: 4.w),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: IConstant.title_color,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: IConstant.main_color,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 6.w,
              child: onShareTap == null
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: onShareTap,
                      borderRadius: BorderRadius.circular(12.w),
                      child: SizedBox(
                        width: 36.w,
                        height: 36.w,
                        child: Center(
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.w),
                              border: Border.all(
                                width: 1.w,
                                color: IConstant.grey_line_color,
                              ),
                            ),
                            child: Center(
                              child: shareIcon ??
                                  Icon(
                                    Icons.ios_share,
                                    size: 20.w,
                                    color: IConstant.title_color,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 抽屉“使用优惠券”页的二维码展示区（二维码 + 券码 + 提示文案）
class CouponQrSection extends StatelessWidget {
  final String qrData;
  final String code;
  final String tipText;

  const CouponQrSection({
    super.key,
    required this.qrData,
    required this.code,
    required this.tipText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200.w,
          height: 200.w,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: qrData.isNotEmpty
              ? QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.w,
                )
              : Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 40.w,
                    color: IConstant.grey_color.withOpacity(0.5),
                  ),
                ),
        ),
        if (code.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
              border: Border.all(width: 1.w, color: IConstant.grey_line_color),
            ),
            child: Text(
              '券码: $code',
              style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
            ),
          ),
        SizedBox(height: 4.w),
        Text(
          tipText,
          style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color),
        ),
      ],
    );
  }
}

/// 券类型卡片（满减/代金/折扣/免邮）——可在抽屉、列表页、详情页复用
/// - active：当前选中态（边框/底色）
/// - status：未使用/已使用/已过期（置灰）
/// - benefitType：可选，未传则根据数据字段推断
class CouponBenefitCard extends StatelessWidget {
  final dynamic coupon;
  final bool active;
  final CouponBenefitStatus status;
  final CouponBenefitType? benefitType;
  final VoidCallback? onTap;
  final double width;

  const CouponBenefitCard({
    super.key,
    required this.coupon,
    required this.active,
    this.status = CouponBenefitStatus.unused,
    this.benefitType,
    this.onTap,
    this.width = 140,
  });

  CouponBenefitType _inferType() {
    if (benefitType != null) return benefitType!;
    final double minPoint = BaseModel.getDouble(coupon, 'minPoint');
    final double discount = BaseModel.getDouble(coupon, 'discount');
    final int freeShipping = BaseModel.getInt(coupon, 'freeShipping');
    if (freeShipping == 1) return CouponBenefitType.freeShipping;
    if (discount > 0) return CouponBenefitType.discount;
    if (minPoint > 0) return CouponBenefitType.fullReduction;
    return CouponBenefitType.cashVoucher;
  }

  String _typeText() {
    final type = _inferType();
    switch (type) {
      case CouponBenefitType.fullReduction:
        return '满减券';
      case CouponBenefitType.discount:
        return '折扣券';
      case CouponBenefitType.freeShipping:
        return '免邮券';
      case CouponBenefitType.cashVoucher:
        return '代金券';
    }
  }

  String _amountText() {
    return '${IConstant.currency}${BaseModel.getDouble(coupon, 'amount').toInt()}';
  }

  String _benefitText() {
    final type = _inferType();
    final double minPoint = BaseModel.getDouble(coupon, 'minPoint');
    final double amount = BaseModel.getDouble(coupon, 'amount');
    if (type == CouponBenefitType.fullReduction && minPoint > 0) {
      return '满 ฿${minPoint.toInt()} 减 ฿${amount.toInt()}';
    }
    if (type == CouponBenefitType.cashVoucher) {
      return '฿${amount.toInt()} 代金券';
    }
    return '';
  }

  String _expireText() {
    final String endTime = BaseModel.getString(coupon, 'endTime');
    if (endTime.isEmpty) return '';
    final String normalized = endTime.replaceAll('T', ' ');
    final String endDate =
        normalized.length >= 10 ? normalized.substring(0, 10) : normalized;
    return '有效期 $endDate';
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        active ? IConstant.main_color : Colors.transparent;

    final bool dimmed = status != CouponBenefitStatus.unused;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.w),
      child: Opacity(
        opacity: dimmed ? 0.55 : 1,
        child: Container(
          width: width.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: IConstant.red_bg_color6,
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(width: 1.w, color: borderColor),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _typeText(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: IConstant.title_color,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _amountText(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: IConstant.title_color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.w),
              Text(
                _benefitText(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: IConstant.main_color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.w),
              Text(
                _expireText(),
                style: TextStyle(fontSize: 11.sp, color: IConstant.grey_color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 券类型横向选择器（对应 Vue 的 coupon-types 区域）
/// - 内部 item 使用 CouponBenefitCard 渲染
class CouponTypeSelector extends StatelessWidget {
  final List<dynamic> couponList;
  final String activeCouponId;
  final ValueChanged<String> onSelect;

  const CouponTypeSelector({
    super.key,
    required this.couponList,
    required this.activeCouponId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: couponList.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = couponList[index];
          final String id = BaseModel.getString(item, 'id');
          final bool active = id == activeCouponId;
          return CouponBenefitCard(
            coupon: item,
            active: active,
            onTap: () {
              if (id.isEmpty) return;
              onSelect(id);
            },
          );
        },
      ),
    );
  }
}

/// 地址栏组件
class CouponStoreAddressRow extends StatelessWidget {
  final String addressText;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onSelectStore;

  const CouponStoreAddressRow({
    super.key,
    required this.addressText,
    required this.expanded,
    required this.onToggle,
    required this.onSelectStore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '选择门店',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: IConstant.title_color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SizedBox(
            height: 44.w,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(22.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.w),
                  border:
                      Border.all(width: 1.w, color: IConstant.grey_line_color),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 18.w, color: IConstant.title_color),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        addressText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: IConstant.title_color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20.w,
                      color: IConstant.title_color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 地图选择器组件
class CouponMapPickerDrawer extends StatelessWidget {
  final String address;
  final String lat;
  final String lng;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const CouponMapPickerDrawer({
    super.key,
    required this.address,
    required this.lat,
    required this.lng,
    this.initialChildSize = 1,
    this.minChildSize = 0.60,
    this.maxChildSize = 0.90,
  });

  static Future<bool> show(
    BuildContext context, {
    required String address,
    required String lat,
    required String lng,
  }) async {
    final bool? ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return CouponMapPickerDrawer(
          address: address,
          lat: lat,
          lng: lng,
        );
      },
    );
    return ok ?? false;
  }

  static Future<bool> _launchMap(
    BuildContext context,
    CouponMapApp app, {
    required String address,
    required String lat,
    required String lng,
  }) async {
    final bool hasCoord = lat.isNotEmpty && lng.isNotEmpty;
    final String name = address.isNotEmpty ? address : '目的地';
    final TargetPlatform platform = Theme.of(context).platform;
    final bool isIOS = platform == TargetPlatform.iOS;

    Uri? uri;
    if (kIsWeb || app == CouponMapApp.google) {
      uri = Uri.parse(
        hasCoord
            ? 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'
            : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    } else if (app == CouponMapApp.amap) {
      if (hasCoord) {
        uri = Uri.parse(
          isIOS
              ? 'iosamap://path?sourceApplication=mxcome&dlat=$lat&dlon=$lng&dname=${Uri.encodeComponent(name)}&dev=0&t=0'
              : 'androidamap://route?sourceApplication=mxcome&dlat=$lat&dlon=$lng&dname=${Uri.encodeComponent(name)}&dev=0&t=0',
        );
      } else {
        uri = Uri.parse(
          isIOS
              ? 'iosamap://poi?sourceApplication=mxcome&keywords=${Uri.encodeComponent(address)}'
              : 'androidamap://poi?sourceApplication=mxcome&keywords=${Uri.encodeComponent(address)}',
        );
      }
    } else if (app == CouponMapApp.tencent) {
      if (hasCoord) {
        uri = Uri.parse(
          'qqmap://map/routeplan?type=drive&tocoord=$lat,$lng&to=${Uri.encodeComponent(name)}&referer=mxcome',
        );
      } else {
        uri = Uri.parse(
          'qqmap://map/search?keyword=${Uri.encodeComponent(address)}&referer=mxcome',
        );
      }
    } else if (app == CouponMapApp.baidu) {
      if (hasCoord) {
        uri = Uri.parse(
          'baidumap://map/direction?destination=latlng:$lat,$lng|name:${Uri.encodeComponent(name)}&mode=driving&src=mxcome',
        );
      } else {
        uri = Uri.parse(
          'baidumap://map/geocoder?address=${Uri.encodeComponent(address)}&src=mxcome',
        );
      }
    }

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }

    final Uri fallback = Uri.parse(
      hasCoord
          ? 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'
          : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(fallback)) {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildOption({
      required String name,
      required String desc,
      required String iconAsset,
      required CouponMapApp app,
    }) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.w),
          onTap: () async {
            final bool ok = await _launchMap(
              context,
              app,
              address: address,
              lat: lat,
              lng: lng,
            );
            if (!context.mounted) return;
            if (ok) {
              Navigator.pop(context, true);
            }
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(
                width: 1.w,
                color: IConstant.grey_line_color,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  alignment: Alignment.center,
                  child: iconAsset.endsWith('.svg')
                      ? SvgPicture.asset(
                          iconAsset,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          iconAsset,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.contain,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: IConstant.title_color,
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: IConstant.grey_color,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios,
                    size: 16.w, color: IConstant.grey_color),
              ],
            ),
          ),
        ),
      );
    }

    final double fixedChildSize = initialChildSize.clamp(0.1, 1.0);
    return DraggableScrollableSheet(
      initialChildSize: fixedChildSize,
      minChildSize: fixedChildSize,
      maxChildSize: fixedChildSize,
      expand: false,
      builder: (context, controller) {
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5F6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(26.w)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(26.w)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: const CouponDrawerHandle(),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      padding: EdgeInsets.all(20.w),
                      itemCount: 4,
                      separatorBuilder: (_, __) => SizedBox(height: 12.w),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return buildOption(
                              name: 'Google Maps',
                              desc: 'Google 地图',
                              iconAsset: 'assets/icons/map_google.svg',
                              app: CouponMapApp.google,
                            );
                          case 1:
                            return buildOption(
                              name: '高德地图',
                              desc: 'Gaode Maps',
                              iconAsset: 'assets/icons/map_gaode.png',
                              app: CouponMapApp.amap,
                            );
                          case 2:
                            return buildOption(
                              name: '百度地图',
                              desc: 'Baidu Maps',
                              iconAsset: 'assets/icons/map_baidu.png',
                              app: CouponMapApp.baidu,
                            );
                          default:
                            return buildOption(
                              name: '腾讯地图',
                              desc: 'Tencent Maps',
                              iconAsset: 'assets/icons/map_tencent.png',
                              app: CouponMapApp.tencent,
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 门店列表组件（包含选中态与复制地址）
class CouponStoreList extends StatelessWidget {
  final List<dynamic> shopList;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const CouponStoreList({
    super.key,
    required this.shopList,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.w,
      child: ListView.separated(
        itemCount: shopList.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.w),
        itemBuilder: (context, index) {
          final store = shopList[index];
          final bool active = index == selectedIndex;
          final String storeName = BaseModel.getString(store, 'name');
          final String address = BaseModel.getString(store, 'address');
          return Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(
                width: 1.w,
                color: active ? IConstant.main_color : IConstant.line_color,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onSelect(index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: IConstant.title_color,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          address,
                          style: TextStyle(
                              fontSize: 12.sp, color: IConstant.grey_color),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                TextButton(
                  onPressed: () {
                    ClipboardUtil.setDataToast(address);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '复制地址',
                    style:
                        TextStyle(fontSize: 12.sp, color: IConstant.main_color),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 底部主按钮（如“导航到店”）
class CouponPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;

  const CouponPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFF4B6DFF),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.w),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                Icon(
                  Icons.near_me_outlined,
                  size: 20.w,
                  color: textColor,
                ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部门店选择器组件
class CouponStorePickerActionSection extends StatelessWidget {
  final String addressText;
  final List<dynamic> shopList;
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final VoidCallback? onNavigateTap;
  final VoidCallback? onNoDataTap;
  final double sheetMaxHeightFactor;

  const CouponStorePickerActionSection({
    super.key,
    required this.addressText,
    required this.shopList,
    required this.selectedIndex,
    required this.onSelectIndex,
    this.onNavigateTap,
    this.onNoDataTap,
    this.sheetMaxHeightFactor = 0.6,
  });

  Future<void> _openStorePicker(BuildContext context) async {
    if (shopList.isEmpty) {
      onNoDataTap?.call();
      return;
    }

    final int? pickedIndex = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final double maxHeight =
            MediaQuery.of(context).size.height * sheetMaxHeightFactor;
        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CouponDrawerHandle(),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 16.w),
                    child: CouponStoreList(
                      shopList: shopList,
                      selectedIndex: selectedIndex,
                      onSelect: (index) => Navigator.pop(context, index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedIndex == null) return;
    onSelectIndex(pickedIndex);
  }

  Future<void> _openMapPicker(BuildContext context) async {
    if (shopList.isEmpty ||
        selectedIndex < 0 ||
        selectedIndex >= shopList.length) {
      onNoDataTap?.call();
      return;
    }

    final dynamic store = shopList[selectedIndex];
    final String address = BaseModel.getString(store, 'address');
    final String lat = BaseModel.getString(store, 'lat').isNotEmpty
        ? BaseModel.getString(store, 'lat')
        : BaseModel.getString(store, 'latitude');
    final String lng = BaseModel.getString(store, 'lng').isNotEmpty
        ? BaseModel.getString(store, 'lng')
        : BaseModel.getString(store, 'longitude');

    if (address.isEmpty && (lat.isEmpty || lng.isEmpty)) {
      onNoDataTap?.call();
      return;
    }

    await CouponMapPickerDrawer.show(
      context,
      address: address,
      lat: lat,
      lng: lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CouponStoreAddressRow(
          addressText: addressText,
          expanded: false,
          onToggle: () => _openStorePicker(context),
          onSelectStore: () => _openStorePicker(context),
        ),
        SizedBox(height: 6.w),
        CouponPrimaryButton(
          text: '导航到店',
          onPressed: onNavigateTap ?? () => _openMapPicker(context),
        ),
      ],
    );
  }
}

enum CouponMapApp { google, amap, tencent, baidu }
