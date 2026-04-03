
import 'package:badges/badges.dart' as badges;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IURLConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/ActivityTaskChangeEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/event/UserInfoEvent.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/model/PocketTabModel.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/ActivityItemEnd.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/ActivityItemStart.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/PocketHeaderBar.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/pocket/TaskItem.dart';
import 'package:mxcome/com/mxcome/app/ui/shop/utils/FormatUtil.dart';
import 'package:mxcome/com/mxcome/app/utils/HttpUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/ViewUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../BaseKeepAliveState.dart';
import '../../../IConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import '../event/PocketEvent.dart';
import '../utils/EventBusUtil.dart';
import '../utils/Util.dart';

class TabPocketPage extends StatefulWidget {

  @override
  State<TabPocketPage> createState() => _TabPocketPageState();
}

class _TabPocketPageState extends BaseKeepAliveState<TabPocketPage> with TickerProviderStateMixin{

  List<PocketTabModel> titles = [];

  List<Widget> pages = [];

  dynamic activityTaskChangeEvent;

  dynamic userInfoEvent;

  dynamic pocketEvent;

  late TabController _tabController;

  int _activityStartCount = 0; //进行中活动数
  int _taskStartCount = 0; //进行中任务数
  int _activityEndCount = 0; //待统计活动数
  int _taskEndCount = 0; //待统计任务数

  int currentType = 1; //1：进行中，2：待统计

  bool isLogin = false;

  int _countedTimeout = 30;

