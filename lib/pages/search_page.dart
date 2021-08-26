///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/25 14:25
///
import 'package:flutter/material.dart';
import 'package:i_jmu/constants/exports.dart';

@FFRoute(name: 'jmu://search-page', routeName: '搜索页')
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.keyword}) : super(key: key);

  final String? keyword;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchTEC = TextEditingController(
    text: widget.keyword,
  );
  bool _isSearching = false, _hasError = false;
  String _searchingKeyword = '';
  SearchResult? _result;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      _search(widget.keyword!);
    }
  }

  @override
  void dispose() {
    _searchTEC.dispose();
    super.dispose();
  }

  Future<void> _search([String? value]) async {
    if (_isSearching) {
      return;
    }
    final String _value = value ?? _searchTEC.text;
    if (_value.isEmpty || _value.trim().isEmpty) {
      showToast('一定要搜点什么才行...');
      return;
    }
    _isSearching = true;
    _hasError = false;
    setState(() {});
    _searchingKeyword = _value.trim();
    try {
      final ResponseModel<SearchResult> res = await PortalAPI.search(
        _searchingKeyword,
      );
      if (res.isSucceed) {
        _result = res.data;
        return;
      }
      _hasError = true;
      showErrorToast(res.message);
    } catch (e) {
      _hasError = true;
      showErrorToast(e.errorMessage);
      rethrow;
    } finally {
      _isSearching = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: context.topPadding),
      color: context.surfaceColor,
      child: Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const FixedBackButton(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: RadiusConstants.max,
                  color: context.theme.dividerColor.withOpacity(.05),
                ),
                child: TextField(
                  controller: _searchTEC,
                  autofocus: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: '搜索',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: _search,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            const Gap.h(15),
          ],
        ),
      ),
    );
  }

  Widget _contentBuilder(BuildContext context) {
    if (_isSearching && _result == null) {
      return const Center(child: PlatformProgressIndicator());
    }
    if (_hasError) {
      return Center(
        child: ListEmptyIndicator(
          isSliver: false,
          isError: true,
          onTap: _search,
        ),
      );
    }
    if (!_isSearching && _result?.isEmpty != false) {
      return Center(
        child: ListEmptyIndicator(isSliver: false, onTap: _search),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _result!.items.length,
      itemBuilder: (BuildContext c, int index) {
        final SearchResultItem item = _result!.items[index];
        return _ResultItemWidget(
          key: item.valueKey(),
          item: item,
          keyword: _searchingKeyword,
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessLayer(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _searchBar(context),
            Expanded(child: _contentBuilder(context)),
          ],
        ),
      ),
    );
  }
}

class _ResultItemWidget extends StatelessWidget {
  const _ResultItemWidget({
    Key? key,
    required this.item,
    required this.keyword,
  }) : super(key: key);

  final SearchResultItem item;
  final String keyword;

  SearchResultItemContent get content => item.content;

  Widget _title(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 16);
    if (content.serveName.contains(keyword)) {
      final List<String> split = content.serveName.split(keyword);
      final List<String> composed =
          split.expand((String s) => <String>[s, keyword]).toList()
            ..removeLast()
            ..removeWhere((String s) => s == '');
      return Text.rich(
        TextSpan(
          children: List<TextSpan>.generate(
            composed.length,
            (int i) {
              final String s = composed[i];
              final bool isHighlighted = s == keyword;
              return TextSpan(
                text: s,
                style: TextStyle(
                  color: isHighlighted ? defaultDarkColor : null,
                  fontWeight: isHighlighted ? FontWeight.bold : null,
                ),
              );
            },
          ),
        ),
        style: style,
      );
    }
    return Text(content.serveName, style: style);
  }

  Widget _labels(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: List<Widget>.generate(
        content.serveLabel.length,
        (int i) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            borderRadius: RadiusConstants.max,
            color: context.theme.canvasColor,
          ),
          child: Text(
            content.serveLabel[i],
            style: context.textTheme.caption,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigator.pushNamed(
          Routes.jmuWebView.name,
          arguments: Routes.jmuWebView.d(
            url: content.serveUrl,
            title: content.serveName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: context.surfaceColor,
        child: Row(
          children: <Widget>[
            ClipOval(child: Image.network(content.serveImageUrl, width: 48)),
            const Gap.h(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _title(context),
                  const Gap.v(4),
                  Text(
                    '编号：${content.serveNum}　|　部门：${content.serveSource}',
                    style: context.textTheme.caption,
                  ),
                  const Gap.v(4),
                  _labels(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
