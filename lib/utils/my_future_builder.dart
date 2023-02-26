import 'package:flutter/material.dart';

class MyFutureBuilder<T> extends StatelessWidget {
  const MyFutureBuilder({
    super.key,
    required this.future,
    required this.onData,
    this.onError,
    this.onLoad,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T? data) onData;
  final Widget Function(BuildContext context, Object error)? onError;
  final Widget Function(BuildContext context)? onLoad;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError?.call(context, snapshot.error!) ??
              Center(child: Text('Error ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return onData(context, snapshot.data);
        }
        return onLoad?.call(context) ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}
