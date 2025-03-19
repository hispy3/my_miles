class VehicleInfoModel {
  String? id;
  String? make;
  String? model;
  int? year;

  VehicleInfoModel({this.id, this.make, this.model, this.year});

  VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    model = json['model'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['model'] = model;
    data['year'] = year;
    return data;
  }
}
