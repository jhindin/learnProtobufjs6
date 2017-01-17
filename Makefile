all : writeM1


CXX_BINDING_DIR=cxx
PROTOC=`pkg-config --variable=prefix protobuf`/bin/protoc
PROTO_CXXFLAGS=`pkg-config --cflags protobuf`
PROTO_SRC_DIR=proto
CXXFLAGS=${PROTO_CXXFLAGS} -I${CXX_BINDING_DIR} -std=c++14 -fPIC -MMD -Wall -Werror
OBJDIR=obj


PROTO_FILES = foo/bar/t1.proto

SRC_H_FILES=${PROTO_FILES:.proto=.pb.h}
H_FILES=${addprefix ${CXX_BINDING_DIR}/, ${SRC_H_FILES}}

OBJ_FILES=${addprefix ${OBJDIR}/, ${PROTO_FILES:.proto=.pb.o}}
DEP_FILES=${addprefix ${OBJDIR}/, ${PROTO_FILES:.proto=.pb.d}}

LDLIBS=`pkg-config --libs protobuf`

${CXX_BINDING_DIR}/%.pb.cc ${CXX_BINDING_DIR}/%.pb.h : ${PROTO_SRC_DIR}/%.proto | ${CXX_BINDING_DIR}
	${PROTOC} --proto_path=${PROTO_SRC_DIR} --cpp_out=${CXX_BINDING_DIR} -I. $<


${OBJDIR}/%.o: ${CXX_BINDING_DIR}/%.cc
	@mkdir -p ${dir $@}
	${CXX} -c -o $@ $^ ${CXXFLAGS}



${OBJDIR}/%.o: %.cc | ${H_FILES}
	@mkdir -p ${dir $@}
	${CXX} -c -o $@ $^ ${CXXFLAGS}

${CXX_BINDING_DIR}:
	mkdir $@

writeM1: ${OBJDIR}/writeM1.o ${OBJ_FILES}
	${CXX} -o $@ $^ ${LDLIBS}


DEP_FILES := writeM1.d

clean:
	rm -rf obj cxx writeM1

.PRECIOUS: ${H_FILES}

-include ${DEP_FILES}
