#! /usr/bin/env python3

from dataclasses import dataclass
from typing import Callable
import numpy as np


@dataclass
class Op:
    name: str
    signed: bool
    is_cond: int
    code: int
    compute: Callable


XLEN = 32

UINT_MAX = np.iinfo(np.uint32).max
INT_MIN = np.iinfo(np.uint32).min
INT_MAX = np.iinfo(np.int32).max

# mask for shift amount value to correctly generate
# expected result in shift ops
SHIFT_MASK = 0x1F

ops = [
    Op("add", False, 0, 0b0000, lambda x, y: x + y),
    Op("sub", False, 0, 0b1000, lambda x, y: x - y),
    Op("sll", False, 0, 0b0001, lambda x, y: x << (y & SHIFT_MASK)),
    Op("slt", True, 0, 0b0010, lambda x, y: 1 if x < y else 0),
    Op("sltu", False, 0, 0b0011, lambda x, y: 1 if x < y else 0),
    Op("xor", False, 0, 0b0100, lambda x, y: x ^ y),
    Op("srl", False, 0, 0b0101, lambda x, y: x >> (y & SHIFT_MASK)),
    Op("sra", True, 0, 0b1101, lambda x, y: x >> (y & SHIFT_MASK)),
    Op("or", False, 0, 0b0110, lambda x, y: x | y),
    Op("and", False, 0, 0b0111, lambda x, y: x & y),
    Op("eq", False, 1, 0b0000, lambda x, y: 1 if x == y else 0),
    Op("ne", False, 1, 0b0001, lambda x, y: 1 if x != y else 0),
    Op("lt", True, 1, 0b0100, lambda x, y: 1 if x < y else 0),
    Op("ge", True, 1, 0b0101, lambda x, y: 1 if x >= y else 0),
    Op("ltu", False, 1, 0b0110, lambda x, y: 1 if x < y else 0),
    Op("geu", False, 1, 0b0111, lambda x, y: 1 if x >= y else 0),
]

BASE_SIGNED = [0, 1, -1, INT_MAX, INT_MIN, 1 << (XLEN - 2), 34]
BASE_UNSIGNED = [0, 1, UINT_MAX, 1 << (XLEN - 1), 34]

EXTRA1 = [23425, -8234234, 42, 800815, -92342]
EXTRA2 = [9214342, -1111, 987631, 2222, -3210]

# get rid of overflow warnings
np.seterr(over="ignore")


def generate(cls, nums1, nums2, op):
    for op1 in nums1:
        for op2 in nums2:
            _op1 = cls(op1)
            _op2 = cls(op2)
            expected = op(_op1, _op2)
            print(f"{np.binary_repr(_op1,XLEN)},{np.binary_repr(_op2,XLEN)},{np.binary_repr(expected,XLEN)}")


for op in ops:
    print(f"!,{op.is_cond},{op.code},{op.name}")
    if op.signed:
        kls = np.int32
        nums1 = BASE_SIGNED + EXTRA1
        nums2 = BASE_SIGNED + EXTRA2
    else:
        kls = np.uint32
        nums1 = BASE_UNSIGNED + [abs(x) for x in EXTRA1]
        nums2 = BASE_UNSIGNED + [abs(x) for x in EXTRA2]

    generate(kls, nums1, nums2, op.compute)
