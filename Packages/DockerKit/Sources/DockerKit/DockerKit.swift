//
//  DockerKit.swift
//  Swoop
//
//  Created by Leo Dion on 7/18/24.
//

enum DockerRunArgument {
    case image(String)
    case volume(host: String, container: String)
    case port(host: Int, container: Int)
    case env(key: String, value: String)
    case detach
    case remove
    case interactive
    case tty
    case name(String)
    case command(String)
}

struct DockerRunBuilder {
    private var arguments: [DockerRunArgument] = []
    
    mutating func add(_ argument: DockerRunArgument) {
        arguments.append(argument)
    }
    
    func build() -> [String] {
        var result = ["docker", "run"]
        
        for argument in arguments {
            switch argument {
            case .image(let name):
                result.append(name)
            case .volume(let host, let container):
                result.append("-v")
                result.append("\(host):\(container)")
            case .port(let host, let container):
                result.append("-p")
                result.append("\(host):\(container)")
            case .env(let key, let value):
                result.append("-e")
                result.append("\(key)=\(value)")
            case .detach:
                result.append("-d")
            case .remove:
                result.append("--rm")
            case .interactive:
                result.append("-i")
            case .tty:
                result.append("-t")
            case .name(let containerName):
                result.append("--name")
                result.append(containerName)
            case .command(let cmd):
                result.append(cmd)
            }
        }
        
        return result
    }
}

// MARK: - Docker Compose

enum DockerComposeCommand {
    case up
    case down
    case build
    case ps
}

enum DockerComposeArgument {
    case file(String)
    case project(String)
    case service(String)
    case build
    case noDeps
    case forceRecreate
    case detached
}

struct DockerComposeBuilder {
    private let command: DockerComposeCommand
    private var arguments: [DockerComposeArgument] = []
    
    init(command: DockerComposeCommand) {
        self.command = command
    }
    
    mutating func add(_ argument: DockerComposeArgument) {
        arguments.append(argument)
    }
    
    func build() -> [String] {
        var result = ["docker", "compose"]
        
        switch command {
        case .up:
            result.append("up")
        case .down:
            result.append("down")
        case .build:
            result.append("build")
        case .ps:
            result.append("ps")
        }
        
        for argument in arguments {
            switch argument {
            case .file(let filePath):
                result.append("-f")
                result.append(filePath)
            case .project(let projectName):
                result.append("-p")
                result.append(projectName)
            case .service(let serviceName):
                result.append(serviceName)
            case .build:
                result.append("--build")
            case .noDeps:
                result.append("--no-deps")
            case .forceRecreate:
                result.append("--force-recreate")
            case .detached:
                result.append("-d")
            }
        }
        
        return result
    }
}
