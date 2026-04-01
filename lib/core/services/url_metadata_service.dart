import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class UrlMetadata {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? favicon;

  UrlMetadata({this.title, this.description, this.imageUrl, this.favicon});
}

class UrlMetadataService {
  static Future<UrlMetadata> fetchMetadata(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return UrlMetadata();
      }

      final document = html_parser.parse(response.body);

      String? title;
      String? description;
      String? imageUrl;
      String? favicon;

      final titleEl = document.querySelector('title');
      title = titleEl?.text.trim();

      final ogTitle = document.querySelector('meta[property="og:title"]');
      if (ogTitle != null) {
        title = ogTitle.attributes['content']?.trim();
      }

      final metaDesc = document.querySelector('meta[name="description"]');
      description = metaDesc?.attributes['content']?.trim();

      final ogDesc = document.querySelector('meta[property="og:description"]');
      if (ogDesc != null) {
        description = ogDesc.attributes['content']?.trim();
      }

      final ogImage = document.querySelector('meta[property="og:image"]');
      if (ogImage != null) {
        imageUrl = ogImage.attributes['content'];
        if (imageUrl != null && !imageUrl.startsWith('http')) {
          imageUrl = '${uri.origin}$imageUrl';
        }
      }

      final faviconEl =
          document.querySelector('link[rel="icon"]') ??
          document.querySelector('link[rel="shortcut icon"]');
      if (faviconEl != null) {
        favicon = faviconEl.attributes['href'];
        if (favicon != null && !favicon.startsWith('http')) {
          favicon = '${uri.origin}$favicon';
        }
      } else {
        favicon = '${uri.origin}/favicon.ico';
      }

      return UrlMetadata(
        title: title,
        description: description,
        imageUrl: imageUrl,
        favicon: favicon,
      );
    } catch (e) {
      return UrlMetadata();
    }
  }
}
