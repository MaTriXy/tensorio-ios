
W
input1Placeholder*
dtype0*
_output_shapes

:*
shape
:
W
input2Placeholder*
shape
:*
dtype0*
_output_shapes

:
r
WConst*Y
valuePBN"@  �?      �?          �?      �?  �?      �?          �?      �?*
dtype0
T
W/readIdentityW*
T0*
_class

loc:@W*
_output_shapes

:
r
BConst*Y
valuePBN"@      �?      �?  �?      �?          �?      �?  �?      �?    *
dtype0
T
B/readIdentityB*
_output_shapes

:*
T0*
_class

loc:@B
_
transpose/permConst*
dtype0*
_output_shapes
:*
valueB"       
d
	transpose	TransposeW/readtranspose/perm*
Tperm0*
T0*
_output_shapes

:
r
MatMulMatMulinput1	transpose*
T0*
transpose_a( *
_output_shapes

:*
transpose_b( 
a
transpose_1/permConst*
valueB"       *
dtype0*
_output_shapes
:
h
transpose_1	TransposeB/readtranspose_1/perm*
_output_shapes

:*
Tperm0*
T0
v
MatMul_1MatMulinput2transpose_1*
T0*
transpose_a( *
_output_shapes

:*
transpose_b( 
I
output1MulMatMulMatMul_1*
T0*
_output_shapes

:
I
output2AddMatMulMatMul_1*
T0*
_output_shapes

: 