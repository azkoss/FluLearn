import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformAssetBundle;
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

///
/// Markdown格式的文档预览
///
class MarkdownViewer extends StatefulWidget {
  final String path;

  const MarkdownViewer({Key key, @required this.path}) : super(key: key);

  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  String _data;

  @override
  void initState() {
    super.initState();
    Future<String> future;
    if (widget.path.startsWith('http') || widget.path.startsWith('file')) {
      future = NetworkAssetBundle(Uri.parse(widget.path)).loadString('');
    } else {
      future = PlatformAssetBundle().loadString(widget.path);
    }
    future.then((data) {
      setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Markdown(data: _data);
  }
}
