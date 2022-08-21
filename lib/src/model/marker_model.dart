class MarkerModel {
  String? sId;
  String? lat;
  String? lng;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MarkerModel(
      {this.sId,
      this.lat,
      this.lng,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MarkerModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['lat'] = lat;
    data['lng'] = lng;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
