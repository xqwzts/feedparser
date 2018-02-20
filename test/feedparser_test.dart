import 'package:test/test.dart';
import 'package:feedparser/feedparser.dart';

void main() {
  test('Empty string throws ArgumentError', () {
    expect(() => parse(''), throwsArgumentError);
  });

  test('Malformed XML throws ArgumentError', () {
    String malformedXML = ''''<?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
    <''';

    expect(() => parse(malformedXML), throwsArgumentError);
  });

  group('Strict mode', () {
    test('Throws ArgumentError if channel title missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <description>description</description>
        <link>href</link>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if channel description missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0>
      <channel>
        <title>title</title>
        <link>href</link>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if channel link missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>title</title>
        <description>description</description>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if image url missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>title</title>
        <description>description</description>
        <link>link</link>
        <image>
          <link>link</link>
          <title>title</title>
        </image>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if enclosure url missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>title</title>      
        <description>description</description>
        <link>link</link>
        <item>
          <enclosure type="audio/mpeg" length="38600620"/>
        </item>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if enclosure type missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>title</title>      
        <description>description</description>
        <link>link</link>
        <item>
          <enclosure url="href" length="38600620"/>
        </item>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('Throws ArgumentError if enclosure length missing', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>title</title>
        <description>description</description>
        <link>link</link>
        <item>
          <enclosure url="href" type="audio/mpeg"/>
        </item>
      </channel>
    </rss>
    ''';

      expect(() => parse(data, strict: true), throwsArgumentError);
    });

    test('parses a Feed if all mandatory fields present', () {
      String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>titleText</title>      
        <description>descriptionText</description>
        <link>linkText</link>
        <item>
          <enclosure url="enclosureUrl" type="enclosureType" length="enclosureLength"/>
        </item>
      </channel>
    </rss>
    ''';

      Feed expected = new Feed(
        'titleText',
        'linkText',
        'descriptionText',
        items: <FeedItem>[
          new FeedItem(
            enclosure: new FeedEnclosure(
              'enclosureUrl',
              'enclosureLength',
              'enclosureType',
            ),
          )
        ],
      );

      Feed result = parse(data, strict: true);

      expect(result.title, expected.title);
      expect(result.link, expected.link);
      expect(result.description, expected.description);
      expect(result.items.length, expected.items.length);
      expect(result.items[0].enclosure.url, expected.items[0].enclosure.url);
      expect(
          result.items[0].enclosure.length, expected.items[0].enclosure.length);
      expect(result.items[0].enclosure.type, expected.items[0].enclosure.type);
    });
  });

  test('Parses a Feed with all possible fields', () {
    String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>titleText</title>      
        <description>descriptionText</description>
        <link>linkText</link>
        <language>en</language>
        <copyright>© 2018 All Rights Reserved</copyright>
        <pubDate>Wed, 10 Jan 2018 08:05:00 -0000</pubDate>
        <lastBuildDate>Wed, 10 Jan 2018 08:05:00 -0000</lastBuildDate>
        <image>
          <url>imageUrl</url>
          <height>imageHeight</height>
          <width>imageWidth</width>
        </image>
        <item>
          <title>itemTitle</title>
          <link>itemLink</link>
          <description>itemDescription</description>
          <author>itemAuthor</author>
          <category>itemCategory</category>
          <guid>itemGuid</guid>
          <pubDate>itemPubDate</pubDate>
          <comments>commentsUrl</comments>
          <itunes:summary>itunesSummary</itunes:summary>
          <itunes:duration>itunesDuration</itunes:duration>
          <enclosure url="enclosureUrl" type="enclosureType" length="enclosureLength"/>
        </item>
      </channel>
    </rss>
    ''';

    Feed expected = new Feed(
      'titleText',
      'linkText',
      'descriptionText',
      language: 'en',
      copyright: '© 2018 All Rights Reserved',
      pubDate: 'Wed, 10 Jan 2018 08:05:00 -0000',
      lastBuildDate: 'Wed, 10 Jan 2018 08:05:00 -0000',
      image: new FeedImage(
        'imageUrl',
        height: 'imageHeight',
        width: 'imageWidth',
      ),
      items: <FeedItem>[
        new FeedItem(
          title: 'itemTitle',
          link: 'itemLink',
          description: 'itemDescription',
          author: 'itemAuthor',
          category: 'itemCategory',
          guid: 'itemGuid',
          pubDate: 'itemPubDate',
          comments: 'commentsUrl',
          itunesSummary: 'itunesSummary',
          itunesDuration: 'itunesDuration',
          enclosure: new FeedEnclosure(
            'enclosureUrl',
            'enclosureLength',
            'enclosureType',
          ),
        )
      ],
    );

    Feed result = parse(data);

    expect(result.title, expected.title);
    expect(result.link, expected.link);
    expect(result.description, expected.description);
    expect(result.language, expected.language);
    expect(result.copyright, expected.copyright);
    expect(result.pubDate, expected.pubDate);
    expect(result.lastBuildDate, expected.lastBuildDate);
    expect(result.image.url, expected.image.url);
    expect(result.image.height, expected.image.height);
    expect(result.image.width, expected.image.width);
    expect(result.items.length, expected.items.length);
    expect(result.items[0].title, expected.items[0].title);
    expect(result.items[0].link, expected.items[0].link);
    expect(result.items[0].description, expected.items[0].description);
    expect(result.items[0].author, expected.items[0].author);
    expect(result.items[0].category, expected.items[0].category);
    expect(result.items[0].guid, expected.items[0].guid);
    expect(result.items[0].pubDate, expected.items[0].pubDate);
    expect(result.items[0].comments, expected.items[0].comments);
    expect(result.items[0].itunesSummary, expected.items[0].itunesSummary);
    expect(result.items[0].itunesDuration, expected.items[0].itunesDuration);
    expect(result.items[0].enclosure.url, expected.items[0].enclosure.url);
    expect(
        result.items[0].enclosure.length, expected.items[0].enclosure.length);
    expect(result.items[0].enclosure.type, expected.items[0].enclosure.type);
  });

  test('Parses a feed with missing mandatory fields defaulted to null', () {
    String data = r'''
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <item>
          <enclosure>
          </enclosure>
        </item>
      </channel>
    </rss>
    ''';

    Feed expected = new Feed(
      null,
      null,
      null,
      items: <FeedItem>[
        new FeedItem(
          enclosure: new FeedEnclosure(
            null,
            null,
            null,
          ),
        )
      ],
    );

    Feed result = parse(data);

    expect(result.title, expected.title);
    expect(result.link, expected.link);
    expect(result.description, expected.description);
    expect(result.items.length, expected.items.length);
    expect(result.items[0].enclosure.url, expected.items[0].enclosure.url);
    expect(
        result.items[0].enclosure.length, expected.items[0].enclosure.length);
    expect(result.items[0].enclosure.type, expected.items[0].enclosure.type);
  });
}
