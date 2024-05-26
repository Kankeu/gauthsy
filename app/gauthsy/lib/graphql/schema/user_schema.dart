part of graphql;

class UserSchema {
  static DocumentNode login = gql(r"""
        mutation ($data: LoginInput!) {
            login(data: $data) {
                expires_in
                token_type
                access_token
                refresh_token
                me{
                  id
                  surname
                  forename
                  email
                  locale
                  email_verified_at
                  fcm_token
                }
            }
        }
  """);

  static DocumentNode appVersion = gql(r"""
              query{               
                appVersion{
                  version
                  must_upgrade
                  message
                  published_at
                }
              }
  """);

  static DocumentNode me = gql(r"""
              query{               
                me{
                  id
                  surname
                  forename
                  email
                  locale
                  email_verified_at
                  fcm_token
                }
              }
  """);

  static DocumentNode updateBasicProfile = gql(r"""
              mutation($data: UpdateUserInput!){
                updateUser(data: $data){
                  id
                  surname
                  forename
                }
              }
  """);

  static DocumentNode updateProfilePicture = gql(r"""
              mutation($data: UpdateUserInput!){
                updateUser(data: $data){
                  id
                }
              }
  """);

  static DocumentNode updateAddresses = gql(r"""
              mutation($data: UpdateUserInput!){
                updateUser(data: $data){
                  id
                  email
                }
              }
  """);

  static DocumentNode updatePassword = gql(r"""
              mutation($data: UpdateUserInput!){
                updateUser(data: $data){
                  id
                }
              }
  """);

  static DocumentNode signUp = gql(r"""
        mutation ($data: SignUpInput!) {
            signUp(data: $data) {
                id
                surname
                forename
                email_verified_at
            }
        }
  """);

  static DocumentNode verifyEmail = gql(r"""
        mutation ($data: VerifyEmailInput!) {
            verifyEmail(data: $data)
        }
  """);

  static DocumentNode resentEmailVerified = gql(r"""
        mutation ($data: ResentEmailVerifiedInput!) {
            resentEmailVerified(data: $data)
        }
  """);

  static DocumentNode forgotPassword = gql(r"""
        mutation ($data: ForgotPasswordInput!) {
            forgotPassword(data: $data)
        }
  """);

  static DocumentNode resetPassword = gql(r"""
        mutation ($data: ResetPasswordInput!) {
            resetPassword(data: $data)
        }
  """);

  static DocumentNode provider = gql(r"""
              query($id: ID!){               
                provider(id: $id){
                  id
                  surname
                  forename
                  email
                  created_at
                }
              }
  """);

  static DocumentNode updateFcmToken = gql(r"""
              mutation($data: UpdateUserInput!){
                updateUser(data: $data){
                  id
                  fcm_token
                }
              }
  """);

  static DocumentNode logout = gql(r"""
              mutation{
                logout
              }
  """);

  static DocumentNode home = gql(r"""
              query{               
                me{
                  id
                  unread_messages_count
                  unread_notifications_count
                }
              }
  """);
}
