#!/usr/bin/env bash

cd domain && dart test -r expanded && cd ..
cd application && dart test -r expanded && cd ..
cd adapters-inbound/rest && dart test -r expanded && cd ../..
# cd adapters-outbound/persistence && dart test -r expanded && cd ../..
cd main && dart test -r expanded && cd ..
