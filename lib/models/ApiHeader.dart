class ApiHeader {
  late String contentType;
  late String xApiKey;

  ApiHeader(this.contentType, this.xApiKey);

  Map<String, String> toJson() => {
    'Content-Type': contentType,
    'x-api-key': xApiKey
  };
}
