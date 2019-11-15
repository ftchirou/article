//
//  Files.swift
//  
//
//  Created by Faiçal Tchirou on 29/10/2019.
//

import Foundation

protocol Files {
    var blogSourceDirectoryURL: URL { get }
    var blogBuildDirectoryURL: URL { get }
    var blogTrashDirectoryURL: URL? { get }
    var blogIndexURL: URL { get }
    var currentDirectoryPath: String { get }
    func directoryExists(at url: URL) -> Bool
    func fileExists(at url: URL) -> Bool
    func createDirectoryIfDoesNotExists(at url: URL) throws
    func createEmptyFile(at url: URL) throws
    func contents(at url: URL) -> String?
    func write(_ contents: String, at url: URL) throws
    func directoriesNames(under url: URL) -> [String]
}
