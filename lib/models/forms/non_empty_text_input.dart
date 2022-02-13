import 'package:formz/formz.dart';

enum NonNullTextValidationError { empty }

class NonNullText extends FormzInput<String?, NonNullTextValidationError> {
  const NonNullText.pure() : super.pure(null);

  const NonNullText.dirty([String? value]) : super.dirty(value);

  @override
  NonNullTextValidationError? validator(String? value) {
    return (value == null || value.isEmpty)
        ? NonNullTextValidationError.empty
        : null;
  }
}
