import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/widget/CouponDrawerComponents.dart';

class CouponDetailDrawer extends StatefulWidget {
  final String initialCouponId;
  final dynamic initialItem;

  const CouponDetailDrawer({
    super.key,
    required this.initialCouponId,
    required this.initialItem,
  });

  @override
  State<CouponDetailDrawer> createState() => _CouponDetailDrawerState();
}

class _CouponDetailDrawerState extends State<CouponDetailDrawer> {
  bool _loading = true;
  dynamic _detail;
  List<dynamic> _couponList = [];
  List<dynamic> _shopList = [];
  late final ValueNotifier<String> _activeCouponId;
  int _selectedStoreIndex = 0;
  int _tabIndex = 0;
  double _bottomDragDy = 0;

  @override
  void initState() {
    super.initState();
    _activeCouponId = ValueNotifier(widget.initialCouponId);
    _loadDetail(_activeCouponId.value);
  }

  @override
  void dispose() {
    _activeCouponId.dispose();
    super.dispose();
  }

  Future<void> _loadDetail(String couponId, {bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _loading = true;
      });
    }
    try {
      final rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_DETAIL, {
        'couponId': couponId,
      });
      if (!mounted) return;
      if (rsp.retCode == 200) {
        final data = rsp.data;
        final dynamic couponTypes = BaseModel.getDynamic(data, 'couponTypes');
        final List<dynamic> couponList =
            (BaseModel.getDynamicList(data, 'couponList') ?? [])
                .cast<dynamic>();
        final List<dynamic> shopList =
            (BaseModel.getDynamicList(data, 'shopList') ?? []).cast<dynamic>();
        final List<dynamic> fallbackCouponList =
            (BaseModel.getDynamicList(couponTypes, 'couponList') ?? [])
                .cast<dynamic>();
        final List<dynamic> fallbackShopList =
            (BaseModel.getDynamicList(couponTypes, 'shopList') ?? [])
                .cast<dynamic>();
        _activeCouponId.value = couponId;
        setState(() {
          final List<dynamic> resolvedShopList =
              shopList.isNotEmpty ? shopList : fallbackShopList;
          _detail = data;
          _couponList = couponList.isNotEmpty ? couponList : fallbackCouponList;
          _shopList = List<dynamic>.generate(10, (_) => resolvedShopList)
              .expand((e) => e)
              .toList();
          _selectedStoreIndex = _shopList.isNotEmpty ? 0 : -1;
          _loading = false;
        });
        return;
      }
      setState(() {
        _loading = false;
      });
      ViewUtils.displayToast(rsp.msg);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.ViewUtils_retry));
    }
  }

  String _couponAmount(dynamic coupon) {
    double minPoint = BaseModel.getDouble(coupon, 'minPoint');
    double amount = BaseModel.getDouble(coupon, 'amount');
    if (minPoint > 0) {
      return '满 ฿${minPoint.toInt()} 减 ฿${amount.toInt()}';
    }
    return '฿${amount.toInt()} 代金券';
  }

  Future<void> _openNavigation() async {
    if (_shopList.isEmpty || _selectedStoreIndex < 0) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
      return;
    }
    final store = _shopList[_selectedStoreIndex];
    final String address = BaseModel.getString(store, 'address');
    final String lat = BaseModel.getString(store, 'lat').isNotEmpty
        ? BaseModel.getString(store, 'lat')
        : BaseModel.getString(store, 'latitude');
    final String lng = BaseModel.getString(store, 'lng').isNotEmpty
        ? BaseModel.getString(store, 'lng')
        : BaseModel.getString(store, 'longitude');

    if (address.isEmpty && (lat.isEmpty || lng.isEmpty)) {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
      return;
    }

    await CouponMapPickerDrawer.show(
      context,
      address: address,
      lat: lat,
      lng: lng,
    );
  }

  bool _handleUseTabScrollNotification(ScrollNotification notification) {
    if (_tabIndex != 0) return false;
    if (notification is OverscrollNotification) {
      final metrics = notification.metrics;
      final bool atBottom = metrics.pixels >= metrics.maxScrollExtent;
      if (atBottom && notification.overscroll > 10) {
        setState(() {
          _tabIndex = 1;
        });
      }
    }
    return false;
  }

  void _switchToShopTab() {
    if (_tabIndex != 0) return;
    if (_bottomDragDy < -40) {
      setState(() {
        _tabIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      minChildSize: 0.3,
      maxChildSize: 0.93,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CouponDrawerHandle(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
                child: Align(
                  alignment: Alignment.center,
                  child: CouponSegmentedSwitch(
                    width: 210,
                    index: _tabIndex,
                    labels: [
                      LanguageConfig.get(
                          LanguageConfigKeys.Shop_mine_use_coupons),
                      LanguageConfig.get(LanguageConfigKeys.Shop_product_shop),
                    ],
                    onChanged: (i) {
                      if (i == _tabIndex) return;
                      setState(() {
                        _tabIndex = i;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child:
                                      NotificationListener<ScrollNotification>(
                                    onNotification:
                                        _handleUseTabScrollNotification,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      padding: EdgeInsets.fromLTRB(
                                          16.w, 8.w, 16.w, 12.w),
                                      child: _tabIndex == 0
                                          ? _buildContent()
                                          : _buildShopTab(),
                                    ),
                                  ),
                                ),
                                if (_tabIndex == 0) _buildBottom(),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopTab() {
    final dynamic detail = _detail ?? {};
    final dynamic shop = BaseModel.getDynamic(detail, 'shop') ?? {};
    final dynamic initShop =
        BaseModel.getDynamic(widget.initialItem, 'shop') ?? {};
    final String logo = BaseModel.getString(shop, 'logo').isNotEmpty
        ? BaseModel.getString(shop, 'logo')
        : BaseModel.getString(initShop, 'logo');
    final String name = BaseModel.getString(shop, 'name').isNotEmpty
        ? BaseModel.getString(shop, 'name')
        : BaseModel.getString(detail, 'name').isNotEmpty
            ? BaseModel.getString(detail, 'name')
            : BaseModel.getString(widget.initialItem, 'name');

    final dynamic store = (_shopList.isNotEmpty &&
            _selectedStoreIndex >= 0 &&
            _selectedStoreIndex < _shopList.length)
        ? _shopList[_selectedStoreIndex]
        : {};
    final String address = BaseModel.getString(store, 'address');
    final String phone = BaseModel.getString(store, 'phone').isNotEmpty
        ? BaseModel.getString(store, 'phone')
        : BaseModel.getString(store, 'tel');

    return CouponShopTabHeaderSection(
      logoUrl: logo,
      name: name,
      address: address,
      phone: phone,
      onNavigateTap: _openNavigation,
      couponList: _couponList,
      activeCouponIdListenable: _activeCouponId,
      onSelectCouponId: (id) {
        if (id.isEmpty) return;
        if (_tabIndex != 0) {
          setState(() {
            _tabIndex = 0;
          });
        }
        if (id == _activeCouponId.value) return;
        _activeCouponId.value = id;
        _loadDetail(id, showLoading: false);
      },
    );
  }

  Widget _buildContent() {
    final dynamic detail = _detail ?? {};
    final dynamic couponTypes =
        BaseModel.getDynamic(detail, 'couponTypes') ?? {};
    final dynamic shop = BaseModel.getDynamic(detail, 'shop') ?? {};
    final dynamic initShop =
        BaseModel.getDynamic(widget.initialItem, 'shop') ?? {};
    final String logo = BaseModel.getString(shop, 'logo').isNotEmpty
        ? BaseModel.getString(shop, 'logo')
        : BaseModel.getString(initShop, 'logo');
    final String name = BaseModel.getString(detail, 'name').isNotEmpty
        ? BaseModel.getString(detail, 'name')
        : BaseModel.getString(widget.initialItem, 'name');
    final String qrcode = BaseModel.getString(detail, 'qrcode').isNotEmpty
        ? BaseModel.getString(detail, 'qrcode')
        : (BaseModel.getString(couponTypes, 'qrcode').isNotEmpty
            ? BaseModel.getString(couponTypes, 'qrcode')
            : BaseModel.getString(couponTypes, 'qrCode'));
    final String code = BaseModel.getString(detail, 'code').isNotEmpty
        ? BaseModel.getString(detail, 'code')
        : BaseModel.getString(couponTypes, 'code');
    final String selectedAddress =
        (_shopList.isNotEmpty && _selectedStoreIndex >= 0)
            ? BaseModel.getString(
                _shopList[_selectedStoreIndex],
                'address',
              )
            : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CouponShopHeader(
          logoUrl: logo,
          title: name,
          subtitle: _couponAmount(detail),
        ),
        CouponQrSection(
          qrData: qrcode,
          code: code,
          tipText: '买单时请向店员出示此券码核销',
        ),
        SizedBox(height: 14.w),
        if (_couponList.isNotEmpty)
          ValueListenableBuilder<String>(
            valueListenable: _activeCouponId,
            builder: (context, activeId, _) {
              return CouponTypeSelector(
                couponList: _couponList,
                activeCouponId: activeId,
                onSelect: (id) {
                  if (id.isEmpty) return;
                  // 切换回“使用优惠券”Tab
                  if (_tabIndex != 0) {
                    setState(() {
                      _tabIndex = 0;
                    });
                  }
                  if (id == _activeCouponId.value) return;
                  _activeCouponId.value = id;
                  _loadDetail(id, showLoading: false);
                },
              );
            },
          ),
        SizedBox(height: 12.w),
        CouponStorePickerActionSection(
          addressText: selectedAddress.isEmpty ? '请选择门店地址' : selectedAddress,
          shopList: _shopList,
          selectedIndex: _selectedStoreIndex,
          onSelectIndex: (index) {
            setState(() {
              _selectedStoreIndex = index;
            });
          },
          onNoDataTap: () {
            ViewUtils.displayToast(
                LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
          },
        ),
      ],
    );
  }

  Widget _buildBottom() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (_) {
        _bottomDragDy = 0;
      },
      onVerticalDragUpdate: (details) {
        _bottomDragDy += details.delta.dy;
      },
      onVerticalDragEnd: (details) {
        final double v = details.primaryVelocity ?? 0;
        if (v < -500) {
          _bottomDragDy = -999;
        }
        _switchToShopTab();
      },
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1.w, color: IConstant.line_color),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Icon(Icons.keyboard_arrow_up,
                      size: 18.w, color: IConstant.grey_color),
                  SizedBox(height: 2.w),
                  Text(
                    '上滑查看店铺',
                    style:
                        TextStyle(fontSize: 12.sp, color: IConstant.grey_color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
