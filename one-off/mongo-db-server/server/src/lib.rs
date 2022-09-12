pub mod definitions;

use definitions::{Requests, Responses, Todo};
use mongodb::{bson::doc, Collection, Database};
use poem::{
    get, handler,
    middleware::AddData,
    web::{Data, Json},
    EndpointExt, Route,
};

#[handler]
async fn index(Json(request): Json<Requests>, collection: Data<&Collection<Todo>>) -> Responses {
    match request {
        Requests::Create { title } => {
            let res = collection
                .insert_one(Todo { title, done: false }, None)
                .await;

            if res.is_ok() {
                Responses::CreatedTodoItem
            } else {
                Responses::Error {
                    reason: "Could not create todo item".to_owned(),
                }
            }
        }
        Requests::UpdateTodoItems { done, undone } => {
            for done in done {
                let res = collection
                    // todo update many
                    .update_one(
                        doc! { "_id": done },
                        doc! {
                            "$set": {
                                "done": true
                            }
                        },
                        None,
                    )
                    .await;

                if res.is_err() {
                    return Responses::Error {
                        reason: "Could not mark todo as completed".to_owned(),
                    };
                }
            }

            for undone in undone {
                let res = collection
                    .update_one(
                        doc! { "_id": undone },
                        doc! {
                            "$set": {
                                "done": false
                            }
                        },
                        None,
                    )
                    .await;

                if res.is_err() {
                    return Responses::Error {
                        reason: "Could not mark todo as not complete".to_owned(),
                    };
                }
            }

            Responses::UpdatedTodoItems
        }
        Requests::ListTodoItems { include_done } => {
            let filter = if include_done {
                None
            } else {
                Some(doc! { "done": false })
            };

            let cursor = collection.find(filter, None).await;

            let mut cursor = if let Ok(cursor) = cursor {
                cursor
            } else {
                return Responses::Error {
                    reason: "Could not read from collection".to_owned(),
                };
            };

            let mut items = Vec::new();
            while let Ok(true) = cursor.advance().await {
                let id = cursor.current().get_object_id("_id").unwrap();
                let todo = cursor.deserialize_current().unwrap();
                items.push((id, todo));
            }

            Responses::TodoItems { items }
        }
    }
}

#[shuttle_service::main]
async fn main(
    #[shared::MongoDb] db: Database,
) -> shuttle_service::ShuttlePoem<impl poem::Endpoint> {
    let collection = db.collection::<Todo>("todo_items");

    let app = Route::new()
        .at("/", get(index))
        .with(AddData::new(collection));

    Ok(app)
}

impl poem::IntoResponse for Responses {
    fn into_response(self) -> poem::Response {
        Json(self).into_response()
    }
}
