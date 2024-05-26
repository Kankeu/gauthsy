import gql from 'graphql-tag'


export const LOGIN = gql(`
    mutation ($data: LoginInput!){
        login(data: $data){
            access_token
            refresh_token
            expires_in
            token_type
            me {
                id
                email
                surname
                forename
                is_admin
                fcm_token
                created_at
                email_verified_at
            }
        }
    }
`)

export const SIGN_UP = gql(`
    mutation($data: SignUpInput!){
        signUp(data: $data){
                id
                surname
                forename
                email_verified_at
        }
    }
`)

export const VERIFY_EMAIL = gql(`
    mutation ($data: VerifyEmailInput!) {
        verifyEmail(data: $data)
    }
`)

export const RESENT_EMAIL_VERIFIED = gql(`
    mutation ($data: ResentEmailVerifiedInput!) {
        resentEmailVerified(data: $data)
    }
`)

export const FORGOT_PASSWORD = gql(`
    mutation ($data: ForgotPasswordInput!) {
        forgotPassword(data: $data)
    }
`)

export const RESET_PASSWORD = gql(`
    mutation ($data: ResetPasswordInput!) {
        resetPassword(data: $data)
    }
`)


export const ME = gql(`
    query{
        me {
            id
            email
            surname
            forename
            is_admin
            fcm_token
            created_at
        }
    }
`)

export const LOGOUT = gql(`
    mutation{
        logout
    }
`)

export const UPDATE_FCM_TOKEN = gql(`
    mutation($data: UpdateUserInput!){
        updateUser(data: $data){
            id
            fcm_token
        }
    }
`)


export const UPDATE_BASIC_PROFILE = gql(`
    mutation($data: UpdateUserInput!){
        updateUser(data: $data){
            id
            surname
            forename
        }
    }
`)


export const UPDATE_ADDRESSES = gql(`
    mutation($data: UpdateUserInput!){
        updateUser(data: $data){
            id
            email
        }
    }
`)


export const UPDATE_PASSWORD = gql(`
    mutation($data: UpdateUserInput!){
        updateUser(data: $data){
            id
        }
    }
`)

export const REVOKE_ALL_TOKENS = gql(`
    mutation{
        revokeAllTokens
    }
`);
