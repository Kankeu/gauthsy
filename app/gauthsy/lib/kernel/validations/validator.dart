library validations;

import 'package:gauthsy/localization/app_localization.dart';

part 'interfaces/validator_interface.dart';

class Validator implements ValidatorInterface {
  final _validators = <ValidatorFun>[];

  Validator required() {
    _validators.add((dynamic value) {
      if (value == null || _isEmpty(value)) return trans("validation.required");
      return null;
    });
    return this;
  }

  bool _isEmpty(value) {
    if (value is String) return value.trim().isEmpty;
    if (value is List) return value.isEmpty;
    return value == null;
  }

  Validator maxSize([int max = 10]) {
    _validators.add((dynamic value) {
      if (value == null || value.length > max)
        return "The field can't be more than $max.";
      return null;
    });
    return this;
  }

  Validator maxLength([int max = 500]) {
    _validators.add((dynamic value) {
      value = value?.trim();
      if (value == null || value.length > max)
        return trans("validation.maxLength", {"max": max});
      return null;
    });
    return this;
  }

  Validator max([double max = 500]) {
    _validators.add((dynamic value) {
      if(value is String) value=int.parse(value);
      if (value == null || value > max)
        return trans("validation.max", {"max": max});
      return null;
    });
    return this;
  }

  Validator min([double min = 0]) {
    _validators.add((dynamic value) {
      if(value==null) return null;
      if(value is String) value=num.tryParse(value);
      if (value == null || value < min)
        return trans("validation.min", {"min": min});
      return null;
    });
    return this;
  }

  Validator minDate(DateTime min) {
    _validators.add((dynamic value) {
      if(value is String) value=DateTime.parse(value);
      if (value != null && value.compareTo(min) <=0 )
        return trans("validation.min", {"min": min});
      return null;
    });
    return this;
  }

  Validator minSize([int min = 1]) {
    _validators.add((dynamic value) {
      if (value == null || value.length < min)
        return "The field can't be less than $min.";
      return null;
    });
    return this;
  }

  Validator minLength([int min = 0]) {
    _validators.add((dynamic value) {
      value = value?.trim();
      if (value == null || value.length < min)
        return trans("validation.minLength", {"min": min});
      return null;
    });
    return this;
  }

  Validator email() {
    _validators.add((dynamic value) {
      value = value?.trim();
      if (value != null && value.trim().isNotEmpty) {
        final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
        if (!nameExp.hasMatch(value)) return trans("validation.email");
      }
      return null;
    });
    return this;
  }

  Validator same(String value, String attribute) {
    _validators.add((dynamic value2) {
      if (value2 != value)
        return trans("validation.same", {"attribute": attribute});

      return null;
    });
    return this;
  }

  Validator accepted() {
    _validators.add((dynamic value) {
      if (!value) return trans("validation.accepted");
      return null;
    });
    return this;
  }

  Validator price() {
    _validators.add((dynamic value) {
      if (value != null && value.trim().isNotEmpty) {
        if (RegExp(r'[,]').hasMatch(value))
          return 'Please use the dot instead of the comma';
        final RegExp nameExp = new RegExp(r'^[0-9.]+$');
        if (!nameExp.hasMatch(value))
          return 'This field must contain only number.';
        if (RegExp(r'[.]').hasMatch(value) &&
            !RegExp(r'^[0-9]+.[0-9]+$').hasMatch(value))
          return "Please use something like this xx.xx (e.g. 0.99)";
      }
      return null;
    });
    return this;
  }

  ValidatorFun make() {
    return (dynamic value) {
      for (var e in _validators) {
        var res = e(value);
        if (res != null) return res;
      }
      return null;
    };
  }
}

typedef ValidatorFun = String Function(dynamic);
