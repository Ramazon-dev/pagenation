import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination/model/model.dart';
import 'package:pagination/service/service.dart';

class MyHomePageView extends StatefulWidget {
  const MyHomePageView({Key? key}) : super(key: key);

  @override
  State<MyHomePageView> createState() => _MyHomePageViewState();
}

class _MyHomePageViewState extends State<MyHomePageView> {
  static const _pageSize = 10;

  final PagingController<int, PhotoModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<PhotoModel> newItems =
          await ServicePhotos.getPhoto(pageKey, _pageSize);
      final bool isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PagedListView<int, PhotoModel>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<PhotoModel>(
            itemBuilder: (context, item, index) => Text(
                "title: ${item.title.toString()}\n id: ${item.id.toString()}"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
