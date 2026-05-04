import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

/// Data model for Message with Firestore serialization.
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.senderName,
    required super.content,
    super.attachmentUrl,
    required super.isDeleted,
    required super.createdAt,
  });

  /// Creates a MessageModel from a Firestore document snapshot.
  factory MessageModel.fromFirestore(DocumentSnapshot doc, String chatId) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      chatId: chatId,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      content: data['content'] as String,
      attachmentUrl: data['attachmentUrl'] as String?,
      isDeleted: data['isDeleted'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Converts the MessageModel to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'attachmentUrl': attachmentUrl,
      'isDeleted': isDeleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Creates a MessageModel from a domain entity.
  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      content: entity.content,
      attachmentUrl: entity.attachmentUrl,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
    );
  }
}
