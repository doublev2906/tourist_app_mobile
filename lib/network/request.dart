// import 'package:pancake_mobile/utils/actions/notification.dart';

Future<dynamic> requestNetwork<T>(
    Future<T> future, {
      bool isShow = false,
      bool isClose = false,
      Function(Object error, StackTrace t)? onError,
      Function(T response)? onSuccess,
    }) async {
  try {
    if (isShow) {
      // showProgress();
    }
    final T response = await future;
    if (isClose) {
      // closeProgress();
    }
    onSuccess?.call(response);
    return response;
  } catch (error, t) {
    onError?.call(error, t);
    // closeProgress();
  }
}