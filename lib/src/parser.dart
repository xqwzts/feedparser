import 'package:xml/xml.dart' as xml;

import 'models.dart';

/// Parses the provided input string into a [Feed] object
/// Throws if [feedString] is not a valid xml string.
///
/// The parser is lenient by default ([strict] is `false`), initializing missing
/// fields to `null`.
///
/// Setting [strict] to `true` will throw an [ArgumentError] when one of the
/// mandatory rss 2.0 properties is missing:
///
/// Mandatory properties:
/// [Feed]: title, link, description
/// [FeedImage]: url
/// [FeedEnclosure]: url, length, type
Feed parse(String feedString, {bool strict = false}) {
  try {
    xml.XmlDocument document = xml.parse(feedString);

    xml.XmlElement channelElement =
        document.rootElement.findElements('channel').single;

    Feed feed = new Feed.fromXml(channelElement, strict);

    return feed;
  } catch (exception) {
    rethrow;
  }
}
