import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/ClipboardUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String _activeCouponId = '';
  int _selectedStoreIndex = 0;
  bool _addressExpanded = false;

  @override
  void initState() {
    super.initState();
    _activeCouponId = widget.initialCouponId;
    _loadDetail(_activeCouponId);
  }

  Future<void> _loadDetail(String couponId) async {
    setState(() {
      _loading = true;
    });
    try {
      final rsp = await HttpUtils.post(IURLConstant.MALL_COUPON_DETAIL, {
        'couponId': couponId,
      });
      if (!mounted) return;
      if (rsp.retCode == 200) {
        final data = rsp.data;
        setState(() {
          _detail = data;
          _couponList = BaseModel.getDynamicList(data, 'couponList') ?? [];
          _shopList = BaseModel.getDynamicList(data, 'shopList') ?? [];
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
      ViewUtils.displayToast(LanguageConfig.get(LanguageConfigKeys.ViewUtils_retry));
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

  String _couponTypeText(dynamic coupon) {
    double minPoint = BaseModel.getDouble(coupon, 'minPoint');
    if (minPoint > 0) return '满减券';
    return '代金券';
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

  Widget _buildHandle() {
    return Container(
      width: 50.w,
      height: 8.w,
      margin: EdgeInsets.only(top: 6.w, bottom: 6.w),
      decoration: BoxDecoration(
        color: IConstant.line_color,
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
      ),
    );
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
              _buildHandle(),
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
                              child: _buildContent(),
                            ),
                          ),
                          _buildBottom(),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    final dynamic detail = _detail ?? {};
    final dynamic shop = BaseModel.getDynamic(detail, 'shop') ?? {};
    final dynamic initShop = BaseModel.getDynamic(widget.initialItem, 'shop') ?? {};
    final String logo = BaseModel.getString(shop, 'logo').isNotEmpty
        ? BaseModel.getString(shop, 'logo')
        : BaseModel.getString(initShop, 'logo');
    final String name = BaseModel.getString(detail, 'name').isNotEmpty
        ? BaseModel.getString(detail, 'name')
        : BaseModel.getString(widget.initialItem, 'name');
    final String qrcode = BaseModel.getString(detail, 'qrcode');
    final String code = BaseModel.getString(detail, 'code');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            Container(
              width: 61.w,
              height: 61.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IConstant.grey_color.withOpacity(0.1),
                image: logo.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(logo),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: logo.isEmpty
                  ? Icon(Icons.store, size: 28.w, color: IConstant.grey_color)
                  : null,
            ),
            SizedBox(height: 8.w),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: IConstant.title_color,
              ),
            ),
            SizedBox(height: 8.w),
            Text(
              _couponAmount(detail),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: IConstant.main_color,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        Column(
          children: [
            Container(
              width: 160.w,
              height: 160.w,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.w),
                border: Border.all(width: 1.w, color: IConstant.line_color),
              ),
              child: qrcode.isNotEmpty
                  ? QrImageView(
                      data: qrcode,
                      version: QrVersions.auto,
                      size: 144.w,
                    )
                  : Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 40.w,
                        color: IConstant.grey_color.withOpacity(0.5),
                      ),
                    ),
            ),
            SizedBox(height: 6.w),
            if (code.isNotEmpty)
              Text(
                '券码 $code',
                style: TextStyle(fontSize: 12.sp, color: IConstant.title_color),
              ),
            SizedBox(height: 4.w),
            Text(
              '买单时请向店员出示此券码核销',
              style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color),
            ),
          ],
        ),
        SizedBox(height: 14.w),
        if (_couponList.isNotEmpty) _buildCouponTypes(),
      ],
    );
  }

  Widget _buildCouponTypes() {
    return SizedBox(
      height: 92.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _couponList.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = _couponList[index];
          final String id = BaseModel.getString(item, 'id');
          final bool active = id == _activeCouponId;
          final String endTime = BaseModel.getString(item, 'endTime');
          final String endDate =
              endTime.contains(' ') ? endTime.split(' ')[0] : endTime;
          return InkWell(
            onTap: () {
              if (id.isEmpty || id == _activeCouponId) return;
              setState(() {
                _activeCouponId = id;
              });
              _loadDetail(id);
            },
            borderRadius: BorderRadius.circular(12.w),
            child: Container(
              width: 170.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: active
                    ? IConstant.main_color.withOpacity(0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12.w),
                border: Border.all(
                  width: 1.w,
                  color: active ? IConstant.main_color : IConstant.line_color,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _couponTypeText(item),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: IConstant.title_color,
                        ),
                      ),
                      Text(
                        '฿${BaseModel.getDouble(item, 'amount').toInt()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: IConstant.main_color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    _couponAmount(item),
                    style: TextStyle(fontSize: 12.sp, color: IConstant.main_color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    '有效期 $endDate',
                    style: TextStyle(fontSize: 11.sp, color: IConstant.grey_color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottom() {
    final String selectedAddress =
        (_shopList.isNotEmpty && _selectedStoreIndex >= 0)
            ? BaseModel.getString(_shopList[_selectedStoreIndex], 'address')
            : '';
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 1.w, color: IConstant.line_color)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _addressExpanded = !_addressExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16.w, color: IConstant.main_color),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      selectedAddress.isEmpty ? '请选择门店地址' : selectedAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12.sp, color: IConstant.title_color),
                    ),
                  ),
                  Icon(
                    _addressExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18.w,
                    color: IConstant.grey_color,
                  ),
                ],
              ),
            ),
            if (_addressExpanded) SizedBox(height: 10.w),
            if (_addressExpanded) _buildStoreList(),
            SizedBox(height: 12.w),
            SizedBox(
              width: double.infinity,
              height: 44.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: IConstant.main_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.w),
                  ),
                  elevation: 0,
                ),
                onPressed: _openNavigation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.near_me, size: 18.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text(
                      '导航到店',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
    return Column(
      children: List.generate(_shopList.length, (index) {
        final store = _shopList[index];
        final bool active = index == _selectedStoreIndex;
        final String storeName = BaseModel.getString(store, 'name');
        final String address = BaseModel.getString(store, 'address');
        return Container(
          margin: EdgeInsets.only(bottom: 8.w),
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
                  onTap: () {
                    setState(() {
                      _selectedStoreIndex = index;
                      _addressExpanded = false;
                    });
                  },
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
                        style: TextStyle(fontSize: 12.sp, color: IConstant.grey_color),
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
                  style: TextStyle(fontSize: 12.sp, color: IConstant.main_color),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

