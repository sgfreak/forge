import os, osproc, strformat, httpclient, strutils, posix

if paramCount() == 0:
    echo """Usage: forge <operation> <package>
    Operations:
        install - Install a package
    """    
    quit(1)

elif paramCount() == 1:
    echo "Error: Missing package name"
    quit(1)
    
elif paramCount() > 2:
    echo "Error: Too many arguments"
    quit(1)

let REPO = readFile("/var/hypernova/repo").strip()
let TMP = "/tmp/hypernova"
let OP = paramStr(1)
let PKG = paramStr(2)
let URL = fmt"{REPO}/{PKG}.tar.gz"
let SEPARATOR= "----------------------------------------"

createDir("/var/forge/world")
discard execProcess(fmt"mkdir -p {TMP}/{PKG}")

proc install() =
    echo "Downloading source."
    echo fmt"Connecting to {REPO}..."

    let workdir = TMP / PKG
    createDir(workdir)
    let pkgsrc = workdir / (PKG & ".tar.gz")
    let client = newHttpClient()
    client.downloadFile(URL, pkgsrc)
    echo fmt"Successfully downloaded {PKG} from {REPO}"
    

    echo SEPARATOR

    echo "Extracting source.\n"
 
    let extract = execProcess(fmt"tar -xzvf {pkgsrc} -C {TMP}/{PKG}")
    echo extract
    echo "Source extracted."  

    echo SEPARATOR

    echo "Building package."
    echo SEPARATOR

    let buildsh = readFile(fmt"{TMP}/{PKG}/build.sh")
    echo buildsh

    echo SEPARATOR

    let build = execProcess(fmt"cd {TMP}/{PKG} && sh build.sh")
    echo build

    echo SEPARATOR
    echo "Done, registering into the world set."
    writeFile(fmt"/var/forge/world/{PKG}", "")
    echo fmt"{PKG} has been installed successfully."
    


if OP == "install":
    install()

