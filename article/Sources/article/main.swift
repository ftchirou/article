import Foundation
import articleCore

ArticleCLI.run(with: CommandLine.arguments) { result in
    switch result {
    case let .success(output):
        FileHandle.standardOutput.write(Data("\(output)\n".utf8))
        exit(0)
    case let .failure(error):
        FileHandle.standardError.write(Data("\(error.localizedDescription)\n".utf8))
        exit(1)
    }
}

RunLoop.main.run()
