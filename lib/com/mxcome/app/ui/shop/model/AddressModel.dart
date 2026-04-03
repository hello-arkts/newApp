import '../../../model/BaseModel.dart';

class AddressModel {
  String id;
  String city;
  String defaultStatus;
  String detailAddress;
  String latitude;
  String longitude;
  String name;
  String phoneNumber;
  String postCode;
  String province;
  String region;
  String placeId;
  bool isSelect;

  AddressModel(
      this.id,
      this.city,
      this.defaultStatus,
      this.detailAddress,
      this.latitude,
      this.longitude,
      this.name,
      this.phoneNumber,
      this.postCode,
      this.province,
      this.region,
      this.placeId,
      this.isSelect);

  factory AddressModel.fromReceiver(
      String receiverName,
      String receiverPhone,
      String receiverProvince,
      String receiverCity,
      String receiverRegion,
      String receiverDetailAddress) {
    return AddressModel("", receiverCity, "", receiverDetailAddress, "", "", receiverName, receiverPhone, "", receiverProvince, receiverRegion, "", false);
  }

  factory AddressModel.fromJson(dynamic item, bool isSelect) {
    String id = BaseModel.getString(item, "id");
    String city = BaseModel.getString(item, "city");
    String defaultStatus = BaseModel.getString(item, "defaultStatus");
    String detailAddress = BaseModel.getString(item, "detailAddress");
    String latitude = BaseModel.getString(item, "latitude");
    String longitude = BaseModel.getString(item, "longitude");
    String name = BaseModel.getString(item, "name");
    String phoneNumber = BaseModel.getString(item, "phoneNumber");
    String postCode = BaseModel.getString(item, "postCode");
    String province = BaseModel.getString(item, "province");
    String region = BaseModel.getString(item, "region");
    String placeId = BaseModel.getString(item, "placeId");
    return AddressModel(id, city, defaultStatus, detailAddress, latitude, longitude, name, phoneNumber, postCode, province, region, placeId, isSelect);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'city': city,
        'defaultStatus': defaultStatus,
        'detailAddress': detailAddress,
        'latitude': latitude,
        'longitude': longitude,
        'name': name,
        'phoneNumber': phoneNumber,
        'postCode': postCode,
        'province': province,
        'region': region,
        'placeId': placeId,
      };
}
