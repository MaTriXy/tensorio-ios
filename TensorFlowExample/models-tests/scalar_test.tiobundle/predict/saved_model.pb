Å8
Õ	ª	
:
Add
x"T
y"T
z"T"
Ttype:
2	
x
Assign
ref"T

value"T

output_ref"T"	
Ttype"
validate_shapebool("
use_lockingbool(
8
Const
output"dtype"
valuetensor"
dtypetype
.
Identity

input"T
output"T"	
Ttype
e
MergeV2Checkpoints
checkpoint_prefixes
destination_prefix"
delete_old_dirsbool(
=
Mul
x"T
y"T
z"T"
Ttype:
2	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
X
PlaceholderWithDefault
input"dtype
output"dtype"
dtypetype"
shapeshape
o
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
H
ShardedFilename
basename	
shard

num_shards
filename
N

StringJoin
inputs*N

output"
Nint(0"
	separatorstring 
s

VariableV2
ref"dtype"
shapeshape"
dtypetype"
	containerstring "
shared_namestring "serve*1.15.52v1.15.4-39-g3db52be7be8²+
F
inputPlaceholder*
dtype0*
shape: *
_output_shapes
: 
F
wConst*
dtype0*
_output_shapes
: *
valueB
 *   A
F
bConst*
_output_shapes
: *
valueB
 *   @*
dtype0
5
MulMulinputw*
_output_shapes
: *
T0
6
outputAddMulb*
T0*
_output_shapes
: 

initNoOp
H
input_1Placeholder*
_output_shapes
: *
dtype0*
shape: 
V
w_1/initial_valueConst*
dtype0*
valueB
 *   A*
_output_shapes
: 
g
w_1
VariableV2*
shape: *
dtype0*
shared_name *
	container *
_output_shapes
: 


w_1/AssignAssignw_1w_1/initial_value*
_output_shapes
: *
_class

loc:@w_1*
T0*
use_locking(*
validate_shape(
R
w_1/readIdentityw_1*
_class

loc:@w_1*
_output_shapes
: *
T0
V
b_1/initial_valueConst*
_output_shapes
: *
dtype0*
valueB
 *   @
g
b_1
VariableV2*
shape: *
shared_name *
	container *
dtype0*
_output_shapes
: 


b_1/AssignAssignb_1b_1/initial_value*
_class

loc:@b_1*
validate_shape(*
T0*
_output_shapes
: *
use_locking(
R
b_1/readIdentityb_1*
_class

loc:@b_1*
T0*
_output_shapes
: 
@
Mul_1Mulinput_1w_1/read*
T0*
_output_shapes
: 
A
output_1AddMul_1b_1/read*
_output_shapes
: *
T0
(
init_1NoOp^b_1/Assign^w_1/Assign
Y
save/filename/inputConst*
valueB Bmodel*
dtype0*
_output_shapes
: 
n
save/filenamePlaceholderWithDefaultsave/filename/input*
shape: *
dtype0*
_output_shapes
: 
e

save/ConstPlaceholderWithDefaultsave/filename*
shape: *
_output_shapes
: *
dtype0
i
save/SaveV2/tensor_namesConst*
_output_shapes
:*
valueBBb_1Bw_1*
dtype0
g
save/SaveV2/shape_and_slicesConst*
dtype0*
valueBB B *
_output_shapes
:
u
save/SaveV2SaveV2
save/Constsave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesb_1w_1*
dtypes
2
}
save/control_dependencyIdentity
save/Const^save/SaveV2*
T0*
_output_shapes
: *
_class
loc:@save/Const
l
save/RestoreV2/tensor_namesConst*
_output_shapes
:*
dtype0*
valueBBb_1Bw_1
j
save/RestoreV2/shape_and_slicesConst*
_output_shapes
:*
dtype0*
valueBB B 

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices*
dtypes
2*
_output_shapes

::

save/AssignAssignb_1save/RestoreV2*
_class

loc:@b_1*
use_locking(*
T0*
validate_shape(*
_output_shapes
: 

save/Assign_1Assignw_1save/RestoreV2:1*
validate_shape(*
_class

loc:@w_1*
use_locking(*
T0*
_output_shapes
: 
6
save/restore_allNoOp^save/Assign^save/Assign_1
[
save_1/filename/inputConst*
dtype0*
_output_shapes
: *
valueB Bmodel
r
save_1/filenamePlaceholderWithDefaultsave_1/filename/input*
_output_shapes
: *
shape: *
dtype0
i
save_1/ConstPlaceholderWithDefaultsave_1/filename*
_output_shapes
: *
shape: *
dtype0

save_1/StringJoin/inputs_1Const*
dtype0*
_output_shapes
: *<
value3B1 B+_temp_f9dc445e278846ec9ac72b527c7aeb7b/part
{
save_1/StringJoin
StringJoinsave_1/Constsave_1/StringJoin/inputs_1*
N*
_output_shapes
: *
	separator 
S
save_1/num_shardsConst*
dtype0*
value	B :*
_output_shapes
: 
^
save_1/ShardedFilename/shardConst*
value	B : *
dtype0*
_output_shapes
: 

save_1/ShardedFilenameShardedFilenamesave_1/StringJoinsave_1/ShardedFilename/shardsave_1/num_shards*
_output_shapes
: 
k
save_1/SaveV2/tensor_namesConst*
_output_shapes
:*
valueBBb_1Bw_1*
dtype0
i
save_1/SaveV2/shape_and_slicesConst*
valueBB B *
_output_shapes
:*
dtype0

save_1/SaveV2SaveV2save_1/ShardedFilenamesave_1/SaveV2/tensor_namessave_1/SaveV2/shape_and_slicesb_1w_1*
dtypes
2

save_1/control_dependencyIdentitysave_1/ShardedFilename^save_1/SaveV2*
T0*)
_class
loc:@save_1/ShardedFilename*
_output_shapes
: 
£
-save_1/MergeV2Checkpoints/checkpoint_prefixesPacksave_1/ShardedFilename^save_1/control_dependency*

axis *
_output_shapes
:*
N*
T0

save_1/MergeV2CheckpointsMergeV2Checkpoints-save_1/MergeV2Checkpoints/checkpoint_prefixessave_1/Const*
delete_old_dirs(

save_1/IdentityIdentitysave_1/Const^save_1/MergeV2Checkpoints^save_1/control_dependency*
T0*
_output_shapes
: 
n
save_1/RestoreV2/tensor_namesConst*
valueBBb_1Bw_1*
dtype0*
_output_shapes
:
l
!save_1/RestoreV2/shape_and_slicesConst*
valueBB B *
_output_shapes
:*
dtype0

save_1/RestoreV2	RestoreV2save_1/Constsave_1/RestoreV2/tensor_names!save_1/RestoreV2/shape_and_slices*
dtypes
2*
_output_shapes

::

save_1/AssignAssignb_1save_1/RestoreV2*
validate_shape(*
_class

loc:@b_1*
_output_shapes
: *
use_locking(*
T0

save_1/Assign_1Assignw_1save_1/RestoreV2:1*
validate_shape(*
use_locking(*
_class

loc:@w_1*
T0*
_output_shapes
: 
>
save_1/restore_shardNoOp^save_1/Assign^save_1/Assign_1
1
save_1/restore_allNoOp^save_1/restore_shard "B
save_1/Const:0save_1/Identity:0save_1/restore_all (5 @F8"
	variablesrp
6
w_1:0
w_1/Assign
w_1/read:02w_1/initial_value:08
6
b_1:0
b_1/Assign
b_1/read:02b_1/initial_value:08"
trainable_variablesrp
6
w_1:0
w_1/Assign
w_1/read:02w_1/initial_value:08
6
b_1:0
b_1/Assign
b_1/read:02b_1/initial_value:08*e
serving_defaultR

input
	input_1:0 
output

output_1:0 tensorflow/serving/predict