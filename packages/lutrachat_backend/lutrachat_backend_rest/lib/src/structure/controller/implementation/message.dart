import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../enumerable/error/channel.dart';
import '../../../enumerable/error/message.dart';
import '../../../model/http/common/message/response.dart';
import '../../../model/http/message/create/request.dart';
import '../../../model/http/message/list/query.dart';
import '../message.dart';

@LazySingleton(as: MessageController)
final class MessageControllerImplementation implements MessageController {
  /// Data accessor for the messages table.
  final MessageAccessor messageAccessor;

  /// Data accessor for the channels table.
  final ChannelAccessor channelAccessor;

  MessageControllerImplementation(
    this.messageAccessor,
    this.channelAccessor,
  );

  @override
  Future<MessageResponse> create(Request request, String channelId) async {
    final MessageCreateRequest messageCreatePayload =
        await request.body.as(MessageCreateRequest.fromJson);

    final UserTableData userTableData =
        request.context['lutrachat/user'] as UserTableData;

    final bool channelExists =
        await channelAccessor.existsByCanonicalId(channelId);

    if (channelExists) {
      final MessageTableData message = await messageAccessor.insert(
        MessageTableCompanion.insert(
          channel: FOxID.fromJson(channelId),
          author: userTableData.id,
          content: messageCreatePayload.content,
        ),
      );

      return MessageResponse.fromTableData(message);
    }

    throw ServerError(ChannelErrorCode.notFound);
  }

  @override
  Future<Iterable<MessageResponse>> list(
      Request request, String channelId) async {
    final MessageListQuery messageListQuery =
        MessageListQuery.fromJson(request.requestedUri.queryParameters);

    final bool channelExists =
        await channelAccessor.existsByCanonicalId(channelId);

    if (channelExists) {
      final List<MessageTableData> messages =
          await messageAccessor.listByCanonicalChannelId(channelId,
              after: messageListQuery.after,
              before: messageListQuery.before,
              limit: messageListQuery.limit);

      return messages.map(MessageResponse.fromTableData);
    }

    throw ServerError(ChannelErrorCode.notFound);
  }

  @override
  Future<MessageResponse> fetch(
      Request request, String channelId, String messageId) async {
    final MessageTableData? messageData =
        await messageAccessor.findByCanonicalId(messageId);

    if (messageData != null &&
        FOxID.fromJson(channelId) == messageData.channel) {
      return MessageResponse.fromTableData(messageData);
    }

    throw ServerError(MessageErrorCode.notFound);
  }
}
