import 'package:xml/xml.dart' as xml;

class FeedEnclosure {
  final String url;

  /// Size in bytes
  final String length;

  /// MIME type
  final String type;

  FeedEnclosure(this.url, this.length, this.type);

  factory FeedEnclosure.fromXml(xml.XmlElement node, bool strict) {
    // Mandatory fields:
    String url = node.getAttribute('url');
    if (url == null) {
      if (strict) {
        throw new ArgumentError('Enclosure missing mandatory url attribute');
      }
    }

    String length = node.getAttribute('length');
    if (length == null) {
      if (strict) {
        throw new ArgumentError('Enclosure missing mandatory length attribute');
      }
    }

    String type = node.getAttribute('type');
    if (type == null) {
      if (strict) {
        throw new ArgumentError('Enclosure missing mandatory type attribute');
      }
    }

    return new FeedEnclosure(url, length, type);
  }

  String toString() {
    return '''
      url: $url
      length: $length
      type: $type
      ''';
  }
}
