import 'dart:async';

import 'package:flutter/services.dart';


class Socket{
  
  int id;
  Map<String, List<Function>> listeners;
  final MethodChannel channel;
  
  Socket(this.id){
    channel = new MethodChannel("adhara_socket_io:socket:${id.toString()}");
    channel.setMethodCallHandler((call) {
      if (call.method == 'incoming') {
        final String eventName = call.arguments['eventNamr'];
        final List<dynamic> arguments = call.arguments['args'];
        _handleData(eventName, arguments);
      }
    });
  }

  on(String eventName, Function listener){
    if(listeners[eventName] == null){
      listeners[eventName] = [];
    }
    listeners[eventName].add(listener);
    channel.invokeMethod("on", {
      "eventName": eventName
    });
  }

  off(String eventName, [Function listener]){
    if(listener==null){
      listeners[eventName] = [];
    }else{
      listeners[eventName].remove(listener);
    }
    if(listeners[eventName].length == 0){
      channel.invokeMethod("off", {
        "eventName": eventName
      });
    }
  }

  _handleData(String eventName, List arguments){
    listeners[eventName]?.forEach((Function listener){
      Function.apply(listener, arguments);
    });
  }
  
  
}