class ErrorModel {
  int? code;
  String? description;
  String? descriptionAr;
  dynamic isoCode;

  ErrorModel({ this.code, this.description, this.descriptionAr, this.isoCode});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    descriptionAr = json['descriptionAr'];
    isoCode = json['isoCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['descriptionAr'] = descriptionAr;
    data['isoCode'] = isoCode;
    return data;
  }
}
