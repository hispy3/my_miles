class VehicleIdModel {
  List<String>? vehicles;
  Paging? paging;

  VehicleIdModel({this.vehicles, this.paging});

  VehicleIdModel.fromJson(Map<String, dynamic> json) {
    vehicles = json['vehicles'].cast<String>();
    paging =
    json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicles'] = vehicles;
    if (paging != null) {
      data['paging'] = paging!.toJson();
    }
    return data;
  }
}

class Paging {
  int? count;
  int? offset;

  Paging({this.count, this.offset});

  Paging.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['offset'] = offset;
    return data;
  }
}