  @override
  void initState() {
    super.initState();
    activityTaskChangeEvent = EventBusUtil.getInstance().on<ActivityTaskChangeEvent>((event) {
        if (event.changeType == ChangeType.activity) {
           setState(() {
             pages = [ActivityItemStart(serviceTime: serviceTime), ActivityItemEnd(serviceTime: serviceTime)];
           });
           updateTabController(2);
        } else {
          setState(() {
            pages = [TaskItem(0, serviceTime: serviceTime), TaskItem(1, serviceTime: serviceTime)];
          });
          updateTabController(1);
        }
    });
    userInfoEvent = EventBusUtil.getInstance().on<UserInfoEvent>((event) {
      if (event.userInfoStatus == UserInfoStatus.complete) {
        loadContentDatas();
      }
    });
    pocketEvent = EventBusUtil.getInstance().on<PocketEvent>((event) {
      getServiceTime();
      if (event.pocketType == PocketType.complete) {
        loadContentDatas();
      }
    });
    loadContentDatas();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().off(activityTaskChangeEvent);
    EventBusUtil.getInstance().off(userInfoEvent);
    EventBusUtil.getInstance().off(pocketEvent);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: IConstant.white_color,
        body: EasyRefresh(
            header: const MaterialHeader(color: IConstant.main_color),
            onRefresh: ()=> _onRefresh(), child: ExtendedNestedScrollView(
              pinnedHeaderSliverHeightBuilder: () {
                  //var pinnedHeaderHeight = appBarHeight + statusBarHeight + kToolbarHeight;
                  var pinnedHeaderHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
                  return pinnedHeaderHeight;
              },
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return buildSliverHeader(innerBoxIsScrolled);
              },
              body: titles.isEmpty ? Container(color: IConstant.white_color) : TabBarView(
                controller: _tabController,
                children: pages.map((item)=>item).toList(),
              ),
        )),
    );
  }

  Future<void> _onRefresh() async {
    EventBusUtil.getInstance().emit(PocketEvent());
    await Future.delayed(const Duration(milliseconds: 800),() {
    });
  }

  List<Widget> buildSliverHeader(bool innerBoxIsScrolled) {
    if (titles.isEmpty) {
      return [
        PocketHeaderBar(innerBoxIsScrolled, startTime: serviceTime,)
      ];
    } else {
      return [
        PocketHeaderBar(innerBoxIsScrolled, startTime: serviceTime,),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
              buildTabBar()
          ),
          pinned: true,
        )
      ];
    }
  }

  @override
  Future<void> loadContentDatas() async {
    getServiceTime();
    bool loginState = await AppUtils.isLogined();
    int activityStartCount = 0; //进行中活动数
    int taskStartCount = 0; //进行中任务数
    int activityEndCount = 0; //待统计活动数
    int taskEndCount = 0; //待统计任务数
    if (loginState) {
      dynamic data = await AppUtils.getPocketData();
      _countedTimeout = BaseModel.isNotEmpty(data, "countedTimeout") ? BaseModel.getInt(data, "countedTimeout") : _countedTimeout;
      List<dynamic> activityMemberList = BaseModel.isNotEmpty(data, "activityMemberList") ? BaseModel.getDynamic(data, "activityMemberList") : [];
      List<dynamic> pocketMemberList = BaseModel.getDynamic(data, "pocketMemberList");
      for (var item in activityMemberList) {
        int status = BaseModel.getInt(item, "status");
        String endTime = BaseModel.getString(item, "endTime");
        DateTime dateTime = DateTime.parse(endTime);
        DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
        if(!Util.isTimeout2(startTime: serviceTime, endTime: endTime)) {
          if (status == 0) {
            activityStartCount++;
          }
        } else if (!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime))) {
          if (status == 1) {
            activityEndCount++;
          }
        }
      }
      for (var item in pocketMemberList) {
        int status = BaseModel.getInt(item, "status");
        String endTime = BaseModel.getString(item, "endTime");
        DateTime dateTime = DateTime.parse(endTime);
        DateTime countedTime = dateTime.add(Duration(minutes: _countedTimeout));
        if(!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(dateTime))) {
          if (status == 0) {
            taskStartCount++;
          }
        } else if (!Util.isTimeout2(startTime: serviceTime, endTime: FormatUtil.formatLineYMDHMS(countedTime))) {
          if (status == 1) {
            taskEndCount++;
          }
        }
      }
    }
    setState(() {
      isLogin = loginState;
      _activityStartCount = activityStartCount;
      _taskStartCount = taskStartCount;
      _activityEndCount = activityEndCount;
      _taskEndCount = taskEndCount;
    });
    updateTabController(currentType);
  }

  TabBar buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      controller: _tabController,
      tabs: titles.map((item)=>Tab(child: buildBadgeText(item))).toList(),
      isScrollable: false,
      indicatorColor: IConstant.main_color,
      labelColor: IConstant.main_color,
      unselectedLabelColor: IConstant.text_color,
      indicatorWeight: 3,
    );
  }

  Widget buildBadgeText(PocketTabModel model) {
    return badges.Badge(
      showBadge: getShowBadge(model),
      position: badges.BadgePosition.topEnd(top: -8, end: -15),
      badgeContent: Text(getBadgeCount(model), style: TextStyle(fontSize: 10.sp, color: Colors.white)),
      child: Text(getTabText(model), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
    );
  }

  bool getShowBadge(PocketTabModel model){
    if (model.type == 1) { //进行中
      return model.badgeCount > 0;
    } else { //待统计
      return model.badgeCount > 0;
    }
  }

  String getBadgeCount(PocketTabModel model) {
    if (model.type == 1) { //进行中
      return "${model.badgeCount}";
    } else { //待统计
      return "${model.badgeCount}";
    }
  }

  @override
  onLanguageUpdate() {
    super.onLanguageUpdate();
    updateTabController(currentType);
  }

  String getTabText(PocketTabModel model) {
    if (model.type == 1) {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_doing);
    } else {
      return LanguageConfig.get(LanguageConfigKeys.Shop_pocket_counted);
    }
  }

  Future<void> updateTabController(int type) async {
    currentType = type;
    bool loginState = await AppUtils.isLogined();
    setState(() {
      titles = [];
      pages = [];
      _tabController = TabController(initialIndex: 0, length: titles.length, vsync: this); //解决红点刷新问题
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        if (type == 1) {
          titles = [PocketTabModel(1, _taskStartCount), PocketTabModel(2, _taskEndCount)];
          pages = [TaskItem(0, serviceTime: serviceTime,), TaskItem(1, serviceTime: serviceTime,)];
          _tabController = TabController(initialIndex: 0, length: titles.length, vsync: this);
          _tabController.addListener(() {
            if (_tabController.index == _tabController.animation?.value) {
              // 为了解决切换Tab回调两次的问题
              if(_tabController.index == 1) {
                if(loginState) {
                  if(IConstant.IS_DEBUG) {
                    ViewUtils.showToastShort(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_counted_tip), [ _countedTimeout ]));
                  }else {
                    ViewUtils.showToastShort(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_task_counted_tip), [ _countedTimeout / 60 ~/ 24 ]));
                  }
                }
              }
            }
          });
          _tabController.animateTo(0);
        } else {
          titles = [PocketTabModel(1, _activityStartCount), PocketTabModel(2, _activityEndCount)];
          pages = [ActivityItemStart(serviceTime: serviceTime,), ActivityItemEnd(serviceTime: serviceTime,)];
          _tabController = TabController(initialIndex: 0, length: titles.length, vsync: this);
          _tabController.addListener(() {
            if (_tabController.index == _tabController.animation?.value) {
              // 为了解决切换Tab回调两次的问题
              if(_tabController.index == 1) {
                if(loginState) {
                  if(IConstant.IS_DEBUG) {
                    ViewUtils.showToastShort(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_activity_counted_tip), [ _countedTimeout ]));
                  }else {
                    ViewUtils.showToastShort(sprintf(LanguageConfig.get(LanguageConfigKeys.Shop_pocket_activity_counted_tip), [ _countedTimeout / 60 ~/ 24 ]));
                  }
                }
              }
            }
          });
          _tabController.animateTo(0);
        }
      });
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  late TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: IConstant.white_color,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
