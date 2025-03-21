class VehicleInfoModel {
  String? id;
  String? make;
  String? model;
  String? vin;
  int? year;
  int? capacity;
  int? range;
  num? percentRemaining;
  int? distance;

  VehicleInfoModel(
      {this.id,
        this.make,
        this.model,
        this.vin,
        this.year,
        this.capacity,
        this.range,
        this.percentRemaining,
        this.distance});

  VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    model = json['model'];
    vin = json['vin'];
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
    data['vin'] = vin;
    data['year'] = year;
    data['capacity'] = capacity;
    data['range'] = range;
    data['percentRemaining'] = percentRemaining;
    data['distance'] = distance;
    return data;
  }
}
