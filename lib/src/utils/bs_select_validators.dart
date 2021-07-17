/// Type definition for custom bs form validator
typedef BsSelectValidatorValue<T> = String? Function(T? value);

class BsSelectValidators {
  const BsSelectValidators({
    required this.validator,
  });

  /// validator function to check value is valid or not
  final BsSelectValidatorValue validator;

  /// define required validation
  static BsSelectValidators get required => BsSelectValidators(
    validator: (value) {
      String valueValidate = value.toString().trim();
      if (valueValidate.isEmpty || value == null) return "Select field is required";

      return null;
    },
  );
}