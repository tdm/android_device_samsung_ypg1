#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#define BML_UNLOCK_ALL	0x8A29	///< unlock all partition RO -> RW
#define BML_BLOCK_SIZE  4096

int
bml_unlock(const char* dev)
{
    int fd;
    int rc;
    fd = open(dev, O_RDWR | O_LARGEFILE);
    if (fd < 0) {
        return -1;
    }
    rc = ioctl(fd, BML_UNLOCK_ALL, 0);
    close(fd);
    return rc;
}

int
bml_write(const char* dev, const char* img)
{
    int rc = -1;
    int ifd = -1;
    int ofd = -1;
    struct stat st;
    ssize_t nr, nw;
    size_t tr, tw;
    char buf[BML_BLOCK_SIZE];

    rc = stat(img, &st);
    if (rc != 0) {
        goto error;
    }
    if (!S_ISREG(st.st_mode)) {
        rc = -1;
        goto error;
    }

    printf("Writing image %s to device %s (%d bytes) ...\n",
            img, dev, st.st_mode);

    ifd = open(img, O_RDONLY);
    if (ifd < 0) {
        fprintf(stderr, "Cannot open %s: %s\n", img, strerror(errno));
        rc = -1;
        goto error;
    }
    ofd = open(dev, O_RDWR | O_LARGEFILE);
    if (ofd < 0) {
        fprintf(stderr, "Cannot open %s: %s\n", dev, strerror(errno));
        rc = -1;
        goto error;
    }

    tr = tw = 0;
    do {
        nr = read(ifd, buf, BML_BLOCK_SIZE);
        if (nr < 0) {
            fprintf(stderr, "read failed: %s\n", strerror(errno));
            rc = -1;
            goto error;
        }
        if (nr != BML_BLOCK_SIZE && tr+nr != st.st_size) {
            rc = -1;
            goto error;
        }
        if (nr < BML_BLOCK_SIZE) {
            memset(buf+nr, 0, BML_BLOCK_SIZE-nr);
        }
        tr += nr;

        nw = write(ofd, buf, BML_BLOCK_SIZE);
        if (nw < 0) {
            fprintf(stderr, "write failed: %s\n", strerror(errno));
            rc = -1;
            goto error;
        }
        if (nw != BML_BLOCK_SIZE) {
            fprintf(stderr, "short write\n");
            rc = -1;
            goto error;
        }
        tw += nw;
    }
    while (tw < st.st_size);

    printf("... success!\n");
    rc = 0;

error:
    fsync(ofd);
    close(ofd);
    close(ifd);
    return rc;
}

int
main(int argc, char** argv)
{
    const char* img;
    const char* dev;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <kernel> <bmldev>\n", argv[0]);
        exit(1);
    }
    img = argv[1];
    dev = argv[2];

    if (bml_unlock(dev) != 0) {
        fprintf(stderr, "Cannot unlock bml device %s\n", dev);
        exit(1);
    }
    if (bml_write(dev, img) != 0) {
        fprintf(stderr, "Cannot write kernel\n");
        exit(1);
    }
    return 0;
}
