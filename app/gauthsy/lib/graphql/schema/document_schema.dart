part of graphql;

class DocumentSchema {
  static DocumentNode documents = gql(r"""
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
  """);

  static DocumentNode createDocument = gql(r"""
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
  """);

  static DocumentNode deleteDocument = gql(r"""
        mutation($data: DeleteDocumentInput!){
            deleteDocument(data: $data)
        }
  """);
}
