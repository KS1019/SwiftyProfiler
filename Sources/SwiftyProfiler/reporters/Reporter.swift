//
//  Reporter.swift
//  swifty-profiler
//
//  Created by Kotaro Suto on 2021/04/05.
//

import Foundation
import SwiftyTextTable
import SwiftyXcActivityLog

protocol Reporter {
    var executions: [Execution] { get set }
    func report()
    
    var limit: Int { get set }
    var threshold: Int { get set }
    var showInvalids: Bool { get set }
    var order: SortOrder { get set }
    var truncateAt: Int { get set }
    var noUnique: Bool { get set }
}

class StandardOutputReporter: Reporter {
    internal init(limit: Int, threshold: Int, showInvalids: Bool, order: SortOrder, truncateAt: Int, noUnique: Bool, executions: [Execution]) {
        self.limit = limit
        self.threshold = threshold
        self.showInvalids = showInvalids
        self.order = order
        self.truncateAt = truncateAt
        self.noUnique = noUnique
        self.executions = executions
    }
    
    var limit: Int
    
    var threshold: Int
    
    var showInvalids: Bool
    
    var order: SortOrder
    
    var truncateAt: Int
    
    var noUnique: Bool
    
    var executions: [Execution]
    
    func report() {
        let fileHeader = TextTableColumn(header: "File")
        let lineHeader = TextTableColumn(header: "Line")
        let methodHeader = TextTableColumn(header: "Method name")
        let timeHeader = TextTableColumn(header: "Time(ms)")
        var table = TextTable(columns: [fileHeader, lineHeader, methodHeader, timeHeader])
        
        executions
            .filter { execution in
                if !showInvalids && execution.isInvalidLocation {
                    return false
                }
                return true
            }
            .filter { execution in
                if threshold != 0 && execution.time < TimeInterval(threshold) {
                    return false
                }
                return true
            }
            .map { execution -> Execution in
                var newExecution = execution
                if truncateAt != 0 {
                    newExecution.methodName =
                        (execution.methodName.count > truncateAt)
                        ? String(execution.methodName.prefix(truncateAt))
                        : execution.methodName
                }
                return newExecution
            }
            .sorted(by: { (e1, e2) -> Bool in
                return e1.methodName < e2.methodName
            })
            .sorted(by: { (e1, e2) -> Bool in
                return e1.line < e2.line
            })
            .sorted(by: { (e1, e2) -> Bool in
                guard let e1 = e1.file, let e2 = e2.file else { return false }
                return e1.name < e2.name
            })
            .uniqueElements(noUnique: noUnique)
            .sorted(by: { (e1, e2) -> Bool in
                if order == .file {
                    return e1.file?.name ?? "<invalid loc>" < e2.file?.name ?? "<invalid loc>"
                } else if order == .time {
                    return e1.time > e2.time
                } else {
                    return false
                }
            })
            .forEach { (execution: Execution) in
                table.addRow(values: [execution.file?.name ?? "<invalid loc>", execution.line, execution.methodName, execution.time])
            }
        
        print(table.render())
    }
    
    
}
