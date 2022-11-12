class RefreshAuthRequestModel {
  RefreshAuthRequestModel({
    required this.refreshToken,
  });
  late final String refreshToken;

  RefreshAuthRequestModel.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}
