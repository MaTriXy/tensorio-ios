
W
input1Placeholder*
shape
:*
dtype0*
_output_shapes

:
W
input2Placeholder*
dtype0*
_output_shapes

:*
shape
:
B
wConst*)
value B"  �?      �?    *
dtype0
T
w/readIdentityw*
T0*
_class

loc:@w*
_output_shapes

:
B
bConst*)
value B"      �?      �?*
dtype0
T
b/readIdentityb*
T0*
_class

loc:@b*
_output_shapes

:
_
transpose/permConst*
dtype0*
_output_shapes
:*
valueB"       
d
	transpose	Transposew/readtranspose/perm*
_output_shapes

:*
Tperm0*
T0
r
MatMulMatMulinput1	transpose*
T0*
transpose_a( *
_output_shapes

:*
transpose_b( 
a
transpose_1/permConst*
valueB"       *
dtype0*
_output_shapes
:
h
transpose_1	Transposeb/readtranspose_1/perm*
T0*
_output_shapes

:*
Tperm0
v
MatMul_1MatMulinput2transpose_1*
T0*
transpose_a( *
_output_shapes

:*
transpose_b( 
I
output1MulMatMulMatMul_1*
T0*
_output_shapes

:
I
output2AddMatMulMatMul_1*
T0*
_output_shapes

: 