import gql from 'graphql-tag'


export const CREATE = gql(`
  mutation($data: CreateReportInput!){
    createReport(data: $data)
  }
`)


