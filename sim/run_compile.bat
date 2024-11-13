if exist ..\object_mem.mif (
    copy /Y ..\object_mem.mif .
)
if exist ..\object_mem_bb.v (
    del ..\object_mem_bb.v
)
if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v
