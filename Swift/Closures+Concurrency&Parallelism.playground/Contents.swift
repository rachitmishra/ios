import UIKit

// dispatch queue
// operation queue

// GCD
"""
 https://cocoacasts.com/choosing-between-nsoperation-and-grand-central-dispatch/
 https://nshipster.com/nsoperation/
 http://eschatologist.net/blog/?p=232
 https://www.hackingwithswift.com/example-code/system/how-to-use-multithreaded-operations-with-operationqueue
"""

func trace(tag: String, iterations: Int, operation: (Int) -> (Int)) {
    let startTime = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        operation(99999)
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("Trace: \(tag) Iterations: \(iterations) Runtime: \(endTime-startTime)")
}

let task: (Int) -> Int = {$0*$0}

// Dispatch Queue

let serialQueue = DispatchQueue(label: "com.rachitmishra")

let concurrentQueue = DispatchQueue(label: "com.rachitmishra", attributes: .concurrent)

let queue = serialQueue
//
//queue.async {
//    trace(tag: "trace1", iterations: 50000, operation: task)
//}
//queue.async {
//    trace(tag: "trace2",iterations: 1000, operation: task)
//}
//queue.async {
//    trace(tag: "trace3", iterations: 10000, operation: task)
//}
//queue.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1000), execute: {
//    trace(tag: "trace4", iterations: 10000, operation: task)
//})

// Operation Queue
//let queue = OperationQueue()
//
//let operation: BlockOperation = BlockOperation(block: {
//    trace(tag: "operation 1 block 1", iterations: 1000, operation: task)
//})
//
//operation.addExecutionBlock {
//    trace(tag: "operation 1 block 2", iterations: 100, operation: task)
//}
//
//queue.maxConcurrentOperationCount = 2 // Blocks execution limited to a
//// single operation and not execution blocks inside each operation
//
//queue.addOperation(operation)
//
//queue.addOperation() {
//    trace(tag: "operation 2", iterations: 100, operation: task)
//}
//
//queue.addOperation() {
//    trace(tag: "operation 3", iterations: 100, operation: task)
//}

//
//class MyOperation: Operation {
//
//    func trace(tag: String, iterations: Int, operation: (Int) -> (Int)) {
//        let startTime = CFAbsoluteTimeGetCurrent()
//        for _ in 0..<iterations {
//            operation(99999)
//        }
//        let endTime = CFAbsoluteTimeGetCurrent()
//        print("Trace: \(tag) Iterations: \(iterations) Runtime: \(endTime-startTime)")
//    }
//
//    let internalTask: (Int) -> Int = {a in a*a}
//
//    override func main() {
//        trace(tag: "custom operation", iterations: 500, operation: internalTask)
//    }
//}
//
//queue.addOperation(MyOperation())


let group = DispatchGroup()
group.enter()
queue.async {
    print("Hello world1!")
    group.leave()
}
group.enter()
queue.async {
    print("Hello world2!")
    group.leave()
}

group.notify(queue: queue) {
    print("Hello world3!")
}


//DispatchQueue.global().async(group: group2, execute: workItem)

//// Closures
//
//let clos1 = {
//    () -> Void in
//    print("Hello, world!!")
//}
//
//clos1()
//
//let clos2 = {
//    (name: String) -> Void in
//    print("Hello, \(name)")
//}
//
//clos2("Rachit")
