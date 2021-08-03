{
    BuildMachineOSBuild = 16B2657;
    CFBundleDevelopmentRegion = English;
    CFBundleGetInfoString = "1.7, Copyright Apple Inc. 1999-2016";
    CFBundleIdentifier = "com.apple.filesystems.hfs";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = hfs;
    CFBundlePackageType = "fs  ";
    CFBundleShortVersionString = "1.7";
    CFBundleSignature = "????";
    CFBundleSupportedPlatforms =     (
        iPhoneOS
    );
    CFBundleVersion = "1.7";
    DTCompiler = "com.apple.compilers.llvm.clang.1_0";
    DTPlatformBuild = "";
    DTPlatformName = iphoneos;
    DTPlatformVersion = "11.3";
    DTSDKBuild = 15E215;
    DTSDKName = "iphoneos11.3.internal";
    DTXcode = 0930;
    DTXcodeBuild = 9P107g;
    FSMediaTypes =     {
        "426F6F74-0000-11AA-AA11-00306543ECAC" =         {
            FSMediaProperties =             {
                "Content Hint" = "426F6F74-0000-11AA-AA11-00306543ECAC";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 1000;
            autodiskmount = 0;
        };
        "48465300-0000-11AA-AA11-00306543ECAC" =         {
            FSMediaProperties =             {
                "Content Hint" = "48465300-0000-11AA-AA11-00306543ECAC";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 1000;
        };
        "Apple_Boot" =         {
            FSMediaProperties =             {
                "Content Hint" = "Apple_Boot";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 1000;
            autodiskmount = 0;
        };
        "Apple_HFS" =         {
            FSMediaProperties =             {
                "Content Hint" = "Apple_HFS";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 1000;
        };
        "Apple_HFSX" =         {
            FSMediaProperties =             {
                "Content Hint" = "Apple_HFSX";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 1000;
        };
        "CD_ROM_Mode_1" =         {
            FSMediaProperties =             {
                "Content Hint" = "CD_ROM_Mode_1";
                Leaf = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 2000;
        };
        Whole =         {
            FSMediaProperties =             {
                Leaf = 1;
                Whole = 1;
            };
            FSProbeArguments = "-p";
            FSProbeExecutable = "hfs.util";
            FSProbeOrder = 2000;
        };
    };
    FSPersonalities =     {
        "Case-sensitive HFS+" =         {
            FSFormatArguments = "-s";
            FSFormatContentMask = "Apple_HFSX";
            FSFormatExecutable = "newfs_hfs";
            FSFormatMaximumSize = 9223372034707292160;
            FSFormatMinimumSize = 4194304;
            FSMountArguments = "";
            FSMountExecutable = "mount_hfs";
            FSName = "Mac OS Extended (Case-sensitive)";
            FSRepairArguments = "-y";
            FSRepairExecutable = "fsck_hfs";
            FSSubType = 2;
            FSVerificationArguments = "-fn";
            FSVerificationExecutable = "fsck_hfs";
            FSXMLOutputArgument = "-x";
            FSfileObjectsAreCasePreserving = 1;
            FSfileObjectsAreCaseSensitive = 1;
            FSvolumeNameIsCasePreserving = 1;
        };
        "Case-sensitive Journaled HFS+" =         {
            FSCoreStorageEncryptionName = "Mac OS Extended (Case-sensitive, Journaled, Encrypted)";
            FSEncryptionName = "Mac OS Extended (Case-sensitive, Journaled, Encrypted)";
            FSFormatArguments = "-s -J";
            FSFormatContentMask = "Apple_HFSX";
            FSFormatExecutable = "newfs_hfs";
            FSFormatMaximumSize = 9223372034707292160;
            FSFormatMinimumSize = 9437184;
            FSLiveVerificationArguments = "-l";
            FSMountArguments = "";
            FSMountExecutable = "mount_hfs";
            FSName = "Mac OS Extended (Case-sensitive, Journaled)";
            FSRepairArguments = "-fy";
            FSRepairExecutable = "fsck_hfs";
            FSSubType = 3;
            FSVerificationArguments = "-fn";
            FSVerificationExecutable = "fsck_hfs";
            FSXMLOutputArgument = "-x";
            FSfileObjectsAreCasePreserving = 1;
            FSfileObjectsAreCaseSensitive = 1;
            FSvolumeNameIsCasePreserving = 1;
        };
        HFS =         {
            FSMountArguments = "";
            FSMountExecutable = "mount_hfs";
            FSName = "Mac OS Standard";
            FSRepairArguments = "-y";
            FSRepairExecutable = "fsck_hfs";
            FSSubType = 128;
            FSVerificationArguments = "-n";
            FSVerificationExecutable = "fsck_hfs";
            FSXMLOutputArgument = "-x";
            FSfileObjectsAreCasePreserving = 1;
            FSfileObjectsAreCaseSensitive = 0;
            FSvolumeNameIsCasePreserving = 1;
        };
        "HFS+" =         {
            FSFormatArguments = "";
            FSFormatContentMask = "Apple_HFS";
            FSFormatExecutable = "newfs_hfs";
            FSFormatMaximumSize = 9223372034707292160;
            FSFormatMinimumSize = 524288;
            FSMountArguments = "";
            FSMountExecutable = "mount_hfs";
            FSName = "Mac OS Extended";
            FSRepairArguments = "-y";
            FSRepairExecutable = "fsck_hfs";
            FSSubType = 0;
            FSVerificationArguments = "-fn";
            FSVerificationExecutable = "fsck_hfs";
            FSXMLOutputArgument = "-x";
            FSfileObjectsAreCasePreserving = 1;
            FSfileObjectsAreCaseSensitive = 0;
            FSvolumeNameIsCasePreserving = 1;
        };
        "Journaled HFS+" =         {
            FSCoreStorageEncryptionName = "Mac OS Extended (Journaled, Encrypted)";
            FSEncryptionName = "Mac OS Extended (Journaled, Encrypted)";
            FSFormatArguments = "-J";
            FSFormatContentMask = "Apple_HFS";
            FSFormatExecutable = "newfs_hfs";
            FSFormatMaximumSize = 9223372034707292160;
            FSFormatMinimumSize = 9437184;
            FSLiveVerificationArguments = "-l";
            FSMountArguments = "";
            FSMountExecutable = "mount_hfs";
            FSName = "Mac OS Extended (Journaled)";
            FSRepairArguments = "-fy";
            FSRepairExecutable = "fsck_hfs";
            FSSubType = 1;
            FSVerificationArguments = "-fn";
            FSVerificationExecutable = "fsck_hfs";
            FSXMLOutputArgument = "-x";
            FSfileObjectsAreCasePreserving = 1;
            FSfileObjectsAreCaseSensitive = 0;
            FSvolumeNameIsCasePreserving = 1;
        };
    };
    MinimumOSVersion = "11.3";
    UIDeviceFamily =     (
        1
    );
    UIRequiredDeviceCapabilities =     (
        arm64
    );
}
