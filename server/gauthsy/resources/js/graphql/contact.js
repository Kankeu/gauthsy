import gql from "graphql-tag";

export const CREATE = gql(`
        mutation($data: CreateContactInput!){
            createContact(data: $data)
        }
`);
