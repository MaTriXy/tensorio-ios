æT
	ë
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
b'unknown'£H
X
input_xPlaceholder*
dtype0*
_output_shapes

:*
shape
:
p
w/initial_valueConst*)
value B"  ?      ?    *
dtype0*
_output_shapes

:
u
w
VariableV2*
shared_name *
dtype0*
_output_shapes

:*
	container *
shape
:

w/AssignAssignww/initial_value*
use_locking(*
T0*
_class

loc:@w*
validate_shape(*
_output_shapes

:
T
w/readIdentityw*
T0*
_class

loc:@w*
_output_shapes

:
I
output_zAddinput_xw/read*
_output_shapes

:*
T0

initNoOp	^w/Assign
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
dtype0*
_output_shapes
: *
shape: 
b
save/SaveV2/tensor_namesConst*
valueBBw*
dtype0*
_output_shapes
:
e
save/SaveV2/shape_and_slicesConst*
valueB
B *
dtype0*
_output_shapes
:
m
save/SaveV2SaveV2
save/Constsave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesw*
dtypes
2
}
save/control_dependencyIdentity
save/Const^save/SaveV2*
T0*
_class
loc:@save/Const*
_output_shapes
: 
e
save/RestoreV2/tensor_namesConst*
dtype0*
_output_shapes
:*
valueBBw
h
save/RestoreV2/shape_and_slicesConst*
dtype0*
_output_shapes
:*
valueB
B 

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices*
_output_shapes
:*
dtypes
2

save/AssignAssignwsave/RestoreV2*
validate_shape(*
_output_shapes

:*
use_locking(*
T0*
_class

loc:@w
&
save/restore_allNoOp^save/Assign
[
save_1/filename/inputConst*
valueB Bmodel*
dtype0*
_output_shapes
: 
r
save_1/filenamePlaceholderWithDefaultsave_1/filename/input*
shape: *
dtype0*
_output_shapes
: 
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
value3B1 B+_temp_f644187b60ea431f887f67231b9e09d4/part
{
save_1/StringJoin
StringJoinsave_1/Constsave_1/StringJoin/inputs_1*
N*
_output_shapes
: *
	separator 
S
save_1/num_shardsConst*
dtype0*
_output_shapes
: *
value	B :
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
d
save_1/SaveV2/tensor_namesConst*
valueBBw*
dtype0*
_output_shapes
:
g
save_1/SaveV2/shape_and_slicesConst*
dtype0*
_output_shapes
:*
valueB
B 

save_1/SaveV2SaveV2save_1/ShardedFilenamesave_1/SaveV2/tensor_namessave_1/SaveV2/shape_and_slicesw*
dtypes
2

save_1/control_dependencyIdentitysave_1/ShardedFilename^save_1/SaveV2*
T0*)
_class
loc:@save_1/ShardedFilename*
_output_shapes
: 
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
save_1/IdentityIdentitysave_1/Const^save_1/MergeV2Checkpoints^save_1/control_dependency*
T0*
_output_shapes
: 
g
save_1/RestoreV2/tensor_namesConst*
valueBBw*
dtype0*
_output_shapes
:
j
!save_1/RestoreV2/shape_and_slicesConst*
valueB
B *
dtype0*
_output_shapes
:

save_1/RestoreV2	RestoreV2save_1/Constsave_1/RestoreV2/tensor_names!save_1/RestoreV2/shape_and_slices*
_output_shapes
:*
dtypes
2

save_1/AssignAssignwsave_1/RestoreV2*
use_locking(*
T0*
_class

loc:@w*
validate_shape(*
_output_shapes

:
,
save_1/restore_shardNoOp^save_1/Assign
1
save_1/restore_allNoOp^save_1/restore_shard
V
inputPlaceholder*
dtype0*
_output_shapes

:*
shape
:
r
w_1/initial_valueConst*)
value B"  ?      ?    *
dtype0*
_output_shapes

:
w
w_1
VariableV2*
dtype0*
_output_shapes

:*
	container *
shape
:*
shared_name 


w_1/AssignAssignw_1w_1/initial_value*
use_locking(*
T0*
_class

loc:@w_1*
validate_shape(*
_output_shapes

:
Z
w_1/readIdentityw_1*
T0*
_class

loc:@w_1*
_output_shapes

:
G
outputAddinputw_1/read*
T0*
_output_shapes

:
&
init_1NoOp	^w/Assign^w_1/Assign
[
save_2/filename/inputConst*
dtype0*
_output_shapes
: *
valueB Bmodel
r
save_2/filenamePlaceholderWithDefaultsave_2/filename/input*
shape: *
dtype0*
_output_shapes
: 
i
save_2/ConstPlaceholderWithDefaultsave_2/filename*
dtype0*
_output_shapes
: *
shape: 
i
save_2/SaveV2/tensor_namesConst*
dtype0*
_output_shapes
:*
valueBBwBw_1
i
save_2/SaveV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:
{
save_2/SaveV2SaveV2save_2/Constsave_2/SaveV2/tensor_namessave_2/SaveV2/shape_and_slicesww_1*
dtypes
2

save_2/control_dependencyIdentitysave_2/Const^save_2/SaveV2*
_output_shapes
: *
T0*
_class
loc:@save_2/Const
l
save_2/RestoreV2/tensor_namesConst*
valueBBwBw_1*
dtype0*
_output_shapes
:
l
!save_2/RestoreV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:

save_2/RestoreV2	RestoreV2save_2/Constsave_2/RestoreV2/tensor_names!save_2/RestoreV2/shape_and_slices*
_output_shapes

::*
dtypes
2

save_2/AssignAssignwsave_2/RestoreV2*
validate_shape(*
_output_shapes

:*
use_locking(*
T0*
_class

loc:@w

save_2/Assign_1Assignw_1save_2/RestoreV2:1*
validate_shape(*
_output_shapes

:*
use_locking(*
T0*
_class

loc:@w_1
<
save_2/restore_allNoOp^save_2/Assign^save_2/Assign_1
[
save_3/filename/inputConst*
valueB Bmodel*
dtype0*
_output_shapes
: 
r
save_3/filenamePlaceholderWithDefaultsave_3/filename/input*
dtype0*
_output_shapes
: *
shape: 
i
save_3/ConstPlaceholderWithDefaultsave_3/filename*
shape: *
dtype0*
_output_shapes
: 

save_3/StringJoin/inputs_1Const*
dtype0*
_output_shapes
: *<
value3B1 B+_temp_835cf411626143b2ab714b647e471635/part
{
save_3/StringJoin
StringJoinsave_3/Constsave_3/StringJoin/inputs_1*
	separator *
N*
_output_shapes
: 
S
save_3/num_shardsConst*
value	B :*
dtype0*
_output_shapes
: 
^
save_3/ShardedFilename/shardConst*
value	B : *
dtype0*
_output_shapes
: 

save_3/ShardedFilenameShardedFilenamesave_3/StringJoinsave_3/ShardedFilename/shardsave_3/num_shards*
_output_shapes
: 
i
save_3/SaveV2/tensor_namesConst*
dtype0*
_output_shapes
:*
valueBBwBw_1
i
save_3/SaveV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:

save_3/SaveV2SaveV2save_3/ShardedFilenamesave_3/SaveV2/tensor_namessave_3/SaveV2/shape_and_slicesww_1*
dtypes
2

save_3/control_dependencyIdentitysave_3/ShardedFilename^save_3/SaveV2*
T0*)
_class
loc:@save_3/ShardedFilename*
_output_shapes
: 
£
-save_3/MergeV2Checkpoints/checkpoint_prefixesPacksave_3/ShardedFilename^save_3/control_dependency*
N*
_output_shapes
:*
T0*

axis 

save_3/MergeV2CheckpointsMergeV2Checkpoints-save_3/MergeV2Checkpoints/checkpoint_prefixessave_3/Const*
delete_old_dirs(

save_3/IdentityIdentitysave_3/Const^save_3/MergeV2Checkpoints^save_3/control_dependency*
T0*
_output_shapes
: 
l
save_3/RestoreV2/tensor_namesConst*
valueBBwBw_1*
dtype0*
_output_shapes
:
l
!save_3/RestoreV2/shape_and_slicesConst*
valueBB B *
dtype0*
_output_shapes
:

save_3/RestoreV2	RestoreV2save_3/Constsave_3/RestoreV2/tensor_names!save_3/RestoreV2/shape_and_slices*
_output_shapes

::*
dtypes
2

save_3/AssignAssignwsave_3/RestoreV2*
validate_shape(*
_output_shapes

:*
use_locking(*
T0*
_class

loc:@w

save_3/Assign_1Assignw_1save_3/RestoreV2:1*
use_locking(*
T0*
_class

loc:@w_1*
validate_shape(*
_output_shapes

:
>
save_3/restore_shardNoOp^save_3/Assign^save_3/Assign_1
1
save_3/restore_allNoOp^save_3/restore_shard "B
save_3/Const:0save_3/Identity:0save_3/restore_all (5 @F8"w
	variablesjh
.
w:0w/Assignw/read:02w/initial_value:08
6
w_1:0
w_1/Assign
w_1/read:02w_1/initial_value:08"
trainable_variablesjh
.
w:0w/Assignw/read:02w/initial_value:08
6
w_1:0
w_1/Assign
w_1/read:02w_1/initial_value:08*q
serving_default^

input
input:0 
output
output:0tensorflow/serving/predict