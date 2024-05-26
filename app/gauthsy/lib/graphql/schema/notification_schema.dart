part of graphql;

class NotificationSchema {
  static DocumentNode notifications = gql(r"""
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
  """);

  static DocumentNode markAllNotificationsAsRead = gql(r"""
        mutation{
            markAllNotificationsAsRead()
        }
  """);

  static DocumentNode deleteNotification = gql(r"""
        mutation($data: DeleteNotificationInput!){
            deleteNotification(data: $data)
        }
  """);
}
