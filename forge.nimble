version       = "1.0.0"
author        = "Your Name"
description   = "A new awesome Nimble package"
license       = "BSD-3-Clause"
srcDir        = "src"
bin           = @["forge"]

requires "nim >= 2.0.8"

import std/strformat

task release, "Build release binary":
    for b in bin:
        selfExec &"c -d:release -d:strip -o:{b} {srcDir}/{b}.nim"
