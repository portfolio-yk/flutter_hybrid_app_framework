class LocalData {

  String key;
  Type type;
  dynamic defaultValue;

  LocalData({required this.key, required this.type, required this.defaultValue});

  static final contentsVersion = LocalData(key: 'contentsVersion', type: String, defaultValue: '0.0.0');
}