import UIKit

//final class BestBeesFetcher  {
//    
//    static func fetchBestBees() -> [String] {
//        print("Started fetching")
//        Thread.sleep(forTimeInterval: 3)
//        // Make a network request to fetch them
//        return ["A", "B"]
//    }
//}
//
//final class BestBeesPrinter {
//    
//    func printBestBees() {
//        BestBeesFetcher.fetchBestBees().forEach{ print($0) }
//        // Fetch the best bees
//        // Iterate through them and print them
//    }
//}

final class BestBeesFetcher  {
    // NSOperation = old, not really used
    // GCD (Grand Central Dispatch) = most common
    // Structured concurrency = new approach
    
    // GDD Queue Types
    
    // 1st Dimension: Privacy
    // Private queues
    //  For controlling access to a shared resrouce, so that a single thread can access it at a time
    // Global queues
    //  For convenience - for example, the main queue
    
    // 2nd: Way of execution
    // Serial queues
    //  The next operation only starts when the current one finishes
    //  Can work fine on a single thread, but can also work with multiple
    // Concurrent queues
    //  Stuff runs in parallel
    //  Can't work with a single thread, it manages multiple ones
    
    // QoS
    // How important the work in the queue is.
    
    // DispatchQueue.main.async
    // DispatchQueue.main.sync - never do this
    // DispatchQueue.global().sync
    /*
        let queueA = DispatchQueue(id: "queue-a")
        let queueB = DispatchQueue(id: "queue-b")
        
        queueA.async {
            print("Hello world")
            queueB.async {
                Thread.sleep(3)
                print("Something else")
            }
            print("Me again")
        }
     
     */
    
    let queue = DispatchQueue(label: "my-queue", qos: .userInteractive)
    
    func fetchBestBees(completionHandler: @Sendable @escaping ([String]) -> Void) {
        self.queue.async {
            print("Started fetching on \(Thread.current)")
            
            Thread.sleep(forTimeInterval: 3)
            let result = ["A", "B"]
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
        
    }
}

final class BestBeesPrinter {
    let fetcher = BestBeesFetcher()
    
    func printBestBees() {
        self.fetcher.fetchBestBees(
            completionHandler: { bestBees in
                bestBees.forEach { print($0) }
                print("\(Thread.current)")
            }
        )
        // Fetch the best bees
        // Iterate through them and print them
    }
}

let printer = BestBeesPrinter()
printer.printBestBees()
