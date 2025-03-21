{
    binary=$1
    version=$2
    cmd = "dpkg-query -W -f='${source:Package}\n' " binary "| head -n 1"
    if ((cmd | getline source) > 0) {
        print "ii ,"binary":"arch","version","source","version
    } else {
        exit 1
    }
    close(cmd)
}
