//
//  MYHelper.m
//  MYTongDunTest
//
//  Created by apple on 2021/10/19.
//

#import "MYHelper.h"
@implementation MYHelper
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager=[[self alloc] init];
    });
    return _manager;
}
-(void)makestatTozero:(struct stat) buf{

    buf.st_dev =0;
    buf.st_mode =0;
    buf.st_nlink =0;
    buf.st_ino =0;
    
    
    buf.st_gid =0;
    buf.st_rdev =0;
    buf.st_atimespec.tv_sec =0;
    buf.st_mtimespec.tv_sec =0;

    buf.st_ctimespec.tv_sec =0;
    buf.st_birthtimespec.tv_sec =0;
    buf.st_mtimespec.tv_nsec =0;
    buf.st_atimespec.tv_nsec =0;

    buf.st_ctimespec.tv_nsec =0;
    buf.st_birthtimespec.tv_nsec =0;
    buf.st_gen =0;
    buf.st_size =0;

    buf.st_flags =0;
    buf.st_blocks =0;
    buf.st_blksize =0;
}

//struct statfs {
//    short   f_otype;                /* TEMPORARY SHADOW COPY OF f_type */
//    short   f_oflags;               /* TEMPORARY SHADOW COPY OF f_flags */
//    long    f_bsize;                /* fundamental file system block size */
//    long    f_iosize;               /* optimal transfer block size */
//    long    f_blocks;               /* total data blocks in file system */
//    long    f_bfree;                /* free blocks in fs */
//    long    f_bavail;               /* free blocks avail to non-superuser */
//    long    f_files;                /* total file nodes in file system */
//    long    f_ffree;                /* free file nodes in fs */
//    fsid_t  f_fsid;                 /* file system id */
//    uid_t   f_owner;                /* user that mounted the filesystem */
//    short   f_reserved1;    /* spare for later */
//    short   f_type;                 /* type of filesystem */
//    long    f_flags;                /* copy of mount exported flags */
//    long    f_reserved2[2]; /* reserved for future use */
//    char    f_fstypename[MFSNAMELEN]; /* fs type name */
//    char    f_mntonname[MNAMELEN];  /* directory on which mounted */
//    char    f_mntfromname[MNAMELEN];/* mounted filesystem */
//    char    f_reserved3;    /* For alignment */
//    long    f_reserved4[4]; /* For future use */
//};
-(NSString *)fstatfsresultWith:(struct statfs *)buf{
    NSString *f_bsize= [NSString stringWithFormat:@"f_bsize=ld",buf->f_bsize];
    NSString *f_iosize= [NSString stringWithFormat:@"f_iosize=ld",buf->f_iosize];
    NSString *f_blocks= [NSString stringWithFormat:@"f_blocks=ld",buf->f_blocks];
    NSString *st_dev= [NSString stringWithFormat:@"f_bsize=ld",buf->f_bsize];
    NSString *f_bfree= [NSString stringWithFormat:@"f_bfree=ld",buf->f_bfree];
    NSString *f_bavail= [NSString stringWithFormat:@"f_bavail=ld",buf->f_bavail];
    NSString *f_fstypename= [NSString stringWithFormat:@"f_fstypename=%s",buf->f_fstypename];
    NSString *f_mntonname= [NSString stringWithFormat:@"f_mntonname=%s",buf->f_mntonname];
    NSString *f_mntfromname= [NSString stringWithFormat:@"f_mntfromname=%s",buf->f_mntfromname];

    NSString *result = [NSString stringWithFormat:@"-%@ -%@ -%@ %@ -%@ %@ -%@ -%@ -%@",f_bsize,f_iosize,f_blocks,st_dev,f_bfree,f_bavail,f_fstypename,f_mntonname,f_mntfromname];
    
    return result;
}


