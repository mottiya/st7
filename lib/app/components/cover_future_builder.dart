import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverFutureBuilder extends StatelessWidget {
  const CoverFutureBuilder({
    Key? key,
    required this.future,
    this.fit = BoxFit.fitWidth,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  final Future<void> future;
  final BoxFit? fit;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            imageUrl: snapshot.data as String,
            placeholder: placeholder ??
                (context, url) => const Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(),
                      ),
                    ),
            fit: fit,
            errorWidget: errorWidget ??
                (context, url, error) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.surface,
                    ),
            imageBuilder: imageBuilder,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
