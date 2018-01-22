import 'package:xml/xml.dart' as xml;

import 'feed_image.dart';
import 'feed_item.dart';

class Feed {
  final String title;
  final String link;
  final String description;
  final String language;
  final String copyright;
  final String pubDate;
  final String lastBuildDate;
  final FeedImage image;
  final List<FeedItem> items;

  Feed(
    this.title,
    this.link,
    this.description, {
    this.language,
    this.copyright,
    this.pubDate,
    this.lastBuildDate,
    this.image,
    this.items,
  });

  factory Feed.fromXml(xml.XmlElement node, bool strict) {
    // Mandatory fields:
    String title;
    try {
      title = node.findElements('title').single.text;
    } catch (e) {
      if (strict) {
        throw new ArgumentError('Feed missing mandatory title element');
      }
    }

    String link;
    try {
      link = node.findElements('link').single.text;
    } catch (e) {
      if (strict) {
        throw new ArgumentError('Feed missing mandatory link element');
      }
    }

    String description;
    try {
      description = node.findElements('description').single.text;
    } catch (e) {
      if (strict) {
        throw new ArgumentError('Feed missing mandatory description element');
      }
    }

    /// Optional fields:
    String language;
    try {
      language = node.findElements('language').single.text;
    } catch (e) {}

    String copyright;
    try {
      copyright = node.findElements('copyright').single.text;
    } catch (e) {}

    String pubDate;
    try {
      pubDate = node.findElements('pubDate').single.text;
    } catch (e) {}

    String lastBuildDate;
    try {
      lastBuildDate = node.findElements('lastBuildDate').single.text;
    } catch (e) {}

    xml.XmlElement imageElement;
    try {
      imageElement = node.findElements('image').single;
    } catch (e) {}
    FeedImage image;
    if (imageElement != null) {
      image = new FeedImage.fromXml(imageElement);
    }

    List<FeedItem> items = node
        .findElements('item')
        .map((itemElement) => new FeedItem.fromXml(itemElement, strict))
        .toList();

    return new Feed(
      title,
      link,
      description,
      copyright: copyright,
      image: image,
      language: language,
      lastBuildDate: lastBuildDate,
      pubDate: pubDate,
      items: items,
    );
  }

  String toString() {
    return '''
      title: $title
      link: $link
      description: $description
      language: $language
      copyright: $copyright
      pubDate: $pubDate
      lastBuildDate: $lastBuildDate
      image: $image
      items: $items
      ''';
  }
}
