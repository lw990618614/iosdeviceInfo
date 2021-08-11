{
    Disabled = 1;
    Label = "com.apple.bootpd";
    ProgramArguments =     (
        "/usr/libexec/bootpd"
    );
    Sockets =     {
        Listeners =         {
            SockFamily = IPv4;
            SockServiceName = bootps;
            SockType = dgram;
        };
    };
    inetdCompatibility =     {
        Wait = 1;
    };
}
