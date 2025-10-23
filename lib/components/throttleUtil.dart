class ThrottleUtil {
  static const Duration _KDelay = Duration(seconds: 5);
  var enable = true;

  ///防止重复点击
  ///func 要执行的方法
  Function throttle(
    Function func, {
    Duration delay = _KDelay,
  }) {
    return () {
      if (enable) {
        func();
        enable = false;
        Future.delayed(delay, () {
          enable = true;
        });
      }
    };
  }
}
