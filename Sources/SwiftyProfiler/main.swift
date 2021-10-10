import ArgumentParser
import SwiftyXcActivityLog

struct Profiler: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "swprofiler",
        abstract: "",
        discussion: "",
        version: "0.0.13",
        shouldDisplay: true,
        helpNames: [.long, .short]
    )
    
    @Argument(help: "Product Name")
    var productName: String
    
    @Option(name: .shortAndLong, help: "Limit for display")
    var limit: Int = 0
    
    @Option(name: .long, help: "Threshold of time to display (ms)")
    var threshold: Int = 0
    
    @Flag(name: .long, help: "Show invalid location results")
    var showInvalids = false
    
    @Option(name: .shortAndLong, help: "Sort order")
    var order: SortOrder = .default
    
    @Option(name: .long, help: "Root path of DerivedData directory")
    var derivedDataPath = ""
    
    @Option(name: .shortAndLong, help: "Truncate the method name with specified length")
    var truncateAt: Int = 0
    
    @Flag(name: .long, help: "Show the duplicated results")
    var noUnique = false
    
    func run() throws {
        let derived = XcActivityLog(productName: productName)
        guard let executions = derived.asExecutions() else { print("Failed to collect .xcactivitylog file");return }
        
         let reporter = StandardOutputReporter(limit: limit, threshold: threshold, showInvalids: showInvalids, order: order, truncateAt: truncateAt, noUnique: noUnique, executions: executions)
         reporter.report()
    }
}

enum SortOrder: String, ExpressibleByArgument {
    case `default`
    case time
    case file
}

Profiler.main()
