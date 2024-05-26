part of auth_manager;

class Auth extends User<Auth> {
  Token _token;
  String table = "users";
  String locale;
  String gender;
  String birthday;
  String fcmToken;
  String emailVerifiedAt;
  int unreadNotificationsCount = 0;
  int unreadMessagesCount = 0;
  int alertsCount = 0;

  bool get verified => emailVerifiedAt != null;

  @override
  List<String> get fillable => [
        "id",
        "surname",
        "forename",
        "email",
        "created_at",
        "updated_at",
        "is_account",
        "is_active"
      ];

  Auth(
      {id,
      surname,
      forename,
      email,
      token,
      emailVerifiedAt,
      locale,
      fcmToken,
      unreadMessagesCount,
      unreadNotificationsCount,
      createdAt,
      updatedAt})
      : _token = token,
        this.fcmToken = fcmToken,
        this.locale = locale,
        this.emailVerifiedAt = emailVerifiedAt,
        this.unreadMessagesCount = unreadMessagesCount ?? 0,
        this.unreadNotificationsCount = unreadNotificationsCount ?? 0,
        super(
            id: id,
            surname: surname,
            forename: forename,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt,
            fromJson: (json) => Auth.fromJson(json));

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        id: json['id'],
        surname: json['surname'],
        forename: json['forename'],
        email: json['email'],
        locale: json['locale'],
        fcmToken: json['fcm_token'],
        emailVerifiedAt: json['email_verified_at'],
        unreadMessagesCount: json['unread_messages_count'],
        unreadNotificationsCount: json['unread_notifications_count'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        token: json['token'] == null ? null : Token.fromJson(json['token']),
      );

  Future<Token> get token async {
    return _token ?? await Token().where('id', this.id.toString()).first();
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['email_verified_at'] = emailVerifiedAt;
    data['is_account'] = 1;
    data['is_active'] = 1;
    data['token'] = _token?.toJson();

    data['email_verified_at'] = emailVerifiedAt;
    data['gender'] = gender;
    data['locale'] = locale;
    return data;
  }

  @override
  Future<bool> save() async {
    // invalid others accounts
    await this.where('is_active', '1').update({'is_active': '0'});
    _token.id = id;
    await _token.save();
    return super.save();
  }
}
