{
    JetsamProperties =     {
        JetsamPriority = "-100";
    };
    KeepAlive = 1;
    Label = "com.apple.powerd";
    MachServices =     {
        "com.apple.PowerManagement.control" = 1;
        "com.apple.iokit.powerdxpc" = 1;
    };
    POSIXSpawnType = Adaptive;
    Program = "/System/Library/CoreServices/powerd.bundle/powerd";
}
