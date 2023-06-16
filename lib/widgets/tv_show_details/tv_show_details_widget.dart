import 'package:flutter/material.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_info_widget.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_model.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_screen_cast_widget.dart';
import 'package:provider/provider.dart';

class TvShowDetailsWidget extends StatefulWidget {
  const TvShowDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TvShowDetailsWidget> createState() => _TvShowDetailsWidgetState();
}

class _TvShowDetailsWidgetState extends State<TvShowDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    Future.microtask(
        () => context.read<TvShowDetailsModel>().setupLocale(context, locale));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((TvShowDetailsModel model) => model.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((TvShowDetailsModel model) => model.data.isLoading);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: const [
        TvShowDetailsMainInfoWidget(),
        SizedBox(height: 30),
        TvShowDetailsMainScreenCastWidget(),
      ],
    );
  }
}
