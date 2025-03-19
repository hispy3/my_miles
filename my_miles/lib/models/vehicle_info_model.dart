class VehicleInfoModel {
  String? id;
  String? make;
  String? model;
  int? year;
  int? capacity;
  int? range;
  double? percentRemaining;
  int? distance;

  VehicleInfoModel(
      {this.id,
        this.make,
        this.model,
        this.year,
        this.capacity,
        this.range,
        this.percentRemaining,
        this.distance});

  VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    model = json['model'];
    year = json['year'];
    capacity = json['capacity'];
    range = json['range'];
    percentRemaining = json['percentRemaining'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['model'] = model;
    data['year'] = year;
    data['capacity'] = capacity;
    data['range'] = range;
    data['percentRemaining'] = percentRemaining;
    data['distance'] = distance;
    return data;
  }
}
