õ4
È	ª	
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
shared_namestring "serve*1.13.12
b'unknown'(
N
inputPlaceholder*
dtype0*
_output_shapes
:*
shape:
T
w/initial_valueConst*
dtype0*
_output_shapes
: *
valueB
 *   A
e
w
VariableV2*
dtype0*
_output_shapes
: *
	container *
shape: *
shared_name 

w/AssignAssignww/initial_value*
T0*
_class

loc:@w*
validate_shape(*
_output_shapes
: *
use_locking(
L
w/readIdentityw*
T0*
_class

loc:@w*
_output_shapes
: 
T
b/initial_valueConst*
valueB
 *   @*
dtype0*
_output_shapes
: 
e
b
VariableV2*
shared_name *
dtype0*
_output_shapes
: *
	container *
shape: 

b/AssignAssignbb/initial_value*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class

loc:@b
L
b/readIdentityb*
T0*
_class

loc:@b*
_output_shapes
: 
>
MulMulinputw/read*
T0*
_output_shapes
:
?
outputAddMulb/read*
T0*
_output_shapes
:
"
initNoOp	^b/Assign	^w/Assign
Y
save/filename/inputConst*
dtype0*
_output_shapes
: *
valueB Bmodel
n
save/filenamePlaceholderWithDefaultsave/filename/input*
dtype0*
_output_shapes
: *
shape: 
e

save/ConstPlaceholderWithDefaultsave/filename*
dtype0*
_output_shapes
: *
shape: 
e
save/SaveV2/tensor_namesConst*
valueBBbBw*
dtype0*
_output_shapes
:
g
save/SaveV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:
q
save/SaveV2SaveV2
save/Constsave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesbw*
dtypes
2
}
save/control_dependencyIdentity
save/Const^save/SaveV2*
T0*
_class
loc:@save/Const*
_output_shapes
: 
h
save/RestoreV2/tensor_namesConst*
valueBBbBw*
dtype0*
_output_shapes
:
j
save/RestoreV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices*
_output_shapes

::*
dtypes
2

save/AssignAssignbsave/RestoreV2*
use_locking(*
T0*
_class

loc:@b*
validate_shape(*
_output_shapes
: 

save/Assign_1Assignwsave/RestoreV2:1*
use_locking(*
T0*
_class

loc:@w*
validate_shape(*
_output_shapes
: 
6
save/restore_allNoOp^save/Assign^save/Assign_1
[
save_1/filename/inputConst*
valueB Bmodel*
dtype0*
_output_shapes
: 
r
save_1/filenamePlaceholderWithDefaultsave_1/filename/input*
dtype0*
_output_shapes
: *
shape: 
i
save_1/ConstPlaceholderWithDefaultsave_1/filename*
dtype0*
_output_shapes
: *
shape: 

save_1/StringJoin/inputs_1Const*
dtype0*
_output_shapes
: *<
value3B1 B+_temp_c62ea68d9caf44d081e5c1cc18e393d6/part
{
save_1/StringJoin
StringJoinsave_1/Constsave_1/StringJoin/inputs_1*
	separator *
N*
_output_shapes
: 
S
save_1/num_shardsConst*
value	B :*
dtype0*
_output_shapes
: 
^
save_1/ShardedFilename/shardConst*
dtype0*
_output_shapes
: *
value	B : 

save_1/ShardedFilenameShardedFilenamesave_1/StringJoinsave_1/ShardedFilename/shardsave_1/num_shards*
_output_shapes
: 
g
save_1/SaveV2/tensor_namesConst*
dtype0*
_output_shapes
:*
valueBBbBw
i
save_1/SaveV2/shape_and_slicesConst*
dtype0*
_output_shapes
:*
valueBB B 

save_1/SaveV2SaveV2save_1/ShardedFilenamesave_1/SaveV2/tensor_namessave_1/SaveV2/shape_and_slicesbw*
dtypes
2

save_1/control_dependencyIdentitysave_1/ShardedFilename^save_1/SaveV2*
_output_shapes
: *
T0*)
_class
loc:@save_1/ShardedFilename
£
-save_1/MergeV2Checkpoints/checkpoint_prefixesPacksave_1/ShardedFilename^save_1/control_dependency*
T0*

axis *
N*
_output_shapes
:

save_1/MergeV2CheckpointsMergeV2Checkpoints-save_1/MergeV2Checkpoints/checkpoint_prefixessave_1/Const*
delete_old_dirs(

save_1/IdentityIdentitysave_1/Const^save_1/MergeV2Checkpoints^save_1/control_dependency*
_output_shapes
: *
T0
j
save_1/RestoreV2/tensor_namesConst*
dtype0*
_output_shapes
:*
valueBBbBw
l
!save_1/RestoreV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:

save_1/RestoreV2	RestoreV2save_1/Constsave_1/RestoreV2/tensor_names!save_1/RestoreV2/shape_and_slices*
_output_shapes

::*
dtypes
2

save_1/AssignAssignbsave_1/RestoreV2*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class

loc:@b

save_1/Assign_1Assignwsave_1/RestoreV2:1*
use_locking(*
T0*
_class

loc:@w*
validate_shape(*
_output_shapes
: 
>
save_1/restore_shardNoOp^save_1/Assign^save_1/Assign_1
1
save_1/restore_allNoOp^save_1/restore_shard "B
save_1/Const:0save_1/Identity:0save_1/restore_all (5 @F8"y
trainable_variablesb`
.
w:0w/Assignw/read:02w/initial_value:08
.
b:0b/Assignb/read:02b/initial_value:08"o
	variablesb`
.
w:0w/Assignw/read:02w/initial_value:08
.
b:0b/Assignb/read:02b/initial_value:08*i
serving_defaultV

input
input:0
output
output:0tensorflow/serving/predict