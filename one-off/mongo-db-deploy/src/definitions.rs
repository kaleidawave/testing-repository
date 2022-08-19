pub use mongodb::bson::oid::ObjectId;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
pub enum Requests {
    Create {
        title: String,
    },
    UpdateTodoItems {
        done: Vec<ObjectId>,
        undone: Vec<ObjectId>,
    },
    ListTodoItems {
        include_done: bool,
    },
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
pub enum Responses {
    TodoItems { items: Vec<(ObjectId, Todo)> },
    CreatedTodoItem,
    UpdatedTodoItems,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Todo {
    pub done: bool,
    pub title: String,
}
