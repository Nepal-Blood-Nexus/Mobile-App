import 'package:get_it/get_it.dart';
import 'package:nepal_blood_nexus/services/calls_and_messages_service.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
