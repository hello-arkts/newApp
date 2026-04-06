import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _addressExpanded = false;
  int _tabIndex = 0;

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
          _detail = data;
          _couponList = couponList.isNotEmpty ? couponList : fallbackCouponList;
          _shopList = shopList.isNotEmpty ? shopList : fallbackShopList;
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

    String url;
    if (lat.isNotEmpty && lng.isNotEmpty) {
      url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    } else if (address.isNotEmpty) {
      url =
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    } else {
      ViewUtils.displayToast(
          LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data));
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
          ),
          child: Column(
            children: [
              const CouponDrawerHandle(),
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
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 12.w),
                              child: _tabIndex == 0
                                  ? _buildContent()
                                  : _buildShopTab(),
                            ),
                          ),
                          if (_tabIndex == 0) _buildBottom(),
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
        if (id.isEmpty || id == _activeCouponId.value) return;
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
                  if (id.isEmpty || id == _activeCouponId.value) return;
                  _activeCouponId.value = id;
                  _loadDetail(id, showLoading: false);
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildBottom() {
    final String selectedAddress =
        (_shopList.isNotEmpty && _selectedStoreIndex >= 0)
            ? BaseModel.getString(
                _shopList[_selectedStoreIndex],
                'address',
              )
            : '';
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(width: 1.w, color: IConstant.line_color)),
        ),
        child: Column(
          children: [
            CouponStoreAddressRow(
              addressText:
                  selectedAddress.isEmpty ? '请选择门店地址' : selectedAddress,
              expanded: _addressExpanded,
              onToggle: () {
                setState(() {
                  _addressExpanded = !_addressExpanded;
                });
              },
              onSelectStore: () {
                setState(() {
                  _addressExpanded = true;
                });
              },
            ),
            if (_addressExpanded) SizedBox(height: 10.w),
            if (_addressExpanded) _buildStoreList(),
            SizedBox(height: 6.w),
            CouponPrimaryButton(text: '导航到店', onPressed: _openNavigation),
            SizedBox(height: 12.w),
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
    );
  }

  Widget _buildStoreList() {
    if (_shopList.isEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 6.w),
        child: Text(
          LanguageConfig.get(LanguageConfigKeys.ViewUtils_no_data),
          style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color),
        ),
      );
    }
    return CouponStoreList(
      shopList: _shopList,
      selectedIndex: _selectedStoreIndex,
      onSelect: (index) {
        setState(() {
          _selectedStoreIndex = index;
          _addressExpanded = false;
        });
      },
    );
  }
}
