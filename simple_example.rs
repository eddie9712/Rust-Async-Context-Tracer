use async_std::task;
use std::time::Duration;

async fn my_test()
{
   task::sleep(Duration::from_millis(100)).await;
}
#[async_std::main]
async fn main(){
     my_test().await;
     task::sleep(Duration::from_millis(150)).await;
}
