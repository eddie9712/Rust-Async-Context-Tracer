use async_std::task;
use std::time::Duration;
use std::thread;
use futures::join;


fn calculate_pi(N: u64) -> f64{
   let  mut pi = 0.0;
   let  dt = 1.0 / N as f64;
   for i in 0..N {
        let x =  (i / N) as f64;
        pi += dt / (1.0 + x * x);
    }
    pi * 4.0
}
async fn inner_future1(){
    task::sleep(Duration::from_millis(50)).await;
}
async fn inner_future2(){
    blocking_future().await; 
}
async fn inner_future3(){
    println!("Do nothing");
}
async fn blocking_future(){     // Detect blocking on this future (abnormal polling time)
    println!("I will block the task!");
    let pi = calculate_pi(500000);    // CPU-bound task 
    thread::sleep(Duration::from_millis(20));   //simulate a blocking I/O operation
}
#[async_std::main] 
async fn main(){

    // we have 3 tasks in total
    let handle1 = task::spawn(async {   //spawn task 1
        inner_future1().await;
        inner_future2().await;
    });
    let handle2 = task::spawn(async {    //spawn task2
       inner_future3().await;
       task::sleep(Duration::from_millis(50)).await;
    });

    join!(handle1,handle2);

}
