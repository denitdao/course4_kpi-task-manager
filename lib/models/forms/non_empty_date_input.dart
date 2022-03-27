import 'package:formz/formz.dart';

enum NonNullDateValidationError { empty }

class NonNullDate extends FormzInput<DateTime?, NonNullDateValidationError> {
  const NonNullDate.pure() : super.pure(null);

  const NonNullDate.dirty([DateTime? value]) : super.dirty(value);

  @override
  NonNullDateValidationError? validator(DateTime? value) {
    return (value == null) ? NonNullDateValidationError.empty : null;
  }
}
