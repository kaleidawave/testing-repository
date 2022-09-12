use mongodb::bson::{doc, oid::ObjectId};

use mongodb_todo_cli_server::definitions::Todo;

#[tokio::test]
async fn test() {
    let ids: Vec<ObjectId> = vec![
        // ObjectId::parse_str("62ffa28d667ada9536a8d8d5").unwrap(),
        ObjectId::parse_str("62ffbca946f49bcc9f07d823").unwrap(),
    ];

    use mongodb::{options::ClientOptions, Client};

    // Parse a connection string into an options struct.
    let client_options = ClientOptions::parse(
        "mongodb://user-mongodb-todo-cli-server:XuFTwDdN9hHN@db.shuttle.rs:27017/mongodb-mongodb-todo-cli-server",
    )
    .await
    .unwrap();

    let client = Client::with_options(client_options).unwrap();
    let db = client.database("mongodb-mongodb-todo-cli-server");

    let collection = db.collection::<Todo>("todo_items");

    collection
        .update_many(
            doc! { "_id": doc!{ "$in": ids } },
            doc! {
                "$set": {
                    "done": true
                }
            },
            None,
        )
        .await
        .unwrap();
}
