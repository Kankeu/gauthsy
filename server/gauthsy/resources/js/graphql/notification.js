import gql from 'graphql-tag'


export const NOTIFICATIONS = gql(`
        query($page: Int){
          me{
            id
            unread_notifications_count
            notifications(first:10, page: $page){
              paginatorInfo{hasMorePages}
              data{
                id
                type
                data
                read_at
                created_at
              }
            }
          }
        }
`)

export const MARK_ALL_AS_READ = gql(`
        mutation{
            markAllNotificationsAsRead()
        }
`)

export const DELETE = gql(`
        mutation($data: DeleteNotificationInput!){
            deleteNotification(data: $data)
        }
`)
