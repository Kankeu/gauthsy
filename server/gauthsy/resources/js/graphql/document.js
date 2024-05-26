import gql from 'graphql-tag'


export const DOCUMENTS = gql(`
        query($page: Int){
          me{
            id
            documents(first:10, page: $page){
              paginatorInfo{hasMorePages}
              data{
                id
                type
                number
                issued_by
                valid
                message
                verified_at
                created_at
                updated_at
                payload{
                     surname
                     forename
                     country_code
                     document_type
                     document_number
                     nationality_country_code
                     sex
                     birth_date
                     expiry_date
                     personal_number
                     personal_number2
                }
                images(first:10,page:1){
                     data{
                        type
                        path
                     }
                }
              }
            }
          }
        }
`)

export const CREATE = gql(`
        mutation($data: CreateDocumentInput!){
            createDocument(data: $data){
                id
                type
                number
                issued_by
                valid
                verified_at
                created_at
                updated_at
                payload{
                     surname
                     forename
                     country_code
                     document_type
                     document_number
                     nationality_country_code
                     sex
                     birth_date
                     expiry_date
                     personal_number
                     personal_number2
                }
                images(first:10,page:1){
                     data{
                        type
                        path
                     }
                }
            }
        }
`)

export const DASHBOARD_DOCUMENTS = gql(`
        query($page: Int){
            documents(first:10, page: $page,where:{column:VERIFIED_AT, operator:IS_NULL}, orderBy:{column: CREATED_AT, order: ASC}){
              paginatorInfo{hasMorePages}
              data{
                id
                type
                number
                issued_by
                valid
                verified_at
                created_at
                updated_at
                payload{
                     surname
                     forename
                     country_code
                     document_type
                     document_number
                     nationality_country_code
                     sex
                     birth_date
                     expiry_date
                     personal_number
                     personal_number2
                }
                images(first:10,page:1){
                     data{
                        type
                        path
                     }
                }
              }
            }
        }
`)

export const DELETE = gql(`
        mutation($data: DeleteDocumentInput!){
            deleteDocument(data: $data)
        }
`)

export  const REJECT = gql(`
        mutation($data: RejectDocumentInput!){
            rejectDocument(data: $data)
        }
`);

export  const VALIDATE = gql(`
        mutation($data: ValidateDocumentInput!){
            validateDocument(data: $data)
        }
`);

export const GENERATE_TOKEN_TO_DOCUMENTS=gql(`
        mutation($data: GenerateTokenToDocumentsInput!){
            generateTokenToDocuments(data: $data)
        }
`);
