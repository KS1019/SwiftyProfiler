import XCTest
import class Foundation.Bundle

final class SwiftyProfilerTests: XCTestCase {
    func testExample() throws {
        guard #available(macOS 10.11, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("swprofiler")
        let process = Process()
        process.executableURL = fooBinary
        
        let pipe = Pipe()
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let outputError = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)

        XCTAssertEqual(errorString, outputError)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

let errorString: String = """
Error: Missing expected argument '<product-name>'

USAGE: swprofiler <product-name> [--limit <limit>] [--threshold <threshold>] [--show-invalids] [--order <order>] [--derived-data-path <derived-data-path>] [--truncate-at <truncate-at>] [--no-unique]

ARGUMENTS:
  <product-name>          Product Name

OPTIONS:
  -l, --limit <limit>     Limit for display (default: 0)
  --threshold <threshold> Threshold of time to display (ms) (default: 0)
  --show-invalids         Show invalid location results
  -o, --order <order>     Sort order (default: default)
  --derived-data-path <derived-data-path>
                          Root path of DerivedData directory
  -t, --truncate-at <truncate-at>
                          Truncate the method name with specified length
                          (default: 0)
  --no-unique             Show the duplicated results
  --version               Show the version.
  -h, --help              Show help information.


"""
.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
