mod definitions;

use definitions::{Requests, Responses, Todo};
use mongodb::{
    bson::{doc, oid::ObjectId},
    Collection, Database,
};
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

            Responses::CreatedTodoItem
        }
        Requests::UpdateTodoItems { done, undone } => {
            for done in done {
                collection.update_one(
                    doc! {"_id": done },
                    doc! {
                        "done": true
                    },
                    None,
                );
            }

            for undone in undone {
                collection.update_one(
                    doc! {"_id": undone },
                    doc! {
                        "done": false
                    },
                    None,
                );
            }

            Responses::UpdatedTodoItems
        }
        Requests::ListTodoItems { include_done } => {
            let filter = if include_done {
                None
            } else {
                Some(doc! { "done": false })
            };

            let mut cursor = collection.find(filter, None).await.unwrap();

            let mut items = Vec::new();
            while let Ok(_) = cursor.advance().await {
                let id: ObjectId = cursor.current().get_object_id("_id").unwrap();
                let todo: Todo = cursor.deserialize_current().unwrap();
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
