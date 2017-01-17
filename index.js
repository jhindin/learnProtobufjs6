#!/usr/bin/env node

var protobufjs = require('protobufjs');

protobuf.load("proto/foo/bar/t1.proto", function(err,root) {
    if (err) throw err;

    console.log("Loaded t1.proto");
});
