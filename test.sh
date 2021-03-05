#!/usr/bin/env bash
for i in  {10..15};
do
python test-reentrancy_symbolic.py ../smartcontract/example$i.sol;
done
