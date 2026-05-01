import 'package:equatable/equatable.dart';

/// Represents a message entity in the domain layer.
class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final String? attachmentUrl;
  final bool isDeleted;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.attachmentUrl,
    required this.isDeleted,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    senderName,
    content,
    attachmentUrl,
    isDeleted,
    createdAt,
  ];
}
