#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <iostream>

#include <foo/bar/t1.pb.h>

using namespace std;

using namespace foo::bar;


int main(int argc, char **argv)
{
    auto m1 = new M1();
    m1->set_s1("aaa");
    m1->set_i1(5);

    int fd = 1;

    if (argc == 2) {
        fd = open(argv[1], O_WRONLY);
        if (fd < 0) {
            cerr << strerror(errno);
            exit(-1);
        }
    }

    m1->SerializeToFileDescriptor(fd);

    delete m1;
}
