import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class Socket {
  Future connect() async {
    try {
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      await pusher.init(
        apiKey: "b6fc6c0bbaa88e19ba69",
        cluster: "ap2",
        onError: onError,
        onEvent: onEvent,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: "main");
      await pusher.connect();
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  void onError(String message, int? code, dynamic e) {
    debugPrint("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    debugPrint("onEvent: $event");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    debugPrint(
        "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }
}
