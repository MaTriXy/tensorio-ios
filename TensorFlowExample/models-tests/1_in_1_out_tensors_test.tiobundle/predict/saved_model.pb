�
��
:
Add
x"T
y"T
z"T"
Ttype:
2	
h
ConcatV2
values"T*N
axis"Tidx
output"T"
Nint(0"	
Ttype"
Tidxtype0:
2	
8
Const
output"dtype"
valuetensor"
dtypetype
W

ExpandDims

input"T
dim"Tdim
output"T"	
Ttype"
Tdimtype0:
2	

NoOp
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
�
StridedSlice

input"T
begin"Index
end"Index
strides"Index
output"T"	
Ttype"
Indextype:
2	"

begin_maskint "
end_maskint "
ellipsis_maskint "
new_axis_maskint "
shrink_axis_maskint "serve*1.13.12
b'unknown'�
^
inputPlaceholder*
dtype0*"
_output_shapes
:*
shape:
h
strided_slice/stackConst*
dtype0*
_output_shapes
:*!
valueB"            
j
strided_slice/stack_1Const*!
valueB"           *
dtype0*
_output_shapes
:
j
strided_slice/stack_2Const*!
valueB"         *
dtype0*
_output_shapes
:
�
strided_sliceStridedSliceinputstrided_slice/stackstrided_slice/stack_1strided_slice/stack_2*
end_mask*
_output_shapes

:*
T0*
Index0*
shrink_axis_mask*
ellipsis_mask *

begin_mask*
new_axis_mask 
J
Add/yConst*
valueB
 *  �?*
dtype0*
_output_shapes
: 
I
AddAddstrided_sliceAdd/y*
T0*
_output_shapes

:
j
strided_slice_1/stackConst*!
valueB"           *
dtype0*
_output_shapes
:
l
strided_slice_1/stack_1Const*!
valueB"           *
dtype0*
_output_shapes
:
l
strided_slice_1/stack_2Const*!
valueB"         *
dtype0*
_output_shapes
:
�
strided_slice_1StridedSliceinputstrided_slice_1/stackstrided_slice_1/stack_1strided_slice_1/stack_2*
T0*
Index0*
shrink_axis_mask*

begin_mask*
ellipsis_mask *
new_axis_mask *
end_mask*
_output_shapes

:
L
Add_1/yConst*
dtype0*
_output_shapes
: *
valueB
 *   @
O
Add_1Addstrided_slice_1Add_1/y*
T0*
_output_shapes

:
j
strided_slice_2/stackConst*!
valueB"           *
dtype0*
_output_shapes
:
l
strided_slice_2/stack_1Const*!
valueB"           *
dtype0*
_output_shapes
:
l
strided_slice_2/stack_2Const*
dtype0*
_output_shapes
:*!
valueB"         
�
strided_slice_2StridedSliceinputstrided_slice_2/stackstrided_slice_2/stack_1strided_slice_2/stack_2*
T0*
Index0*
shrink_axis_mask*
ellipsis_mask *

begin_mask*
new_axis_mask *
end_mask*
_output_shapes

:
L
Add_2/yConst*
valueB
 *  @@*
dtype0*
_output_shapes
: 
O
Add_2Addstrided_slice_2Add_2/y*
T0*
_output_shapes

:
P
ExpandDims/dimConst*
value	B : *
dtype0*
_output_shapes
: 
f

ExpandDims
ExpandDimsAddExpandDims/dim*

Tdim0*
T0*"
_output_shapes
:
R
ExpandDims_1/dimConst*
value	B : *
dtype0*
_output_shapes
: 
l
ExpandDims_1
ExpandDimsAdd_1ExpandDims_1/dim*

Tdim0*
T0*"
_output_shapes
:
R
ExpandDims_2/dimConst*
value	B : *
dtype0*
_output_shapes
: 
l
ExpandDims_2
ExpandDimsAdd_2ExpandDims_2/dim*

Tdim0*
T0*"
_output_shapes
:
M
output/axisConst*
value	B : *
dtype0*
_output_shapes
: 
�
outputConcatV2
ExpandDimsExpandDims_1ExpandDims_2output/axis*
T0*
N*"
_output_shapes
:*

Tidx0

initNoOp "*y
serving_defaultf
"
input
input:0$
output
output:0tensorflow/serving/predict