-(NSString *)lstatresultWith:(struct stat) buf{
    NSString        *msg;
    if ( S_ISREG(buf.st_mode) )
    {
        msg=@"regular";
    }
    else if ( S_ISDIR(buf.st_mode) )
    {
        msg=@"directory";
    }
    else if ( S_ISCHR(buf.st_mode) )
    {
        msg=@"character special";
    }
    else if ( S_ISBLK(buf.st_mode) )
    {
        msg=@"block special";
    }
    else if ( S_ISFIFO(buf.st_mode) )
    {
        msg=@"fifo";
    }
    else if ( S_ISLNK(buf.st_mode) )
    {
        msg=@"symbolic link";
    }
    else if ( S_ISSOCK(buf.st_mode) )
    {
        msg=@"socket";
    }
    else
    {
        msg=@" ** unknown mode";
    }

    //    buf.st_dev=16777219;
    //    buf.st_mode=33188;
    //    buf.st_nlink=1;
    //    buf.st_ino=25823;
    //    buf.st_uid=501;
    //    buf.st_gid=0;
    //    buf.st_rdev=0;
    //    buf.st_atimespec.tv_sec=1634196789;
    //    buf.st_mtimespec.tv_sec=1634196789;
    //    buf.st_ctimespec.tv_sec=1634196789;
    //    buf.st_birthtimespec.tv_sec=1634196789;
    //    buf.st_mtimespec.tv_nsec=71388586;
    //    buf.st_atimespec.tv_nsec=506670984;
    //    buf.st_ctimespec.tv_nsec=562604728;
    //    buf.st_birthtimespec.tv_nsec=71388586;
    //    buf.st_gen=0;
    //    buf.st_size=54948;
    //    buf.st_flags=0;
    //    buf.st_blocks=112;
    //    buf.st_blksize=4194304;
    
    NSString *st_dev= [NSString stringWithFormat:@"st_dev=%d",buf.st_dev];
    NSString *st_mode= [NSString stringWithFormat:@"st_mode=%d",buf.st_mode];
    NSString *st_nlink= [NSString stringWithFormat:@"st_nlink=%d",buf.st_nlink];
    NSString *st_ino= [NSString stringWithFormat:@"st_ino=%lld",buf.st_ino];
    
    NSString *st_gid= [NSString stringWithFormat:@"st_gid=%d",buf.st_gid];
    NSString *st_rdev= [NSString stringWithFormat:@"st_rdev=%d",buf.st_rdev];
    NSString *st_atimespec_tv_sec= [NSString stringWithFormat:@"st_atimespec_tv_sec=%ld",buf.st_atimespec.tv_sec];
    NSString *st_mtimespec_tv_sec= [NSString stringWithFormat:@"st_mtimespec_tv_sec=%ld",buf.st_mtimespec.tv_sec];
    
    NSString *st_ctimespec_tv_sec= [NSString stringWithFormat:@"st_ctimespec_tv_sec=%ld",buf.st_ctimespec.tv_sec];
    NSString *st_birthtimespec_tv_sec= [NSString stringWithFormat:@"st_birthtimespec_tv_sec=%ld",buf.st_birthtimespec.tv_sec];
    NSString *st_mtimespec_tv_nsec= [NSString stringWithFormat:@"st_mtimespec_tv_nsec=%ld",buf.st_mtimespec.tv_nsec];
    NSString *st_atimespec_tv_nsec= [NSString stringWithFormat:@"st_atimespec_tv_nsec=%ld",buf.st_atimespec.tv_nsec];
    
    NSString *st_ctimespec_tv_nsec= [NSString stringWithFormat:@"st_ctimespec_tv_nsec=%ld",buf.st_ctimespec.tv_nsec];
    NSString *st_birthtimespec_tv_nsec= [NSString stringWithFormat:@"st_birthtimespec_tv_nsec=%ld",buf.st_birthtimespec.tv_nsec];
        NSString *st_gen= [NSString stringWithFormat:@"st_gen=%d",buf.st_gen];
    NSString *st_size= [NSString stringWithFormat:@"st_size=%lld",buf.st_size];
    
    NSString *st_flags= [NSString stringWithFormat:@"st_flags=%d",buf.st_flags];
    NSString *st_blocks= [NSString stringWithFormat:@"st_blocks=%lld",buf.st_blocks];
    NSString *st_blksize= [NSString stringWithFormat:@"st_blksize=%d",buf.st_blksize];

   NSString *result=  [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ -%@ - %@ - %@ - %@- %@ -%@ - %@",st_dev,st_mode,st_nlink,st_ino,
                       st_gid,st_rdev,st_atimespec_tv_sec,st_mtimespec_tv_sec,
                       st_ctimespec_tv_sec,st_birthtimespec_tv_sec,st_mtimespec_tv_nsec,st_atimespec_tv_nsec,
                       st_ctimespec_tv_nsec,st_birthtimespec_tv_nsec,st_gen,st_size,
                       st_flags,st_flags,st_blocks,st_blksize];
    return result;
}


//-(NSString *)statfsresultWith:(struct statfs) buf{
//    NSString *f_otype = [NSString stringWithFormat:@"f_otype=%d",buf.f_otype];
//
//
//    short   f_otype;                /* TEMPORARY SHADOW COPY OF f_type */
//    short   f_oflags;               /* TEMPORARY SHADOW COPY OF f_flags */
//    long    f_bsize;                /* fundamental file system block size */
//    long    f_iosize;               /* optimal transfer block size */
//    long    f_blocks;               /* total data blocks in file system */
//    long    f_bfree;                /* free blocks in fs */
//    long    f_bavail;               /* free blocks avail to non-superuser */
//    long    f_files;                /* total file nodes in file system */
//    long    f_ffree;                /* free file nodes in fs */
//    fsid_t  f_fsid;                 /* file system id */
//    uid_t   f_owner;                /* user that mounted the filesystem */
//    short   f_reserved1;    /* spare for later */
//    short   f_type;                 /* type of filesystem */
//    long    f_flags;                /* copy of mount exported flags */
//    long    f_reserved2[2]; /* reserved for future use */
//    char    f_fstypename[MFSNAMELEN]; /* fs type name */
//    char    f_mntonname[MNAMELEN];  /* directory on which mounted */
//    char    f_mntfromname[MNAMELEN];/* mounted filesystem */
//    char    f_reserved3;    /* For alignment */
//    long    f_reserved4[4]; /* For future use */
//
//
//    return @"";
//}

-(NSString *)opendirresultWith:(struct dirent * ) buf{

    NSString *d_ino = [NSString stringWithFormat:@"d_ino=%llu",buf->d_ino];
    NSString *d_seekoff = [NSString stringWithFormat:@"d_seekoff=%llu",buf->d_seekoff];
    NSString *d_reclen = [NSString stringWithFormat:@"d_reclen=%hu",buf->d_reclen];
    NSString *d_namlen = [NSString stringWithFormat:@"d_namlen=%hu",buf->d_namlen];
    NSString *d_type = [NSString stringWithFormat:@"d_type=%hu",buf->d_type];
    NSString *d_name = [NSString stringWithFormat:@"d_name=%s",buf->d_name];

    NSString *result=  [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@ - %@ ",d_ino,d_seekoff,d_reclen,d_namlen,d_type,d_name];
    

    return result;
      
}

@end
