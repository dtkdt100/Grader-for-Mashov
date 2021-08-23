library mashov_api;

import 'src/controller/api_controller.dart';
import 'src/controller/cookie_manager_impl.dart';
import 'src/controller/request_controller_impl.dart';

export 'src/controller/api_controller.dart';
export 'src/controller/cookie_manager.dart';
export 'src/controller/cookie_manager_impl.dart';
export 'src/controller/request_controller.dart';
export 'src/controller/request_controller_impl.dart';
export 'src/models.dart';

class MashovApi {
  static ApiController? _controller;

  static ApiController? getController() {
    _controller ??= ApiController(CookieManagerImpl(), RequestControllerImpl());
    return _controller;
  }
}
