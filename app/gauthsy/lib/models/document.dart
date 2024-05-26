import 'package:gauthsy/kernel/database_manager/model.dart';
import 'package:gauthsy/models/image.dart';

class Document extends Model {
  String table = 'documents';

  String id;
  String type;
  String number;
  String issuedBy;
  DocumentPayload payload;
  bool valid;
  String message;
  String verifiedAt;
  String createdAt;
  String updatedAt;

  List<Image> images = [];

  Image get face => images.firstWhere((element) => element.type == "FACE",
      orElse: () => null);

  Image get front => images.firstWhere((element) => element.type == "FRONT",
      orElse: () => null);

  Image get back => images.firstWhere((element) => element.type == "BACK",
      orElse: () => null);

  Image get frontFace =>
      images.firstWhere((element) => element.type == "FRONT_FACE",
          orElse: () => null);

  Document(
      {this.id,
      this.type,
      this.number,
      this.issuedBy,
      this.payload,
      this.valid,
      this.message,
      this.verifiedAt,
      this.images,
      this.createdAt,
      this.updatedAt})
      : super((json) => Document.fromJson(json));

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      id: json['id'],
      type: json['type'],
      number: json['number'],
      issuedBy: json['issued_by'],
      message: json['message'],
      payload: DocumentPayload.fromJson(json['payload']),
      valid: json['valid'],
      verifiedAt: json['verified_at'],
      images: json['images'].map<Image>((e) => Image.fromJson(e)).toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "number": number,
        "issued_by": issuedBy,
        "valid": valid,
        "message": message,
        "verified_at": verifiedAt,
        "payload": payload.toJson(),
        "images": images.map((e) => e.toJson()).toList(),
        "created_at": createdAt,
        "updated_at": updatedAt
      };
}

class DocumentPayload {
  String surname;
  String forename;
  String countryCode;
  String documentType;
  String documentNumber;
  String sex;
  String message;
  String birthDate;
  String expiryDate;
  String personalNumber;
  String personalNumber2;
  String nationalityCountryCode;

  String get fullName => forename + " " + surname;

  DocumentPayload(
      {this.surname,
      this.forename,
      this.countryCode,
      this.documentType,
      this.documentNumber,
      this.sex,
      this.message,
      this.birthDate,
      this.expiryDate,
      this.nationalityCountryCode,
      this.personalNumber,
      this.personalNumber2});

  factory DocumentPayload.fromJson(Map<String, dynamic> json) =>
      DocumentPayload(
        surname: json['surname'],
        forename: json['forename'],
        countryCode: json['country_code'],
        documentType: json['document_type'],
        documentNumber: json['document_number'],
        sex: json['sex'],
        birthDate: json['birth_date'],
        expiryDate: json['expiry_date'],
        nationalityCountryCode: json['nationality_country_code'],
        personalNumber: json['personal_number'],
        personalNumber2: json['personal_number2'],
      );

  Map<String, dynamic> toJson() => {
        "surname": surname,
        "forename": forename,
        "country_code": countryCode,
        "document_type": documentType,
        "document_number": documentNumber,
        "sex": sex,
        "birth_date": birthDate,
        "nationality_country_code": nationalityCountryCode,
        "personal_number": personalNumber,
        "personal_number2": personalNumber2,
      };
}
