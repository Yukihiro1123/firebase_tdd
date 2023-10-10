// a generic Listener class, used to keep track of when a provider notifies its listeners
import 'package:mocktail/mocktail.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
