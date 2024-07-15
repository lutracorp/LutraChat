import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/channel/fetch/response.dart';

/// A controller that performs channel actions.
abstract interface class ChannelController {
  /// Returns a channel object for a given channel ID.
  Future<ChannelFetchResponse> fetch(Request request, String target);
}