import 'package:formz/formz.dart';

enum NonEmptyTextValidationError { empty }

class NonEmptyText extends FormzInput<String?, NonEmptyTextValidationError> {
  const NonEmptyText.pure() : super.pure(null);

  const NonEmptyText.dirty([String? value]) : super.dirty(value);

  @override
  NonEmptyTextValidationError? validator(String? value) {
    return (value == null || value.isEmpty)
        ? NonEmptyTextValidationError.empty
        : null;
  }
}
